### A Pluto.jl notebook ###
# v0.20.4

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

# ╔═╡ 72c7843c-3698-4045-9c83-2ad391097ad8
# ╠═╡ show_logs = false
begin
	import Pkg
    # activate the shared project environment
    Pkg.activate(Base.current_project())
    # instantiate, i.e. make sure that all packages are downloaded
	#Pkg.resolve()
    #Pkg.instantiate()
	using MicrosimTraining
	# initialise parameters - 2024 system, annual and pre-weeklyised system
	const settings = Settings()
	const EXAMPLE_HH = ExampleHouseholdGetter.get_household("example_hh3")
	const BASE_SYS = 
		get_default_system_for_fin_year( 2024; scotland=true, autoweekly = true )
	const ANNUAL_BASE_SYS = 
		get_default_system_for_fin_year( 2024; scotland=true, autoweekly = false )
	const DEFAULT_WAGE = 10.0
	const BASE_BC = BCCalcs.makebc(
        EXAMPLE_HH, 
        BASE_SYS, 
        settings, 
        DEFAULT_WAGE );
	
	function makebcs( allowance, rate, taper )
		sys = deepcopy( ANNUAL_BASE_SYS )
		sys.it.personal_allowance = allowance
		sys.it.non_savings_rates[3] = rate
		sys.uc.taper = taper
		weeklyise!( sys )
		
		sys_bc = BCCalcs.makebc(
	        EXAMPLE_HH, 
	        sys, 
	        settings, 
	        DEFAULT_WAGE )
		return drawbc( BASE_BC, sys_bc )
	end
	
	function drawbc( base_bc, sys_bc )
		f = Figure(;)
		ax = Axis(f[1,1]; xlabel="Gross Income £s pw", ylabel="Net Income £s pw",title="Budget Constraint")
		
		sc = lines!(ax, base_bc.gross, base_bc.net;label = "Before")
		sys_ln = lines!(ax, sys_bc.gross, sys_bc.net;label = "After",)
		axislegend(ax; position = :rb)
		f
	end
	PlutoUI.TableOfContents(aside=true)
end

# ╔═╡ 3a2a55d5-8cf8-4d5c-80a7-84a03923bba8
md"""
## Budget Constraints: Putting things Together
"""

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
md"""
    For example, if tax allowances are low and the generosity of in-work benefits fairly high, it's possible to pay taxes and receive means-tested benefits at the same time. Depending on the exact calculations involved, this can produce METRs in excess of 100%  - earn more and net income falls.
    """


# ╔═╡ 99152830-e5b1-4541-8b0a-ad51e1168f95
aside( md"See, for example: [Stark and Dilnot](^FN_STARK_DILNOT-2)"; v_offset=-80 )

# ╔═╡ d447f5dd-253c-4c8a-a2d4-873d50c9a9ec
begin
    md"""
    ##### Activity
    """
end 

# ╔═╡ 4aa314f2-3415-4482-a042-d4c7ebd1cb21
begin
md"""
tax allowance: $(@bind tax_allowance NumberField(0:200:25000,default=12570.0)) (p.a.) 

income tax rate: $(@bind income_tax_rate NumberField(0:1:100,default=21) )) (%)

benefit withdrawal rate: $(@bind uc_taper NumberField(0:1:100,default=55) )) (%)
"""
end

# ╔═╡ 627959cf-6a7c-4f87-82f7-406f5c7eb76a
makebcs( tax_allowance, income_tax_rate, uc_taper )


# ╔═╡ 8c34657d-e843-4ff2-9c01-bdadc98c0a0e
begin
    md"""
    Exercise: we simply invite you to experiment here. Try to get  a feel for how taxes and benefits interact.
    """
end 

# ╔═╡ 154ed134-8431-4792-a915-9ffcadf0016e
begin
    md"""

#### Integrating Taxes and Benefits
	
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
# ╟─3a2a55d5-8cf8-4d5c-80a7-84a03923bba8
# ╟─72c7843c-3698-4045-9c83-2ad391097ad8
# ╟─15c504c8-4a72-4aa5-b83f-4d03c3659df9
# ╟─5c5b2176-148b-4f5c-a02c-5e9e82df11c3
# ╟─b267f167-6f9b-49e3-9d6e-ac9c449ae180
# ╟─c5f6f64e-7a1c-4fc3-836d-aafde14b44d8
# ╟─99152830-e5b1-4541-8b0a-ad51e1168f95
# ╠═627959cf-6a7c-4f87-82f7-406f5c7eb76a
# ╟─d447f5dd-253c-4c8a-a2d4-873d50c9a9ec
# ╟─4aa314f2-3415-4482-a042-d4c7ebd1cb21
# ╟─8c34657d-e843-4ff2-9c01-bdadc98c0a0e
# ╟─154ed134-8431-4792-a915-9ffcadf0016e
# ╟─a367666b-f8eb-425e-9ccd-ff54f8e5626f
# ╟─b1033397-d349-4aba-855f-e500102c3e6b
# ╟─04eb3fe6-7279-46d5-b9b2-2770858c9f0b
# ╟─de3ef31d-f22a-414b-bf0a-c4d516d82cc2
