### A Pluto.jl notebook ###
# v0.20.4

using Markdown
using InteractiveUtils

# ╔═╡ 72c7843c-3698-4045-9c83-2ad391097ad8
begin
	import Pkg
    # activate the shared project environment
    Pkg.activate(Base.current_project())
    # instantiate, i.e. make sure that all packages are downloaded
	# Pkg.resolve()
    # Pkg.instantiate()
	using MicrosimTraining
    PlutoUI.TableOfContents(aside=true)
end

# ╔═╡ 6c221320-2013-42f9-90c7-77f97bddfb04
begin
    md"""
    ## Where Next?
    """
end 

# ╔═╡ bf4eebd2-8c50-457b-afb7-c2ef33364635
begin
    md"""
    We've come a long way. We've studied most of the important concepts a professional in this field needs, got hands-on with a tax-benefit model, and carried out some ambitious policy design.
    """
end 

# ╔═╡ 280fcd0c-e6aa-4df7-9073-7744001cf060
begin
    md"""
    The model you've been using is static and very conventional, and we've discussed its problems at length. Nonetheless I hope the policy simulations you've been doing show that static microsimulation is a powerful and useful tool.
    """
end 

# ╔═╡ e040059e-2b2f-4610-b38e-dec7b83454cf
begin
    md"""
    Earlier, I expressed scepticism about whether a model that addressed all the limitations of this present one was feasible, and whether, if such an all-singing, all-dancing model was somehow built, it would actually be very useful. But interesting extensions in various directions have been made, and in this final section I'll discuss a couple of them.
    """
end 

# ╔═╡ c1d8b6ab-9988-461e-aefc-84964c554990
begin
    md"""
    ### Long-Run Forecasting using Microsimulation: A simple example
    """
end 

# ╔═╡ fcd81e2d-dd18-468f-b846-7e22adbd27e4
begin
    md"""
    Last year, I and my colleague Howard Reed of Landman Economics[^FN_LANDMAN] were commissioned to produce long run poverty projections for Scotland, as part of the anti-child poverty policy[^FN_REED_STARK] we mentioned right at the beginning. We've seen that poverty simulation is classic tax-benefit model territory. But how could we project forward over 15 or more years? It turns out that we've already encountered the tricks that you need: reweighting and uprating. We saw above how, because of differential non-response, we needed to re-weight our FRS dataset - give more emphasis to some households than others in the output - so that the final results matched know facts about the overall populations, such as the numbers of people of different ages and genders. We can extend this idea to produce weights such that our data matches not current levels of these things, but *projected* levels. Likewise, for incomes, we can uprate the recorded levels in the data to match projections of thee things from macroeconomic forecasters. Such projections exist: the ONS and Public Records Scotland produce long-run forecasts for populations and household composition[^FN_PRS] and the Scottish Fiscal Commission produces income forecasts[^FN_SFC]. Note that we're not forecasting populations and incomes *ourselves*; rather, we're making projections of poverty that are consistent with official forecasts.
    """
end 

# ╔═╡ e1578346-9a2c-4942-8a22-ea471a58fb07
begin
    md"""
    ### Micro- to Macro-
    """
end 

# ╔═╡ Cell order:
# ╟─72c7843c-3698-4045-9c83-2ad391097ad8
# ╟─6c221320-2013-42f9-90c7-77f97bddfb04
# ╟─bf4eebd2-8c50-457b-afb7-c2ef33364635
# ╟─280fcd0c-e6aa-4df7-9073-7744001cf060
# ╟─e040059e-2b2f-4610-b38e-dec7b83454cf
# ╟─c1d8b6ab-9988-461e-aefc-84964c554990
# ╟─fcd81e2d-dd18-468f-b846-7e22adbd27e4
# ╟─e1578346-9a2c-4942-8a22-ea471a58fb07

