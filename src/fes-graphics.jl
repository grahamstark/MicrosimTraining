# 2nd bit is opacity
const PRE_COLOURS = [(:lightsteelblue3, 0.5) (:lightslategray,0.5)]
const POST_COLOURS = [(:peachpuff, 0.5) (:peachpuff3,0.5)]

function ft(v::Vector) 
    return Format.format.(v./1000; precision=0, commas=true).*"k"
end

f2(v) = Format.format(v, precision=2, commas=true)

f0(v) = Format.format(v, precision=0, commas=true)

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
    ih = summary.income_hists[1]
    ax = Axis( f[sysno,1], 
        title=title, 
        subtitle=subtitle,
        xlabel="£s pw, in £$(f0(bandwidth)) bands; shaded bands represent deciles.", 
        ylabel="Counts",
        ytickformat = ft)
    deciles = summary.deciles[sysno]
    deccols = colourbins( colours, edges, deciles ) #ih.hist.edges[1], summary.deciles[1])
    incs = deepcopy(res.hh[sysno][!,measure])
    incs = max.( 0.0, incs )
    incs = min.(2200, incs )
    h = hist!( ax, 
        incs;
        weights=res.hh[1].weighted_people,
        bins=edges, 
        color = deccols )
    mheight=36_000*bandwidth # arbitrary height for mean/med lines
    povline = ih.median*0.6
    v1 = lines!( ax, [ih.median,ih.median], [0, mheight]; color=:grey16, label="Median £$(f2(ih.median))", linestyle=:dash )
    v2 = lines!( ax, [ih.mean,ih.mean], [0, mheight]; color=:chocolate4, label="Mean £$(f2(ih.mean))", linestyle=:dash )
    v3 = lines!( ax, [povline,povline], [0, mheight]; color=:olivedrab4, label="60% of median £$(f2(povline))", linestyle=:dash )
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
    ih = summary.income_hists[1]
    ax = Axis( f[row,col], title=title, yticklabelsvisible=false)
    deciles = summary.deciles[sysno]
    deccols = colourbins( colours, edges, deciles ) #ih.hist.edges[1], summary.deciles[1])
    incs = deepcopy(res.hh[sysno][!,measure])
    incs = max.( 0.0, incs )
    incs = min.(2200, incs )
    h = hist!( ax, 
        incs;
        weights=res.hh[1].weighted_people,
        bins=edges, 
        color = deccols )
    mheight=36_000*bandwidth # arbitrary height for mean/med lines
    povline = ih.median*0.6
    v1 = lines!( ax, [ih.median,ih.median], [0, mheight]; color=:grey16, label="Median £$(f2(ih.median))", linestyle=:dash )
    v2 = lines!( ax, [ih.mean,ih.mean], [0, mheight]; color=:chocolate4, label="Mean £$(f2(ih.mean))", linestyle=:dash )
    v3 = lines!( ax, [povline,povline], [0, mheight]; color=:olivedrab4, label="60% of median £$(f2(povline))", linestyle=:dash )
    return ax
end

