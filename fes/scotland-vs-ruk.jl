### A Pluto.jl notebook ###
# v0.20.21

#> [frontmatter]
#> language = "en-GB"
#> title = "FES Project Template"
#> date = "2025-09-03"
#> 
#>     [[frontmatter.author]]
#>     name = "Graham Stark"

using Markdown
using InteractiveUtils

# ╔═╡ 72c7843c-3698-4045-9c83-2ad391097ad8
# ╠═╡ show_logs = false

begin

import Pkg
# activate the shared project environment
Pkg.activate(Base.current_project())
using MicrosimTraining
PlutoUI.TableOfContents(aside=true)

end

# ╔═╡ da8d10ef-0ccf-40b9-901c-7214327e0203
md"""

Everything below this is automatically generated output. It changes every time the parameters change.

"""

# ╔═╡ 0d8df3e0-eeb9-4e61-9298-b735e9dcc284
begin
# get round assigning runs 2x
function incr(runs::Vector)::Int
	global go
	push!(runs,"")
	return size(runs)[1]
end
	
runs = [];
	
end;

# ╔═╡ f750ca33-d975-4f05-b878-ad0b23f968a9
md"""
### Incomes Summary
"""

# ╔═╡ 7b3f061d-4d6b-46db-aef2-4d3611824f73
md"""
### Poverty 

Standard Poverty Measures, using Before Housing Costs Equivalised Net Income.

"""

# ╔═╡ d48b7079-1b1e-464c-8775-c90460b5783c
md"""
### Inequality

Standard Inequality Measures, using Before Housing Costs Equivalised Net Income.

"""

# ╔═╡ a1318fc7-9d20-4c00-8a89-b5ae90b5cc0c
md"### Poverty Transitions"

# ╔═╡ ff5c2f9a-9616-4791-8da6-79327e9592ce
md"""
## Higher Rates Effects Table
"""

# ╔═╡ a1bbc2ae-68a2-40de-93a4-2c9a68c9ee91
md"""

### More Detailed Income Breakdown

There's also a spreadsheet of this ... maybe not needed here.

"""

# ╔═╡ 569d1ac6-c33c-4b64-9bea-d45431925232
# ╠═╡ show_logs = false
# ╠═╡ disabled = true
#=╠═╡
exadec = get_examples( settings, 
			  summary.gain_lose[2].dec_examples, 
			  systems=[sys1,sys2]; 
			  colval="Lose £10.01+", 
			  rowval="6" )
  ╠═╡ =#

# ╔═╡ 7947a8a6-f451-48f8-afef-e45460c5b9c0
#=╠═╡
exadec[1].results[1].bus[1].pers[120191130901].it
  ╠═╡ =#

# ╔═╡ 7058949f-8d9f-4ec9-ab30-7f9996cc988e
#=╠═╡
exadec[1].results[2].bus[1].pers[120191130901].it
  ╠═╡ =#

# ╔═╡ 6691e0c2-a440-4f24-855a-6c0c3d746b2e
md"""## Examples of Gaining Households

This is for checking purposes and you may want to ignore.

"""

# ╔═╡ 758496fe-edae-4a3a-9d04-5c09362ec037
md"## Examples of Losing Households"

# ╔═╡ 1e27cffe-c86c-4b3e-91f4-22e1b429a9cd
html"""
<style>
	.change-good{
		color: darkgreen;
	}
	.change-bad{
		color: darkred;
	}
	.post-sys{
		color: darkblue;
	}
	.pre-sys{
		color: darkred;
	}
</style>
"""

# ╔═╡ 35e3f85f-581b-45f2-b078-fef31b917f8d
# ╠═╡ show_logs = false
begin
	settings = Settings() 
	settings.run_name = "Scotland vs rUK 2026"
	settings.do_marginal_rates = true
	wage = 30
	examples = get_example_hhs(settings)
	
	const DEFAULT_SYS_2026 = get_default_system_for_fin_year(2026; scotland=true, autoweekly=false )
 
end;

# ╔═╡ 3a2a55d5-8cf8-4d5c-80a7-84a03923bba8
md"""

# $(settings.run_name)

This is an analysis of what would happen if Scotland had the income tax system of the rest of the UK, but nothing else (benefits, council tax, etc.) was unchanged.

The "Before" system is the Scottish System announced in the Jan 16 budget, but with the rUK 2026/7 income tax rules applied; the "After" system is the actual Scottish System. Gainers are those better off under the Scottish system. 

It uses [Scotben, an Open Source microsimulation model of Scotland](https://github.com/grahamstark/ScottishTaxBenefitModel.jl/). More on ScotBen [here](https://stb-blog.virtual-worlds.scot), including an independent evaluation.

"""

# ╔═╡ 1516e738-7adb-4cb5-9fac-e983ce5d17bd
md"""
## Summary Results : $(settings.run_name)
"""

# ╔═╡ e3188a8c-e21d-488f-aa4c-d8885646b5ca
begin
if settings.do_marginal_rates
md"""
### Marginal Effective Tax Rates (METRs)

Working age individuals with Marginal Effective Tax Rates (METRs) in the given range. METR is the percentage of the next £1 you earn that is taken away in taxes or reduced means-tested benefits.
"""
end
end

# ╔═╡ 1bad315e-d9ff-4c7b-9282-b5627deea6df
md""" 
## Gain/Lose Tables 

*Using $(INEQ_INCOME_MEASURE_STRS[settings.ineq_income_measure])*
"""

# ╔═╡ 8618f4e9-8b12-4929-98f2-9713f3814c67
# ╠═╡ show_logs = false
begin
	systmp = STBParameters.get_default_system_for_fin_year( 2026; scotland=false, autoweekly=false)
	
	sys1 = deepcopy( DEFAULT_SYS_2026)	
	sys2 = deepcopy( DEFAULT_SYS_2026)	
	# copy rUK IT system into sys1, leave everything else unchanged
	sys1.it = deepcopy( systmp.it )
	
	weeklyise!(sys1)
	weeklyise!(sys2)
end;

# ╔═╡ 627959cf-6a7c-4f87-82f7-406f5c7eb76a
# ╠═╡ show_logs = false
summary, data, short_summary, zipname  = fes_run( settings, [sys1, sys2] );

# ╔═╡ ebf923a1-b940-4b67-8a3b-29e61bf30b5d
begin

	function ruk_vs_scot( ;scot, ruk )
		ch = DataFrame( weight=scot.weight, diff = ruk.it_non_savings - scot.it_non_savings )
		avch = mean( ch.diff, Weights( ch.weight ))
		scot_gainers = sum( ch[ch.diff .> 0,:weight])
		scot_losers = sum( ch[ch.diff .< 0,:weight])
		total = sum(ch.weight )
		scot_gainers_prp = scot_gainers/total
		unchanged = total - scot_gainers - scot_losers
		return (; total, scot_gainers, scot_losers, scot_gainers_prp, unchanged )
	end
	
	i1 = data.indiv[1]
	i2 = data.indiv[2]
	taxp1 = i1[i1.it_non_savings .> 0, :]
	taxp2 = i2[i1.it_non_savings .> 0, :]
	ft_work1 = i1[i2.employment_status .== Full_time_Employee, :]
	ft_work2 = i2[i2.employment_status .== Full_time_Employee, :]
	all_work1 = i1[i1.employment_status .∈ ([Full_time_Employee,Part_time_Employee],), :]
	all_work2 = i2[i2.employment_status .∈ ([Full_time_Employee,Part_time_Employee],), :]
	all = ruk_vs_scot( scot=i2, ruk=i1 )
	taxpayers = ruk_vs_scot( scot=taxp2, ruk=taxp1 )
	ft_workers = ruk_vs_scot( scot=ft_work2, ruk=ft_work1 )
	all_workers = ruk_vs_scot( scot=all_work2, ruk=all_work1 )
	# all, ft_workers, taxpayers, all_workers
end;

# ╔═╡ 543d0a01-f3c7-4ad3-8fc5-c1a09de52cfc
begin

prp = fp(all.scot_gainers_prp)
	
md"""
## Scot vs rUK income tax

#### % Gaining Under Scottish System
(counts of individuals)
	
* Total population: **$(fp(all.scot_gainers_prp))**
* FT Working population: **$(fp(ft_workers.scot_gainers_prp))**
* All Working population: **$(fp(all_workers.scot_gainers_prp))**
* Taxpayers: **$(fp(taxpayers.scot_gainers_prp))**

	
#### Counts

* Total household population:  **$(fc(all.total))** Gaining: **$(fc(all.scot_gainers))** Losing: **$(fc(all.scot_losers))** Unchanged: **$(fc(all.unchanged))**
* FT Working population: **$(fc(ft_workers.total))** Gaining **$(fc(ft_workers.scot_gainers))** Losing **$(fc(ft_workers.scot_losers))** Unchanged: **$(fc(ft_workers.unchanged))**
* All Working population: **$(fc(all_workers.total))** Gaining **$(fc(all_workers.scot_gainers))** Losing **$(fc(all_workers.scot_losers))** Unchanged: **$(fc(all_workers.unchanged))**
* All Taxpayers: **$(fc(taxpayers.total))** Gaining **$(fc(taxpayers.scot_gainers))** Losing **$(fc(taxpayers.scot_losers))** Unchanged: **$(fc(taxpayers.unchanged))**
"""

end

# ╔═╡ 6a57627d-e592-4845-af8a-60d1db327fab
begin

pov_line_str = if settings.ineq_income_measure ==  pl_from_settings
	" - Poverty Line Set to : ** $(fm( settings.poverty_line))**"
else
	""
end 
	
md"""
	
### Run Settings Summary
	
* ScotBen version: **$(string(pkgversion(ScottishTaxBenefitModel)))**
* Incomes uprated to: **$(settings.to_y)** q**$(settings.to_q)**;
* Income Type Used for Poverty/Inequality/Decile Graphs: **$(INEQ_INCOME_MEASURE_STRS[settings.ineq_income_measure])**;
* Income Type used for Gain-Lose tables: **$(INEQ_INCOME_MEASURE_STRS[settings.ineq_income_measure])** 
* Populations weighed to: **$(settings.weighting_target_year)**;
* Poverty Line :**$(POVERTY_LINE_SOURCE_STRS[settings.poverty_line_source])** $(pov_line_str);
* Means-Tested Benefits Phase in assumption: **$(MT_ROUTING_STRS[settings.means_tested_routing])**;
* Disability Benefits Phase in assumption: **Scottish System 100% phased in**;
* Dodgy Means-Tested Benefits takeup corrections applied: **$(settings.do_dodgy_takeup_corrections)**;
* Output written to directory **$(zipname)**.
"""
end

# ╔═╡ d2188dd8-1240-4fdd-870b-dcd15e91f4f2
begin
	MicrosimTraining.fes_draw_summary_graphs( settings, data, summary )
end

# ╔═╡ d069cd4d-7afc-429f-a8fd-3f1c0a640117
begin
	
md"""

Net Cost of your changes: **$(short_summary.netcost)**


#### Direct Tax revenue 

before: **$(short_summary.tax1)** after: **$(short_summary.tax2)** change: **$(short_summary.dtax)** £mn pa

#### Net Revenue Raised inc. Local Taxes

**$(short_summary.netcost)** £mn pa

#### Net Revenue raised - Benefits & Direct Taxes only

**$(short_summary.netdirect)** £mn pa

**$(short_summary.netcost)** £mn pa


#### Benefit Spending
before: **$(short_summary.ben1)** after: **$(short_summary.ben2)** change: **$(short_summary.dben)** £m pa

#### Inequality

* **Gini:** before: **$(short_summary.gini1)** after: **$(short_summary.gini2)** change: **$(short_summary.dgini)**
* **Palma:** before: **$(short_summary.palma1)** after: **$(short_summary.palma2)** change: **$(short_summary.dpalma)**

*Using $(INEQ_INCOME_MEASURE_STRS[settings.ineq_income_measure]) income*.
	
#### Gainers & Losers
People gaining: **$(short_summary.gainers)** losing: **$(short_summary.losers)** unchanged: **$(short_summary.nc)**
"""
end

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
### Poverty Measures

* **Count:** before: **$(povrate1)** after: **$(povrate2)** change: **$(dpovrate)**
* **Gap:** before: **$(povgap1)** after: **$(povgap2)** change: **$(dpovgap)**
* **Severity:** before: **$(povsev1)** after: **$(povsev2)** change: **$(dpovsev)**
* **Child Poverty:** before: **$(cp1)** after: **$(cp2)** change: **$(dcp)**	

*Using $(INEQ_INCOME_MEASURE_STRS[settings.ineq_income_measure]) income.*
	
""" 
end

# ╔═╡ e6816e6d-660c-46ee-b90b-d07b29dac1ad
Show(MIME"text/html"(), MicrosimTraining.costs_table( summary.income_summary[1],
        summary.income_summary[2]))

# ╔═╡ 8ce36be3-2573-415e-a245-eb049d0f3884
begin
	Show( MIME"text/html"(), format_sfc("SFC Behavioral Corrections", data.behavioural_results[2]))
end

# ╔═╡ 9db85469-8ded-444c-b8d5-6989d96c3d52
# ╠═╡ show_logs = false
begin
if settings.do_marginal_rates
Show(MIME"text/html"(), MicrosimTraining.mr_table( summary.metrs[1],
        summary.metrs[2]))
end
end

# ╔═╡ 5d5ea47f-74fb-46aa-842b-b74b964ad9bb
# ╠═╡ show_logs = false
Show(MIME"text/html"(), MicrosimTraining.pov_table(
        summary.poverty[1],
        summary.poverty[2],
        summary.child_poverty[1],
        summary.child_poverty[2]))

# ╔═╡ db1a4510-9190-4556-806b-2a6dc8fd3e1b
Show(MIME"text/html"(), MicrosimTraining.ineq_table(
        summary.inequality[1],
        summary.inequality[2]))

# ╔═╡ aa9d43a0-a45c-48bd-ae28-7b525be605ce
# ╠═╡ show_logs = false
begin
	t = make_pov_transitions( summary.povtrans_matrix[2] )
	Show(MIME"text/html"(), t )
end

# ╔═╡ feed5169-225f-4e95-b279-403dff21539d
summary.short_income_summary

# ╔═╡ 6bf8bfc0-1221-4055-9c65-ea9b04802321
Show( MIME"text/html"(), format_gainlose("By Decile",summary.gain_lose[2].dec_gl ))

# ╔═╡ f1ed5325-1d96-4693-8a2a-64951a04c0ef
Show( MIME"text/html"(), format_gainlose("By Tenure",summary.gain_lose[2].ten_gl ))

# ╔═╡ 4ed19478-f0bd-4579-87ff-dce95737d60d
Show( MIME"text/html"(), format_gainlose("By Numbers of Children",summary.gain_lose[2].children_gl ))

# ╔═╡ 1f054554-f7c4-478e-906b-ce57f451ce6d
Show( MIME"text/html"(), format_gainlose("By Household Size",summary.gain_lose[2].hhtype_gl ))

# ╔═╡ d18b50f2-cbc8-44f4-ba5f-9c69c9b95f7f
begin
        hh = examples[3]
        bc1, bc2 = getbc( settings, hh.hh, sys1, sys2, wage )
end;


# ╔═╡ 573030ef-e5fc-48f3-b41e-4ab925f79e11
draw_bc( settings, "Budget Constraint for $(hh.label)", bc1, bc2 )

# ╔═╡ 65162b5e-23d0-4072-b159-6d0f4ce01a2a
Show(MIME"text/html"(), format_bc_df( "Pre Budget Constraint $(hh.label)", bc1 ))


# ╔═╡ 4cbba143-6130-4931-9d8f-6127e0e9d265
Show(MIME"text/html"(), format_bc_df( "Post Budget Constraint  $(hh.label)", bc2 ))

# ╔═╡ 53646b2c-315a-4f8d-af53-fb7a099a3f49
begin
        save_taxable_graph( settings, data, summary, [sys1,sys2] )
end


# ╔═╡ fa12ec1f-4969-43d9-b5b4-b1c83f92ce9a
# ╠═╡ show_logs = false
begin
	inc_compare = if(sys1.it.non_savings_rates != sys2.it.non_savings_rates) ||
		(sys1.it.non_savings_thresholds != sys2.it.non_savings_thresholds)
		hrt, tpretty, systems, shortsum = do_higher_rates_run(settings,sys1,sys2)
		hrt.label = pretty.( hrt.label )
		hrt
	else
		"Rates and Bands Haven't Changed: Not Bothering."
	end
	inc_compare
end

# ╔═╡ 77711184-d05a-4129-ab36-5816c0d53bdd
# ╠═╡ show_logs = false
get_examples( settings, 
			  summary.gain_lose[2].ten_examples, 
			  systems=[sys1,sys2]; 
			  colval="Lose £10.01+", 
			  rowval="Mortgaged_Or_Shared" )

# ╔═╡ ef390757-e8a4-4b21-b9d8-aa58d8473c48
# ╠═╡ show_logs = false
exasize = get_examples( settings, 
			  summary.gain_lose[2].hhtype_examples, 
			  systems=[sys1,sys2]; 
			  colval="Gain £10.01+", 
			  rowval="4" )

# ╔═╡ 6c308ebe-ca45-4774-81cc-bfafc46ba2a4
get_change_target_hhs( settings, sys1, sys2, summary.gain_lose[2].ex_gainers )

# ╔═╡ 34c7ebc0-d137-4572-b68d-3c79d62592d4
# ╠═╡ show_logs = false
get_change_target_hhs( settings, sys1, sys2, summary.gain_lose[2].ex_losers )

# ╔═╡ Cell order:
# ╟─3a2a55d5-8cf8-4d5c-80a7-84a03923bba8
# ╟─627959cf-6a7c-4f87-82f7-406f5c7eb76a
# ╟─ebf923a1-b940-4b67-8a3b-29e61bf30b5d
# ╟─543d0a01-f3c7-4ad3-8fc5-c1a09de52cfc
# ╟─da8d10ef-0ccf-40b9-901c-7214327e0203
# ╟─6a57627d-e592-4845-af8a-60d1db327fab
# ╟─1516e738-7adb-4cb5-9fac-e983ce5d17bd
# ╟─d2188dd8-1240-4fdd-870b-dcd15e91f4f2
# ╟─d18b50f2-cbc8-44f4-ba5f-9c69c9b95f7f
# ╠═53646b2c-315a-4f8d-af53-fb7a099a3f49
# ╟─d069cd4d-7afc-429f-a8fd-3f1c0a640117
# ╟─0d8df3e0-eeb9-4e61-9298-b735e9dcc284
# ╟─2fe134f3-6d6d-4109-a2f9-faa583be1189
# ╟─f750ca33-d975-4f05-b878-ad0b23f968a9
# ╟─e6816e6d-660c-46ee-b90b-d07b29dac1ad
# ╟─8ce36be3-2573-415e-a245-eb049d0f3884
# ╟─e3188a8c-e21d-488f-aa4c-d8885646b5ca
# ╟─9db85469-8ded-444c-b8d5-6989d96c3d52
# ╟─7b3f061d-4d6b-46db-aef2-4d3611824f73
# ╟─5d5ea47f-74fb-46aa-842b-b74b964ad9bb
# ╟─d48b7079-1b1e-464c-8775-c90460b5783c
# ╟─db1a4510-9190-4556-806b-2a6dc8fd3e1b
# ╟─a1318fc7-9d20-4c00-8a89-b5ae90b5cc0c
# ╟─aa9d43a0-a45c-48bd-ae28-7b525be605ce
# ╟─ff5c2f9a-9616-4791-8da6-79327e9592ce
# ╟─fa12ec1f-4969-43d9-b5b4-b1c83f92ce9a
# ╟─a1bbc2ae-68a2-40de-93a4-2c9a68c9ee91
# ╠═feed5169-225f-4e95-b279-403dff21539d
# ╟─1bad315e-d9ff-4c7b-9282-b5627deea6df
# ╠═6bf8bfc0-1221-4055-9c65-ea9b04802321
# ╟─569d1ac6-c33c-4b64-9bea-d45431925232
# ╠═f1ed5325-1d96-4693-8a2a-64951a04c0ef
# ╠═77711184-d05a-4129-ab36-5816c0d53bdd
# ╠═4ed19478-f0bd-4579-87ff-dce95737d60d
# ╠═1f054554-f7c4-478e-906b-ce57f451ce6d
# ╠═ef390757-e8a4-4b21-b9d8-aa58d8473c48
# ╠═7947a8a6-f451-48f8-afef-e45460c5b9c0
# ╠═7058949f-8d9f-4ec9-ab30-7f9996cc988e
# ╠═6691e0c2-a440-4f24-855a-6c0c3d746b2e
# ╠═6c308ebe-ca45-4774-81cc-bfafc46ba2a4
# ╠═758496fe-edae-4a3a-9d04-5c09362ec037
# ╠═34c7ebc0-d137-4572-b68d-3c79d62592d4
# ╟─1e27cffe-c86c-4b3e-91f4-22e1b429a9cd
# ╠═573030ef-e5fc-48f3-b41e-4ab925f79e11
# ╠═65162b5e-23d0-4072-b159-6d0f4ce01a2a
# ╠═4cbba143-6130-4931-9d8f-6127e0e9d265
# ╟─8618f4e9-8b12-4929-98f2-9713f3814c67
# ╟─35e3f85f-581b-45f2-b078-fef31b917f8d
# ╟─72c7843c-3698-4045-9c83-2ad391097ad8
