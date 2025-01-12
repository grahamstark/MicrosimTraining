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

# ╔═╡ 5c2f7d0e-5964-4305-9c8e-53e182c32ca9
begin
    md"""
    #### Budget Constraints: Introducing Cash Benefits
    """
end 

# ╔═╡ 83a1b5b6-1ba4-4076-bc46-ac2240bf124a
begin
    md"""
    I'll now introduce cash benefits using the same diagram but a different set of inputs.
    """
end 

# ╔═╡ ad6d2b08-f5f1-4a36-a1e0-bb524c5ce09a
begin
    md"""
    The low incomes on the left of the diagram might well be below the poverty line; indeed, they might be impossible to live on at all. So it may be necessary to introduce have cash benefits - transfers of money to people depending on their circumstances.
    """
end 

# ╔═╡ f8a44c16-8bb2-47ec-857b-1efe8cbf3b6e
begin
    md"""
    You can broadly classify cash benefits into three types:
    """
end 

# ╔═╡ fb93734a-09c8-49e3-9269-8fc4d25c0986
begin
    md"""
    * *universal benefits*: given to everyone, regardless of income or other circumstances* *means-tested benefits*  - these are benefits that are given solely to people with low incomes, and so withdrawn as incomes rise;* *contingent benefits* - these are given to people in certain circumstances, for example, the unemployed or disabled.
    """
end 

# ╔═╡ 646af8c7-b14c-475a-960c-2467bc3598a4
begin
    md"""
    In practice benefits are often hybrids of these things, but it's still a useful classification[^FN_IFS_BENEFITS].
    """
end 

# ╔═╡ 6e1a15a1-8e4a-4afe-932e-c3cffad48a0a
begin
    md"""
    In this example, we'll model three different benefits, so we have some new fields on the left-hand-side. The modelling here is very basic; in reality the benefits would have multiple levels depending on age, disability status, number of children, and so on, and detailed rules on who qualifies. But there's more than enough here to produce some pretty complex results, and to give you a feel for the difficult choices involved in designing a social security system.
    """
end 

# ╔═╡ ed0767d7-2af6-4d1c-8e16-0b9dd9216a82
begin
    md"""
    ##### Minimum Income Benefits
    """
end 

# ╔═╡ 7e0d604e-7712-4036-9d76-a40b8c97e702
begin
    md"""
    The first field represents a *Minimum Income Benefit*[^FN_MIG]. Job Seeker's Allowance and Income Support are examples of this kind of benefit[^FN_JSA]. Minimum income benefits are designed to ensure that people don't fall below some acceptable standard. If they do, their income is topped up to that standard. Those above the minimum standard don't receive the benefit. Since benefits of this type are solely targeted on the poor, they can be very effective anti-poverty measures. Against this, since the benefit is the difference between some minimum acceptable level and actual income, if your income goes up by £1 the benefit must fall by £1.
    """
end 

# ╔═╡ 01d64841-6157-46b5-8da4-bbdd4fc42085
begin
    md"""
    We discussed earlier how means-tested benefits are normally assessed over 'benefit units' - roughly traditional nuclear families. A stay-at-home spouse of a high earner would not normally be assessed as poor. For now, we can rather gloss over this point, but family structure comes to be very important when we come presently to our full model with its representative dataset.
    """
end 

# ╔═╡ 5ac8b170-c0d9-4ad9-ac08-3f63e72cb0e9
begin
    md"""
    In the last section we discussed Marginal Tax Rates (MTRs) as being the wedge between an extra £1 you earn and the amount you get to keep. You can think of a means-tested benefit in just the same way. With a minimum income benefit of this type, in effect you don't get to keep any of the next £1 you earn, since £1 of extra earnings is matched by £1 of withdrawn benefit.
    """
end 

# ╔═╡ f82f2c5e-a5a4-4061-8a26-a3d9fb84182e
begin
    md"""
    Q: What's the implied marginal tax rate here?
    """
end 

# ╔═╡ 0249358d-247f-4a59-83c0-d1a9ad93c975
begin
    md"""
    In some cases, people on low incomes might also be liable for taxes, and perhaps also eligible for other benefits which are also withdrawn as income rises. So the MTR for low-income people might be a complicated mix of benefit withdrawals and tax increases - it's possible for these withdrawals to *exceed* 100% in some cases, so earning an extra £1 leaves you net worse off [^FN_STARK_DILNOT].
    """
end 

# ╔═╡ 07e0a714-67be-45f6-8b0e-94a66f3415a8
begin
    md"""
    Marginal Tax rates that mix together deductions from multiple sources are sometimes known as Marginal *Effective* Tax Rates (METRs), and we'll use that term from now on.
    """
end 

# ╔═╡ 72b419ca-f747-4020-888b-5fe376cd5dfb
begin
    md"""
    These very high marginal tax rates on the poor are sometimes referred to as the *Poverty Trap* - though that's a phrase with multiple meanings.
    """
end 

# ╔═╡ 6f9f2dd3-7e8f-4240-a920-8a5505b7441a
begin
    md"""
    Exercise: we invite you to experiment with raising or lowering the minimum income benefit.
    """
end 

# ╔═╡ 9a17e5d2-2e00-4e4e-b6ef-3d6b1186bb1d
begin
    md"""
    Our *Average Tax Rate* notion can also be applied here. The difference is that the average tax rate for a benefit recipient who is not also a tax payer is *negative* - net income is *above* gross income.
    """
end 

# ╔═╡ 7fd32b9d-2ec2-4e79-8a29-1ba43cfe2f1a
begin
    md"""
    ##### In Work Benefits
    """
end 

# ╔═╡ 2742c2e7-67fe-49fa-8091-8d55e1ff80c9
begin
    md"""
    The next group of inputs model a simple in-work benefit. Examples from the UK are Working Tax Credit[^FN_WTC] (WTC) and, to an extent, the Universal Credit (UC) that is gradually replacing it[^FN_UC]. In work benefits boost the incomes of people who work at least a certain number of hours but who don't earn a great deal; they are normally withdrawn gradually as income increases, rather tha £1 for £1.
    """
end 

# ╔═╡ 12acb44b-fda1-4f88-a159-e81c3a7f8699
begin
    md"""
    WTC and UC are normally paid in people's pay packets, effectively as a deduction from any taxes due, hence the names. In the past, however, they were paid directly to mothers in the same way as child benefit. We've just established that we can analyse taxes and benefits in the same way using our METR concepts, so one one level whether WTC and UC are classed as taxes or benefits doesn't matter to us, but you should also bear in mind here our earlier discussion on the intra-household distribution of income.
    """
end 

# ╔═╡ 608ee996-94ec-49db-b39b-14148244798a
begin
    md"""
    We need four parameters for a basic model of such a system:
    """
end 

# ╔═╡ 2a2cee74-630e-4e0b-a0f9-021792c04a2f
begin
    md"""
    * *Maximum Payment* - if a family qualifies, this is the most they'll be paid;* *Minimum Hours Needed* - if this is to be an in-work benefit, we may want to specify some minimum amount of hours of work (or perhaps gross earnings) befire you qualify. Although our budget constraint has gross income on the x- axis, we can map that to hours worked if we make some assumption about hourly wages;* *Upper Limit* - if we want to deny this benefit from high earners, we can set a point above which we start to withdraw it;* *Taper above upper limit* - the benefit is withdrawn at this rate for every £1 earned above the upper limit. So, if this is 50%, if you earn above the upper limit, you lose 50p in benefits for the next £1 you earn, until eventually your entitlement is exhausted.
    """
end 

# ╔═╡ 32fd3a7f-51e8-4d1b-86da-e126a2530547
begin
    md"""
    This is actually a pretty flexible system. For example, you can set parameters here to produce the same results as the minimum income benefit we discussed above.
    """
end 

# ╔═╡ 52b734cf-8f72-44f2-9732-951ccba631ae
begin
    md"""
    
    """
end 

# ╔═╡ 427ed702-7f23-4782-bfc1-5c938e1a6604
begin
    md"""
    ##### Activity
    """
end 

# ╔═╡ ad346d24-c6f1-4b14-992b-91132587a576
begin
    md"""
    1. Replicate the MIG using the 4 parameters of the in-work benefit. Answer:(maximum payment should be positive 0, minimum hours=0, upper limit = maximum payment, taper=100)
    """
end 

# ╔═╡ 2466810b-e7e6-42f0-aae8-ac7bcdb35456
begin
    md"""
    2. We invite you to spend some time experimenting with the in-work benefit. Things you might want to consider are:- Marginal Tax Rates: how do METRs change as you change the withdrawal rate? Answer: very high withdrawal rates lead to very high METRs over a short section; lower withdrawal rates lead to smaller but possibly still high METRs over a bigger range of gross incomes- Universality - what happens as you change the qualifying condition?
    """
end 

# ╔═╡ a2dbaa23-8c6c-42f4-92de-17ad8f5e4c1e
begin
    md"""
    #### Basic "Citizen's" Income
    """
end 

# ╔═╡ bc1f8a8c-bc07-4c81-84b5-f967bbe4cd10
begin
    md"""
    The final field represents a *basic income*[^FN_BASIC].  The the many benefits that make up UK social security all have qualifying conditions of some sort - the examples above have means-tests and hours of work conditions; other benefits are conditional on age, or whether the claimant is disabled in some way, widowed, and much else. All of these conditions need to be checked, and we've seen the possible disincentive effects of means tests. A Basic Income sweeps all this away - everyone is eligible regardless of income, health, or anything else.
    """
end 

# ╔═╡ 6b9591df-6212-4a36-a061-05811062627d
begin
    md"""
    A Basic Income appears to eliminate the problems we've identified with means tested benefits, but it comes at a (literal) cost: since it goes to everybody at all incomes, it's expensive. Whether a Basic Income reduces poverty or inequality, or improves work incentives, depends on how it's paid for and the extent to which it replaced or complemented the existing benefit system.
    """
end 

# ╔═╡ e5b60325-4fd6-49cb-bf2c-3a2bbc8eedb2
begin
    md"""
    ##### Activity
    """
end 

# ╔═╡ Cell order:
# ╟─72c7843c-3698-4045-9c83-2ad391097ad8
# ╟─5c2f7d0e-5964-4305-9c8e-53e182c32ca9
# ╟─83a1b5b6-1ba4-4076-bc46-ac2240bf124a
# ╟─ad6d2b08-f5f1-4a36-a1e0-bb524c5ce09a
# ╟─f8a44c16-8bb2-47ec-857b-1efe8cbf3b6e
# ╟─fb93734a-09c8-49e3-9269-8fc4d25c0986
# ╟─646af8c7-b14c-475a-960c-2467bc3598a4
# ╟─6e1a15a1-8e4a-4afe-932e-c3cffad48a0a
# ╟─ed0767d7-2af6-4d1c-8e16-0b9dd9216a82
# ╟─7e0d604e-7712-4036-9d76-a40b8c97e702
# ╟─01d64841-6157-46b5-8da4-bbdd4fc42085
# ╟─5ac8b170-c0d9-4ad9-ac08-3f63e72cb0e9
# ╟─f82f2c5e-a5a4-4061-8a26-a3d9fb84182e
# ╟─0249358d-247f-4a59-83c0-d1a9ad93c975
# ╟─07e0a714-67be-45f6-8b0e-94a66f3415a8
# ╟─72b419ca-f747-4020-888b-5fe376cd5dfb
# ╟─6f9f2dd3-7e8f-4240-a920-8a5505b7441a
# ╟─9a17e5d2-2e00-4e4e-b6ef-3d6b1186bb1d
# ╟─7fd32b9d-2ec2-4e79-8a29-1ba43cfe2f1a
# ╟─2742c2e7-67fe-49fa-8091-8d55e1ff80c9
# ╟─12acb44b-fda1-4f88-a159-e81c3a7f8699
# ╟─608ee996-94ec-49db-b39b-14148244798a
# ╟─2a2cee74-630e-4e0b-a0f9-021792c04a2f
# ╟─32fd3a7f-51e8-4d1b-86da-e126a2530547
# ╟─52b734cf-8f72-44f2-9732-951ccba631ae
# ╟─427ed702-7f23-4782-bfc1-5c938e1a6604
# ╟─ad346d24-c6f1-4b14-992b-91132587a576
# ╟─2466810b-e7e6-42f0-aae8-ac7bcdb35456
# ╟─a2dbaa23-8c6c-42f4-92de-17ad8f5e4c1e
# ╟─bc1f8a8c-bc07-4c81-84b5-f967bbe4cd10
# ╟─6b9591df-6212-4a36-a061-05811062627d
# ╟─e5b60325-4fd6-49cb-bf2c-3a2bbc8eedb2

