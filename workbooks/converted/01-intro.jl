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

# ╔═╡ a299878e-cb62-4cb6-8986-a3c34662aaa4
begin
    md"""
    # Tax Benefit Models and Microsimulation
    """
end 

# ╔═╡ 3b5155d5-8aea-484e-8b89-5fb6a06a4cea
begin
    md"""
    ## Introduction
    """
end 

# ╔═╡ c001c7f6-c0ae-4228-b57a-ee15347b074d
begin
    md"""
    Let's start with some recent headlines:
    """
end 

# ╔═╡ 704eb1e1-0a17-4ede-a061-c9cf2008ec31
begin
    md"""
    * In Scotland, the Government responds to concern about rising child poverty by introducing a new cash benefit[^FN_SCOTTISH_CHILD];* Meantime, the Scottish Government is warned that increasing higher rate income tax rates to pay for this might backfire[^FN_SCOT_INCOME_TAX_1];* At the Conservative party conference, large increase in Minimum Wages are proposed[^FN_JAVED];* Also at the conference, the Government proposes that Fuel Taxes - already frozen for eight years, be further cut[^FN_FUEL].
    """
end 

# ╔═╡ 2c258145-f176-4ecc-bc13-9e7a0cacf934
begin
    md"""
    How can we analyse what's going on with these things? How can we understand the reasoning behind the decisions that weremade in each case?
    """
end 

# ╔═╡ 0bb3216f-e724-4714-9a4e-e835d4c7c01c
begin
    md"""
    This week we want to do two things:
    """
end 

# ╔═╡ 302c5c14-dc85-4104-a74f-2bf448f2075d
begin
    md"""
    1. firstly, we will discuss some ideas that can help you to think systematically about questions like these; and2. give you a chance to experiment with a simple example of the most important tool used in this field - a Microsimulation Tax Benefit model.
    """
end 

# ╔═╡ c7309921-5eec-409c-8764-ef3359f14294
begin
    md"""
    What all our headlines have in common is that they are concerned with the impact on our diverse society of broad Government policies - on Social Security, wage setting, or the taxation of income and spending. We need to always keep this diversity in mind: Microsimulation is a way of confronting what may seem on paper a good, simple idea with thereality of a society with rich and poor, able and disabled, young and old, conventional nuclear families and those living in very different arrangements. But the very complexity of a modern society makes it all the more important that we have a few organising principles to guide us - it's no use just holding our hands up and saying "it's all verycomplicated" - even if it is.
    """
end 

# ╔═╡ 2345ef0b-10e2-4e41-b6d1-bd88b806a0b0
begin
    md"""
    Broadly, we can group the questions we might want to ask about our policies changes into two:
    """
end 

# ╔═╡ e350caf8-2bf0-451c-887b-c8a5540b374f
begin
    md"""
    1. policy changes inevitably produce gainers and losers: some people might be better off, and some worse off, and we want to summarise those changes in an intelligible way. This leads us to the study of measures such as poverty and inequality; when we come to do some modelling we'll also consider some more prosaic measures such as counts of gainersand losers disaggregated in various ways, aggregate costings and the like;
    """
end 

# ╔═╡ 5506e4a0-0309-4baa-9c9b-fcd56f5c2884
begin
    md"""
    2. our policy changes may alter the way the economy works in some way - for example an income tax cut might make people work more (or, as we'll see, less), or a tax on plastic bags might lead people to use less of them. Some of these effects may be beneficial and part of the intention of the change, others may be harmful and unintentional. A useful is organising idea here is *fiscal neutrality* - if we start from the broad premise that a market economy is a reasonably efficient thing, then we should design our fiscal system should so as to alter the behaviour of the economy as little as possible, unless there is some clear argument why we should do otherwise.
    """
end 

# ╔═╡ f65d8ae4-1f80-4975-a1ad-48d3b12285de
begin
    md"""
    Much of the art of policy analysis and policy design lies in balancing these two aspects; for example, redistributingincome whilst maintaining incentives to work, or raising taxes on some harmful good without hurting the poorest and mostvulnerable.
    """
end 

# ╔═╡ 12dcc8f8-936a-4788-8915-b74e7f3299b6
begin
    md"""
    The distributional and incentive analysis of policy changes, and the art of balancing these things, are huge and technical subjects that go well beyond this course, but we aim to equip you with many of the key ideas and give you a flavour of where more advanced treatments might take you. As you'll see, you can get remarkably far with a few simple measures.
    """
end 

# ╔═╡ 519a28be-0f2f-448c-854a-e30d2d4d4a49
begin
    md"""
    A note on our language. This section is quite jargon-heavy, and covers a lot of technical issues. None of it is especially difficult, but it does mean that we will be approaching questions about very personal things like poverty, whether it's worth working, or whether people are being treated fairly, in a relatively detached, technocratic way. Many people find this detachment distasteful[^FN_MOND]. The detachment of many researchers in this field from the problems they are modelling can be a problem, but I hope to show that there are things that a technocratic, data-driven approach can be of use to those with strong personal commitments, whatever those commitments might be.
    """
end 

# ╔═╡ 3ec44051-3dff-4554-97c9-97f4a2851a1d
begin
    md"""
    ### Outline Of the Week
    """
end 

# ╔═╡ a0891c08-746a-45da-a179-ad5a810b5661
begin
    md"""
    The week is split in two:
    """
end 

# ╔═╡ 2d07489f-19cc-4587-8ded-d1d034a7750f
begin
    md"""
    1. in the first part, we'll take you through many of the concepts needed to interpret the outputs of a tax-benefit microsimulation model. Some of this material has already been covered earlier in the course, and some is also covered in other OU courses that you may have studied, in particular DD209 book 2, chapter 19 and DB125, chapter 3, but here the emphasis is on how things can be measured in practice;2. We then get you hands-on with our tax-benefit model. Initially we'll use the model to study how the tax and benefit system affects just one example person: this lets you explore how the tax and benefit system affects incentives. We'll then move on to using the model on a full, representative dataset - after a few exercises to give you a feel for how the model behaves, we'll invite you to take charge of the economy and design some packages of measures that Governments of different persuasions might adopt.
    """
end 

# ╔═╡ 249a1455-6b70-4760-a99b-8484ffe318ca
begin
    md"""
    
    """
end 

# ╔═╡ 93679741-5f1a-470f-9dfd-c1b63e7796b3
begin
    md"""
    ### Learning Outcomes
    """
end 

# ╔═╡ 2fd8a4b7-d27d-478d-b87e-33e44fb3784f
begin
    md"""
    After completing this week, you should:
    """
end 

# ╔═╡ 5d8c5887-6878-4fc1-b123-3c91c874a47f
begin
    md"""
    1. be able to read reports produced using microsimulation techniques, and understand the concepts and something of the mechanics of how they were produced, as well of having a feel for their limitations[^FN_MS_EXAMPLES];2. understand how to present rich and detailed results produced by a microsimulation model from differing angles - for example, as a technical report, a submission from lobbyist,  or as journalism;3. understand how to construct packages of measures that meet some policy objectives, and understand how objectives may need to be traded off;4. understand, at least in outline, some important microsimulation concepts and techniques:- the pros and cons of different types of large-sample datasets;- how these large dataset are used in microsimulation, including data weighting and uprating;- techniques for the measurement of poverty and inequality;- measures of the incentive effects of taxation, including marginal and average tax rates, replacement rates.
    """
end 

# ╔═╡ Cell order:
# ╟─72c7843c-3698-4045-9c83-2ad391097ad8
# ╟─a299878e-cb62-4cb6-8986-a3c34662aaa4
# ╟─3b5155d5-8aea-484e-8b89-5fb6a06a4cea
# ╟─c001c7f6-c0ae-4228-b57a-ee15347b074d
# ╟─704eb1e1-0a17-4ede-a061-c9cf2008ec31
# ╟─2c258145-f176-4ecc-bc13-9e7a0cacf934
# ╟─0bb3216f-e724-4714-9a4e-e835d4c7c01c
# ╟─302c5c14-dc85-4104-a74f-2bf448f2075d
# ╟─c7309921-5eec-409c-8764-ef3359f14294
# ╟─2345ef0b-10e2-4e41-b6d1-bd88b806a0b0
# ╟─e350caf8-2bf0-451c-887b-c8a5540b374f
# ╟─5506e4a0-0309-4baa-9c9b-fcd56f5c2884
# ╟─f65d8ae4-1f80-4975-a1ad-48d3b12285de
# ╟─12dcc8f8-936a-4788-8915-b74e7f3299b6
# ╟─519a28be-0f2f-448c-854a-e30d2d4d4a49
# ╟─3ec44051-3dff-4554-97c9-97f4a2851a1d
# ╟─a0891c08-746a-45da-a179-ad5a810b5661
# ╟─2d07489f-19cc-4587-8ded-d1d034a7750f
# ╟─249a1455-6b70-4760-a99b-8484ffe318ca
# ╟─93679741-5f1a-470f-9dfd-c1b63e7796b3
# ╟─2fd8a4b7-d27d-478d-b87e-33e44fb3784f
# ╟─5d8c5887-6878-4fc1-b123-3c91c874a47f

