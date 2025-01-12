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

# ╔═╡ cd2a3374-c450-4971-b0c7-a7eca1934ae8
begin
    md"""
    ### You are the finance Secretary: Task III: A Budget for Women
    """
end 

# ╔═╡ 5d2f76f5-cd50-4980-9f72-2b75ecf18e86
begin
    md"""
    Party policy is to produce the worlds first explicitly pro-woman budget. It is for you to interpret what this is to mean, and  to construct a package of measures to deliver it.
    """
end 

# ╔═╡ fd7d62a6-0964-4335-8b9f-c76e8214385e
begin
    md"""
    Points to consider:
    """
end 

# ╔═╡ 7e7f7138-1f60-46e8-8643-2f8cfb8e6f05
begin
    md"""
    * is the pattern of male and female working different - part-time versus full time, for instance, or low versus high wages? How could the tax and benefit system better support the kinds of work women do?* what about families? If women are more frequently the main carers, should the benefit system reflect that?
    """
end 

# ╔═╡ Cell order:
# ╟─72c7843c-3698-4045-9c83-2ad391097ad8
# ╟─cd2a3374-c450-4971-b0c7-a7eca1934ae8
# ╟─5d2f76f5-cd50-4980-9f72-2b75ecf18e86
# ╟─fd7d62a6-0964-4335-8b9f-c76e8214385e
# ╟─7e7f7138-1f60-46e8-8643-2f8cfb8e6f05

