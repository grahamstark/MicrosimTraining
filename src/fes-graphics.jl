# 2nd bit is opacity
const PRE_COLOURS = [(:lightsteelblue3, 0.5) (:lightslategray,0.5)]
const POST_COLOURS = [(:peachpuff, 0.5) (:peachpuff3,0.5)]

function gft(v::Vector) 
    return Format.format.(v./1000; precision=0, commas=true).*"k"
end

gf2(v) = Format.format(v, precision=2, commas=true)

gf0(v) = Format.format(v, precision=0, commas=true)

export make_colourbins, 
       draw_hbai_clone!, 
       draw_hbai_thumbnail!, 
       save_taxable_graph,
       gf0, 
       gf2, 
       POST_COLOURS, 
       PRE_COLOURS
"""
List of colours for barcharts that change from col1->col2 and back
when the bars step over a decile. Approximate.
* `bins`: breaks e.g every £10
* `deciles` 10x4 matrix from PovertyInequality - we want :,3 - decile breaks
"""
function make_colourbins( input_colours, bins::Vector, deciles::Matrix )
@argcheck length( input_colours ) >= 2
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

"""
kinda sorta copy of fig 5 from: https://www.gov.uk/government/statistics/households-below-average-income-for-financial-years-ending-1995-to-2024/households-below-average-income-an-analysis-of-the-uk-income-distribution-fye-1995-to-fye-2024

* `results` STBOutput main results dump (incomes individual)
* `summary` STBOutput results summary dump (means, medians)
"""
function draw_hbai_clone!( 
    f :: Figure, 
    results :: NamedTuple, 
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
    deccols = make_colourbins( colours, edges, deciles ) #ih.hist.edges[1], summary.deciles[1])
    incs = deepcopy(results.hh[sysno][!,measure])
    incs = max.( 0.0, incs )
    incs = min.(2200, incs )
    h = hist!( ax, 
        incs;
        weights=results.hh[sysno].weighted_people,
        bins=edges, 
        color = deccols )
    mheight=10_000*bandwidth # arbitrary height for mean/med lines
    povline = ih.median*0.6
    v1 = lines!( ax, [ih.mean,ih.mean], [0, mheight]; color=:chocolate4, label="Mean £$(gf2(ih.mean))", linestyle=:dash )
    v2 = lines!( ax, [ih.median,ih.median], [0, mheight]; color=:grey16, label="Median £$(gf2(ih.median))", linestyle=:dash )
    v3 = lines!( ax, [povline,povline], [0, mheight]; color=:olivedrab4, label="60% of median £$(gf2(povline))", linestyle=:dash )
    axislegend(ax)
    return ax
end

"""
* `results` STBOutput main results dump (incomes individual)
* `summary` STBOutput results summary dump (means, medians)
"""
function draw_hbai_thumbnail!( 
    f :: Figure, 
    results :: NamedTuple, 
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
    deccols = make_colourbins( colours, edges, deciles ) #ih.hist.edges[1], summary.deciles[1])
    incs = deepcopy(results.hh[sysno][!,measure])
    incs = max.( 0.0, incs )
    incs = min.(2200, incs )
    h = hist!( ax, 
        incs;
        weights=results.hh[sysno].weighted_people,
        bins=edges, 
        color = deccols )
    mheight=10_000*bandwidth # arbitrary height for mean/med lines
    povline = ih.median*0.6
    v1 = lines!( ax, [ih.mean,ih.mean], [0, mheight]; color=:chocolate4, label="Mean £$(gf2(ih.mean))", linestyle=:dash )
    v2 = lines!( ax, [ih.median,ih.median], [0, mheight]; color=:grey16, label="Median £$(gf2(ih.median))", linestyle=:dash )
    v3 = lines!( ax, [povline,povline], [0, mheight]; color=:olivedrab4, label="60% of median £$(gf2(povline))", linestyle=:dash )
    return ax
end

"""
* `results` STBOutput main results dump (incomes individual)
* `summary` STBOutput results summary dump (means, medians)
"""
function fes_draw_summary_graphs( 
    settings::Settings,  
    results :: NamedTuple, 
    summary :: NamedTuple )::Figure
    f = Figure(fontsize = 10, fonts = (; regular = "Gill Sans"))
    ax1 = draw_hbai_thumbnail!( f, results, summary;
        title="Income Distribution - Before",
        col = 1,
        row = 1,
        sysno = 1,
        bandwidth=20,
        measure=Symbol(string(settings.ineq_income_measure )),
        colours=PRE_COLOURS)
    ax2 = draw_hbai_thumbnail!( f, results, summary;
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
            ind = results.indiv[i]
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

"""
* `results` STBOutput main results dump (incomes individual)
* `summary` STBOutput results summary dump (means, medians)
"""
function save_hbai_graph( settings::Settings, 
    results :: NamedTuple, 
    summary :: NamedTuple )
    hbaif2 = Figure(size=(2100,2970), fontsize = 25, fonts = (; regular = "Gill Sans"))
    ax1 = draw_hbai_clone!( hbaif2, results, summary;
        title="Incomes: Pre",
        subtitle=INEQ_INCOME_MEASURE_STRS[settings.ineq_income_measure ],
        sysno = 1,
        bandwidth=10, # £10 steps - £20 looks prettier but the deciles don't line up so well
        measure=Symbol(string(settings.ineq_income_measure )),
        colours=PRE_COLOURS)
    ax2 = draw_hbai_clone!( hbaif2, results, summary;
        title="Incomes: Post",
        subtitle=INEQ_INCOME_MEASURE_STRS[settings.ineq_income_measure ],
        sysno = 2,
        bandwidth=10,
        measure=Symbol(string(settings.ineq_income_measure )),
        colours=POST_COLOURS)
    linkxaxes!( ax1, ax2 )
    linkyaxes!( ax1, ax2 )
    fname = joinpath( settings.output_dir, basiccensor( settings.run_name ), "hbai-clone.svg" ) 
    save( fname, hbaif2 )
end 

function make_rate_bins( 
    colourstr::String, 
    edges::AbstractVector,
	rates::AbstractVector,
    bands::AbstractVector )
    @assert all(rates .<= 1.0)
    lr = length(rates) 
    lb = length(bands)
    @assert (lr - lb) in 0:1
    cbands = deepcopy(bands)
    if lr > lb
        push!( cbands, typemax( eltype( bands )))
        lb = length(cbands)
    end
    nbins = length(edges)-1
    # map of colors based on the tax rate levels and some base colo[u]r
    # NO - rates are often too close together
    # see: https://juliagraphics.github.io/Colors.jl/stable/constructionandconversion/
    # basecolor = parse( Colorant, colourstr )
    # colmap = alphacolor.((basecolor,), rates)
    colmap = colormap(colourstr, lr+2)[2:end] # 1st one is usually too light
    colours = fill( colmap[1], nbins )
    rb = 1
	colno = 2
    for i in 1:nbins
        if (edges[i] >= cbands[rb]) # next shade
	        rb += 1
			colno += 1
        end
        colours[i] = colmap[colno]
    end
    return colours, colmap
end

function draw_incomes_vs_bands!( 
	f :: Figure;
	rates :: AbstractArray,
	bands :: AbstractArray,
	results :: NamedTuple, 
	title :: AbstractString,
	subtitle :: AbstractString,
	bandwidth=10.0,
	sysno::Int, 
	measure::Symbol, 
	colour :: String ) 
	edges = collect(0:bandwidth:3000)
	incs = deepcopy(results.income[sysno][!,measure])
	positive_incs = incs.>0.0
	incs = incs[ positive_incs ]
	weight = results.income[sysno].weight[positive_incs]
	ax = Axis( 
		f[sysno,1], 
		title=title, 
		subtitle=subtitle,
		xlabel="£s pw, in £$(MicrosimTraining.gf0(bandwidth)) bands; shaded bands represent Scottish Income Tax bands.", 
		ylabel="Counts",
		ytickformat = MicrosimTraining.gft)
	ratecols, colourmap = make_rate_bins( colour, edges, rates, bands )
	incs = max.( 0.0, incs )
	incs = min.(3000, incs )
	h = hist!( ax, 
		incs;
		weights=weight,
		bins=edges, 
		color = ratecols )
	mheight=10_000*bandwidth # arbitrary height for mean/med lines
	mean = StatsBase.mean( incs, StatsBase.Weights( weight ))
	median = StatsBase.median( incs, StatsBase.Weights( weight ))
	v1 = lines!( ax, [mean,mean], [0, mheight]; color=:chocolate4, label="Mean £$(gf2(mean))", linestyle=:dash )
	v2 = lines!( ax, [median,median], [0, mheight]; color=:grey16, label="Median £$(gf2(median))", linestyle=:dash )
	axislegend(ax)
	# draw the pseudo key top right
	i = 2 # start at color 2 as in the graph since col1 is too light
    ytext = mheight-12_000 # draw downwards - 8000 turns out to be roughly right for height
    # 
	for r in rates 
		rs = r*100
		text!( 2800, ytext; 
			   text = "\u2588", 
			   color=colourmap[i], 
			   fontsize=40, 
			   font = "Gill Sans" ) 
		text!( 2900, ytext; 
			   text = "$(rs)%", 
			   color=:black, 
			   fontsize=30, 
			   font = "Gill Sans" ) 
                
		ytext -= 5000
		i += 1
	end
    ylims!(ax, 0, 100_000) 
    xlims!(ax, 0, edges[end])   
	return ax, edges[end]
end

function draw_tax_rates(
    f :: Figure;
    rates :: AbstractArray,
	bands :: AbstractArray,
    sysno :: Int,
    endx  :: Number,
    colour  )
    ax = Axis( f[sysno,1], 
        yaxisposition = :right, 
        xticksvisible=false, 
        xlabelvisible=false,
        xticklabelsvisible = false,
        ylabel="Marginal Rate (%)" )
    T = eltype(rates)
    b = T[] #copy(bands) 
    r = T[] # copy(rates) .* 100
    nr = length(rates)
    nb = length(bands)
    band = 0.0
    for i in 1:nr
        push!(b,band)
        if i <= nb
            band = bands[i]
            push!(b,band)
        else
            push!(b,endx)
        end
        push!(r,rates[i])
        push!(r,rates[i])
    end
    # @show r
    # @show b
    r .*= 100
    @assert length(b) == length(r)
    ylims!(ax, 0, 100)
    lines!(ax, b, r; color=colour, linewidth=3 )
    hidespines!(ax)
    return ax
end

function save_taxable_graph( 
    settings::Settings, 
	results :: NamedTuple, 
    summary :: NamedTuple, 
    systems :: Vector )
	f = Figure(size=(2100,2970), fontsize = 25, fonts = (; regular = "Gill Sans"))	
	ax1,endb1 = draw_incomes_vs_bands!(
		f;
		rates = systems[1].it.non_savings_rates,
		bands = systems[1].it.non_savings_thresholds,
		results=results, 
		title="Distribution of Scottish Non-Savings Taxable Income", 
		subtitle="Pre System", 
		sysno=1, 
		measure=:it_non_savings_taxable, 
		colour="Blues" )
	ax1a = draw_tax_rates(
        f;
        rates = systems[1].it.non_savings_rates,
		bands = systems[1].it.non_savings_thresholds,
        sysno = 1,
        endx  = endb1,
        colour = :darkblue )	
	ax2, endb2 = draw_incomes_vs_bands!(
		f;
		rates = systems[2].it.non_savings_rates,
		bands = systems[2].it.non_savings_thresholds,
		results=results, 
		title="", 
		subtitle="Post System", 
		sysno=2, 
		measure=:it_non_savings_taxable, 
		colour="Oranges" )
	ax2a = draw_tax_rates(
        f;
        rates = systems[2].it.non_savings_rates,
		bands = systems[2].it.non_savings_thresholds,
        sysno = 2,
        endx  = endb2,
        colour = :orange4 )	
	linkxaxes!( ax1, ax2 )
	linkxaxes!( ax1, ax1a )
	linkxaxes!( ax2, ax2a )
	linkyaxes!( ax1, ax2 )
    # linkyaxes!( ax1, ax1a )
    # linkyaxes!( ax2, ax2a )
    fname = joinpath( settings.output_dir, basiccensor( settings.run_name ), "taxable-incomes-graph.svg" ) 
    save(fname, f)	
	return f
end
