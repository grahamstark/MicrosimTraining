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

function make_rate_bins( colour::String, 
    edges::AbstractVector, 
    bands::AbstractVector )::Vector
    nbins = length(edges)-1
    bl = length( bands )
    colmap = colormap( colour, bl )
    wbands = bands ./ WEEKS_PER_YEAR
    colours = fill( colmap[1], nbins )
    rb = 1
    for i in 1:nbins
        colours[i] = colmap[rb]
        if edges[i] >= wbands[i]
            rb += 1
        end
    end
    return colours
end

function draw_incomes_vs_bands!( 
    f :: Figure;
    results :: NamedTuple, 
    summary :: NamedTuple,
    title :: AbstractString,
    subtitle :: AbstractString,
    bandwidth=10.0,
    sysno::Int, 
    measure::Symbol, 
    colour :: String ) 
    edges = collect(0:bandwidth:2200)
    ih = summary.taxable_income_hists[sysno][measure]
    incs = deepcopy(results.incomes[sysno][!,measure])
    ax = Axis( f[sysno,1], 
        title=title, 
        subtitle=subtitle,
        xlabel="£s pw, in £$(gf0(bandwidth)) bands; shaded bands represent Scottish Income Tax bands.", 
        ylabel="Counts",
        ytickformat = gft)
    ratecols = make_rate_bins( colour, edges, bands )
    incs = max.( 0.0, incs )
    incs = min.(2200, incs )
    h = hist!( ax, 
        incs;
        weights=results.incomes[sysno].weight,
        bins=edges, 
        color = ratecols )
    mheight=10_000*bandwidth # arbitrary height for mean/med lines
    v1 = lines!( ax, [income_hist.mean,ih.mean], [0, mheight]; color=:chocolate4, label="Mean £$(gf2(ih.mean))", linestyle=:dash )
    v2 = lines!( ax, [income_hist.median,ih.median], [0, mheight]; color=:grey16, label="Median £$(gf2(ih.median))", linestyle=:dash )
    axislegend(ax)
    return ax
end


function make_rate_bins( colour::String, 
    edges::AbstractVector,
	rates::AbstractVector,
    bands::AbstractVector )
    nbins = length(edges)-1
    band_length = length( rates ) # use rates since we won't always have a top band
    colmap = colormap( colour, band_length+2 )[2:end] # 1st colour is too light
	colours = fill( colmap[1], nbins )
    rb = 1
	colno = 1
	for i in 1:nbins
        colours[i] = colmap[colno]
        if (rb < band_length) && (edges[i] >= bands[rb]) # next shade
	        rb += 1
			colno = rb
			# println( "on band $(bands[rb-1]) rb = $rb colno $colno")
		elseif(rb == band_length) && (colno == rb)
			colno += 1 # handle top
			# println( "on band $(bands[rb-1]) rb = $rb colno $colno start=$(edges[i])")
        end
    end
    return colours, colmap
end

function draw_incomes_vs_bands!( 
	f :: Figure;
	rates :: AbstractArray,
	bands :: AbstractArray,
	results :: NamedTuple, 
	summary :: NamedTuple,
	title :: AbstractString,
	subtitle :: AbstractString,
	bandwidth=10.0,
	sysno::Int, 
	measure::Symbol, 
	colour :: String ) 
	edges = collect(0:bandwidth:3000)
	ih = summary.taxable_income_hists[sysno][measure]
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
	ytext = mheight-8000
	i = 1
    # 
	for r in rates 
		rs = r*100
		text!( 2600, ytext; 
			   text = "\u2588", 
			   color=colourmap[i], 
			   fontsize=40, 
			   font = "Gill Sans" ) 
		text!( 2800, ytext; 
			   text = "$(rs)%", 
			   color=:black, 
			   fontsize=30, 
			   font = "Gill Sans" ) 
                
		ytext -= 5000
		i += 1
	end
	return ax
end

function save_taxable_graph( 
    settings::Settings, 
	results :: NamedTuple, 
    summary :: NamedTuple, 
    systems :: Vector )
	f = Figure(size=(2100,2970), fontsize = 25, fonts = (; regular = "Gill Sans"))	
	ax1 = draw_incomes_vs_bands!(
		f;
		rates = systems[1].it.non_savings_rates,
		bands = systems[1].it.non_savings_thresholds,
		results=results, 
		summary=summary, 
		title="Distribution of Scottish Non-Savings Taxable Income", 
		subtitle="Pre System", 
		sysno=1, 
		measure=:it_non_savings_taxable, 
		colour="Blues" )
		
	ax2 = draw_incomes_vs_bands!(
		f;
		rates = systems[2].it.non_savings_rates,
		bands = systems[2].it.non_savings_thresholds,
		results=results, 
		summary=summary, 
		title="", 
		subtitle="Post System", 
		sysno=2, 
		measure=:it_non_savings_taxable, 
		colour="Reds" )
	linkxaxes!( ax1, ax2 )
	linkyaxes!( ax1, ax2 )
    fname = joinpath( settings.output_dir, basiccensor( settings.run_name ), "taxable-incomes-graph.svg" ) 
    save(fname, f)	
	return f
end
