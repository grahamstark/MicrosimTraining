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
		settings::Settings )::Tuple
		global running_total
		@show allowance 
		@show income_tax_rate
		@show uc_taper
		sys2 = deepcopy(ANNUAL_BASE_SYS)
		sys2.it.personal_allowance = allowance
		itdiff = sys2.it.non_savings_rates[2] - income_tax_rate
		sys2.it.non_savings_rates .-= itdiff
		sys2.uc.taper = uc_taper

		weeklyise!( sys2 )
		sys = [BASE_SYS, sys2]
		running_total = 0
		results = Runner.do_one_run( settings, sys, run_progress )
		summary = summarise_frames!( results, settings )
		summary, results
	end

    PlutoUI.TableOfContents(aside=true)
end

# ╔═╡ 3a2a55d5-8cf8-4d5c-80a7-84a03923bba8
md"""
# A War On Poverty
"""

# ╔═╡ 5c5b2176-148b-4f5c-a02c-5e9e82df11c3
begin
    md"""
The Government of Unicoria has plegded to reduce the headcount measure of poverty by 3 percentage points. Your task is to design a policy package that delivers this in the most effective way possible. The economy is doing well, and net extra spending of up to £4 billion has been agreed.
* *cost* any costs above £4bn will have to be raised from somewhere;
* *targetting vs. incentives*: well targetted benefit increases may force poor people into poverty traps, whilst more widely spread increases may require tax increases to keep within budget; 
* *alternative measures of poverty* have you cheated at all, and reduced poverty headcounts by concentrating on the near-poor, perhaps through increasing in-work benefits? (You may need to do this in order to meet the political objectives)
    """
end 

# ╔═╡ d447f5dd-253c-4c8a-a2d4-873d50c9a9ec
begin
    md"""
    ##### Taxes and Benefits
    """
end 

# ╔═╡ 4aa314f2-3415-4482-a042-d4c7ebd1cb21
begin
md"""
tax allowance: $(@bind tax_allowance NumberField(0:10:25000,default=12570.0)) (p.a.) 

income tax rate: $(@bind income_tax_rate NumberField(0:1:100,default=20) )) (%)

benefit withdrawal rate: $(@bind uc_taper NumberField(0:1:100,default=55) )) (%)
"""
end

# ╔═╡ 627959cf-6a7c-4f87-82f7-406f5c7eb76a
# ╠═╡ show_logs = false
summary, data = run_model( tax_allowance, income_tax_rate, uc_taper, settings );

# ╔═╡ d2188dd8-1240-4fdd-870b-dcd15e91f4f2
begin
	function draw_summary_graphs( summary :: NamedTuple, data::NamedTuple )::Figure
		f = Figure()
		ax1 = Axis(f[1,1]; title="Lorenz Curve", xlabel="Population Share", ylabel="Income Share")
		popshare = summary.quantiles[1][:,1]
		incshare_pre = summary.quantiles[1][:,2]
		incshare_post = summary.quantiles[2][:,2];
		insert!(popshare,1,0)
		insert!(incshare_pre,1,0)
		insert!(incshare_post,1,0)
		lines!(ax1, popshare, incshare_pre; label="Before", color=(:lightsteelblue, 1))
		lines!(ax1,popshare,incshare_post; label="After", color=(:gold2, 1))
		lines!(ax1,[0,1],[0,1]; color=:grey)
		ax2 = Axis(f[1,2]; title="Income Changes By Decile", 
			ylabel="Change in £s per week", xlabel="Decile" )
		dch = summary.deciles[2][:, 3] .- summary.deciles[1][:, 3]
		barplot!( ax2, dch)
		ax3 = Axis(f[2,1:2]; title="Income Distribution", xlabel="£s pw", ylabel="")
		density!( ax3, data.indiv[1].eq_bhc_net_income; 
			weights=data.indiv[1].weight, label="Before", color=(:lightsteelblue, 0.5))
		density!( ax3, data.indiv[2].eq_bhc_net_income; 
			weights=data.indiv[2].weight, label="After", color=(:gold2, 0.5) )
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
		r2 = summary.income_summary[2][1,:]
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
		gainers=fc( summary.gain_lose[2].gainers ),
		losers=fc( summary.gain_lose[2].losers ),
		nc = fc( summary.gain_lose[2].nc) )
	end
	
	draw_summary_graphs( summary, data )
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

* **Gini:** before: **$(res.gini1)** after: **$(res.gini2)** change: **$(res.dgini)**
* **Palma:** before: **$(res.palma1)** after: **$(res.palma2)** change: **$(res.dpalma)**

### Gainers & Losers
Households gaining: **$(res.gainers)** losing: **$(res.losers)** unchanged: **$(res.nc)**
"""
end

# ╔═╡ 8cff2a32-35b5-4330-8bfe-0dc604438dba
hint(md"Maybe try changing the witghdrawal rate.")

# ╔═╡ 67813f80-f4bd-41b3-8963-937e015614c5
danger(md"Don't forget to commit your saved notebook to your repository.")

# ╔═╡ Cell order:
# ╟─3a2a55d5-8cf8-4d5c-80a7-84a03923bba8
# ╟─72c7843c-3698-4045-9c83-2ad391097ad8
# ╟─5c5b2176-148b-4f5c-a02c-5e9e82df11c3
# ╟─d069cd4d-7afc-429f-a8fd-3f1c0a640117
# ╟─d2188dd8-1240-4fdd-870b-dcd15e91f4f2
# ╟─627959cf-6a7c-4f87-82f7-406f5c7eb76a
# ╟─d447f5dd-253c-4c8a-a2d4-873d50c9a9ec
# ╟─4aa314f2-3415-4482-a042-d4c7ebd1cb21
# ╟─8cff2a32-35b5-4330-8bfe-0dc604438dba
# ╟─67813f80-f4bd-41b3-8963-937e015614c5
