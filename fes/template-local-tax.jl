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
	settings.run_name = "Mansion Tax"
	settings.do_marginal_rates = true
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

# ╔═╡ 8618f4e9-8b12-4929-98f2-9713f3814c67
begin
	sys2 = deepcopy( DEFAULT_SYS)	
	#=
	# scotgov proposed progressive CT relativities
	SG_RELATIVITIES = deepcopy( sys2.loctax.ct.relativities ) 
	# 7.5%, 12.5%, 17.5% and 22.5% 
	SG_RELATIVITIES[Band_E] *= 1.075
	SG_RELATIVITIES[Band_F] *= 1.125
	SG_RELATIVITIES[Band_G] *= 1.175
	SG_RELATIVITIES[Band_H] *= 1.225
	sys2.loctax.ct.relativities = SG_RELATIVITIES
	=#
	# sys2.name = settings.run_name
	sys2.it.non_savings_rates[5:end] .+= 5
	# sys2.ni.primary_class_1_rates .+= 5
	#=
	sys2.loctax.ppt.local_rates = [0, 2_500.0, 7_500.0] # annual
    sys2.loctax.ppt.local_bands = [500_000, 1_000_000] 
    sys2.loctax.ppt.fixed_sum = true
	sys2.loctax.ppt.abolished = false
	=#
	weeklyise!(sys2)
end

# ╔═╡ b9af7395-2d50-4001-87cb-57d32af2a8dc
#= 
	excerpt from STBParameters.jl
	
@with_kw mutable struct CouncilTax{RT<:Real}
    abolished :: Bool = false
    revalue :: Bool = false
    house_values :: Dict{CT_Band,RT} = default_ct_house_values(RT)
    band_d :: Dict{Symbol,RT} = default_band_ds(RT)
    relativities :: Dict{CT_Band,RT} = default_ct_ratios(RT)
    single_person_discount :: RT = 25.0
    # TODO see CT note on disabled discounts
end

@with_kw mutable struct ProportionalPropertyTax{RT<:Real}
    abolished :: Bool = true
    rate :: RT = 0.0
end

@with_kw mutable struct LocalTaxes{RT<:Real}
    ct = CouncilTax{RT}()
    ppt = ProportionalPropertyTax{RT}()
    local_income_tax_rates :: RateBands{RT} = zeros(RT,1) # [19.0,20.0,21.0,41.0,46.0]
    # other possible local taxes go here
end

	local authorities are indexed in the parameters by the symbols on the left 
i.e. :S12000033 (don't use "s)
	
const LA_NAMES = Dict(
    :S12000033 => "Aberdeen City",
    :S12000034 => "Aberdeenshire",
    :S12000041 => "Angus",
    :S12000035 => "Argyll and Bute",
    :S12000036 => "City of Edinburgh",
    :S12000005 => "Clackmannanshire",
    :S12000006 => "Dumfries and Galloway",
    :S12000042 => "Dundee City",
    :S12000008 => "East Ayrshire",
    :S12000045 => "East Dunbartonshire",
    :S12000010 => "East Lothian",
    :S12000011 => "East Renfrewshire",
    :S12000014 => "Falkirk",
    :S12000047 => "Fife",
    :S12000049 => "Glasgow City",
    :S12000017 => "Highland",
    :S12000018 => "Inverclyde",
    :S12000019 => "Midlothian",
    :S12000020 => "Moray",
    :S12000013 => "Na h-Eileanan Siar",
    :S12000021 => "North Ayrshire",
    :S12000050 => "North Lanarkshire",
    :S12000023 => "Orkney Islands",
    :S12000048 => "Perth and Kinross",
    :S12000038 => "Renfrewshire",
    :S12000026 => "Scottish Borders",
    :S12000027 => "Shetland Islands",
    :S12000028 => "South Ayrshire",
    :S12000029 => "South Lanarkshire",
    :S12000030 => "Stirling",
    :S12000039 => "West Dunbartonshire",
    :S12000040 => "West Lothian")
	PROGRESSIVE_RELATIVITIES = Dict{CT_Band,Float64}(
    # halved below D, doubled above
    Band_A=>120/360,
    Band_B=>140/360,
    Band_C=>160/360,
    Band_D=>360/360,
    Band_E=>473/180,
    Band_F=>585/180,                                                                      
    Band_G=>705/180,
    Band_H=>882/180,
    Band_I=>-1,
    Household_not_valued_separately => 0.0 ) 

	# proportional property tax of 2% of property value
	sys2 = deepcopy(sys1)
    sys2.loctax.ct.abolished = true        
    sys2.loctax.ppt.abolished = false
    sys2.loctax.ppt.rate = 2/(100.0*WEEKS_PER_YEAR)


	# revalued house prices
	
    sys2.loctax.ct.revalue = true
    sys2.loctax.ct.house_values = Dict{CT_Band,Float64}(
        Band_A=>44_000.0,
        Band_B=>65_000.0,
        Band_C=>91_000.0,
        Band_D=>123_000.0,
        Band_E=>162_000.0,
        Band_F=>223_000.0,                                                                      
        Band_G=>324_000.0,
        Band_H=>99999999999999999999999.999, # 424_000.00,
        Band_I=>-1, # wales only
        Household_not_valued_separately => 0.0 )
	# set the revised CT of Angus to 2,000pa
    sys2.loctax.ct.band_d[:S12000041] = 2000
	
=#



# ╔═╡ 8473236d-b207-4494-b4e8-a527106bff56
sort(sys1.loctax.ct.relativities)

# ╔═╡ 90db21bc-bff3-4e9d-956e-fd4d7707840d
sort(sys2.loctax.ct.relativities)

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

# ╔═╡ 53646b2c-315a-4f8d-af53-fb7a099a3f49


# ╔═╡ 9f9297a4-a684-46a8-a6b4-f9d2471ec83a
data.behavioural_results[2]

# ╔═╡ 0d8c26b6-a0ef-453c-b190-a25f1150a7a5
4.96414e8+7.55747e7

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
get_examples( settings, 
			  summary.gain_lose[2].dec_examples, 
			  systems=[sys1,sys2]; 
			  colval="Lose £10.01+", 
			  rowval="1" )

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

# ╔═╡ 6691e0c2-a440-4f24-855a-6c0c3d746b2e
md"""## Examples of Gaining Households

This is for checking purposes and you may want to ignore.

"""

# ╔═╡ 6c308ebe-ca45-4774-81cc-bfafc46ba2a4
get_change_target_hhs( settings, sys1, sys2, summary.gain_lose[2].ex_gainers )

# ╔═╡ 758496fe-edae-4a3a-9d04-5c09362ec037
md"## Examples of Losing Households"

# ╔═╡ 85b5715b-aa6b-409b-b2bc-46b2ad3e4343


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
# ╟─72c7843c-3698-4045-9c83-2ad391097ad8
# ╠═35e3f85f-581b-45f2-b078-fef31b917f8d
# ╠═8618f4e9-8b12-4929-98f2-9713f3814c67
# ╟─b9af7395-2d50-4001-87cb-57d32af2a8dc
# ╠═8473236d-b207-4494-b4e8-a527106bff56
# ╠═90db21bc-bff3-4e9d-956e-fd4d7707840d
# ╟─696c6862-1c2b-4d40-a941-44bcbc94e9e2
# ╠═627959cf-6a7c-4f87-82f7-406f5c7eb76a
# ╟─da8d10ef-0ccf-40b9-901c-7214327e0203
# ╟─6a57627d-e592-4845-af8a-60d1db327fab
# ╟─1516e738-7adb-4cb5-9fac-e983ce5d17bd
# ╟─d2188dd8-1240-4fdd-870b-dcd15e91f4f2
# ╠═53646b2c-315a-4f8d-af53-fb7a099a3f49
# ╠═9f9297a4-a684-46a8-a6b4-f9d2471ec83a
# ╠═0d8c26b6-a0ef-453c-b190-a25f1150a7a5
# ╟─d069cd4d-7afc-429f-a8fd-3f1c0a640117
# ╟─0d8df3e0-eeb9-4e61-9298-b735e9dcc284
# ╟─2fe134f3-6d6d-4109-a2f9-faa583be1189
# ╠═f750ca33-d975-4f05-b878-ad0b23f968a9
# ╟─e6816e6d-660c-46ee-b90b-d07b29dac1ad
# ╠═8ce36be3-2573-415e-a245-eb049d0f3884
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
# ╠═569d1ac6-c33c-4b64-9bea-d45431925232
# ╠═f1ed5325-1d96-4693-8a2a-64951a04c0ef
# ╠═77711184-d05a-4129-ab36-5816c0d53bdd
# ╠═4ed19478-f0bd-4579-87ff-dce95737d60d
# ╠═1f054554-f7c4-478e-906b-ce57f451ce6d
# ╠═6691e0c2-a440-4f24-855a-6c0c3d746b2e
# ╟─6c308ebe-ca45-4774-81cc-bfafc46ba2a4
# ╠═758496fe-edae-4a3a-9d04-5c09362ec037
# ╠═85b5715b-aa6b-409b-b2bc-46b2ad3e4343
# ╠═34c7ebc0-d137-4572-b68d-3c79d62592d4
# ╟─1e27cffe-c86c-4b3e-91f4-22e1b429a9cd
# ╠═65162b5e-23d0-4072-b159-6d0f4ce01a2a
