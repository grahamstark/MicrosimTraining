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
	const BASE_SYS = 
		get_default_system_for_fin_year( 2024; scotland=true, autoweekly = true )
	const ANNUAL_BASE_SYS = 
		get_default_system_for_fin_year( 2024; scotland=true, autoweekly = false )

	settings = Settings()
    settings.num_households, settings.num_people = 
        FRSHouseholdGetter.initialise( settings; reset=false )

	run_progress = Observable( Progress(settings.uuid,"",0,0,0,0))
	
	running_total = 0
	phase = "Not Running"
	
	function obs_processor( progress::Progress )
		global running_total, phase, size
		size = progress.size
	    running_total += progress.step
		phase = progress.phase
	end 
	
	observer_function = on( obs_processor, run_progress )


	function run_model( 
		allowance::Number, 
		income_tax_rate::Number, 
		uc_taper::Number, 
		settings::Settings )::NamedTuple
		global running_total
		@show allowance 
		@show income_tax_rate
		@show uc_taper
		sys2 = deepcopy(ANNUAL_BASE_SYS)
		sys2.it.personal_allowance = allowance
		sys2.it.non_savings_rates[3] = income_tax_rate
		sys2.uc.taper = uc_taper

		weeklyise!( sys2 )
		sys = [BASE_SYS, sys2]
		running_total = 0
		results = Runner.do_one_run( settings, sys, run_progress )
		summary = summarise_frames!( results, settings )
		summary
	end

    PlutoUI.TableOfContents(aside=true)
end

# ╔═╡ 3a2a55d5-8cf8-4d5c-80a7-84a03923bba8
md"""
## A Budget for ...
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
# ╠═╡ show_logs = false
summary= run_model( tax_allowance, income_tax_rate, uc_taper, settings )


# ╔═╡ d2188dd8-1240-4fdd-870b-dcd15e91f4f2
begin
	function draw_summary_graphs( summary :: NamedTuple )::Figure
		f = Figure()
		ax1 = Axis(f[1,1]; title="Lorenz Curve", xlabel="Population Share", ylabel="Income Share")
		popshare = summary.quantiles[1][:,1]
		incshare_pre = summary.quantiles[1][:,2]
		incshare_post = summary.quantiles[2][:,2];
		insert!(popshare,1,0)
		insert!(incshare_pre,1,0)
		insert!(incshare_post,1,0)
		lines!(ax1, popshare, incshare_pre; label="Before")
		lines!(ax1,popshare,incshare_post; label="After")
		lines!(ax1,[0,1],[0,1]; color=:grey)
		ax2 = Axis(f[1,2]; title="Income Changes By Decile", 
			ylabel="Change in £s per week", xlabel="Decile" )
		dch = summary.deciles[2][:, 3] .- summary.deciles[1][:, 3]
		barplot!( ax2, dch)
		f
	end

	# some formatting
    function fm(v)
			"£"*format( v/1_000_000, commas=true, precision=0 )*"mn"
	end

	function fp(v)
			format( v*100, precision=1 )*"%"
	end

	function fc(v)
			format( v, precision=0, commas=true )
	end     

	function make_short_summary( summary :: NamedTuple )::NamedTuple
		r1 = summary.income_summary[1][1,:]
		r2 = summary.income_summary[1][1,:]
		ben1 = r1.total_benefits
		ben2 = r2.total_benefits
		tax1 = r1.income_tax+r1.national_insurance+r1.employers_ni	
		tax2 = r2.income_tax+r2.national_insurance+r2.employers_ni	
		dtax = tax2 - tax1
		dben = ben2 - ben1 
		palma1 = summary.inequality[1].palma
		palma2 = summary.inequality[2].palma
		dpalma = palma2 - palma1
		gini1 = summary.inequality[1].gini
		gini2 = summary.inequality[2].gini
		dgini = gini2 - gini1
		(; 
		ben1 = fm( ben1 ),
		ben2 = fm( ben2 ),
		dben = fm(dben),
		gini1=fp(gini1), 
		gini2=fp(gini2),
		palma1=fp(palma1),
		palma2=fp(palma2),
		dpalma=fp(dpalma),
		dgini=fp(dgini),
		tax1=fm( tax1 ),
		tax2=fm( tax2 ),
		dtax=fm( dtax ),
		gainers=fc( summary.gain_lose[1].gainers ),
		losers=fc( summary.gain_lose[1].losers ),
		nc = fc( summary.gain_lose[1].nc) )
	end

		

	draw_summary_graphs( summary )
end

# ╔═╡ d069cd4d-7afc-429f-a8fd-3f1c0a640117
begin
res = make_short_summary( summary )
md"""
### Tax revenue 

before: **$(res.tax1)** after: **$(res.tax2)** change: **$(res.dtax)** £mn pa

### Benefit Spending
before: **$(res.ben1)** after: **$(res.ben2)** change: **$(res.dben)** £m pa

### Inequality
Gini before: **$(res.gini1)** after: **$(res.gini2)** change: **$(res.dgini)**

Palma before: **$(res.palma1)** after: **$(res.palma2)** change: **$(res.dpalma)**

### Gainers & Losers
Households gaining: **$(res.gainers)** losing: **$(res.losers)** unchanged: **$(res.nc)**
"""
end

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
# ╠═3a2a55d5-8cf8-4d5c-80a7-84a03923bba8
# ╟─72c7843c-3698-4045-9c83-2ad391097ad8
# ╟─15c504c8-4a72-4aa5-b83f-4d03c3659df9
# ╟─5c5b2176-148b-4f5c-a02c-5e9e82df11c3
# ╟─b267f167-6f9b-49e3-9d6e-ac9c449ae180
# ╟─c5f6f64e-7a1c-4fc3-836d-aafde14b44d8
# ╟─99152830-e5b1-4541-8b0a-ad51e1168f95
# ╠═d2188dd8-1240-4fdd-870b-dcd15e91f4f2
# ╠═d069cd4d-7afc-429f-a8fd-3f1c0a640117
# ╟─627959cf-6a7c-4f87-82f7-406f5c7eb76a
# ╟─d447f5dd-253c-4c8a-a2d4-873d50c9a9ec
# ╠═4aa314f2-3415-4482-a042-d4c7ebd1cb21
# ╟─8c34657d-e843-4ff2-9c01-bdadc98c0a0e
# ╟─154ed134-8431-4792-a915-9ffcadf0016e
# ╟─a367666b-f8eb-425e-9ccd-ff54f8e5626f
# ╟─b1033397-d349-4aba-855f-e500102c3e6b
# ╟─04eb3fe6-7279-46d5-b9b2-2770858c9f0b
# ╟─de3ef31d-f22a-414b-bf0a-c4d516d82cc2
