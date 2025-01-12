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

# ╔═╡ 70a89ed3-7d77-4f2b-9beb-d8a02e179126
begin
    md"""
    ### You are the finance Secretary: Task II - Let's Get Unicoria Working!
    """
end 

# ╔═╡ 0f4ea991-be26-408a-a2a6-2756fa70eed8
begin
    md"""
    The Government, worried about sluggish economic growth, changes tack and decides to go for economic liberalisation, encouraging people to work harder and keep more of what they earn.
    """
end 

# ╔═╡ 3974d280-5deb-44f7-b366-ef3b2e843f32
begin
    md"""
    Your task is to design a package which:
    """
end 

# ╔═╡ 122b6b4f-a2a5-48de-b7c3-d6fb48220651
begin
    md"""
    * has close to zero net cost;* cuts marginal tax rates, especially very high ones;* if possible, improves replacement rates so as to encourage people back to work; and* implements an overall income tax cut of £50 million.
    """
end 

# ╔═╡ 77088d6d-8e31-4fcf-99bd-8198d92f5b92
begin
    md"""
    In doing all this, you should try to avoid hurting the poor as much as possible, though some losses may be inevitable.
    """
end 

# ╔═╡ Cell order:
# ╟─72c7843c-3698-4045-9c83-2ad391097ad8
# ╟─70a89ed3-7d77-4f2b-9beb-d8a02e179126
# ╟─0f4ea991-be26-408a-a2a6-2756fa70eed8
# ╟─3974d280-5deb-44f7-b366-ef3b2e843f32
# ╟─122b6b4f-a2a5-48de-b7c3-d6fb48220651
# ╟─77088d6d-8e31-4fcf-99bd-8198d92f5b92

