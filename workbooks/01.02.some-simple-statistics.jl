### A Pluto.jl notebook ###
# v0.20.4

using Markdown
using InteractiveUtils

# ╔═╡ 72c7843c-3698-4045-9c83-2ad391097ad8
# ╠═╡ show_logs = false
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

# ╔═╡ 67980aee-51d2-472d-9099-8be80ecae212
begin
    md"""
    ## Some Concepts
    """
end 

# ╔═╡ c80f2400-0019-48cc-aaf0-1f8a30813205
begin
    md"""
    Economics is about people - about how people behave, and whether we can make people better or worse off in some sense. But there are a lot of people - 60m in the UK, and every one is different. In principle we could just list the effects of some tax change on all 60m, but without some organising principles it would be impossible to make sense of the results. If we are going to get anywhere here we need some abstractions.
    """
end 

# ╔═╡ adec5729-3466-44ff-b5a2-3088b6ab3701
begin
    md"""
    So, in this section, I'll start by briefly revisiting the summary statistics you met in block 1 - means, medians, totals, and some simple charts. In subsequent sections we'll then briefly discuss poverty, inequality - these everyday words have distinct technical meanings here[^FN_POVOLD]. Mostly we'll be talking about people's incomes, but before we get on to the model, I'll briefly double back and discuss what the thing that we're trying to summarise should be: should it be people's income, or consumption, or should we go directly for some measure of happiness? Do we need to account for different living arrangements?
    """
end 

# ╔═╡ b9425083-9df6-46d4-82d3-7d1bdfff894c
begin
    md"""
    ### Summary Statistics
    """
end 

# ╔═╡ 4ec78fb9-9ad2-4aba-9c82-0eca370210b2
begin
    md"""
    Here's a picture of one measure of the UK income distribution, as a bar chart.
    """
end 

# ╔═╡ 3a1f9e5c-a74c-446c-b0ce-4dc3aba8ff89
load(joinpath(artifact"main_data","images", "uk_income_hbai_2018-8.png"))


# ╔═╡ 7fc9ebc8-3d7b-4d8c-884b-23493f6313ec
begin
    md"""
    This comes from thee [Department for Work and Pensions]() (DWP) [Households Below Average Income]() (HBAI) data series [^FN_HBAI]
    """
end 

# ╔═╡ e9796a54-7b8e-4fe5-8947-0dc1efb89185
begin
    md"""
    This shows distribution an official UK measure of income for the financial year 2017/8[^FN_FINANCIAL_YEAR], the latest available at the time of writing:
    """
end 

# ╔═╡ 1dcb942c-3187-4aa9-9493-93a1cf92ae53
udata = CSV.File( joinpath(artifact"main_data", "data", "unicoria-incomes.tab")) |> DataFrame

# ╔═╡ 4fb5cf04-2a9a-4a39-82dc-42f300f1285b
median(udata.eq_bhc_net_income, Weights(udata.weight))

# ╔═╡ 8c840fc5-beb3-4396-8767-5136ee2bb73c
mean(udata.eq_bhc_net_income, Weights(udata.weight))

# ╔═╡ f26395e4-02dd-4e62-8b65-9b3cb594dca2
maximum( udata.eq_bhc_net_income)

# ╔═╡ 611a9bb6-d977-42fe-b7d0-765b2275b440
censdata = udata[ (udata.eq_bhc_net_income .< 1000) .& (udata.eq_bhc_net_income .> 0), :]

# ╔═╡ 53cb5179-5d5b-4ec7-af1d-7bee173a8064
hist( censdata.eq_bhc_net_income; weights=censdata.weight, color=:pink, bins=40)

# ╔═╡ b8fd6f10-24ce-4720-8667-9095c1216d2d
begin
    md"""
    The income measure is "Equivalised Net Household Income, Before Housing Costs". In the sections that follow we'll discuss in some detail what you should take each of those words to mean, and consider some other possible measures. But for now, just think of it as "UK income".
    """
end 

# ╔═╡ 7d596303-be1b-4218-9ed5-458c3c2e271b
begin
    md"""
    The chart uses data from the Family Resources Survey (FRS) [^FN_FRS], a large annual survey that provides detailed information about the incomes and living circumstances of households and families in the UK. The microsimulation model used later in this section also uses the FRS. The FRS is one of several large UK surveys. I'll further discuss large sample surveys below, and let you explore the FRS using our tax-benefit model.
    """
end 

# ╔═╡ 2b628154-5a7d-42f0-b968-18a5e3e4c3f1
begin
    md"""
    There's a lot of useful material in this graph. Income in £per week is on X-axis, in £10 bands, and an estimate of the numbers of people in each band on the y-axis.
    """
end 

# ╔═╡ 9c7b369f-e72b-4c8c-92f8-29b652b49311
begin
    md"""
    The chart is a little misleading in that it stops at £1,000pw. In reality, there are people with incomes higher than that - literally off-the-scale - so the full graph stretches far to the right. It's likely that the chart is truncated at £1,000 because very high incomes are hard to measure; I'll return to this point later,
    """
end 

# ╔═╡ 707568d0-13ed-4175-9660-20f96a1f084e
begin
    md"""
    It's useful to be able to summarise this data in various ways. The mean and median that you encountered in block 1 are useful:
    """
end 

# ╔═╡ d04e44db-c3e9-4f27-9297-cd5bfaaf16c6
begin
    md"""
    * The Mean income is £613;* the Median £517: half the population is richer than the median, and half poorer;
    """
end 

# ╔═╡ 81439da8-91ad-4fbf-a789-0e06812bb2ea
begin
    md"""
    Note how the mean income is nearly £100 higher than the median. This is because there are a large number of relatively small incomes (around where the graph peaks), but a few very large ones out to the right (incomes are 'skewed right'). The large incomes pull the mean up away from the median. Right-skewed data like this is very common in economics - not only income but the size of companies or national incomes of countries, or the distribution of wealth or consumption.
    """
end 

# ╔═╡ 46e9d905-f47a-4b45-9fa1-b4bedd190cf1
begin
    md"""
    #### Activity
    """
end 

# ╔═╡ 6d8a4a00-16ad-4546-8cfc-388e4ae3f3df
begin
    md"""
    Open [this spreadsheet](/activities/activity_1.xlsx). It contains some income distribution data for an imaginary country of 1,000 people. Incomes are heavily right-skewed.
    """
end 

# ╔═╡ 02db3f2e-e1f2-410a-a4fd-65a8fb975075
begin
    md"""
    1) Find the minimum, maximum, mean and the median. Ans:
    """
end 

# ╔═╡ e91b46d1-5664-472a-aafe-559b81928457
begin
    md"""
    min	43.69max	22,640.63mean	1,696.22median	1,043.17
    """
end 

# ╔═╡ 1518414f-0aef-488a-8fcf-93e2e5477525
begin
    md"""
    2) Draw a bar chart similar the HBAI chart above (don't worry about creating the shading). Ans: should look a bit like:![Bar Chart of 1,000 log-normal incomes](./activities/activity_1.svg)
    """
end 

# ╔═╡ 92851ec7-9680-40ae-b429-918409563122
begin
    md"""
    2) Now double the income of the 10 richest people. What happens to the mean and median. Ans:
    """
end 

# ╔═╡ 3a03c7b5-8e81-429c-8da2-62d78e6b362f
begin
    md"""
    min	43.69max	45,281.25mean	1,857.70median	1,043.17
    """
end 

# ╔═╡ b1a74461-66bb-4929-a4b9-8b787e055f50
begin
    md"""
    
    """
end 

# ╔═╡ 9d964ada-4743-4f5a-b4a6-db34fb8d0744
begin
    md"""
    #### Other things to note
    """
end 

# ╔═╡ d6f0c83b-3828-4bed-9174-a3484f95bc66
begin
    md"""
    The insensitivity to changes at the very top that you see in the activity is why the median is often preferred to the mean in economic discussions. Very high incomes are hard to measure in sample surveys, because it's hard to persuade very rich people to participate, because those rich people who do participate may understate their income, and because the circumstances of the rich can be too complex to fit easily into a standard survey, and so recorded top incomes are uncertain and tend to jump around from year-to-year[^FN_SPI].
    """
end 

# ╔═╡ 0784dc16-f6d0-429b-93e4-e85353068f16
begin
    md"""
    When you hear a discussion about how some change affects an "average person", you should remember that an average person could well be comparatively rich.
    """
end 

# ╔═╡ cf6c3cc8-6b19-4139-aabb-fa7fc90a2c36
begin
    md"""
    A couple of other things of note in that graph.
    """
end 

# ╔═╡ b890a945-9780-4385-bac4-16abfa8861e4
begin
    md"""
    1. The Line marked "60% of median (£304pw)" is the official UK poverty line - 60% of median income for that year (note the use of median over mean, for the reasons we've just discussed). We return to poverty below.2. The chart is shaded into `deciles`. The dark area on the left labelled "1" contains the poorest tenth of the population, the lighter area labelled "2" to the left of that is the next poorest tenth and so on. Chopping the population up like into progressively richer chunks is a simple but very useful trick. For example, you can see that the mean is 1/2 way up the 7th decile, so about 65% of people have an income less than the mean[^FN_INCOME_HHLD], and that the poverty line is just below the start of the 3rd decile, so about 18% of people are in poverty, on this measure. We'll be using deciles a lot in what follows
    """
end 

# ╔═╡ Cell order:
# ╠═72c7843c-3698-4045-9c83-2ad391097ad8
# ╟─67980aee-51d2-472d-9099-8be80ecae212
# ╟─c80f2400-0019-48cc-aaf0-1f8a30813205
# ╟─adec5729-3466-44ff-b5a2-3088b6ab3701
# ╟─b9425083-9df6-46d4-82d3-7d1bdfff894c
# ╠═4ec78fb9-9ad2-4aba-9c82-0eca370210b2
# ╟─3a1f9e5c-a74c-446c-b0ce-4dc3aba8ff89
# ╟─7fc9ebc8-3d7b-4d8c-884b-23493f6313ec
# ╟─e9796a54-7b8e-4fe5-8947-0dc1efb89185
# ╠═1dcb942c-3187-4aa9-9493-93a1cf92ae53
# ╠═4fb5cf04-2a9a-4a39-82dc-42f300f1285b
# ╠═8c840fc5-beb3-4396-8767-5136ee2bb73c
# ╠═f26395e4-02dd-4e62-8b65-9b3cb594dca2
# ╠═611a9bb6-d977-42fe-b7d0-765b2275b440
# ╠═53cb5179-5d5b-4ec7-af1d-7bee173a8064
# ╟─b8fd6f10-24ce-4720-8667-9095c1216d2d
# ╟─7d596303-be1b-4218-9ed5-458c3c2e271b
# ╟─2b628154-5a7d-42f0-b968-18a5e3e4c3f1
# ╟─9c7b369f-e72b-4c8c-92f8-29b652b49311
# ╟─707568d0-13ed-4175-9660-20f96a1f084e
# ╟─d04e44db-c3e9-4f27-9297-cd5bfaaf16c6
# ╟─81439da8-91ad-4fbf-a789-0e06812bb2ea
# ╟─46e9d905-f47a-4b45-9fa1-b4bedd190cf1
# ╟─6d8a4a00-16ad-4546-8cfc-388e4ae3f3df
# ╟─02db3f2e-e1f2-410a-a4fd-65a8fb975075
# ╟─e91b46d1-5664-472a-aafe-559b81928457
# ╟─1518414f-0aef-488a-8fcf-93e2e5477525
# ╟─92851ec7-9680-40ae-b429-918409563122
# ╟─3a03c7b5-8e81-429c-8da2-62d78e6b362f
# ╟─b1a74461-66bb-4929-a4b9-8b787e055f50
# ╟─9d964ada-4743-4f5a-b4a6-db34fb8d0744
# ╟─d6f0c83b-3828-4bed-9174-a3484f95bc66
# ╟─0784dc16-f6d0-429b-93e4-e85353068f16
# ╟─cf6c3cc8-6b19-4139-aabb-fa7fc90a2c36
# ╟─b890a945-9780-4385-bac4-16abfa8861e4
