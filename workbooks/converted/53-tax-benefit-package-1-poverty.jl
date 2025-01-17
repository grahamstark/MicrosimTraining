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

# ╔═╡ 196a1640-a940-49cb-a300-e927f83d28b4
begin
    md"""
    ### You are the finance Secretary: Task 1: A War On Poverty
    """
end 

# ╔═╡ 111e1c91-45c6-41f2-be19-f3155d5fadc0
begin
    md"""
    The Government of Unicoria has plegded to reduce the headcount measure of poverty by 10 percentage points. Your task is to design a policy package that delivers this in the most effective way possible. The economy is doing well, and net extra spending of up to £4 billion has been agreed.
    """
end 

# ╔═╡ 2a4eaf8b-ad91-4f68-81ec-e5affdeeb54d
begin
    md"""
    Things to consider include:
    """
end 

# ╔═╡ b246c228-417f-42bd-8ebc-523d25377440
begin
    md"""
    * *cost* any costs above £4bn will have to be raised from somewhere;* *targetting vs. incentives*: well targetted benefit increases may force poor people into poverty traps, whilst more widely spread increases may require tax increases to keep within budget;* *alternative measures of poverty* have you cheated at all, and reduced poverty headcounts by concentrating on the near-poor, perhaps through increasing in-work benefits? (You may need to do this in order to meet the political objectives)
    """
end 

# ╔═╡ Cell order:
# ╟─72c7843c-3698-4045-9c83-2ad391097ad8
# ╟─196a1640-a940-49cb-a300-e927f83d28b4
# ╠═111e1c91-45c6-41f2-be19-f3155d5fadc0
# ╟─2a4eaf8b-ad91-4f68-81ec-e5affdeeb54d
# ╠═b246c228-417f-42bd-8ebc-523d25377440
