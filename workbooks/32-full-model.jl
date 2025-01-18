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

# ╔═╡ 3a2a55d5-8cf8-4d5c-80a7-84a03923bba8
md"""
# A War On Poverty
"""

# ╔═╡ 5c5b2176-148b-4f5c-a02c-5e9e82df11c3
begin
    md"""
The Government of Unicoria has pledged to reduce the headcount measure of poverty by 3 percentage points. Your task is to design a policy package that delivers this in the most effective way possible. The economy is doing well, and net extra spending of up to £4 billion has been agreed.
* *cost* any costs above £4bn will have to be raised from somewhere;
* *targetting vs. incentives*: well targetted benefit increases may force poor people into poverty traps, whilst more widely spread increases may require tax increases to keep within budget; 
* *alternative measures of poverty* have you cheated at all, and reduced poverty headcounts by concentrating on the near-poor, perhaps through increasing in-work benefits? (You may need to do this in order to meet the political objectives)
    """
end 

# ╔═╡ 4aa314f2-3415-4482-a042-d4c7ebd1cb21
md"""
## Taxes and Benefits
Tax Allowance: $(@bind tax_allowance NumberField(0:10:25000,default=12_570))(£p.a.; *default £12,570*)

Income Tax Rate: $(@bind income_tax_rate NumberField(0:1:100,default=20)) (%; *default 20*)

Benefit Withdrawal Rate: $(@bind uc_taper NumberField(0:1:100,default=55)) (%; *default 55*)

Child Benefit: $(@bind child_benefit NumberField(0:0.01:100,default=25.60)) (£s pw; *default £25.60p*)

Pension: $(@bind pension NumberField(0:0.01:500,default=221.20)) (£s pw; *default £221.20p*)
"""

# ╔═╡ 72c7843c-3698-4045-9c83-2ad391097ad8
# ╠═╡ show_logs = false

begin
    import Pkg
	# activate the shared project environment
    Pkg.activate(Base.current_project())
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


	function run_model( 
		allowance::Number, 
		income_tax_rate::Number, 
		uc_taper::Number,
		child_benefit :: Number,
		pension :: Number,
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
		sys2.nmt_bens.child_benefit.first_child = child_benefit
		sys2.nmt_bens.pensions.new_state_pension = pension
		sys2.nmt_bens.pensions.cat_a *= 
			(pension/sys2.nmt_bens.pensions.new_state_pension)
		weeklyise!( sys2 )
		sys = [BASE_SYS, sys2]
		running_total = 0
		results = Runner.do_one_run( settings, sys, run_progress )
		summary = summarise_frames!( results, settings )
		short_summary = make_short_summary( summary )
		summary, results, short_summary
	end

	
function all_defaults()::Bool
	global tax_allowance, income_tax_rate, uc_taper, child_benefit, pension
 return (default_tax_allowance == tax_allowance) &&
		(default_income_tax_rate == income_tax_rate) &&
		(default_uc_taper == uc_taper) &&
		(default_child_benefit == child_benefit) &&
		(default_pension == pension)
end
	
function pstate(m, povs )::Int
		i = 0
		for p in povs
			i += 1
			if m <= p
				return i
			end
		end
		return i+1
	end

	function make_povtrans_mat( data :: NamedTuple )::Matrix
		trans = zeros(6,6)
		med1 = median(data.indiv[1].eq_bhc_net_income, Weights(data.indiv[1].weight ))
		povs = med1.*[ 0.3, 0.4, 0.6, 0.8 ]
		nrows, ncols = size( data.indiv[1])
		for r in 1:nrows
			i1 = data.indiv[1][r,:]
			i2 = data.indiv[2][r,:]
			p1 = pstate(i1.eq_bhc_net_income, povs)
			p2 = pstate(i2.eq_bhc_net_income, povs)
			trans[p1,p2] += i1.weight
			trans[p1,6]+= i1.weight
			trans[6,p2]+= i1.weight
			trans[6,6]+= i1.weight
		end
		trans
	end
	
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
	const sevcols = [
			"#ee0000",
			"#cc2222",
			"#990000",
			"#666666",
			"#333333",
			"#333333"]

	function one_row( label::String, v :: Vector, r::Int )::String
		s = "<tr><th style='color:$(sevcols[r])'>$label</th>"	
		for i in 1:5
			bgcol = if r == 6
				"#dddddd"
			elseif i < r
				"#ffccbb"
			elseif i > r
				"#bbffdd"
			else 
				"#dddddd"
			end
			cell = "<td style='text-align:right;background:$bgcol;color:$(sevcols[i])'>$(v[i])</td>"
			s *= cell
		end
		cell = "<td style='text-align:right;background:#cccccc;color:$(sevcols[r])'>$(v[6])</td>"
		s *= cell
		s *= "</tr>"
		s
	end
	
	function pov_summary( trans::Matrix )::String
		labels = ["V.Deep (<=30%)",
		 		 "Deep (<=40%)",
		 		 "In Poverty (<=60%)",
		 		 "Near Poverty (<=80%)",
		 		 "Not in Poverty",
				 "Total"]
		vs = fb.(trans)
		cells = ""
		for r in 1:6
			cells *= one_row( labels[r], vs[r,:], r )
		end
		
		return """
<table width='100%' style=''>
	<thead></thead>
	<tr><th colspan='7'>After</th>
	<tr><th rowspan='9'>Before</th>
	<tr>
		<th></th>
		<th style='color:$(sevcols[1])'>$(labels[1])</th>
		<th style='color:$(sevcols[2])'>$(labels[2])</th>
		<th style='color:$(sevcols[3])'>$(labels[3])</th>
		<th style='color:$(sevcols[4])'>$(labels[4])</th>
		<th style='color:$(sevcols[5])'>$(labels[5])</th>
		<th style='color:$(sevcols[6])'>$(labels[6])</th>
	</tr>
	$cells
</table>
"""
	end # pov_summary
	

    PlutoUI.TableOfContents(aside=true)
end

# ╔═╡ 627959cf-6a7c-4f87-82f7-406f5c7eb76a
# ╠═╡ show_logs = false
summary, data, short_summary = run_model( tax_allowance, income_tax_rate, uc_taper, child_benefit, pension, settings );

# ╔═╡ 4f94f598-8ffc-40c1-9911-bc0afad14e84
begin
	# if ! all_defaults()
		short_summary.response
	# end
end

# ╔═╡ d069cd4d-7afc-429f-a8fd-3f1c0a640117
begin
	
md"""
## Summary Results

Net Cost of your changes: **$(short_summary.netcost)**

#### Tax revenue 

before: **$(short_summary.tax1)** after: **$(short_summary.tax2)** change: **$(short_summary.dtax)** £mn pa

#### Benefit Spending
before: **$(short_summary.ben1)** after: **$(short_summary.ben2)** change: **$(short_summary.dben)** £m pa

#### Inequality

* **Gini:** before: **$(short_summary.gini1)** after: **$(short_summary.gini2)** change: **$(short_summary.dgini)**
* **Palma:** before: **$(short_summary.palma1)** after: **$(short_summary.palma2)** change: **$(short_summary.dpalma)**

#### Gainers & Losers
People gaining: **$(short_summary.gainers)** losing: **$(short_summary.losers)** unchanged: **$(short_summary.nc)**
"""
end

# ╔═╡ d2188dd8-1240-4fdd-870b-dcd15e91f4f2
begin
	draw_summary_graphs( summary, data )
end

# ╔═╡ a51da585-0668-498e-aa02-ac8d52d44916
make_povtrans_mat( data )

# ╔═╡ 2fe134f3-6d6d-4109-a2f9-faa583be1189
begin
		s1 = summary.poverty[1]
		s2 = summary.poverty[2]
		povrate1 = fp(s1.foster_greer_thorndyke[1])
		povrate2 = fp(s2.foster_greer_thorndyke[1])
		dpovrate = fp(s2.foster_greer_thorndyke[1]-s1.foster_greer_thorndyke[1] )
		povgap1 = fp(s1.foster_greer_thorndyke[3])
		povgap2 = fp(s2.foster_greer_thorndyke[3])
		dpovgap = fp(s2.foster_greer_thorndyke[3]-s1.foster_greer_thorndyke[3] )
		povsev1 = fp(s1.foster_greer_thorndyke[5])
		povsev2 = fp(s2.foster_greer_thorndyke[5])
		dpovsev = fp(s2.foster_greer_thorndyke[5]-s1.foster_greer_thorndyke[5] )
		c1 = summary.child_poverty[1]
		c2 = summary.child_poverty[2]
		cp1 = fp(c1.prop)
	    cp2 = fp(c2.prop)
		dcp = fp(c2.prop-c1.prop)
	md"""
## Poverty Measures

* **Count:** before: **$(povrate1)** after: **$(povrate2)** change: **$(dpovrate)**
* **Gap:** before: **$(povgap1)** after: **$(povgap2)** change: **$(dpovgap)**
* **Severity:** before: **$(povsev1)** after: **$(povsev2)** change: **$(dpovsev)**
* **Child Poverty:** before: **$(cp1)** after: **$(cp2)** change: **$(dcp)**	 
	""" 
end

# ╔═╡ a1318fc7-9d20-4c00-8a89-b5ae90b5cc0c
md"## Poverty Transitions"

# ╔═╡ aa9d43a0-a45c-48bd-ae28-7b525be605ce
begin

	trans = make_povtrans_mat( data )
	t = pov_summary( trans )
	Show(MIME"text/html"(), t )
end

# ╔═╡ 8cff2a32-35b5-4330-8bfe-0dc604438dba
hint(md"Try changing the withdrawal rate. A rate of 100% gives you a MIG, 0 a basic Income.")

# ╔═╡ 67813f80-f4bd-41b3-8963-937e015614c5
danger(md"Don't forget to commit your saved notebook to your repository.")

# ╔═╡ bada072d-d79b-4bfe-a546-d5df15bf2ea1
# summary

# ╔═╡ Cell order:
# ╟─3a2a55d5-8cf8-4d5c-80a7-84a03923bba8
# ╠═72c7843c-3698-4045-9c83-2ad391097ad8
# ╟─5c5b2176-148b-4f5c-a02c-5e9e82df11c3
# ╠═4aa314f2-3415-4482-a042-d4c7ebd1cb21
# ╟─4f94f598-8ffc-40c1-9911-bc0afad14e84
# ╠═d069cd4d-7afc-429f-a8fd-3f1c0a640117
# ╠═d2188dd8-1240-4fdd-870b-dcd15e91f4f2
# ╟─a51da585-0668-498e-aa02-ac8d52d44916
# ╟─2fe134f3-6d6d-4109-a2f9-faa583be1189
# ╠═627959cf-6a7c-4f87-82f7-406f5c7eb76a
# ╟─a1318fc7-9d20-4c00-8a89-b5ae90b5cc0c
# ╟─aa9d43a0-a45c-48bd-ae28-7b525be605ce
# ╟─8cff2a32-35b5-4330-8bfe-0dc604438dba
# ╟─67813f80-f4bd-41b3-8963-937e015614c5
# ╟─bada072d-d79b-4bfe-a546-d5df15bf2ea1
