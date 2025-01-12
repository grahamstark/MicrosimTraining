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

# ╔═╡ 28dfa6cd-7667-457d-838e-e5d5d4a25744
begin
    md"""
    ## Introducing The Full Model
    """
end 

# ╔═╡ 320e7c0c-999e-49a5-a79d-344ccb6009b6
begin
    md"""
    ### Welcome To Unicornia
    """
end 

# ╔═╡ 5bbc73a4-b182-4b55-8f2d-91ab0cf2b5d4
begin
    md"""
    We'll be modelling the fiscal system of Unicoria, an imaginary small economy on the Northern fringes of Europe, with a population of just under 6 million; Unicoria is a similar country to the one I live in but with a slightly simpler tax and benefit system. I've chosen a slightly fictionalised country so I can get most of the essential ideas across without confronting you all with the thousands of parameters needed to model the actual tax-benefit system of the United Kingdom.
    """
end 

# ╔═╡ fe613622-6b17-4eb4-b8da-29e9820c918a
begin
    md"""
    Unicoria's economy is mid-way between the very high income Scandinavian countries and the newly independent Baltic Counties. A period of radical free market policies two decades ago has left a mixed legacy. On the positive side, Unicornia now has a flexible, service orientated labour market with very high employment levels, especially amongst the young and women. On the other, the mass redundancies that followed the decline of the old heavy industry base has left many long-term unemployed, many of whom receive sickness and disability benefits. Also, the new service-orientated has a large number of low paid and part-time jobs.
    """
end 

# ╔═╡ a7764a4c-cc68-4511-b6ff-8fe10e67f432
begin
    md"""
    The population is ageing but this is partly mitigated by immigration.
    """
end 

# ╔═╡ f9f9ed07-31a2-43de-bc59-f24ebeedd800
begin
    md"""
    #### Unicornia's Tax system
    """
end 

# ╔═╡ 52b46507-6987-406f-b6f2-bed0a8d03a86
begin
    md"""
    About 35% of Unicornia's national income is collected in tax. This, too, is mid-way between the Scandinavian counties and the newly independent Baltic states.
    """
end 

# ╔═╡ d7d9270e-02c1-4c3a-a002-c4cb842cbb4d
begin
    md"""
    Unicornia has three main taxes:
    """
end 

# ╔═╡ eaef47bc-7834-4385-94d7-24657ed27d66
begin
    md"""
    * income tax - this has an old, creaking administrative system but is relatively progressive, with a relatively flat rate structure but high tax allowances. Tax competition from near neighbours makes significant increases in income tax risky.* employment insurance of about 1/5th wages and self employment income - this is not enough to pay for particularly generous pensions* indirect taxes - the main tax is VAT at 20% - but about 1/3rd of all spending is not fully covered by the tax - these exemptions are unpopular with the European Union but are jealously guarded. There are also a variety of 'Sin Taxes' on alcohol, tobacco and driving.
    """
end 

# ╔═╡ 8c4eedc0-9dc8-474a-b9eb-60740c2f6da6
begin
    md"""
    There are also taxes on corporations, wealth and natural resources, plus a local property tax which part funds local government spending.
    """
end 

# ╔═╡ 26183a87-f49a-4fc7-bcdf-19deb31d9391
begin
    md"""
    #### The Social Security System
    """
end 

# ╔═╡ 2b6d33b8-ec1d-46e1-9dd0-f496ee66c884
begin
    md"""
    Just under 1/2 of Government spending goes in social security. The system has evolved over nearly a century into a complex mix of means-tested and contingent benefits with a creaking administrative system
    """
end 

# ╔═╡ 05a26df4-f5a5-45b2-beed-90a91b539584
begin
    md"""
    The most expensive item is state pensions. The relatively low level of employment insurance means that pensions are relatively un-generous. Many retirees have private pensions, but others rely on top-ups from means-tested benefits.
    """
end 

# ╔═╡ a22d4ada-8a59-4bed-a100-ef3a599559a3
begin
    md"""
    There are also large expenditures on payments to families with children, and to the sick and disabled.
    """
end 

# ╔═╡ 033c6d98-e3f8-4881-a39e-d469a8198754
begin
    md"""
    However, means tested benefits are the most important tool used to boost the incomes of those on low incomes. After an unpopular experiment with the Galactic Credit negative income tax, Unicornia has reverted to a minimum income guarantee plus an in-work tax credit and housing costs support.
    """
end 

# ╔═╡ f961f993-565f-4b22-9a78-b6a3329c117b
begin
    md"""
    Pressures on the benefit system include:
    """
end 

# ╔═╡ cc421238-be0b-4ff4-a8d5-0724f1e7cdf0
begin
    md"""
    * rising Housing support driven by low wages and earlier household formation;* the ageing population causing rising pension and social care costs;* the rise in self-employment and 'gig economy' workers.
    """
end 

# ╔═╡ e92750e2-e00b-4ee2-8e19-5fb7aee1c657
begin
    md"""
    Concern about poverty traps and complexity have led to a debate about replacing much of the benefit system with a Citizen's Income.  Preparatory work has been done so it would be administratively straightforward to introduce one.
    """
end 

# ╔═╡ Cell order:
# ╟─72c7843c-3698-4045-9c83-2ad391097ad8
# ╟─28dfa6cd-7667-457d-838e-e5d5d4a25744
# ╟─320e7c0c-999e-49a5-a79d-344ccb6009b6
# ╟─5bbc73a4-b182-4b55-8f2d-91ab0cf2b5d4
# ╟─fe613622-6b17-4eb4-b8da-29e9820c918a
# ╟─a7764a4c-cc68-4511-b6ff-8fe10e67f432
# ╟─f9f9ed07-31a2-43de-bc59-f24ebeedd800
# ╟─52b46507-6987-406f-b6f2-bed0a8d03a86
# ╟─d7d9270e-02c1-4c3a-a002-c4cb842cbb4d
# ╟─eaef47bc-7834-4385-94d7-24657ed27d66
# ╟─8c4eedc0-9dc8-474a-b9eb-60740c2f6da6
# ╟─26183a87-f49a-4fc7-bcdf-19deb31d9391
# ╟─2b6d33b8-ec1d-46e1-9dd0-f496ee66c884
# ╟─05a26df4-f5a5-45b2-beed-90a91b539584
# ╟─a22d4ada-8a59-4bed-a100-ef3a599559a3
# ╟─033c6d98-e3f8-4881-a39e-d469a8198754
# ╟─f961f993-565f-4b22-9a78-b6a3329c117b
# ╟─cc421238-be0b-4ff4-a8d5-0724f1e7cdf0
# ╟─e92750e2-e00b-4ee2-8e19-5fb7aee1c657

