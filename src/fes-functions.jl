
export DEFAULT_SYS, 
    do_higher_rates_run,
    draw_bc,
    fes_run, 
    format_bc_df, 
    format_gainlose, 
    get_change_target_hhs, 
    getbc

const DEFAULT_SYS = get_default_system_for_fin_year(2025; scotland=true, autoweekly=false )
    
function fm(v, r,c) 
    return if c == 1
        v
    elseif c < 7
        Format.format(v, precision=0, commas=true)
    else
        Format.format(v, precision=2, commas=true)
    end
    s
end

function zip_dump( settings :: Settings )
    rname = basiccensor( settings.run_name )
    dirname = joinpath( settings.output_dir, rname ) 
    io = ZipFile.Writer("$(dirname).zip")
    for f in readdir(dirname)
        ZipFile.addfile( io, f )
    end
    ZipFile.close(io)
    return dirname
end


h1 = HtmlHighlighter( ( data, r, c ) -> (c == 1), ["font_weight"=>"bold", "color"=>"slategrey"])
# HtmlDecoration( font_weight="bold", color="slategrey"))

function f_gainlose( h, data, r, c ) 
    colour = "black"
    if c == 7
        colour = if data[r,c] < -0.1
            "darkred"
        elseif data[r,c] > 0.1
            "darkgreen"
        else
            "black"
        end
    end
    return ["color" => colour ]
    # HtmlDecoration( color=colour )
end

"""
format cols at end green for good, red for bad.
"""
h7 = HtmlHighlighter( (data, r, c)->(c >= 7), f_gainlose )

"""

"""
function format_gainlose(title::String, gl::DataFrame)
    gl[!,1] = pretty.(gl[!,1]) # labels on RHS
    io = IOBuffer()
    pretty_table( 
        io, 
        gl[!,1:end-1]; 
        backend = :html,
        formatters=[fm], 
        alignment=[:l,fill(:r,7)...],
        highlighters = [h1,h7],
        title = title,
        column_labels=["",
            "Lose £10.01+",
            "Lose £1.01-£10",
            "No Change",
            "Gain £1.01-£10",
            "Gain £10.01+",
            "Av. Change",
            "Pct. Change"])
    return String(take!(io))
end

function fes_run( settings :: Settings, systems::Vector; supress_dumps=false )::Tuple
    # delete higher rates
    global running_total
    tot = 0
    results = nothing
    summaries = nothing 
    results = do_one_run( settings, systems, run_progress )
    summaries = summarise_frames!( results, settings )
    dump_summaries( settings, summaries )
    short_summary = make_short_summary( summaries )
    if ! supress_dumps
        dump_summaries( settings, summaries )
    end
    rname = basiccensor( settings.run_name )
    dirname = joinpath( settings.output_dir, rname ) 
    save_hbai_graph( settings, results, summaries ) 
    save_taxable_graph( settings, results, summaries, systems )
    summaries, results, short_summary, dirname
end

"""
Progressively delete all the Scottish 2025/6 Higher rates and return the cumulative revenue
differences.
"""
function do_higher_rates_run( settings::Settings, base_sys :: TaxBenefitSystem, changed_sys :: TaxBenefitSystem )::Tuple
    # settings.run_name = "Higher Rates"
    # create 4 systems with progressively deleted higher rates
    base = deepcopy( base_sys )
    systems = [base]
    nrates = length( changed_sys.it.non_savings_rates)
    # basic_rate = max(1,nrates - 3 )
    for i in nrates:-1:1 # basic_rate
        tsys = deepcopy( changed_sys )
        tsys.it.non_savings_rates = tsys.it.non_savings_rates[1:i]
        # possibly reset the 'basic rate'
        if length( tsys.it.non_savings_rates ) < (base.it.non_savings_basic_rate)
            tsys.it.non_savings_basic_rate = max(1,i-1)
        end
        tsys.it.non_savings_thresholds = tsys.it.non_savings_thresholds[1:i-1]
        @show i tsys.it.non_savings_rates tsys.it.non_savings_thresholds
        push!( systems, tsys ) 
    end
    # weeklyise!.( systems )
    # run the whole set
    summaries, results, short_summary, dirname = fes_run( settings, systems, supress_dumps=true )
    # extract just the little bit we want from the incomes summary
    s=summaries.short_income_summary
    @show names(s)
    rename!(s, ["Grant Total £p.a"=>"Base", "Grant Total £p.a_1"=>"Full_Reformed_Sys"])
    grant_labels = ["Base", "Full_Reformed_Sys"]
    for i in nrates:-1:2
        label = "Reform_Rates[$nrates->$(i)]_Deleted"
        rename!(s, ["Grant Total £p.a_$(nrates-i+2)"=>label])
        push!( grant_labels, label )
    end
    grant_labels = Symbol.( grant_labels )
    it = s[s.label .== "Scottish Income Tax",:]
    # flip the ouput sideways
    hrt = permutedims(it[:,[:label, grant_labels...]],1)
    # add in cumulative change columns
    nrows, ncols = size(hrt)
    hrt.diff_prev = zeros(nrows)
    hrt.diff_cum = zeros(nrows)
    for i in 1:nrows
        di = max(1,i-1)
        hrt.diff_prev[i] = hrt[i,2]-hrt[di,2]
        hrt.diff_cum[i] = hrt[i,2]-hrt[1,2]
    end
    # formatted version
    t = hcat(pretty.(hrt.label), format.(hrt[:,2:end];precision=0,commas=true))
    rename!( t, ["diff_prev"=>"Incremental Change", "diff_cum"=>"Total Change"] )
    return hrt, t, systems, summaries.short_income_summary
end

"""
Generate a pair of budget constraints (as Dataframes) for the given household.
"""
function getbc( 
    settings :: Settings,
    hh  :: Household, 
    sys1 :: TaxBenefitSystem, 
    sys2 :: TaxBenefitSystem, 
    wage :: Real )::Tuple
    bc1 = BCCalcs.makebc( hh, sys1, settings, wage; to_html=true )
    bc1 = recensor(bc1)
    bc1.mr .*= 100.0
    bc1.char_labels = BCCalcs.get_char_labels(size(bc1)[1])
    settings.means_tested_routing = uc_full 
    bc2 = BCCalcs.makebc( hh, sys2, settings, wage; to_html=true )
    bc2 = recensor(bc2)
    bc2.mr .*= 100.0 # MR to percent
    bc2.char_labels = BCCalcs.get_char_labels(size(bc2)[1])
    (bc1,bc2)
end

function fmbc(v, r,c) 
    return if c in [1,7]
        v
    elseif c == 4
        if abs(v) > 4000
            "Discontinuity"
        else
            Format.format(v, precision=3, commas=false)
        end
    else
        Format.format(v, precision=2, commas=true)
    end
    s
end

function format_bc_df( title::String, bc::DataFrame)
    io = IOBuffer()
    nr,nc = size(bc)
    #= valiant attempt, but doesn't render right
    bc.html_label = fill( "", nr )
    for r in eachrow(bc)
        r.html_label = Markdown.html(md"$r.label")
    end
    =#
    pretty_table( 
        io,
        bc[!,[:char_labels,:gross,:net,:mr]], #,:cap,:reduction,:html_label]]; 
        backend = :html,
        formatters=[fmbc],
        allow_html_in_cells=true,
        title = title,
        table_class="table table-sm table-striped table-responsive",
        column_labels = ["ID", "Earnings &pound;pw","Net Income BHC &pound;pw", "METR"], #"Benefit Cap", "Benefits Reduced By","Breakdown"], 	
        alignment=[fill(:r,3)...,:l] )
    return String(take!(io))   
end

# convoluted way of making pairs of (0,-10),(0,10) for label offsets
const OFFSETS = collect( Iterators.flatten(fill([(0,-10),(0,10)],50)))

function draw_bc( settings::Settings, title :: String, df1 :: DataFrame, df2 :: DataFrame )::Figure
    f = Figure(size=(1200,1200))
    nrows1,ncols1 = size(df1)
    nrows2,ncols2 = size(df2)
    xmax = max( maximum(df1.gross), maximum(df2.gross))*1.1
    ymax = max( maximum(df1.net), maximum(df2.net))*1.1
    ymin = min( minimum(df1.net), minimum(df2.net))
    ax = Axis(f[1,1]; xlabel="Earnings £s pw", 
        ylabel=TARGET_BC_INCOMES_STRS[settings.target_bc_income]*" £s pw", 
        title=title)
    ylims!( ax, 0, ymax )
    xlims!( ax, -10, xmax )
    # diagonal gross=net
    lines!( ax, [0,xmax], [0, ymax]; color=:lightgrey)
    # bc 1 lines
    lines!( ax, df1.gross, df1.net, color=:darkred, label="Pre"  )
    # b1 labels
    scatter!( ax, df1.gross, df1.net; marker=df1.char_labels, marker_offset=OFFSETS[1:nrows1], markersize=15, color=:darkred,  )
    # b1 points
    scatter!( ax, df1.gross, df1.net, markersize=5, color=:darkred )
    # bc 1 lines
    lines!( ax, df2.gross, df2.net; color=:darkblue, label="Post" )
    # b1 labels
    scatter!( ax, df2.gross, df2.net; marker=df2.char_labels, marker_offset=OFFSETS[1:nrows2], markersize=15, color=:darkblue )
    # b1 points
    scatter!( ax, df2.gross, df2.net, markersize=5, color=:darkblue )
    axislegend(;position = :rc)

    fname = joinpath( settings.output_dir, basiccensor( settings.run_name ), "budget_constraint.svg" ) 
    save(fname, f)
    f
end
  
function get_change_target_hhs( 
    settings :: Settings, 
    sys1 :: TaxBenefitSystem, 
    sys2 :: TaxBenefitSystem, 
    target_list :: Vector )::Vector
    v = []
    n = min( length( target_list), 20 )
    for ls in target_list[1:n]
        hh = FRSHouseholdGetter.get_household( ls )
        res1 = do_one_calc( hh, sys1, settings )
        res2 = do_one_calc( hh, sys2, settings )
        push!( v, ( hh = hh, res1=res1, res2=res2 ))
    end
    return v
end