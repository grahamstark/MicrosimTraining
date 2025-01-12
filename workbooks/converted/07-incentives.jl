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

# ╔═╡ 006c839d-a617-42a1-b8e9-a16ff0d8758c
begin
    md"""
    ### Incentives and Fiscal Neutrality
    """
end 

# ╔═╡ 0eb4b595-4a48-45d7-8dca-f4215848a8ab
begin
    md"""
    As you saw in Chapter 1 of the textbook, mainstream economics starts from the premise that a properly functioning competitive market economy is the most efficient way of organising production and consumption for a modern society.
    """
end 

# ╔═╡ 73dade1e-87b6-47bb-9d99-c05475d7c433
begin
    md"""
    Economists often think of an economy as a "price system": where the market works well, prices reflect the relevant costs ("at the margin") of doing a thing, and people following these prices will be let "as if by an invisible hand"[^FN_SMITH] to do the best thing. "At the margin" is important here - it's the price of doing a little bit more of something that's the key thing - the price of the next litre of petrol you buy, or the wage for the next hour you work.
    """
end 

# ╔═╡ 7e931e34-9f35-47e1-a7af-86e14220dc2a
begin
    md"""
    In designing a tax and benefit system, one common objective is therefore to distort market incentives as little as possible. There is a presumption in favour of low *marginal* tax rates on goods so the prices of things don't move away from their efficient level too much. In this context we'd consider labour to be a good that's bought and sold at a wage, so the presumption is for low marginal tax rates on earnings. (I'll discuss marginal versus average tax rates in more detail we have the simulation model in front of us)[^FN_MEADE_2].
    """
end 

# ╔═╡ 3d93909b-7001-4d77-836e-77a3b16e8479
begin
    md"""
    As well as low marginal rates, there is also a presumption in favour of broad based taxation. Suppose a particular brand of baked beans was taxed, but all other brands were not. Since brands of beans are likely close substitutes, even if the tax rate was low, the taxed brand of beans would likely be wiped out - a pretty severe distortion. A tax on all beans would be less distortionary, a tax on all food better still, and a tax on everything best of all from this point of view. In the UK, most food, children's clothes and books are not subject to our 20% Value Added Tax, whilst most other goods are. Economists at the Treasury have long had their eye on these exemptions, whilst politicians and their advisors have jealously guarded them, on both distributional and electoral grounds. (Both sides are right in their own way)[^FN_VAT].
    """
end 

# ╔═╡ e3569d7b-9570-4ad9-9e9d-d94d81149bbc
begin
    md"""
    Sometimes subtleties in the tax code matter more than the headline tax rates. Consider corporation taxes - taxes on profits of companies. If a company is operating efficiently, and making the most profit it can (maximising profits), then in principle it has no reason to change what it's doing if a proportion of those profits are taken away - its before-tax plan is still the best it can do. Neutrality in this case means careful attention to the detail of the tax code so the notion of profit for the tax corresponds to the notion of profit that the company seeks to maximise.
    """
end 

# ╔═╡ 31068d97-cd76-4d90-a3f3-5548fc376a71
begin
    md"""
    As we've seen earlier in the course, there are many important counter examples. Collective action will always be required to supply "public goods" (for example defence) and to correct the distribution of income. Markets may fail altogether in some circumstances - where important information is unobtainable, for example[^FN_STIGLITZ]. Frequently the price that a free market would produce would not reflect the true marginal cost of things; so petrol pollutes, alcohol causes crime and illness, and so on - these are "externalities" that are not priced in in private transactions. In these cases there is a good argument for for having taxes that deliberately move the prices away from its free market level to reflect the full 'social' cost.
    """
end 

# ╔═╡ Cell order:
# ╟─72c7843c-3698-4045-9c83-2ad391097ad8
# ╟─006c839d-a617-42a1-b8e9-a16ff0d8758c
# ╟─0eb4b595-4a48-45d7-8dca-f4215848a8ab
# ╟─73dade1e-87b6-47bb-9d99-c05475d7c433
# ╟─7e931e34-9f35-47e1-a7af-86e14220dc2a
# ╟─3d93909b-7001-4d77-836e-77a3b16e8479
# ╟─e3569d7b-9570-4ad9-9e9d-d94d81149bbc
# ╟─31068d97-cd76-4d90-a3f3-5548fc376a71

