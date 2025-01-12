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

# ╔═╡ 537cebfd-3f5d-465b-96a7-8ae850e52be2
begin
    md"""
    ### A Tour of Our Model
    """
end 

# ╔═╡ 1b7c2601-3d35-4e27-a5d7-d8181585fbd5
begin
    md"""
    **PLEASE NOTE this model is incomplete and there are bugs in the interface (some arrows wrong way)**.
    """
end 

# ╔═╡ b5538a7a-cde6-4bb7-a933-1b68da58960b
begin
    md"""
    Now we have everything in place, we can start exploring the  main model.
    """
end 

# ╔═╡ ee9048e8-6385-42fd-873d-a4b726ff1f4b
begin
    md"""
    I'll describe the mechanics of using the model first, and then in the next few sections explore different aspects of it.
    """
end 

# ╔═╡ 6f5a0d9a-7a47-42c2-bdd2-8796fd439fad
begin
    md"""
    #### Inputs
    """
end 

# ╔═╡ 23cf9843-a9e8-4fed-a1aa-d48fe7576812
begin
    md"""
    The input fields to the left should look familiar to you by now. There are a couple of things to note, though:
    """
end 

# ╔═╡ 641eff88-b7cd-4a2a-98ca-4691a191d993
begin
    md"""
    1. we've pre-set default values for everything. So, you don't have to build a default system from scratch this time;2. although the fields are the same, what they actually now do once you press 'submit' is a bit different. In the budget constraint case, the few parameters you could see really were the entire system we were modelling - as you saw, those parameters produced results that were more than complicated enough to get the important ideas across. Here, since we have such rich FRS data, it's worth us modelling in much more detail: under the hood, there are actually more that 150 parameters, for multiple tax rates, other benefits including disability and housing benefits, and different levels of generosity for our main benefits. So, we use your choices to adjust several parameters at a time. Changing the basic rate of tax, for instance, actually changes three tax rates by the same amount. Doing it this way seems a good compromise between keeping things simple enough to learn from without too much distraction, but complex enough to capture much of the richness of our data.
    """
end 

# ╔═╡ f275ca6c-50c6-4ef6-a24f-d1aa2f88c447
begin
    md"""
    When you press 'submit' your requests are sent to the server and the model is run - it's actually run *twice*, once for your changed system and once for the default values; most of what's shown in the output section is differences between the two, since its the changes you've brought about that are the of the most interest.
    """
end 

# ╔═╡ e474a587-1a63-4a53-8d24-2614157fe370
begin
    md"""
    #### Ouputs
    """
end 

# ╔═╡ 1ec2d979-1379-44f5-a1f0-7ba3b1474b79
begin
    md"""
    Instead of the budget constraint graph, we have the "Output Dashboard", a table of summary measures showing how the changes you enter affect Unicoria as a whole.
    """
end 

# ╔═╡ a5efc793-4cf6-4e24-a227-0ee11b93bc18
begin
    md"""
    There's a lot tshere, but everything here has been introduced earlier.
    """
end 

# ╔═╡ 211d210c-3b5d-47f8-9fe1-b3613bdc2473
begin
    md"""
    From left to right, starting at the top row, the fields show:
    """
end 

# ╔═╡ 8478121b-36da-4fd3-9508-9377e8c69d56
begin
    md"""
    * **The net cost of your changes**, to the nearest £10 million per year. This was discussed under 'fiscal neutrality'. You needn't always aim for a net zero cost, but you should be aware of the projected cost and have a story to hand if this cost is significant;* **gainers and losers** - the numbers of individuals gaining or losing more than 1% of their net income;* **marginal effective tax rates**. We've seen these in our budget constraint exercises. Since we've averaging over the whole population, we show the proportion of the population with METRs above 75% - this will include those in the poverty traps we discussed earlier, but, if you choose to increase higher rates of tax, could also include some higher rate payers.* **replacement rates**. Again, these were covered in our budget constraint discussion. Increases here might indicate reduced incentives to work amongst the low-paid;* **Changes In Net Income By Decile** this is a slightly unfamiliar graph, although we've encountered all the ideas previously. We chop the population up into the poorest 10%, the next poorest 10%, and plot the average change in net income for each group. This is a nice way of seeing quickly whether your changes distribute income towards the poor or the rich;* **Lorenz Curve** this is the same chart you experimented with earlier, except we show both a pre- and post- change curve;* **Inequality** the measures shown here should all be familiar from our earlier discussion;* **Poverty** Likewise, everything here is discussed in the poverty section;* **Taxes on Income** - the total change (if any) in income taxes in £million* **Taxes on Spending** - likewise for spending taxes* **Spending on Benefits** - change in benefit spending in £m* **Benefit Targetting** - This shows the proportion of any extra benefit spending that is targetted on the poor (defined as XX). We discussed the trade-offs between how well a benefit is targetted on the poor and high METRs.
    """
end 

# ╔═╡ f49d7546-2a6f-4515-9722-257f0316f91e
begin
    md"""
    ##### Activity
    """
end 

# ╔═╡ Cell order:
# ╟─72c7843c-3698-4045-9c83-2ad391097ad8
# ╟─537cebfd-3f5d-465b-96a7-8ae850e52be2
# ╟─1b7c2601-3d35-4e27-a5d7-d8181585fbd5
# ╟─b5538a7a-cde6-4bb7-a933-1b68da58960b
# ╟─ee9048e8-6385-42fd-873d-a4b726ff1f4b
# ╟─6f5a0d9a-7a47-42c2-bdd2-8796fd439fad
# ╟─23cf9843-a9e8-4fed-a1aa-d48fe7576812
# ╟─641eff88-b7cd-4a2a-98ca-4691a191d993
# ╟─f275ca6c-50c6-4ef6-a24f-d1aa2f88c447
# ╟─e474a587-1a63-4a53-8d24-2614157fe370
# ╟─1ec2d979-1379-44f5-a1f0-7ba3b1474b79
# ╟─a5efc793-4cf6-4e24-a227-0ee11b93bc18
# ╟─211d210c-3b5d-47f8-9fe1-b3613bdc2473
# ╟─8478121b-36da-4fd3-9508-9377e8c69d56
# ╟─f49d7546-2a6f-4515-9722-257f0316f91e

