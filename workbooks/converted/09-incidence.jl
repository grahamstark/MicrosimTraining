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

# ╔═╡ 94ecc354-16d1-4281-9af8-c5988a386b03
begin
    md"""
    ### Incidence: Who Really Pays Taxes?[^FN_KAY_INCIDENCE]
    """
end 

# ╔═╡ 6e5d5e88-f65d-47e3-adb0-3bc3e29e6517
begin
    md"""
    All the examples above and almost all of what follows are about things that directly affect people, by, for example, taking some of their income in tax, raising their wages, or paying them benefits. But we can use Microsimulation to study, for example, policy changes affecting companies, industries, schools, or Local Authorities. This raises an important point: ultimately the effects of a change to, say, the taxation of corporations or the funding of local councils falls on people, by changing, say, dividends, local taxes, or the quality of local parks, but the effect is at one remove from the policy. Resolving this indirection is know as finding the *effective incidence* of the change; the first-round effect is the *formal incidence*. For example, recent debates about the fairness of the United States tax code revolve round the question of whether corporation tax - which has been cut heavily in recent years, ultimately falls on wages or profits[^FN_US_CORP].
    """
end 

# ╔═╡ Cell order:
# ╟─72c7843c-3698-4045-9c83-2ad391097ad8
# ╟─94ecc354-16d1-4281-9af8-c5988a386b03
# ╟─6e5d5e88-f65d-47e3-adb0-3bc3e29e6517

