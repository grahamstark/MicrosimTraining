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
	settings.run_name="Wealth Tax Example"
	wage = 30
	examples = get_example_hhs(settings)
	sys1 = deepcopy( DEFAULT_SYS)
	weeklyise!(sys1)
end;

# ╔═╡ 3a2a55d5-8cf8-4d5c-80a7-84a03923bba8
md"""
# FES Project Output

## $(settings.run_name)
"""

# ╔═╡ bf273956-910b-49ce-bcf2-0973d15caaca
md"""
### Changing the income measure

Below is an example of how to change the income measure used in output inequality, poverty anf gain/lose tables. Options are:

* `bhc_net_income`
* `eq_bhc_net_income`
* `ahc_net_income`
* `eq_ahc_net_income`
* `net_after_indirect_income`
* `eq_net_after_indirect_income`

latter 2 won't be any different for out runs.

* "bhc" => "Before Housing Costs
* "ahc" => "After"
* "eq" => "Equivalised"

	
**NOTE:** You may need to run the model manually in the cell below go and some of the labels on the tables below may not change automatically to reflect this change.

"""

# ╔═╡ 422f362d-9e1c-4b5f-99b1-344d046490ae
begin
	settings.ineq_income_measure = eq_bhc_net_income # this the default
	#= 
	change to unequivalised with:
	=#
	# settings.ineq_income_measure = bhc_net_income 
end

# ╔═╡ a429d732-f12b-46ed-94c6-e4ae1268e66a
md""" 
## Example Wealth Tax

A simple tax of 1% on wealth above 300k, excluding pension wealth. Wealth is at the household level. Excludes `net_pension_wealth`. 

Note: this works at the household level. The Wealth Commission proposal was at the individual level.

"""

# ╔═╡ 40626eb7-ee13-4d28-8394-0df789888c6e
begin
	# create a new system
	sys2 = deepcopy( DEFAULT_SYS )		
	# turn on the wealth tax
	sys2.wealth.abolished = false
	# Include physical wealth, financial wealth, and net housing wealth ..
	sys2.wealth.included_wealth = Set([net_physical_wealth,
		net_financial_wealth,
        net_pension_wealth,
		net_housing_wealth])
	# Set it to 1% above 1,000k
	sys2.wealth.rates = [0,1.0]
	sys2.wealth.thresholds = [1_000_000]
	# 
	weeklyise!(sys2)	
end

# ╔═╡ ebb741af-7a8d-487e-be18-a7a63aed5db9
sys2.wealth

# ╔═╡ 696c6862-1c2b-4d40-a941-44bcbc94e9e2
md"""

The next line runs the model every time one of the blocks above changes. 

"""

# ╔═╡ 627959cf-6a7c-4f87-82f7-406f5c7eb76a
# ╠═╡ show_logs = false
begin
	summary, data, short_summary, zipname  = fes_run( settings, [sys1, sys2] );
end;

# ╔═╡ 0b969669-1098-4bf4-af74-3b699954de85
CSV.write("/home/graham_s/tmp/wealth-1000.tab",data.income[2];delim='\t')

# ╔═╡ 30ae2c84-6445-46d5-ad88-f81aa33ecf18
summary.gain_lose[2].dec_examples

# ╔═╡ 97bef16c-63b0-4bd2-8842-4b0bdb78a8f5
FRSHouseholdGetter.get_household(BigInt(5311), 2021)

# ╔═╡ 6a57627d-e592-4845-af8a-60d1db327fab
begin

pov_line_str = if settings.ineq_income_measure ==  pl_from_settings
	" - Poverty Line Set to : ** $(fm( settings.poverty_line))**"
else
	""
end 
	
md"""
	
## Run Settings Summary
	
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

# ╔═╡ d069cd4d-7afc-429f-a8fd-3f1c0a640117
begin
	
md"""

Net Cost of your changes: **$(short_summary.netcost)**


#### Tax revenue 

before: **$(short_summary.tax1)** after: **$(short_summary.tax2)** change: **$(short_summary.dtax)** £mn pa

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

# ╔═╡ 887eda30-285b-4ce1-ab0c-4b1fefb676e5
begin
	save_taxable_graph( settings, data, summary, [sys1,sys2] )
end

# ╔═╡ e3188a8c-e21d-488f-aa4c-d8885646b5ca
md"""
### Marginal Effective Tax Rates (METRs)

Working age individuals with Marginal Effective Tax Rates (METRs) in the given range. METR is the percentage of the next £1 you earn that is taken away in taxes or reduced means-tested benefits.
"""

# ╔═╡ 9db85469-8ded-444c-b8d5-6989d96c3d52
# ╠═╡ show_logs = false
Show(MIME"text/html"(), MicrosimTraining.mr_table( summary.metrs[1],
        summary.metrs[2]))

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
		"Rates and Bands Havn't Changed: Not Bothering."
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

# ╔═╡ f1ed5325-1d96-4693-8a2a-64951a04c0ef
Show( MIME"text/html"(), format_gainlose("By Tenure",summary.gain_lose[2].ten_gl ))

# ╔═╡ 4ed19478-f0bd-4579-87ff-dce95737d60d
Show( MIME"text/html"(), format_gainlose("By Numbers of Children",summary.gain_lose[2].children_gl ))

# ╔═╡ 1f054554-f7c4-478e-906b-ce57f451ce6d
Show( MIME"text/html"(), format_gainlose("By Household Size",summary.gain_lose[2].hhtype_gl ))

# ╔═╡ 1f7d6f70-0bc3-48ee-ba87-e25f6ba4b907
begin
	hh = examples[3]
	bc1, bc2 = getbc( settings, hh.hh, sys1, sys2, wage )
end;

# ╔═╡ c123f000-bcd6-4a37-b715-759473365b60
md""" ## Budget Constraints 

This shows the relationship between gross earnings (x-axis) and net income (y-axis)
for a $(hh.label) (we can change the family easily). Before change in red and after in blue.
"""

# ╔═╡ 477c0dc2-9141-49a2-a4c8-fdab84ea586c
draw_bc( settings, "Budget Constraint for $(hh.label)", bc1, bc2 )

# ╔═╡ 8c2c6e7c-53fa-4604-b5dd-85782443ffca
Show(MIME"text/html"(), format_bc_df( "Pre Budget Constraint $(hh.label)", bc1 ))

# ╔═╡ 4718dd2b-9c0f-4c15-b249-52deffee46b6
Show(MIME"text/html"(), format_bc_df( "Post Budget Constraint  $(hh.label)", bc2 ))

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

# ╔═╡ 65162b5e-23d0-4072-b159-6d0f4ce01a2a


# ╔═╡ Cell order:
# ╟─3a2a55d5-8cf8-4d5c-80a7-84a03923bba8
# ╠═72c7843c-3698-4045-9c83-2ad391097ad8
# ╠═35e3f85f-581b-45f2-b078-fef31b917f8d
# ╟─bf273956-910b-49ce-bcf2-0973d15caaca
# ╠═422f362d-9e1c-4b5f-99b1-344d046490ae
# ╟─a429d732-f12b-46ed-94c6-e4ae1268e66a
# ╠═40626eb7-ee13-4d28-8394-0df789888c6e
# ╠═ebb741af-7a8d-487e-be18-a7a63aed5db9
# ╟─696c6862-1c2b-4d40-a941-44bcbc94e9e2
# ╠═627959cf-6a7c-4f87-82f7-406f5c7eb76a
# ╠═0b969669-1098-4bf4-af74-3b699954de85
# ╠═30ae2c84-6445-46d5-ad88-f81aa33ecf18
# ╠═97bef16c-63b0-4bd2-8842-4b0bdb78a8f5
# ╟─6a57627d-e592-4845-af8a-60d1db327fab
# ╟─1516e738-7adb-4cb5-9fac-e983ce5d17bd
# ╠═d2188dd8-1240-4fdd-870b-dcd15e91f4f2
# ╠═d069cd4d-7afc-429f-a8fd-3f1c0a640117
# ╟─0d8df3e0-eeb9-4e61-9298-b735e9dcc284
# ╟─2fe134f3-6d6d-4109-a2f9-faa583be1189
# ╟─f750ca33-d975-4f05-b878-ad0b23f968a9
# ╟─e6816e6d-660c-46ee-b90b-d07b29dac1ad
# ╠═887eda30-285b-4ce1-ab0c-4b1fefb676e5
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
# ╟─feed5169-225f-4e95-b279-403dff21539d
# ╠═1bad315e-d9ff-4c7b-9282-b5627deea6df
# ╠═6bf8bfc0-1221-4055-9c65-ea9b04802321
# ╠═f1ed5325-1d96-4693-8a2a-64951a04c0ef
# ╟─4ed19478-f0bd-4579-87ff-dce95737d60d
# ╟─1f054554-f7c4-478e-906b-ce57f451ce6d
# ╟─c123f000-bcd6-4a37-b715-759473365b60
# ╟─1f7d6f70-0bc3-48ee-ba87-e25f6ba4b907
# ╟─477c0dc2-9141-49a2-a4c8-fdab84ea586c
# ╟─8c2c6e7c-53fa-4604-b5dd-85782443ffca
# ╟─4718dd2b-9c0f-4c15-b249-52deffee46b6
# ╟─6691e0c2-a440-4f24-855a-6c0c3d746b2e
# ╟─6c308ebe-ca45-4774-81cc-bfafc46ba2a4
# ╠═758496fe-edae-4a3a-9d04-5c09362ec037
# ╠═34c7ebc0-d137-4572-b68d-3c79d62592d4
# ╟─1e27cffe-c86c-4b3e-91f4-22e1b429a9cd
# ╠═65162b5e-23d0-4072-b159-6d0f4ce01a2a
