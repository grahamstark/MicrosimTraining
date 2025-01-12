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

# ╔═╡ 8d1b8de5-632e-4610-bb6c-f15d34a046a7
begin
    md"""
    ## Tax-Benefit Models
    """
end 

# ╔═╡ 0d65e25b-6df3-4a6d-aca0-15fe938fa540
begin
    md"""
    ### Where we're going
    """
end 

# ╔═╡ e3684e72-4673-49c4-bf3a-135c87d2231a
begin
    md"""
    We've covered a lot of ground quite fast: summary statistics, large sample datasets, data weighting, measuring poverty and inequality, measures of well-being, tax incidence and incentives. Now we'll to put all these things to use and build a microsimulation tax-benefit model.
    """
end 

# ╔═╡ 0a4a2e44-cdd1-4542-a051-0d5d1d42b79c
begin
    md"""
    ### Building a tax-benefit model
    """
end 

# ╔═╡ 12d68bd3-3be0-4f90-a3f6-f3cce2718929
begin
    md"""
    In essence a tax benefit model is a simple thing.  It's a computer program that calculates the effects ofpossible changes to the fiscal system on a sample of households. We take each of the households in our dataset, calculate how much tax the household members are liable for under some proposed tax and benefit regime, and how much benefits they are entitled to, and add add up the results. If the sample is representative of the population, and the modelling sufficiently accurate, the model can then tell you, for example, the net costs of the proposals, the numbers who are made better or worse off, the effective tax rates faced by individuals, the numbers taken in and out of poverty by some change, and much else.
    """
end 

# ╔═╡ 3e74741d-a141-4df2-90c7-c9887cab8a0b
begin
    md"""
    The model we use here is written in the Julia programming language[^FN_JULIA]. All the program code stored on a public website [^FN_GIT] but there's no need to look at that unless you're interested. We've equipped the model with a simple Web interface so that you can interact with it.
    """
end 

# ╔═╡ cb03301c-8dfd-4aed-a1eb-e92d7cc57c85
begin
    md"""
    ### Structure
    """
end 

# ╔═╡ 848725bd-1009-4808-b895-9ff79d3fb3a4
begin
    md"""
    The main thing we haven't covered already is how we actually do the tax and benefit calculations. The first thing to confront is that there's a lot of stuff to model: the standard guide to the UK tax system is Tolley's Guides[^FN_TOLLEY]. Here are the current Tolley's guides:
    """
end 

# ╔═╡ d6c93dc9-59b8-4e23-bd40-66d3505cc97a
begin
    md"""
    ![Tolleys Guides](./images/tolleys_guides.jpeg)(Source: [@neidle_excitingly_2017])
    """
end 

# ╔═╡ 7614aca9-ac3c-4ed7-a037-128e3ecb3264
begin
    md"""
    The corresponding thing for the Benefit System is the Child Poverty Action Group Welfare Benefits guide[^FN_CPAG], which looks like this^FN_MELVILLE]:
    """
end 

# ╔═╡ 2f06168d-f7bc-4681-8fd4-aff0b5b5dbc0
begin
    md"""
    ![CPAG Guide](./images/cpag_guide.jpg)(Source: author's photograph.)
    """
end 

# ╔═╡ 1e52d592-5344-4a91-9d04-2681b35ea698
begin
    md"""
    There is no royal road to creating the actual calculations; it's mostly a question of judgement - how much detail it's necessary to include, how best to use the available data, and so on.
    """
end 

# ╔═╡ 6e487e65-378d-4d9f-85fc-1c8a48604b92
begin
    md"""
    Here's a simple flowchart of the steps the model goes through:
    """
end 

# ╔═╡ ab77b304-c0d4-4497-867d-82701d0a02b8
begin
    md"""
    ![Model Flowchart](./images/model_flowchart.svg)
    """
end 

# ╔═╡ 6ed7c055-e786-4c44-b8b6-21accd63a90d
begin
    md"""
    Most of the steps here are hopefully familiar to you from earlier in the week; the one thing we haven't discussed is *uprating*: our datasets are typically 1-3 years old by the time they are released and wages, prices and interest rates will have changed since the time of the interviews, so we multiply incomes, rents and consumption by amounts to reflect these changes.
    """
end 

# ╔═╡ 41640c8c-bd88-4661-bee7-c9ffa7e28658
begin
    md"""
    ### How do we know the model is right?
    """
end 

# ╔═╡ Cell order:
# ╟─72c7843c-3698-4045-9c83-2ad391097ad8
# ╟─8d1b8de5-632e-4610-bb6c-f15d34a046a7
# ╟─0d65e25b-6df3-4a6d-aca0-15fe938fa540
# ╟─e3684e72-4673-49c4-bf3a-135c87d2231a
# ╟─0a4a2e44-cdd1-4542-a051-0d5d1d42b79c
# ╟─12d68bd3-3be0-4f90-a3f6-f3cce2718929
# ╟─3e74741d-a141-4df2-90c7-c9887cab8a0b
# ╟─cb03301c-8dfd-4aed-a1eb-e92d7cc57c85
# ╟─848725bd-1009-4808-b895-9ff79d3fb3a4
# ╟─d6c93dc9-59b8-4e23-bd40-66d3505cc97a
# ╟─7614aca9-ac3c-4ed7-a037-128e3ecb3264
# ╟─2f06168d-f7bc-4681-8fd4-aff0b5b5dbc0
# ╟─1e52d592-5344-4a91-9d04-2681b35ea698
# ╟─6e487e65-378d-4d9f-85fc-1c8a48604b92
# ╟─ab77b304-c0d4-4497-867d-82701d0a02b8
# ╟─6ed7c055-e786-4c44-b8b6-21accd63a90d
# ╟─41640c8c-bd88-4661-bee7-c9ffa7e28658

