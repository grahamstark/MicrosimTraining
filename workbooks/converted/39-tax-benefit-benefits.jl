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

# ╔═╡ 59bcef9f-6288-46b9-af37-c8ac36d8c575
begin
    md"""
    ### Benefits
    """
end 

# ╔═╡ 905259c2-d27e-4d96-8dbb-14091c9e664d
begin
    md"""
    **PLEASE NOTE this model is incomplete and there are bugs in the interface (some arrows wrong way). Also, these inputs shouldn't be zero.**
    """
end 

# ╔═╡ 55682567-45e2-4a28-bc97-a0384ef4ff02
begin
    md"""
    Now, we invite you to experiment with just the state benefit system, holding taxes constant.
    """
end 

# ╔═╡ 64b6ac7d-ccdb-44ab-a77c-394c84ad9c85
begin
    md"""
    The inputs should be familiar to you from before, but bear in mind the extra complexity of the underlying benefit system.
    """
end 

# ╔═╡ ef3eec27-b845-42a7-b68a-255614a538ef
begin
    md"""
    ##### Activity
    """
end 

# ╔═╡ Cell order:
# ╟─72c7843c-3698-4045-9c83-2ad391097ad8
# ╟─59bcef9f-6288-46b9-af37-c8ac36d8c575
# ╟─905259c2-d27e-4d96-8dbb-14091c9e664d
# ╟─55682567-45e2-4a28-bc97-a0384ef4ff02
# ╟─64b6ac7d-ccdb-44ab-a77c-394c84ad9c85
# ╟─ef3eec27-b845-42a7-b68a-255614a538ef

