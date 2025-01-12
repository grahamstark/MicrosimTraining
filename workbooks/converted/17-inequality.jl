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

# ╔═╡ 5cfb3c89-4027-4c22-a3d8-c547d1eea6f1
begin
    md"""
    ### Inequality
    """
end 

# ╔═╡ 8287d810-60c1-4649-acc4-9e9c25227f62
begin
    md"""
    Inequality is a broader concept than poverty, defined across the whole population rather than just the poor[^FN_REL_POV].
    """
end 

# ╔═╡ 1ad152ab-a8fd-4f56-a3c8-93e587dc6458
begin
    md"""
    As with poverty, our job here is to take the intuitive notions we all have about whether some state is more or less equal than another and make them operational, so we can make broad but reasonably precise statement about the inequality of society and how possible reforms might change it.
    """
end 

# ╔═╡ cf7f997a-cc5d-424e-aa2b-8055456d0df9
begin
    md"""
    I'll start with a simple table and a diagram. In table 1 column we show all the incomes of the people a little economy. They've been sorted from the poorest at the top to the richest at the bottom. You can change the numbers in the income column (but please wait till we've explained them!). Next to that is the *cumulative population* - the sum of all the population up to that point; so the first cell is 1, the next 2 `(1+1)` and so on. Then we have the sum of incomes up to that point (so the first is 10, the next `10+11=21` and so on). Finally we have two columns which just re-express the cumulative populations and incomes as a share of the totals (the totals are recorded at the bottom) - as with poverty, a lot of the work on inequality is done using proportions and shares rather than absolute levels.  Since the total income is 145, and the poorest two people have 21, the share of the bottom two is 14.48% `(100*21/145)`, and so on.
    """
end 

# ╔═╡ 97355b5c-1b8f-493a-8b18-97cefb494357
begin
    md"""
    The graph to the left charts the cumulative population share on the x- axis against cumulative income share on the y-axis. This is the *lorenz curve* and this simple thing is probably the best tool we have for thinking systematically about inequality.
    """
end 

# ╔═╡ 414b6802-8314-44ac-8564-23ae4ba19bf5
begin
    md"""
    If you try changing the numbers in the income column, you'll see that the other columns get recalculated and the chart redisplayed. We invite you to get a feel for this by experimenting. In particular, please try:
    """
end 

# ╔═╡ dd9c6f83-73f8-4d7c-91c2-cf424a688975
begin
    md"""
    * what happens to the Lorenz curve when all the incomes are equal - so, all the incomes cell have the same numbers in them? (Can you predict the Lorenz curve before you try changing the numbers?)* what happens when the distribution is completely *unequal* - so the first 9 incomes are zero and the top one has everything? Again, can you draw what you think the Lorenz should look like before you try?
    """
end 

# ╔═╡ 3adc4346-9e37-4afc-ad38-a8db13424de8
begin
    md"""
    You'll have seen (and may have realised anyway) that with perfect equality, the Lorenz curve is a straight diagonal line. With perfect equality, the first 10% of the population have a 10% share of income, the first 20% of population have 20% of total income, and so on.
    """
end 

# ╔═╡ 08fcd5d6-9d17-4917-9433-d2e2a16ac423
begin
    md"""
    With perfect inequality, the share of everyone but the top person is zero, and the top person has 100%.
    """
end 

# ╔═╡ 11a5070a-e568-4d50-b9c1-f996e0dfacca
begin
    md"""
    So, the more equal a country is, the closer the lorenz curve will be to the diagonal, and, conversely, the more unequal it is, the more the curve will be bowed away from the diagonal. Again, we invite you to play with the incomes to confirm this for yourself.
    """
end 

# ╔═╡ e331216a-d946-4c52-a9ef-f3fe689ac4f7
begin
    md"""
    #### The Gini Coefficient - The Standard Measure of Poverty
    """
end 

# ╔═╡ 95516ca1-1f99-472c-a2d1-7c3d092b2563
begin
    md"""
    The *Gini Coefficient* is a a nice way of summarising this, and is the most widely quoted inequality measure. In the  diagram below we've shaded the area between the perfect equality diagonal and the actual Lorenz curve in yellow.
    """
end 

# ╔═╡ 7ca43e44-39d1-4322-adff-f8c1e4f3b861
begin
    md"""
    ![Gini Example](./images/gini-shaded-yellow.png)
    """
end 

# ╔═╡ 48d39f79-cac7-497e-8efa-f8d548e6c243
begin
    md"""
    The bigger the yellow area the greater the inequality. The Gini Coefficient just expresses this area as a percentage[^FNPCT] of the triangle ABC in the diagram. Complete inequality gives a Gini of 1, and complete equality gives 0.
    """
end 

# ╔═╡ 1e29bb69-8c2b-4368-bd74-bcf3b3225971
begin
    md"""
    Chart 2, below, from the World Bank shows some international comparisons of Gini Coefficients [^FN_WORLD_BANK_GINI]
    """
end 

# ╔═╡ 413db9b1-d314-4e10-91ed-7fb40ed79949
begin
    md"""
    
    """
end 

# ╔═╡ 94a88896-81c9-49b2-999b-d8683d758ce8
begin
    md"""
    |   country   |  Gini (%) ||-------------|---------||  Australia  | 35.8 || Czech Republic|  29.9 || Denmark | 28.2 || UK | 33.2 || USA | 41.5 || South Africa | 63.0 |
    """
end 

# ╔═╡ b7c9b90d-3995-4c35-9426-3db5f012e6b4
begin
    md"""
    
    """
end 

# ╔═╡ 48f520ff-23fb-4758-9ed1-5780900ae6fd
begin
    md"""
    You can see that the UK has a high inequality by European standards, but a low one compared to the USA or South Africa.
    """
end 

# ╔═╡ 62339bf5-5daa-4d7c-ba95-0b79332d5599
begin
    md"""
    And here is a chart showing the UK Gini Coefficient over time, using many years of our HBAI data we encountered earlier.
    """
end 

# ╔═╡ 856495b7-8d02-4297-8d0d-821ba2ca0475
begin
    md"""
    ![UK Gini Time Series](./images/gini-by-year.png)Source: [@department_for_work_and_pensions_households_2019]
    """
end 

# ╔═╡ 1a0f43cd-085f-48b7-84c3-db8bdc08f63a
begin
    md"""
    UK Inequality rose sharply during the Thatcher administration but has been roughly steady since then. The 2008 recession actually *reduced* inequality on the Gini measure, mainly by wiping out some very high incomes in the financial sector.
    """
end 

# ╔═╡ 87c7d840-10af-4eb0-8c8f-6c203419d7d3
begin
    md"""
    #### Advanced Measures of Inequality
    """
end 

# ╔═╡ 25871b2c-b382-4bcf-9c28-c416e3eb8bc0
begin
    md"""
    There is a huge technical literature on inequality. Many other summary indexes have been proposed, each with different desirable properties[^FN_INDEXES]. For example:
    """
end 

# ╔═╡ 578b0620-ccee-4398-b0dd-8da8ae987b7c
begin
    md"""
    * the *Theil index* has the feature that it can be neatly disaggregated to show the contribution of different groups to inequality; for example, the rise in UK inequality in the 80s and early 90s was accompanied by large changes in Regional inequality. With the Theil index one can split changes in overall inequality into changes in inequality *between* regions (London vs the South East, for example) and changes *within* regions (greater inequality in London between financial workers and the rest);* The *Atkinson index* allows inequality to depend not just on the distribution of income, but also on the analyst's (or society's) views on inequality ("Inequality Aversion");* The Palma Index [^FN_PALMA] has recently become popular - it's simply the ratio between the share of the richest 10% of the population and the poorest 40%.
    """
end 

# ╔═╡ e3ff6baf-ed5d-42ab-8d3d-ec3183083959
begin
    md"""
    As with poverty measures, there's a tension between how sophisticated these measures are and how easy they are to explain to non-specialists. The Palma index, in particular, is very easy to explain, and so has become very popular, but arguably lacks a strong basis - it clearly violates Dalton's principle, for example, since upward redistributions within the bottom 40%, the middle 50, or the top 10%, do not change the value of the Palma.
    """
end 

# ╔═╡ b9af0fef-e63b-4c6a-b6f0-55eebb9d5366
begin
    md"""
    #### Activity
    """
end 

# ╔═╡ de4240b8-8255-4134-9f1f-96f0df52e1a6
begin
    md"""
    What happens to poverty, inequality, and mean and median incomes if:
    """
end 

# ╔═╡ Cell order:
# ╟─72c7843c-3698-4045-9c83-2ad391097ad8
# ╟─5cfb3c89-4027-4c22-a3d8-c547d1eea6f1
# ╟─8287d810-60c1-4649-acc4-9e9c25227f62
# ╟─1ad152ab-a8fd-4f56-a3c8-93e587dc6458
# ╟─cf7f997a-cc5d-424e-aa2b-8055456d0df9
# ╟─97355b5c-1b8f-493a-8b18-97cefb494357
# ╟─414b6802-8314-44ac-8564-23ae4ba19bf5
# ╟─dd9c6f83-73f8-4d7c-91c2-cf424a688975
# ╟─3adc4346-9e37-4afc-ad38-a8db13424de8
# ╟─08fcd5d6-9d17-4917-9433-d2e2a16ac423
# ╟─11a5070a-e568-4d50-b9c1-f996e0dfacca
# ╟─e331216a-d946-4c52-a9ef-f3fe689ac4f7
# ╟─95516ca1-1f99-472c-a2d1-7c3d092b2563
# ╟─7ca43e44-39d1-4322-adff-f8c1e4f3b861
# ╟─48d39f79-cac7-497e-8efa-f8d548e6c243
# ╟─1e29bb69-8c2b-4368-bd74-bcf3b3225971
# ╟─413db9b1-d314-4e10-91ed-7fb40ed79949
# ╟─94a88896-81c9-49b2-999b-d8683d758ce8
# ╟─b7c9b90d-3995-4c35-9426-3db5f012e6b4
# ╟─48f520ff-23fb-4758-9ed1-5780900ae6fd
# ╟─62339bf5-5daa-4d7c-ba95-0b79332d5599
# ╟─856495b7-8d02-4297-8d0d-821ba2ca0475
# ╟─1a0f43cd-085f-48b7-84c3-db8bdc08f63a
# ╟─87c7d840-10af-4eb0-8c8f-6c203419d7d3
# ╟─25871b2c-b382-4bcf-9c28-c416e3eb8bc0
# ╟─578b0620-ccee-4398-b0dd-8da8ae987b7c
# ╟─e3ff6baf-ed5d-42ab-8d3d-ec3183083959
# ╟─b9af0fef-e63b-4c6a-b6f0-55eebb9d5366
# ╟─de4240b8-8255-4134-9f1f-96f0df52e1a6

