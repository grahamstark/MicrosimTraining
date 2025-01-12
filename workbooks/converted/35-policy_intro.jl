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

# ╔═╡ 2b2c599f-faf2-4992-9c4f-5eff78bba42a
begin
    md"""
    ## Putting the model to Work
    """
end 

# ╔═╡ f2a570e1-0cda-469d-ac2e-06407c0ed693
begin
    md"""
    Women's budget group reports. Discuss the assumptions needed. Example from Deaton of food shares & women's earnings
    """
end 

# ╔═╡ Cell order:
# ╟─72c7843c-3698-4045-9c83-2ad391097ad8
# ╟─2b2c599f-faf2-4992-9c4f-5eff78bba42a
# ╟─f2a570e1-0cda-469d-ac2e-06407c0ed693

