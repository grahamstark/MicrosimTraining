
export DEFAULT_SYS, format_gainlose, fes_run, get_change_target_hhs, getbc, format_bc_df, draw_bc

const DEFAULT_SYS = get_default_system_for_fin_year(2025; scotland=true)
    
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

h1 = HtmlHighlighter( ( data, r, c ) -> (c == 1), HtmlDecoration( font_weight="bold", color="slategrey"))
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
    HtmlDecoration( color=colour )
end
h7 = HtmlHighlighter( (data, r, c)->(c == 7), f_gainlose )

"""

"""
function format_gainlose(title::String, gl::DataFrame)
    gl[!,1] = pretty.(gl[!,1])
    io = IOBuffer()
    pretty_table( 
        io, 
        gl[!,1:end-1]; 
        backend = Val(:html),
        formatters=fm, alignment=[:l,fill(:r,6)...],
        highlighters = (h1,h7),
        title = title,
        header=["",
            "Lose £10.01+",
            "Lose £1.01-£10",
            "No Change",
            "Gain £1.01-£10",
            "Gain £10.01+",
            "Av. Change"])
    return String(take!(io))
end


function fes_run( settings :: Settings, systems::Vector )::Tuple
    # delete higher rates
    global running_total
    tot = 0
    results = nothing
    summaries = nothing 
    rtime = @be begin
        results = do_one_run( settings, systems, run_progress )
        summaries = summarise_frames!( results, settings )
    end
    settings = Settings()
    dump_summaries( settings, summaries )
    Chairmarks.summarize( rtime )
    short_summary = make_short_summary( summaries )
    summaries, results, short_summary, rtime
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
    bc.html_label = html.(MD.(bc.label))
    pretty_table( 
        io,
        bc[!,[:char_labels,:gross,:net,:mr,:cap,:reduction,:html_label]]; 
        backend = Val(:html),
        formatters=fmbc,
        allow_html_in_cells=true,
        table_class="table table-sm table-striped table-responsive",
        header = ["ID", "Earnings &pound;pw","Net Income AHC &pound;pw", "METR", "Benefit Cap", "Benefits Reduced By","Breakdown"], 	
        alignment=[fill(:r,6)...,:l],
        title = title )
    return String(take!(io))   
end

# convoluted way of making pairs of (0,-10),(0,10) for label offsets
const OFFSETS = collect( Iterators.flatten(fill([(0,-10),(0,10)],50)))

function draw_bc( title :: String, df1 :: DataFrame, df2 :: DataFrame )::Figure
    f = Figure(size=(1200,1200))
    nrows1,ncols1 = size(df1)
    nrows2,ncols2 = size(df2)
    xmax = max( maximum(df1.gross), maximum(df2.gross))*1.1
    ymax = max( maximum(df1.net), maximum(df2.net))*1.1
    ymin = min( minimum(df1.net), minimum(df2.net))
    ax = Axis(f[1,1]; xlabel="Earnings &pound;s pw", ylabel="Net Income (AHC) &pound;s pw", title=title)
    ylims!( ax, 0, ymax )
    xlims!( ax, -10, xmax )
    # diagonal gross=net
    lines!( ax, [0,xmax], [0, ymax]; color=:lightgrey)
    # bc 1 lines
    lines!( ax, df1.gross, df1.net, color=:red  )
    # b1 labels
    scatter!( ax, df1.gross, df1.net; marker=df1.char_labels, marker_offset=OFFSETS[1:nrows1], markersize=15, color=:red )
    # b1 points
    scatter!( ax, df1.gross, df1.net, markersize=5, color=:red )
    # bc 1 lines
    lines!( ax, df2.gross, df2.net, color=:blue )
    # b1 labels
    scatter!( ax, df2.gross, df2.net; marker=df2.char_labels, marker_offset=OFFSETS[1:nrows2], markersize=15, color=:blue )
    # b1 points
    scatter!( ax, df2.gross, df2.net, markersize=5, color=:blue )
    f
end
  
function get_change_target_hhs( settings :: Settings, target_list :: Vector )::Vector
    v = []
    n = min( length( target_list), 20 )
    for ls in target_list[1:n]
        hh = FRSHouseholdGetter.get_household( ls )
        bres = do_one_calc( hh, DEFAULT_SYS, settings )
        pres = do_one_calc( hh, sys2, settings )
        push!( v, ( hh = hh, bres=bres, pres=pres ))
    end
    return v
end

