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

# ╔═╡ 35e3f85f-581b-45f2-b078-fef31b917f8d
# ╠═╡ show_logs = false
begin
	settings = Settings() 
	settings.run_name = "Scottish Budget 2026"
	settings.do_marginal_rates = true
	wage = 30
	examples = get_example_hhs(settings)
	
	const DEFAULT_SYS_2026 = get_default_system_for_fin_year(2026; scotland=true, autoweekly=false )
 
end;

# ╔═╡ 3a2a55d5-8cf8-4d5c-80a7-84a03923bba8
md"""
# FES Project Output

## $(settings.run_name)
"""

# ╔═╡ 243da852-da2d-4f50-94b1-363e015d76c8


function turn_on_property!( ; sys::TaxBenefitSystem{T}, 
							rates::Vector{T}, 
							thresholds::Vector{T}, 
							basic_rate=2 ) where T <: AbstractFloat
	sys.it.property_rates = copy(rates)
    sys.it.property_thresholds = copy(thresholds) 
    sys.it.property_basic_rate = basic_rate
    # no equivalent of the savings allowance.
	sys.it.personal_property_allowance = 0.0
	# just property income in the property definition
	push!(sys.it.property_income,PROPERTY)
	# ... and remove property from standard Scottish Income Tax
	setdiff!(sys.it.non_savings_income, [PROPERTY] )
end



# ╔═╡ 8618f4e9-8b12-4929-98f2-9713f3814c67
begin
	sys1 = deepcopy( DEFAULT_SYS_2026 )
	
	sys2 = deepcopy( DEFAULT_SYS_2026)	
	#= 
	Rooker-wised 2025/6 thresholds 
	gaps between bands increased by 3.8% rounded up to next £100
	=#
	sys1.it.non_savings_thresholds = [
		 3000.0,
	    15600.0,
  		32400.0,
  		65000.0,
 		130100.0]
	#=
	or just do:
	sys1.it.non_savings_thresholds = [
		2934.426,
  		15487.998000000001,
  		32273.496000000003,
  		64802.340000000004,
 		129895.32]
	=#
	# The next 2 add £40 for children under 1
	sys2.scottish_child_payment.maximum_ages = [0,15,99]
	sys2.scottish_child_payment.amounts = [40.0,28.2,0]
	
	# This adds extra CT for house values above 1m. All other CT is unchanged.
	sys2.loctax.ct.house_values[Band_H] = 1_000_000
    sys2.loctax.ct.house_values[Band_I] = 2_000_000
    sys2.loctax.ct.house_values[Band_J] = 99999999999
    
    sys2.loctax.ct.keep_band = Band_H
	# these relativities are made up.
    sys2.loctax.ct.relativities[Band_I] = 840/360
    sys2.loctax.ct.relativities[Band_J] = 960/360
    sys2.loctax.ct.revalue = true # turn false/true for CT 1m 
	weeklyise!(sys1)
	weeklyise!(sys2)
end

# ╔═╡ 00a8de3a-f2d2-40bc-9f5b-18ef0f3138e4


# ╔═╡ 696c6862-1c2b-4d40-a941-44bcbc94e9e2
md"""

The next line runs the model every time one of the blocks above changes. 

"""

# ╔═╡ 627959cf-6a7c-4f87-82f7-406f5c7eb76a
# ╠═╡ show_logs = false
summary, data, short_summary, zipname  = fes_run( settings, [sys1, sys2] );

# ╔═╡ da8d10ef-0ccf-40b9-901c-7214327e0203
md"""

Everything below this is automatically generated output. It changes every time the parameters change.

"""

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

# ╔═╡ 1516e738-7adb-4cb5-9fac-e983ce5d17bd
md"""
## Summary Results : $(settings.run_name)
"""

# ╔═╡ d2188dd8-1240-4fdd-870b-dcd15e91f4f2
begin
	MicrosimTraining.fes_draw_summary_graphs( settings, data, summary )
end

# ╔═╡ d18b50f2-cbc8-44f4-ba5f-9c69c9b95f7f
begin
        hh = examples[3]
        bc1, bc2 = getbc( settings, hh.hh, sys1, sys2, wage )
end;


# ╔═╡ 53646b2c-315a-4f8d-af53-fb7a099a3f49
begin
        save_taxable_graph( settings, data, summary, [sys1,sys2] )
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

# ╔═╡ f750ca33-d975-4f05-b878-ad0b23f968a9
md"""
### Incomes Summary
"""

# ╔═╡ e6816e6d-660c-46ee-b90b-d07b29dac1ad
Show(MIME"text/html"(), MicrosimTraining.costs_table( summary.income_summary[1],
        summary.income_summary[2]))

# ╔═╡ 8ce36be3-2573-415e-a245-eb049d0f3884
begin
	Show( MIME"text/html"(), format_sfc("SFC Behavioral Corrections", data.behavioural_results[2]))
end

# ╔═╡ e3188a8c-e21d-488f-aa4c-d8885646b5ca
begin
if settings.do_marginal_rates
md"""
### Marginal Effective Tax Rates (METRs)

Working age individuals with Marginal Effective Tax Rates (METRs) in the given range. METR is the percentage of the next £1 you earn that is taken away in taxes or reduced means-tested benefits.
"""
end
end

# ╔═╡ 9db85469-8ded-444c-b8d5-6989d96c3d52
# ╠═╡ show_logs = false
begin
if settings.do_marginal_rates
Show(MIME"text/html"(), MicrosimTraining.mr_table( summary.metrs[1],
        summary.metrs[2]))
end
end

# ╔═╡ 7b3f061d-4d6b-46db-aef2-4d3611824f73
md"""
### Poverty 

Standard Poverty Measures, using Before Housing Costs Equivalised Net Income.

"""

# ╔═╡ 5d5ea47f-74fb-46aa-842b-b74b964ad9bb
# ╠═╡ show_logs = false
Show(MIME"text/html"(), MicrosimTraining.pov_table(
        summary.poverty[1],
        summary.poverty[2],
        summary.child_poverty[1],
        summary.child_poverty[2]))

# ╔═╡ d48b7079-1b1e-464c-8775-c90460b5783c
md"""
### Inequality

Standard Inequality Measures, using Before Housing Costs Equivalised Net Income.

"""

# ╔═╡ db1a4510-9190-4556-806b-2a6dc8fd3e1b
Show(MIME"text/html"(), MicrosimTraining.ineq_table(
        summary.inequality[1],
        summary.inequality[2]))

# ╔═╡ a1318fc7-9d20-4c00-8a89-b5ae90b5cc0c
md"### Poverty Transitions"

# ╔═╡ aa9d43a0-a45c-48bd-ae28-7b525be605ce
# ╠═╡ show_logs = false
begin
	t = make_pov_transitions( summary.povtrans_matrix[2] )
	Show(MIME"text/html"(), t )
end

# ╔═╡ ff5c2f9a-9616-4791-8da6-79327e9592ce
md"""
## Higher Rates Effects Table
"""

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

# ╔═╡ a1bbc2ae-68a2-40de-93a4-2c9a68c9ee91
md"""

### More Detailed Income Breakdown

There's also a spreadsheet of this ... maybe not needed here.

"""

# ╔═╡ feed5169-225f-4e95-b279-403dff21539d
summary.short_income_summary

# ╔═╡ 1bad315e-d9ff-4c7b-9282-b5627deea6df
md""" 
## Gain/Lose Tables 

*Using $(INEQ_INCOME_MEASURE_STRS[settings.ineq_income_measure])*
"""

# ╔═╡ 6bf8bfc0-1221-4055-9c65-ea9b04802321
Show( MIME"text/html"(), format_gainlose("By Decile",summary.gain_lose[2].dec_gl ))

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

# ╔═╡ f1ed5325-1d96-4693-8a2a-64951a04c0ef
Show( MIME"text/html"(), format_gainlose("By Tenure",summary.gain_lose[2].ten_gl ))

# ╔═╡ 77711184-d05a-4129-ab36-5816c0d53bdd
# ╠═╡ show_logs = false
get_examples( settings, 
			  summary.gain_lose[2].ten_examples, 
			  systems=[sys1,sys2]; 
			  colval="Lose £10.01+", 
			  rowval="Mortgaged_Or_Shared" )

# ╔═╡ 4ed19478-f0bd-4579-87ff-dce95737d60d
Show( MIME"text/html"(), format_gainlose("By Numbers of Children",summary.gain_lose[2].children_gl ))

# ╔═╡ 1f054554-f7c4-478e-906b-ce57f451ce6d
Show( MIME"text/html"(), format_gainlose("By Household Size",summary.gain_lose[2].hhtype_gl ))

# ╔═╡ ef390757-e8a4-4b21-b9d8-aa58d8473c48
# ╠═╡ show_logs = false
exasize = get_examples( settings, 
			  summary.gain_lose[2].hhtype_examples, 
			  systems=[sys1,sys2]; 
			  colval="Gain £10.01+", 
			  rowval="4" )

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

# ╔═╡ 6c308ebe-ca45-4774-81cc-bfafc46ba2a4
get_change_target_hhs( settings, sys1, sys2, summary.gain_lose[2].ex_gainers )

# ╔═╡ 758496fe-edae-4a3a-9d04-5c09362ec037
md"## Examples of Losing Households"

# ╔═╡ 34c7ebc0-d137-4572-b68d-3c79d62592d4
# ╠═╡ show_logs = false
get_change_target_hhs( settings, sys1, sys2, summary.gain_lose[2].ex_losers )

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

# ╔═╡ 573030ef-e5fc-48f3-b41e-4ab925f79e11
draw_bc( settings, "Budget Constraint for $(hh.label)", bc1, bc2 )

# ╔═╡ 65162b5e-23d0-4072-b159-6d0f4ce01a2a
Show(MIME"text/html"(), format_bc_df( "Pre Budget Constraint $(hh.label)", bc1 ))


# ╔═╡ 4cbba143-6130-4931-9d8f-6127e0e9d265
Show(MIME"text/html"(), format_bc_df( "Post Budget Constraint  $(hh.label)", bc2 ))

# ╔═╡ Cell order:
# ╠═3a2a55d5-8cf8-4d5c-80a7-84a03923bba8
# ╟─72c7843c-3698-4045-9c83-2ad391097ad8
# ╠═35e3f85f-581b-45f2-b078-fef31b917f8d
# ╠═243da852-da2d-4f50-94b1-363e015d76c8
# ╠═8618f4e9-8b12-4929-98f2-9713f3814c67
# ╠═00a8de3a-f2d2-40bc-9f5b-18ef0f3138e4
# ╟─696c6862-1c2b-4d40-a941-44bcbc94e9e2
# ╠═627959cf-6a7c-4f87-82f7-406f5c7eb76a
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
