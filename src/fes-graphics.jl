# 2nd bit is opacity
const PRE_COLOURS = [(:lightsteelblue3, 0.5) (:lightslategray,0.5)]
const POST_COLOURS = [(:peachpuff, 0.5) (:peachpuff3,0.5)]

function gft(v::Vector) 
    return Format.format.(v./1000; precision=0, commas=true).*"k"
end

gf2(v) = Format.format(v, precision=2, commas=true)

gf0(v) = Format.format(v, precision=0, commas=true)

export colourbins, 
       draw_hbai_clone!, 
       draw_hbai_thumbnail!, 
       gf0, 
       gf2, 
       POST_COLOURS, 
       PRE_COLOURS
"""
List of colours for barcharts that change from col1->col2 and back
when the bars step over a decile.
"""
function colourbins( input_colours, bins::Vector, deciles::Matrix )
    nbins = length(bins)-1
    colours = fill(input_colours[1],nbins)
    decile = 1
    colourno = 1
    for i in 1:nbins
        if bins[i] > deciles[decile,3] # next decile - swap colour.
            colourno = if colourno == 1
                2
            else 
                1
            end
            decile += 1
        end
        colours[i] = input_colours[colourno]        
    end
    colours
end

function draw_hbai_clone!( 
    f :: Figure, 
    res :: NamedTuple, 
    summary :: NamedTuple; 
    title :: AbstractString,
    subtitle :: AbstractString,
    bandwidth=10.0,
    sysno::Int, 
    measure::Symbol, 
    colours )
    edges = collect(0:bandwidth:2200)
    ih = summary.income_hists[sysno]
    ax = Axis( f[sysno,1], 
        title=title, 
        subtitle=subtitle,
        xlabel="£s pw, in £$(gf0(bandwidth)) bands; shaded bands represent deciles.", 
        ylabel="Counts",
        ytickformat = gft)
    deciles = summary.deciles[sysno]
    deccols = colourbins( colours, edges, deciles ) #ih.hist.edges[1], summary.deciles[1])
    incs = deepcopy(res.hh[sysno][!,measure])
    incs = max.( 0.0, incs )
    incs = min.(2200, incs )
    h = hist!( ax, 
        incs;
        weights=res.hh[sysno].weighted_people,
        bins=edges, 
        color = deccols )
    mheight=10_000*bandwidth # arbitrary height for mean/med lines
    povline = ih.median*0.6
    v1 = lines!( ax, [ih.median,ih.median], [0, mheight]; color=:grey16, label="Median £$(gf2(ih.median))", linestyle=:dash )
    v2 = lines!( ax, [ih.mean,ih.mean], [0, mheight]; color=:chocolate4, label="Mean £$(gf2(ih.mean))", linestyle=:dash )
    v3 = lines!( ax, [povline,povline], [0, mheight]; color=:olivedrab4, label="60% of median £$(gf2(povline))", linestyle=:dash )
    axislegend(ax)
    return ax
end


function draw_hbai_thumbnail!( 
    f :: Figure, 
    res :: NamedTuple, 
    summary :: NamedTuple;
    title :: AbstractString,
    col = 1,
    row = 2,
    bandwidth=20.0,
    sysno::Int, 
    measure::Symbol, 
    colours )
    edges = collect(0:bandwidth:2200)
    ih = summary.income_hists[sysno]
    ax = Axis( f[row,col], title=title, yticklabelsvisible=false)
    deciles = summary.deciles[sysno]
    deccols = colourbins( colours, edges, deciles ) #ih.hist.edges[1], summary.deciles[1])
    incs = deepcopy(res.hh[sysno][!,measure])
    incs = max.( 0.0, incs )
    incs = min.(2200, incs )
    h = hist!( ax, 
        incs;
        weights=res.hh[sysno].weighted_people,
        bins=edges, 
        color = deccols )
    mheight=10_000*bandwidth # arbitrary height for mean/med lines
    povline = ih.median*0.6
    v1 = lines!( ax, [ih.median,ih.median], [0, mheight]; color=:grey16, label="Median £$(gf2(ih.median))", linestyle=:dash )
    v2 = lines!( ax, [ih.mean,ih.mean], [0, mheight]; color=:chocolate4, label="Mean £$(gf2(ih.mean))", linestyle=:dash )
    v3 = lines!( ax, [povline,povline], [0, mheight]; color=:olivedrab4, label="60% of median £$(gf2(povline))", linestyle=:dash )
    return ax
end

function fes_draw_summary_graphs( 
    settings::Settings, 
    summary :: NamedTuple, 
    data::NamedTuple )::Figure
    f = Figure(fontsize = 10, fonts = (; regular = "Gill Sans"))
    ax1 = draw_hbai_thumbnail!( f, data, summary;
        title="Income Distribution - Before",
        col = 1,
        row = 1,
        sysno = 1,
        bandwidth=20,
        measure=Symbol(string(settings.ineq_income_measure )),
        colours=PRE_COLOURS)
    ax2 = draw_hbai_thumbnail!( f, data, summary;
        title="Income Distribution - After",
        col = 1,
        row = 2,
        sysno = 2,
        bandwidth=20,
        measure=Symbol(string(settings.ineq_income_measure )),
        colours=POST_COLOURS)
    linkxaxes!( ax1, ax2 )
    linkyaxes!( ax1, ax2 )
    ax3 = Axis(f[1,2]; title="Income Changes By Decile", 
        ylabel="% Change", xlabel="Decile" )
    dch = 100.0 .* (summary.deciles[2][:, 4] .- summary.deciles[1][:, 4]) ./ summary.deciles[1][:, 4]
    barplot!( ax3, dch)
    if settings.do_marginal_rates 
        ax4 = Axis(f[2,2]; title="METRs", xlabel="%", ylabel="")
        for i in 1:2
            ind = data.indiv[i]
            m1=ind[.! ismissing.(ind.metr),:]
            m1.metr = Float64.( m1.metr ) # Coerce away from missing type.
            m1.metr = min.( 200.0, m1.metr )
            label, colour = if i == 1
                "Before", PRE_COLOUR
            else 
                "After", POST_COLOUR
            end
            density!( ax4, m1.metr; label, weights=m1.weight, color=colour)
        end
    end
    fname = joinpath( settings.output_dir, basiccensor( settings.run_name ), "summary_graph.svg" ) 
    save(fname, f)
    f
end

function save_hbai_graph( settings::Settings, 
    res::NamedTuple, 
    summ :: NamedTuple )
    hbaif2 = Figure(size=(2970,2100), fontsize = 25, fonts = (; regular = "Gill Sans"))
    ax1 = draw_hbai_clone!( hbaif2, res, summ;
        title="Incomes: Pre",
        subtitle=INEQ_INCOME_MEASURE_STRS[settings.ineq_income_measure ],
        sysno = 1,
        bandwidth=20,
        measure=Symbol(string(settings.ineq_income_measure )),
        colours=PRE_COLOURS)
    ax2 = draw_hbai_clone!( hbaif2, res, summ;
        title="Incomes: Post",
        subtitle=INEQ_INCOME_MEASURE_STRS[settings.ineq_income_measure ],
        sysno = 2,
        bandwidth=20,
        measure=Symbol(string(settings.ineq_income_measure )),
        colours=POST_COLOURS)
    linkxaxes!( ax1, ax2 )
    linkyaxes!( ax1, ax2 )
    fname = joinpath( settings.output_dir, basiccensor( settings.run_name ), "hbai-clone.svg" ) 
    save( fname, hbaif2 )
end 
