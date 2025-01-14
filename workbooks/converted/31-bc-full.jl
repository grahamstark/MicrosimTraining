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
	#Pkg.resolve()
    #Pkg.instantiate()
	using MicrosimTraining
    PlutoUI.TableOfContents(aside=true)
end

# ╔═╡ 3a2a55d5-8cf8-4d5c-80a7-84a03923bba8
begin
    md"""
    #### Budget Constraints: Putting things Together
    """
end 

# ╔═╡ 15c504c8-4a72-4aa5-b83f-4d03c3659df9
begin
    md"""
    Finally in this section, let's consider taxes and benefits together.
    """
end 

# ╔═╡ 5c5b2176-148b-4f5c-a02c-5e9e82df11c3
begin
    md"""
    We have the usual diagram, but now all the fields for taxes and benefits together on the left. So it's possible to design a complete system.
    """
end 

# ╔═╡ b267f167-6f9b-49e3-9d6e-ac9c449ae180
begin
    md"""
    We've seen seen that you can understand the effects of taxes and benefits using the same concepts. Now, when we put the two sides together, we can analyse the results in the same way, but the tax side and the benefit side can interact in ways that produce complicated and often unintended outcomes.
    """
end 

# ╔═╡ c5f6f64e-7a1c-4fc3-836d-aafde14b44d8
begin
    md"""
    For example, if tax allowances are low and the generosity of in-work benefits fairly high, it's possible to pay taxes and receive means-tested benefits at the same time. Depending on the exact calculations involved, this can produce METRs in excess of 100%  - earn more and net income falls[^FN_STARK_DILNOT-2].
    """
end 

# ╔═╡ d447f5dd-253c-4c8a-a2d4-873d50c9a9ec
begin
    md"""
    ##### Activity
    """
end 

# ╔═╡ 8c34657d-e843-4ff2-9c01-bdadc98c0a0e
begin
    md"""
    Exercise: we simply invite you to experiment here. Try to get  a feel for how taxes and benefits interact.
    """
end 

# ╔═╡ cd20fb57-58b4-4f2a-bf5d-c96ea2ae06b2
begin
    md"""
    #### Integrating Taxes abd Benefits
    """
end 

# ╔═╡ 154ed134-8431-4792-a915-9ffcadf0016e
begin
    md"""
    The sometimes chaotic nature of the interaction of taxes and benefits have led to advocacy of the complete integration of taxes and benefits. Completely integrated systems are sometimes known as *Negative Income Taxes*; one such system was proposed for the UK in the early 1970s[^FN_SLOMAN]. Universal Credit, briefly discussed above, is an attempt to integrate several means-tested benefits, though not taxes. However, though it produces messy and inconsistent interactions, there are often good reasons for keeping parts of the tax and benefit system separate. With Minimum Income benefits, for example, it's often important to get help to people very quickly if they are destitute, whereas with an in-work benefit, it's often helpful to take a longer view, so support can be given consistently over say a, year.
    """
end 

# ╔═╡ a367666b-f8eb-425e-9ccd-ff54f8e5626f
begin
    md"""
    #### Replacement Rates
    """
end 

# ╔═╡ b1033397-d349-4aba-855f-e500102c3e6b
begin
    md"""
    Now we have taxes and benefits together, we can introduce our fourth summary measure: the *replacement rate*. This is intended to be a measure of whether it is worth working at all, and simply the ratio between the net income someone would have when working some standard amount of hours (usually 40 per week), and the income received when not working at all.
    """
end 

# ╔═╡ 04eb3fe6-7279-46d5-b9b2-2770858c9f0b
begin
    md"""
    ![Illustration of the replacement rate](./images/bc-2.png)
    """
end 

# ╔═╡ de3ef31d-f22a-414b-bf0a-c4d516d82cc2
begin
    md"""
    The replacement rate is worth knowing about because it is sometimes used in academic studies trying to explain, for example, the aggregate level of unemployment; it also sometimes appears in popular discourse[^FN_RP].
    """
end 

# ╔═╡ Cell order:
# ╠═72c7843c-3698-4045-9c83-2ad391097ad8
# ╟─3a2a55d5-8cf8-4d5c-80a7-84a03923bba8
# ╟─15c504c8-4a72-4aa5-b83f-4d03c3659df9
# ╟─5c5b2176-148b-4f5c-a02c-5e9e82df11c3
# ╟─b267f167-6f9b-49e3-9d6e-ac9c449ae180
# ╟─c5f6f64e-7a1c-4fc3-836d-aafde14b44d8
# ╟─d447f5dd-253c-4c8a-a2d4-873d50c9a9ec
# ╟─8c34657d-e843-4ff2-9c01-bdadc98c0a0e
# ╟─cd20fb57-58b4-4f2a-bf5d-c96ea2ae06b2
# ╟─154ed134-8431-4792-a915-9ffcadf0016e
# ╟─a367666b-f8eb-425e-9ccd-ff54f8e5626f
# ╟─b1033397-d349-4aba-855f-e500102c3e6b
# ╟─04eb3fe6-7279-46d5-b9b2-2770858c9f0b
# ╟─de3ef31d-f22a-414b-bf0a-c4d516d82cc2
