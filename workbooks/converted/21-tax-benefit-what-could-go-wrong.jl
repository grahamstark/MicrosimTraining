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

# ╔═╡ 261b9a74-7b4a-4816-b53d-9f29d562fbcc
begin
    md"""
    ## Tax Benefit Models: What Could Possibly Go Wrong?
    """
end 

# ╔═╡ ed136fac-9811-4eeb-a100-0de56b71e664
begin
    md"""
    Our model doesn't calculate what the people and households in our dataset will actually receive in benefits or pay in tax; rather, it calculates *entitlements* to benefits and *liabilities* to tax are. In terms of our earlier discussion, we are modelling *formal incidence*. People's entitlements and liabilities are important to know in themselves, but to go from liabilities and entitlements to what's actually received in tax and paid out in benefits requires a few extra steps that our simple model does not take. Further, by default we're assuming that no-one reacts to tax and changes, for instance by changing their spending or work patterns, or even by moving to a different jurisdiction. We'll consider these things in turn.
    """
end 

# ╔═╡ a9872062-21be-450a-be1a-a6a9e74ab533
begin
    md"""
    ### Unclaimed Benefits
    """
end 

# ╔═╡ 0b9c77ca-15b5-4e41-8383-8d3c9295faf7
begin
    md"""
    Our FRS dataset records actual receipts of state benefits as part of its record of peoples incomes. These recorded receipts are often different from the values a tax benefit model predicts. In particular, there are often cases where there a person is modelled to have an entitlement to some benefit but there is no recorded receipt. Typically the modelled entitlement for these case is relatively small. It's usual to interpret this as *non-take-up* - the modelled entitlements are correct but some people are choosing not to claim them, perhaps because of stigma or because the costs of claiming exceed the anticipated benefits. The fact that it's typically small amounts that seem to be unclaimed is consistent with this view[^FN_FRY_STARK], but it's also consistent with the view that we are making errors when we model entitlements and so the small entitlements that appear not to be taken up are actually just modelling mistakes[^FN_DUCLOS]. Either way, the way to correct for apparent non-take-up is the same: we construct a statistical model a bit like the ones we've seen, except it predicts whether a modelled entitlement is taken up or not - explanatory variables are the modelled entitlement and characteristics of the household like age of the head, presence of children and the like. Our little model does not have such a correction; since it's small entitlements that appear not to be claimed, we're not actually going to be all that far out modelling total costs and the levels of household incomes, but we may severely underestimating *caseloads* - the numbers of people receiving a benefit. Caseloads are very important for administrators, who need to know how many staff to hire and computers to buy, but arguably are less important for us than payments and incomes.
    """
end 

# ╔═╡ 4a965b10-5045-4422-b1b2-ae541df6ad04
begin
    md"""
    ### Errors with Taxes
    """
end 

# ╔═╡ 55f4bc9d-6187-4657-9139-720cd85b27a0
begin
    md"""
    Similarly, it's often the case that the modelled amounts for direct tax liabilities (income tax and national insurance) are ifferent from the tax payments recorded in the data. There could be lots of reasons for this, such as timing issues (recorded payments might be for liabilities from months or years ago) or data problems (especially for the self-employed). Unlike benefits, however, there's rarely any very clear pattern, with as many over- as under- estimates, so that in aggregate tax-benefits usual predict total direct tax revenues quite well, at least once the high-income corrections discussed earlier have been applied.
    """
end 

# ╔═╡ 3ff42ab7-9f15-459e-a6cf-8390e657c534
begin
    md"""
    This isn't the case for indirect taxes, however. We discussed earlier how spending in household surveys on 'bads' such as alcohol and tobacco is much too low given what is known from customs data. It could be that people are usually honest to the survey interviewer about whether they drink, but then understate how much they drink, perhaps out of embarrassment (or drunkenness). If this is the case then we can fix things simply by multiplying up the amounts people are recorded spending on alcohol - this is the standard correction used by most tax-benefit models. But suppose instead that the real reason for the understatement was that we weren't interviewing enough drinkers. If that was the case, multiplying up the alcohol spending we do have would still give us the correct aggregate amounts, but would make our distributional analysis *worse* - it would look like an extra tax on alcohol would punish a few people really severely, whereas in fact the pain would be spread between more households.
    """
end 

# ╔═╡ 9a18f759-8549-482d-920e-a5cd1f459dec
begin
    md"""
    This is an example where improving the model's ability to forecast aggregates such as total tax revenues might *worsen* its accuracy at the level of individual or households. The non-takeup problem discussed above is another example: since not everyone actually takes up benefits, a microsimulation model that mistakenly understates individual entitlements, and so gets all the micro details wrong, might perform better in predicting aggregate costs than a model that gets entitlements right.
    """
end 

# ╔═╡ ed2a1061-3046-47da-ad57-2c03544b0f5a
begin
    md"""
    ### Changing Behaviour
    """
end 

# ╔═╡ c7e9fa1a-6a49-4f21-977a-7723e3b94315
begin
    md"""
    People may change their behaviour in response to changes to taxes and benefits, perhaps working more or less, or changing their spending on some good. Our model takes peoples hours and earnings as fixed, but, as you'll see, the model does produce some of the key building blocks for an analysis of labour supply - it can calculate the *marginal effective tax rates (METRs)* for every person in the survey, and indeed complete *budget constraints*. I'll discuss METRS and budget constraints next. The literature on the effects of taxes and benefits on the supply of labour is largely inconclusive[^FN_LABOUR]. Our understanding of the effect of taxes on demand for other goods is slightly firmer - see the discussion of sugar taxes in Block XX for an example.
    """
end 

# ╔═╡ af1c1590-2e48-49c2-80a7-dbbcd98280cf
begin
    md"""
    Models that don't allow for behavioural changes, as with takeup or labour supply here, are often referred to as *static* models, as opposed to *dynamic* models which do allow behavioural changes[^FN_MALCHUP].
    """
end 

# ╔═╡ 16649ec9-5cae-40ea-a390-e7238c66ec13
begin
    md"""
    ### Macroeconomic Feedbacks
    """
end 

# ╔═╡ e12de08a-d1f3-4b90-ae4b-d08392c60a6e
begin
    md"""
    You've seen examples of how macroeconomic models try to capture important feedbacks in the economy. For example, a tax increase, all else equal, will reduce the amount households have to spend, and this decreases total demand in the economy, which in turn causes wages, profits and employment to be lower. Since incomes and spending are lower, the amount raised by the tax might be less than you'd predict from a static model such as ours[^FN_WREN_LEWIS]. I'll briefly discuss a microsimulation model that attempts to capture these feedbacks right at the end of this chapter.
    """
end 

# ╔═╡ a208587a-f3b6-428f-a423-7ca06f5b6de3
begin
    md"""
    ### Summing Up: What's a Good Model?
    """
end 

# ╔═╡ cefaa4d5-7967-417d-9da8-8e7f2397fb51
begin
    md"""
    The last few sections may have seen like a long list of things we may not be measuring correctly, or are ignoring either to keep things manageable or because there is no know way of doing them correctly.
    """
end 

# ╔═╡ ab498423-5038-47a4-ad25-0d7886bff561
begin
    md"""
    It's tempting to think that we should just wait for someone to build a model that: fully allows for behavioural responses, calculates the true incidence of taxes, captures the true distribution within households, corrects for non-takeup, and produces elaborate multi-dimensional measures of well-being. But no-one will produce such a model any time soon, and even if they did it would depend on so many strong assumptions that the output it produced would always be open to challenge, and the interactions in the model likely be so complex that you would in practice you would get little insight into what was really going on.
    """
end 

# ╔═╡ Cell order:
# ╟─72c7843c-3698-4045-9c83-2ad391097ad8
# ╟─261b9a74-7b4a-4816-b53d-9f29d562fbcc
# ╟─ed136fac-9811-4eeb-a100-0de56b71e664
# ╟─a9872062-21be-450a-be1a-a6a9e74ab533
# ╟─0b9c77ca-15b5-4e41-8383-8d3c9295faf7
# ╟─4a965b10-5045-4422-b1b2-ae541df6ad04
# ╟─55f4bc9d-6187-4657-9139-720cd85b27a0
# ╟─3ff42ab7-9f15-459e-a6cf-8390e657c534
# ╟─9a18f759-8549-482d-920e-a5cd1f459dec
# ╟─ed2a1061-3046-47da-ad57-2c03544b0f5a
# ╟─c7e9fa1a-6a49-4f21-977a-7723e3b94315
# ╟─af1c1590-2e48-49c2-80a7-dbbcd98280cf
# ╟─16649ec9-5cae-40ea-a390-e7238c66ec13
# ╟─e12de08a-d1f3-4b90-ae4b-d08392c60a6e
# ╟─a208587a-f3b6-428f-a423-7ca06f5b6de3
# ╟─cefaa4d5-7967-417d-9da8-8e7f2397fb51
# ╟─ab498423-5038-47a4-ad25-0d7886bff561

