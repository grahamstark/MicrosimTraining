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

# ╔═╡ b0bc0cb6-c068-4309-b6ac-159d1dc1070b
begin
    md"""
    ### Budget Constraints 1 - Income Taxes
    """
end 

# ╔═╡ 92aee33a-12d0-41a5-94c2-c6dd91779b20
begin
    md"""
    We're going to start exploring our model by using it to generate a simple diagram: a *budget constraint*.
    """
end 

# ╔═╡ 59790ae1-7ccb-489c-bb7a-175c091ec85e
begin
    md"""
    Above, to the left, we have some input fields you can use to sets up a simple income tax system. The first field is a *tax allowance*. This is the amount you can earn tax-free. Income above the tax allowance is *taxable income*. Underneath the allowance field, we have two fields for tax rates. We'll call the first the *basic rate* and the second the *higher rate*. Below those is the *higher rate threshold* field. You pay at the basic rate till your taxable income exceeds the higher rate threshold, and any taxable income more than the threshold is taxed at the higher rate.
    """
end 

# ╔═╡ 697d2b88-a3de-4587-b3ad-f0868b31f915
begin
    md"""
    As an example, suppose your income was £40,000 per year, the allowance as £5,000, the basic rate 20%, the higher rate was 40% and the higher rate threshold £20,000. Then:
    """
end 

# ╔═╡ 5dcf57ef-b24c-4b58-94a8-8c249ea0405b
begin
    md"""
    taxable income would be: * (40,000-5,000) = 35,000 *tax at the basic rate would be:  * 20%×20,000 = 4,000 *tax at the higher rate would be:  * (35,000-20,000)×40% = 6,000 *so total tax due would be: * (4,000+6,000) = £10,000 *
    """
end 

# ╔═╡ e725e5b0-359e-4fc7-9766-11095ae002c5
begin
    md"""
    Many tax systems have more than two rates (the Scottish system has five): I show two just to keep things simple. A complete description of the UK tax system would need a lot more than these four parameters, but I want to keep things as clear as possible for now. You can get a good feel for how a real world tax system works just with these four numbers.
    """
end 

# ╔═╡ 71e8a0cc-9183-4947-95b3-c46415d17bb6
begin
    md"""
    *A Note on periods* A slightly confusing thing here is that the allowances and bands on the left are in £s per annum, whilst the graph is in £ per week. Taxes are normally expressed in annual amount, whilst benefits (and our FRS data) are normally expressed weekly or monthly. And from the next page on we'll have taxes and benefits on the same page. I've tried to keep everything in its most natural units, but I appreciate this can be confusing at first.
    """
end 

# ╔═╡ f022a0e1-e877-412d-9f63-61b11348939e
begin
    md"""
    On this page, the tax rates and allowances are initially set to zero - that may make it easier for you to see what the effects are of your choices of tax rates and allowances.
    """
end 

# ╔═╡ a72ec3bb-2007-4b64-9271-5e539d6b5c30
begin
    md"""
    To the right of the inputs is our *budget constraint* graph. It shows for one person, or one family, the relationship between income *before* taxes (*gross income*) on the x- (horizontal) axis, and income *after* taxes have been taken off on the y- (vertical) axis. It's often useful to think of the gross income as being pre-tax earnings.
    """
end 

# ╔═╡ 9e337c18-0349-49d3-9b7f-609ff3aeb8fa
begin
    md"""
    The button at the bottom of the input fields sends your tax choices to the model, and the models does the needed suums and sends back a graph showing all the possible gross vs net income combinations for earnings from £0 to £2,000 per week[^FN_BUDGET_CONSTRAINT].
    """
end 

# ╔═╡ 49b8d376-6522-4d39-b382-bd12f927f8f7
begin
    md"""
    If there are no taxes (and no benefits - I'll come to benefits in the next page), then if you earn £1, your net income will be £1, £100 gross gives you £100 net and so on. So the graph showing gross versus net income - the budget constraint - should simply be a 45% line up the middle of the chart. We invite you to check this by now by pressing the 'run' button with the default zero tax rates and allowance.
    """
end 

# ╔═╡ d21174c8-15db-46e7-b9e8-df3b0a55ba86
begin
    md"""
    Now, I'd like you to experiment a little. Try setting the tax allowance and tax rates to some positive values just to get a feel for what happens.
    """
end 

# ╔═╡ 810cebc8-156a-413e-978f-db1562546004
begin
    md"""
    ####  Budget Constraints And the orthodox analysis of labour supply
    """
end 

# ╔═╡ 0a984089-133f-4754-bca6-e96df12505ad
begin
    md"""
    In mainstream economics, people are assumed to make rational choices, choosing the best possible thing given their preferences and the constraints they face. An elaborate theory has been constructed about the nature of peoples preferences. But it turns out we don't need much of this to get far in understanding choice - often all we need is to enumerate the constraints that they face, and the best choice is then often self-evident.
    """
end 

# ╔═╡ 76508727-a6b3-4749-82a4-bbae616e571b
begin
    md"""
    Economists draw budget constraints to help them understand all kinds of choices. In block XX week YY, you encountered one drawn between consumption now and consumption in the future, and you saw how that could help you understand savings decisions. Indeed, although not always drawn out, there are implicit budget constraints in practically everything in the course; for example between sugar and all other goods in the discussion of sugar taxes, or a 'Government Budget Constraint' in the cost-benefit-analysis week.
    """
end 

# ╔═╡ 09805d4f-715e-4bb9-a843-ab916a344540
begin
    md"""
    However, although it's standard in the microsimulation field to call the graph we're drawing here a budget constraint, it's actually slightly different from the examples you normally find in textbooks. Crucially, I'm drawing this graph flipped round horizontally from the normal one.
    """
end 

# ╔═╡ 3263fabd-1ade-42d2-af4b-12479f2bbe68
begin
    md"""
    When we analyse how direct taxes and benefits affect the economy, it's natural to focus on the supply of labour - for a start, if a tax increase caused people to work less, it could backfire and cause revenues to fall. So he budget constraint that's normally used to illustrate the choice of how much to work is set up in a slightly unintuitive way, so as to make it easy to analyse this aspect. The goods are *consumption* (usually on the y- axis) and *leisure* on the x- axis. So instead of studying the supply of labour directly, the analysis flips things round and studies the demand for leisure.
    """
end 

# ╔═╡ 96602014-8369-4c99-9a1c-8b1314fb94c3
begin
    md"""
    Every available hour not consumed as leisure spent working; that is exchanged for  at consumption goods at some hourly wage.
    """
end 

# ╔═╡ 79aa386b-bb33-425d-9ca7-271aeea07d10
begin
    md"""
    In effect, the person's wage is playing two roles here:
    """
end 

# ╔═╡ 8cadef33-98a9-4492-a399-7ea276ff573b
begin
    md"""
    * it's the source of the person's income - as wages go up, the income from every hour that you work increases, so workers can afford more time doing the things they really like doing;* but it's also the price of leisure - as wages go up, taking an extra hour in bed or at the beach means you're giving up more consumption goods.
    """
end 

# ╔═╡ e64a89d0-808d-4765-a011-70cf0eec3086
begin
    md"""
    These two aspects of a wage - the 'income effect and the 'substitution effect' - work against each other, and are often thought to roughly cancel out, so increases or decreases in hourly wages might not make much difference to how much people want to work. Note that even if a tax increase has no effect on labour supply for this reason, it's still effecting choices and hence welfare - a tax increase with no change in labour supply must mean that consumption of goods, and hence the welfare of the worker, is lower, and the price system is distorted.
    """
end 

# ╔═╡ 85a07571-da6e-458b-b697-d77c9c1ce5f5
begin
    md"""
    ![Wage Increase Diagram](./images/wage_increase.png)
    """
end 

# ╔═╡ ca0cc254-5780-4ec5-bfed-92452eb99155
begin
    md"""
    Of course, this analysis needs to be modified in many ways - for example, many office workers might not get paid more if they stay late at work, or workers may be on fixed hours contracts and so unable to vary their hours, many people enjoy  their work (at least up to some limit) and so on. Plus, of course, wages are not be the only source of income. Nonetheless, this the mainstream approach offers a simple but powerful analysis.
    """
end 

# ╔═╡ 640c02a2-07af-4a20-847f-52b379d31802
begin
    md"""
    If you think about it, the key thing here is that consumers own a thing (their time) that is both a source of income and something that they want to consume directly (as leisure). Many economic problems have this characteristic. The two-period consumption versus saving example from block XX is an example. The choices of subsistence farmers between consuming their own crops or selling them at market is another.
    """
end 

# ╔═╡ e07e078d-e91e-4f7f-99f8-e1b2dfbd3c78
begin
    md"""
    ##### Activity:1. Activity: look back at the 2 period saving/consumption diagram of Block XX. How would you analyse the effect of an interest rate rise on period 1 consumption using the ideas you've just encountered? Answer if the interest rate goes up, lifetime wealth (amount available to consume over both periods) goes up but the marginal cost of period 1 consumption also goes up since each extra £ spent in period 1 costs more in terms of foregone consumption in period 2. Hence the effect of an interest rate increase on period 1 consumption is ambiguous.2. (Note this is a rather difficult question). Using this framework, can you suggest why employers might offer overtime (higher wages for hours worked above the standard amount)? How does the analysis of overtime in this framework differ from the analysis of an across-the-board wage increase? Answer: overtime offers higher wages only for extra hours worked at not for all hours worked. This effectively removes the income effect that you would see from a general wage increase, leaving only the substitution effect.
    """
end 

# ╔═╡ bf1e3129-ac16-4a90-9a1f-ba1f2b5337bf
begin
    md"""
    
    """
end 

# ╔═╡ 8f9419f3-212e-42ae-8f0b-d210670527b7
begin
    md"""
    #### Some important measures
    """
end 

# ╔═╡ 62f1c6b9-705d-4e51-9376-4503ee43e074
begin
    md"""
    We'll use the budget constraint graph to introduce some important ideas: *marginal tax rates*, *average tax rates*, and *replacement rates*. Replacement rates make more sense when we can consider state benefits and taxes together, which we do in the next screen, so we'll hold off on that one for now.
    """
end 

# ╔═╡ c23b3855-e088-4640-9872-99a1628d39ac
begin
    md"""
    The *Marginal tax rate* (MTR) is the rate of tax on the next £1 that someone earns. We've seen in our discussion on fiscal neutrality that this is the key number for understanding how taxes distort the economy. In this case, it's pretty easy to work out - since there is only one tax, with two tax rates and an allowance - the MTRs are 0, up to the tax allowance, then 20% up to the higher rate threshold, then 40% from then on. In the diagram, the MTR measures the extent to which the tax system flattens out the budget constraint compared to the 45° line - with a marginal rate of 0, you keep all of the next £ that you earn, with a MTR of 100% (which as we'll see in a minute, is all too possible) you keep none of the next £1, so the budget constraint would be horizontal.  If you hover your mouse over the points on the budget constraint, the program will display the MTR at that point.
    """
end 

# ╔═╡ 9e9421fa-7d87-4793-8bb2-7293ef20d5d4
begin
    md"""
    The  *Average tax Rate* is the proportion of total income you pay in tax.  Some important choices are all-or-nothing rather than marginal, and for those, the average tax rate is more important than the marginal one. For example, back at the very start we saw a brief discussion of the fear that higher taxes in Scotland might encourage people to move to England. For this decision, people are choosing which side of the border they would to earn *all* of their income on, not just the next £1[^FN_SFC_2].
    """
end 

# ╔═╡ 2ef433d2-61e0-461a-8dd4-57f2c7c48378
begin
    md"""
    If the average tax rate rises with income, so a bigger proportion of income is taken in tax from rich people than poorer ones, the tax system is said to be *progressive*. Note that a progressive tax system *doesn't* require marginal tax rates to be rising, so long as there is a tax allowance, since, with an allowance, the proportion of income that is taxable is higher for a rich person than a poorer one. We invite you to verify this by setting the basic and higher tax rates equal and examining the average tax rate at various points.
    """
end 

# ╔═╡ 443e21d6-e857-4621-971a-53d01223425a
begin
    md"""
    There's one further measure that's worth discussing here. Consider Edward, who earns £20,000 per anum. His tax allowance means that he has a taxable income of £10,000 (20,000-1000), and so pays tax of £2,000 (10,000×20%), with 20% also being his MTR. Ed would be in exactly the same position if he was taxed on *all* his income (so 20,000×20% or 4,000) and then given a tax-credit of £2,000, which is his tax allowance of £10,000 × his MTR of 20%. In other words his tax allowance has a cash value to him of £2,000. There's much more to the tax and benefit system than the income tax we're showing here, but no matter how convoluted the system gets, you can always summarise the entirety of someone's position using just his MRT and this notional tax credit; this is a very useful trick when thinking about even the most complicated system[^FN_ESRI].
    """
end 

# ╔═╡ 1f8f56a6-9388-4288-aa95-2df2d7644a6b
begin
    md"""
    Figure XX below tries to summarise all these points in a stylised version of our budget constraint diagram.
    """
end 

# ╔═╡ 62878556-6c51-45e6-b2f4-4dd3c4db7e3e
begin
    md"""
    ![Illustration of METR,ATR and Tax Credit](./images/bc-1.png)
    """
end 

# ╔═╡ 9c080ef2-52d3-402d-b8f9-d25368a943ed
begin
    md"""
    
    """
end 

# ╔═╡ a03d8ace-6090-494f-adac-b9fc67520634
begin
    md"""
    ##### Activity
    """
end 

# ╔═╡ Cell order:
# ╟─72c7843c-3698-4045-9c83-2ad391097ad8
# ╟─b0bc0cb6-c068-4309-b6ac-159d1dc1070b
# ╟─92aee33a-12d0-41a5-94c2-c6dd91779b20
# ╟─59790ae1-7ccb-489c-bb7a-175c091ec85e
# ╟─697d2b88-a3de-4587-b3ad-f0868b31f915
# ╟─5dcf57ef-b24c-4b58-94a8-8c249ea0405b
# ╟─e725e5b0-359e-4fc7-9766-11095ae002c5
# ╟─71e8a0cc-9183-4947-95b3-c46415d17bb6
# ╟─f022a0e1-e877-412d-9f63-61b11348939e
# ╟─a72ec3bb-2007-4b64-9271-5e539d6b5c30
# ╟─9e337c18-0349-49d3-9b7f-609ff3aeb8fa
# ╟─49b8d376-6522-4d39-b382-bd12f927f8f7
# ╟─d21174c8-15db-46e7-b9e8-df3b0a55ba86
# ╟─810cebc8-156a-413e-978f-db1562546004
# ╟─0a984089-133f-4754-bca6-e96df12505ad
# ╟─76508727-a6b3-4749-82a4-bbae616e571b
# ╟─09805d4f-715e-4bb9-a843-ab916a344540
# ╟─3263fabd-1ade-42d2-af4b-12479f2bbe68
# ╟─96602014-8369-4c99-9a1c-8b1314fb94c3
# ╟─79aa386b-bb33-425d-9ca7-271aeea07d10
# ╟─8cadef33-98a9-4492-a399-7ea276ff573b
# ╟─e64a89d0-808d-4765-a011-70cf0eec3086
# ╟─85a07571-da6e-458b-b697-d77c9c1ce5f5
# ╟─ca0cc254-5780-4ec5-bfed-92452eb99155
# ╟─640c02a2-07af-4a20-847f-52b379d31802
# ╟─e07e078d-e91e-4f7f-99f8-e1b2dfbd3c78
# ╟─bf1e3129-ac16-4a90-9a1f-ba1f2b5337bf
# ╟─8f9419f3-212e-42ae-8f0b-d210670527b7
# ╟─62f1c6b9-705d-4e51-9376-4503ee43e074
# ╟─c23b3855-e088-4640-9872-99a1628d39ac
# ╟─9e9421fa-7d87-4793-8bb2-7293ef20d5d4
# ╟─2ef433d2-61e0-461a-8dd4-57f2c7c48378
# ╟─443e21d6-e857-4621-971a-53d01223425a
# ╟─1f8f56a6-9388-4288-aa95-2df2d7644a6b
# ╟─62878556-6c51-45e6-b2f4-4dd3c4db7e3e
# ╟─9c080ef2-52d3-402d-b8f9-d25368a943ed
# ╟─a03d8ace-6090-494f-adac-b9fc67520634

