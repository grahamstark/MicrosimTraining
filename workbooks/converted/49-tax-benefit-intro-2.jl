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

# ╔═╡ 47c822fd-3791-4458-adde-d3315b1d39dc
begin
    md"""
    ## (Finally) Introducing Our Model
    """
end 

# ╔═╡ ae2e1507-4a28-4d72-a9ab-34fc80f7c172
begin
    md"""
    Now we can go on to experiment with our model. We'll do this in two steps. Firstly, we'll use it to draw some *budget constraints* for a example person. This allows us to study in a simple way how taxes and benefits interact, and to introduce a few more concepts that can help us think about policy.
    """
end 

# ╔═╡ Cell order:
# ╟─72c7843c-3698-4045-9c83-2ad391097ad8
# ╟─47c822fd-3791-4458-adde-d3315b1d39dc
# ╟─ae2e1507-4a28-4d72-a9ab-34fc80f7c172

