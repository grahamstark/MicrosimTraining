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

# ╔═╡ 6e196cd2-5421-4edb-969a-d7035737ff09
begin
    md"""
    ### Indirect Taxation
    """
end 

# ╔═╡ 39ac4d97-6b8e-4604-8d5d-5e246c247821
begin
    md"""
    ### FIXME not implemented and maybe delete?
    """
end 

# ╔═╡ 4af5e450-033d-492e-b3e5-0c278d902044
begin
    md"""
    Our Family Resources Survey doesn't have expenditure data, so to model indirect taxes, we have to cheat slightly. Back in the discussion of households, we estimated *Engel Curves* showing the relationship between spending on some good and total spending using the Living Costs and Food Survey (LCF). We can use a similar trick here.
    """
end 

# ╔═╡ d6434dbc-4a89-4002-8769-7e45d15c2c35
begin
    md"""
    Note: how to include in Marginal Tax Rates
    """
end 

# ╔═╡ Cell order:
# ╟─72c7843c-3698-4045-9c83-2ad391097ad8
# ╟─6e196cd2-5421-4edb-969a-d7035737ff09
# ╟─39ac4d97-6b8e-4604-8d5d-5e246c247821
# ╟─4af5e450-033d-492e-b3e5-0c278d902044
# ╟─d6434dbc-4a89-4002-8769-7e45d15c2c35

