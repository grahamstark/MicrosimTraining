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

# ╔═╡ c093e22f-8ec2-4211-b8a0-2391101fbcd2
md"""

This a static HTML dump of a [Pluto interactive Notebook](https://plutojl.org/) I've constructed for running ScotBen for this project. here are also dumps of data as spreadsheets. 
"""

# ╔═╡ 1f2de37a-948e-4651-9276-eb39743ef812
md"""

The next block sets up changes we're making. 
The line:

```julia
settings = Settings() 
```
sets default run settings (number of households to run over, uprating targets, etc.)


"""


# ╔═╡ 35e3f85f-581b-45f2-b078-fef31b917f8d
# ╠═╡ show_logs = false
begin
	settings = Settings() 
	settings.run_name = "IT - behavioural final"
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

# ╔═╡ 2c605323-6b28-4819-9955-1276e4dac14f
md"""In the next block, the line:

```julia
sys2 = deepcopy( DEFAULT_SYS)
```

Constructs a parameter system (tax rates, benefit amounts, etc.) which is a copy of the base 25/6 fiscal system `DEFAULT_SYS`). Then the lines :

```julia
it_eq_change = 2.46
sys2.it.non_savings_rates .+= it_eq_change
```

Adds **2.46%** to each IT band. Everyting else is unchanged. This produces a net revenue gain (after mt benefits) of £2bn. It you don't care about the extra benefits paid, the change would be **£2.42%**.

Only one of the following parameter blocks should be enabled at a time. Disable button is top right in the cell.

"""

# ╔═╡ 4a96a751-19e3-4135-b9bc-7c059edaf8ad
md"### uprate council tax to 26/27"

# ╔═╡ 3de69e22-48f4-4ba1-8737-db8c6ce441bf
begin
	sys1 = deepcopy( DEFAULT_SYS_2026)
	sys2 = deepcopy( DEFAULT_SYS_2026)
end

# ╔═╡ b784075d-1967-49e8-9507-709751e62e71
begin
	for i in keys(sys1.loctax.ct.band_d)
        sys1.loctax.ct.band_d[i] *= 1.034
    end
	for i in keys(sys2.loctax.ct.band_d)
        sys2.loctax.ct.band_d[i] *= 1.034
    end
end

# ╔═╡ 9f004910-b2a3-4c63-94d6-fea4aa0cdcfb
md"### main reform"

# ╔═╡ c1f9511b-52d7-4b62-a977-2c9b109b75d6
begin
	# IT reform
	newrates = [20, 21, 22, 44, 47, 50]
	sys2.it.non_savings_rates = newrates
	sys2.it.non_savings_thresholds[3] = (40000-12570)
	weeklyise!(sys1)
	weeklyise!(sys2)
end

# ╔═╡ dc102136-d6ee-4407-8d41-203a81603db1
md"""

### (Commented Out) Examples of Local Tax Changes.

Delete the `#=` `=#` comments to activate.

"""

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

# ╔═╡ f3caa4e8-3af1-4f1b-aaf2-59e10b2dfbf6
begin
	save_taxable_graph( settings, data, summary, [sys1,sys2] )
end

# ╔═╡ af045f77-ca59-44c1-b968-94dbd60ebe40
zipname

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

# ╔═╡ 8ba72e41-19b5-4f0d-a6b2-d4a27c401607
Show( MIME"text/html"(), format_sfc("SFC Behavioral Corrections",
data.behavioural_results[2]))

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
	t = make_pov_transitions( data )
	Show(MIME"text/html"(), t )
end

# ╔═╡ ff5c2f9a-9616-4791-8da6-79327e9592ce
md"""
## Higher Rates Effects Table - setting rates to zero
"""

# ╔═╡ fa12ec1f-4969-43d9-b5b4-b1c83f92ce9a
# ╠═╡ show_logs = false
inc_compare = begin
    hrt, tpretty, systems, shortsum = do_higher_rates_run2(settings, sys1, sys2)
    tpretty
end


# ╔═╡ d302dc5e-9005-4719-b325-143552b3e4d7
begin
    using CSV, DataFrames
	# Use the same output folder created by `fes_run`
    filepath = joinpath(zipname, "highratestozero.csv")
    CSV.write(filepath, inc_compare)

end

# ╔═╡ f02cf689-8a09-4685-adfa-e118b56f47e7
begin 
	
# =============================================================================
# Result structures
# =============================================================================

struct BehaviouralResult
    band_label::String
    tie_rate::Union{Float64, Missing}
    aetr_rate::Union{Float64, Missing}
    n_taxpayers::Float64  # Changed to Float64 to handle weighted counts
    static_baseline::Float64
    static_reform::Float64
    static_change::Float64
    change_intensive::Float64
    change_extensive::Float64
    total_behavioural::Float64
    sfc_change::Float64
    behavioural_offset_pct::Float64
end

"""
Convert BehaviouralResult structs to a formatted DataFrame
"""
function to_dataframe(br::Vector{BehaviouralResult})::DataFrame
    n = length(br)
    df = DataFrame(
        band_label = [r.band_label for r in br],
        tie_rate = [ismissing(r.tie_rate) ? "" : Format.format(r.tie_rate; precision=2) for r in br],
        aetr_rate = [ismissing(r.aetr_rate) ? "" : Format.format(r.aetr_rate; precision=2) for r in br],
        n_taxpayers = [round(Int, r.n_taxpayers) for r in br],
        static_baseline = [r.static_baseline * WEEKS_PER_YEAR for r in br],
        static_reform = [r.static_reform * WEEKS_PER_YEAR for r in br],
        static_change = [r.static_change * WEEKS_PER_YEAR for r in br],
        change_intensive = [r.change_intensive * WEEKS_PER_YEAR for r in br],
        change_extensive = [r.change_extensive * WEEKS_PER_YEAR for r in br],
        total_behavioural = [r.total_behavioural * WEEKS_PER_YEAR for r in br],
        sfc_change = [r.sfc_change * WEEKS_PER_YEAR for r in br],
        behavioural_offset_pct = [r.behavioural_offset_pct for r in br]
    )
    return df
end

# =============================================================================
# Constants - SFC methodology parameters
# =============================================================================

TIE_RATES = [0.015, 0.10, 0.20, 0.35, 0.55, 0.75]
PERSONAL_ALLOWANCE = 12_570.0

TIE_EDGES = [
    0.0,
    50_270.0 - PERSONAL_ALLOWANCE,
    80_000.0 - PERSONAL_ALLOWANCE,
    150_000.0,
    300_000.0,
    500_000.0,
    Inf
] ./ WEEKS_PER_YEAR

TIE_BAND_LABELS = [
    "£0 - £57,270",
    "£57,271 - £80,000",
    "£80,001 - £150,000",
    "£150,001 - £300,000",
    "£300,001 - £500,000",
    "£500,000+"
]

AETR_RATES = [0.00, 0.06, 0.06, 0.25, 0.25, 0.25]
AETR_EDGES = copy(TIE_EDGES)

# =============================================================================
# Helper functions
# =============================================================================

"""
Aggregate taxable income and counts by income group thresholds
"""
function grouping_stats(taxable_income, group_thresholds, weights)
    income_totals = zeros(length(group_thresholds))
    counts = zeros(length(group_thresholds))
    
    for i in 1:length(taxable_income)
        group_idx = findlast(threshold -> taxable_income[i] >= threshold, group_thresholds)
        if !isnothing(group_idx)
            income_totals[group_idx] += taxable_income[i] * weights[i]
            counts[group_idx] += weights[i]
        end
    end
    
    return income_totals, counts
end

"""
Get marginal tax rates for each group threshold
"""
function get_marginal_rates(group_thresholds, tax_rates, tax_thresholds)
    marginal_rates = zeros(length(group_thresholds))
    
    for i in 1:length(group_thresholds)
        band_idx = findlast(threshold -> group_thresholds[i] >= threshold, tax_thresholds)
        
        if isnothing(band_idx)
            marginal_rates[i] = tax_rates[1]
        else
            marginal_rates[i] = tax_rates[band_idx + 1]
        end
    end
    
    return marginal_rates
end

"""
Get TIE or AETR rates for each group threshold
"""
function get_TIE_rates(group_thresholds, rates, edges)
    rate_groupings = zeros(length(group_thresholds))
    
    for i in 1:length(group_thresholds)
        band_idx = findlast(edge -> group_thresholds[i] >= edge, edges)
        
        if isnothing(band_idx)
            rate_groupings[i] = rates[1]
        elseif band_idx > length(rates)
            # Above highest rate band - use top rate
            rate_groupings[i] = rates[end]
        else
            rate_groupings[i] = rates[band_idx]
        end
    end
    
    return rate_groupings
end

"""
Get the tax threshold immediately at or below each group threshold
"""
function get_lower_thresholds(group_thresholds, tax_thresholds)
    lower_thresholds = zeros(length(group_thresholds))
    
    for i in 1:length(group_thresholds)
        idx = findlast(threshold -> threshold <= group_thresholds[i], tax_thresholds)
        
        if isnothing(idx)
            lower_thresholds[i] = 0.0
        else
            lower_thresholds[i] = tax_thresholds[idx]
        end
    end
    
    return lower_thresholds
end

"""
Aggregate grouped results by TIE bands
"""
function aggregate_by_TIE_bands(groups, grouping_count, tax_baseline_grouped, tax_reform_grouped,
                                 intensive_change, extensive_change, TIE_groupings, AETR_groupings)
    results = BehaviouralResult[]
    
    # Totals for summary row
    total_n = 0.0
    total_baseline = 0.0
    total_reform = 0.0
    total_static = 0.0
    total_intensive = 0.0
    total_extensive = 0.0
    
    # Process each TIE band
    for band_idx in 1:length(TIE_RATES)
        # Find all groups that fall in this TIE band
        mask = TIE_groupings .== TIE_RATES[band_idx]
        
        if !any(mask)
            # Empty band
            push!(results, BehaviouralResult(
                TIE_BAND_LABELS[band_idx],
                TIE_RATES[band_idx],
                AETR_RATES[band_idx],
                0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
            ))
            continue
        end
        
        # Sum across all groups in this band
        band_n = sum(grouping_count[mask])
        band_baseline = sum(tax_baseline_grouped[mask])
        band_reform = sum(tax_reform_grouped[mask])
        band_static = band_reform - band_baseline
        band_intensive = sum(intensive_change[mask])
        band_extensive = sum(extensive_change[mask])
        band_total_behav = band_intensive + band_extensive
        band_sfc = band_static + band_total_behav
        band_offset_pct = band_static != 0.0 ? (-band_total_behav / band_static) * 100.0 : 0.0
        
        push!(results, BehaviouralResult(
            TIE_BAND_LABELS[band_idx],
            TIE_RATES[band_idx],
            AETR_RATES[band_idx],
            band_n,
            band_baseline,
            band_reform,
            band_static,
            band_intensive,
            band_extensive,
            band_total_behav,
            band_sfc,
            band_offset_pct
        ))
        
        # Accumulate totals
        total_n += band_n
        total_baseline += band_baseline
        total_reform += band_reform
        total_static += band_static
        total_intensive += band_intensive
        total_extensive += band_extensive
    end
    
    # Add TOTAL row
    total_behavioural = total_intensive + total_extensive
    total_sfc = total_static + total_behavioural
    total_offset_pct = total_static != 0.0 ? (-total_behavioural / total_static) * 100.0 : 0.0
    
    push!(results, BehaviouralResult(
        "TOTAL",
        missing,
        missing,
        total_n,
        total_baseline,
        total_reform,
        total_static,
        total_intensive,
        total_extensive,
        total_behavioural,
        total_sfc,
        total_offset_pct
    ))
    
    return results
end

# =============================================================================
# Main calculation function
# =============================================================================

function calc_behavioural_response2(
    df_baseline::DataFrame,
    df_reform::DataFrame,
    sys_baseline::TaxBenefitSystem,
    sys_reform::TaxBenefitSystem)::AbstractDataFrame

    # Extract individual-level data
    taxable_baseline = df_baseline.it_non_savings_taxable
    taxable_reform = df_reform.it_non_savings_taxable
    tax_baseline = df_baseline.scottish_income_tax
    tax_reform = df_reform.scottish_income_tax
    weights = df_baseline.weight
    
    # Define income groups combining TIE bands and IT thresholds
    groups = sort(unique(vcat(
        TIE_EDGES, 
        sys_baseline.it.non_savings_thresholds, 
        sys_reform.it.non_savings_thresholds
    )))
    
    # Aggregate to group level
    taxable_by_group, grouping_count = grouping_stats(taxable_baseline, groups, weights)
    
    # Group tax revenue - need to aggregate individual tax payments
    tax_baseline_grouped = zeros(length(groups))
    tax_reform_grouped = zeros(length(groups))
    for i in 1:length(taxable_baseline)
        group_idx = findlast(threshold -> taxable_baseline[i] >= threshold, groups)
        if !isnothing(group_idx)
            tax_baseline_grouped[group_idx] += tax_baseline[i] * weights[i]
            tax_reform_grouped[group_idx] += tax_reform[i] * weights[i]
        end
    end
    
    # National Insurance marginal rates
    NI_UPPER_EARNINGS_LIMIT = (50_270.0 - PERSONAL_ALLOWANCE) / WEEKS_PER_YEAR
    NI_marginal = ifelse.(groups .< NI_UPPER_EARNINGS_LIMIT, 0.08, 0.02)
    
    # Income tax marginal rates
    mtr_baseline = get_marginal_rates(groups, sys_baseline.it.non_savings_rates, 
                                      sys_baseline.it.non_savings_thresholds)
    mtr_reform = get_marginal_rates(groups, sys_reform.it.non_savings_rates, 
                                    sys_reform.it.non_savings_thresholds)
    
    # Marginal retention rates and their percentage change
    mrr_baseline = @. 1.0 - mtr_baseline - NI_marginal
    mrr_reform = @. 1.0 - mtr_reform - NI_marginal
    mrr_change = @. ifelse(mrr_baseline == 0.0, 0.0, mrr_reform / mrr_baseline - 1.0)
    
    # Taxable Income Elasticities
    TIE_groupings = get_TIE_rates(groups, TIE_RATES, TIE_EDGES)
    
    # INTENSIVE MARGIN: Change in taxable income and revenue impact
    taxable_change = mrr_change .* TIE_groupings .* taxable_by_group
    intensive_change = taxable_change .* mtr_reform
    
    # EXTENSIVE MARGIN: Average effective tax rate changes
    lower_thresholds_reform = get_lower_thresholds(groups, sys_reform.it.non_savings_thresholds)
    
	ind_AETR_change = [
	    calctaxdue(
	        taxable = t,
	        rates = sys_baseline.it.non_savings_rates,
	        thresholds = sys_baseline.it.non_savings_thresholds
	    ).due - calctaxdue(
	        taxable = t,
	        rates = sys_reform.it.non_savings_rates,
	        thresholds = sys_reform.it.non_savings_thresholds
	    ).due
	    for t in lower_thresholds_reform
	]
    
    AETR_groupings = get_TIE_rates(groups, AETR_RATES, AETR_EDGES)
    extensive_change = grouping_count .* ind_AETR_change .* AETR_groupings
    
    # Aggregate results by TIE bands
    results = aggregate_by_TIE_bands(
        groups, grouping_count, tax_baseline_grouped, tax_reform_grouped,
        intensive_change, extensive_change, TIE_groupings, AETR_groupings
    )
    
    return to_dataframe(results)
end
end

# ╔═╡ f0de5570-e103-4777-bf93-61fab27ef6f5
begin 
	html_content = format_sfc(
    "SFC Behavioral Corrections",
    calc_behavioural_response2(
        data.income[1],
        data.income[2],
        sys1,
        sys2
	    )
	)
	
	# Create filepath using your existing zipname folder
	filepathsfc = joinpath(zipname, "sfc_behavioral_corrections.html")
	
	open(filepathsfc, "w") do io
	    write(io, html_content)
	end

	println("File saved to: ", filepathsfc)
end

# ╔═╡ 7072e6e6-2ca5-4c51-ac1e-2c71c93cd023
Show( MIME"text/html"(), format_sfc("SFC Behavioral Corrections",
calc_behavioural_response2(data.income[1],
						  data.income[2],
						  sys1,
						  sys2)))

# ╔═╡ d9ff67a4-4c97-4e04-9d9d-dc844dca38f1
typeof(format_sfc("SFC Behavioral Corrections",
calc_behavioural_response2(data.income[1],
						  data.income[2],
						  sys1,
						  sys2)))

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
# ╟─c093e22f-8ec2-4211-b8a0-2391101fbcd2
# ╟─1f2de37a-948e-4651-9276-eb39743ef812
# ╠═35e3f85f-581b-45f2-b078-fef31b917f8d
# ╟─2c605323-6b28-4819-9955-1276e4dac14f
# ╟─4a96a751-19e3-4135-b9bc-7c059edaf8ad
# ╠═3de69e22-48f4-4ba1-8737-db8c6ce441bf
# ╠═b784075d-1967-49e8-9507-709751e62e71
# ╟─9f004910-b2a3-4c63-94d6-fea4aa0cdcfb
# ╠═c1f9511b-52d7-4b62-a977-2c9b109b75d6
# ╟─dc102136-d6ee-4407-8d41-203a81603db1
# ╟─696c6862-1c2b-4d40-a941-44bcbc94e9e2
# ╠═627959cf-6a7c-4f87-82f7-406f5c7eb76a
# ╟─da8d10ef-0ccf-40b9-901c-7214327e0203
# ╟─6a57627d-e592-4845-af8a-60d1db327fab
# ╟─1516e738-7adb-4cb5-9fac-e983ce5d17bd
# ╟─d2188dd8-1240-4fdd-870b-dcd15e91f4f2
# ╟─d069cd4d-7afc-429f-a8fd-3f1c0a640117
# ╠═f3caa4e8-3af1-4f1b-aaf2-59e10b2dfbf6
# ╠═af045f77-ca59-44c1-b968-94dbd60ebe40
# ╟─0d8df3e0-eeb9-4e61-9298-b735e9dcc284
# ╠═8ba72e41-19b5-4f0d-a6b2-d4a27c401607
# ╠═f0de5570-e103-4777-bf93-61fab27ef6f5
# ╠═7072e6e6-2ca5-4c51-ac1e-2c71c93cd023
# ╠═d9ff67a4-4c97-4e04-9d9d-dc844dca38f1
# ╠═f02cf689-8a09-4685-adfa-e118b56f47e7
# ╟─2fe134f3-6d6d-4109-a2f9-faa583be1189
# ╟─f750ca33-d975-4f05-b878-ad0b23f968a9
# ╠═e6816e6d-660c-46ee-b90b-d07b29dac1ad
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
# ╟─d302dc5e-9005-4719-b325-143552b3e4d7
# ╟─a1bbc2ae-68a2-40de-93a4-2c9a68c9ee91
# ╟─feed5169-225f-4e95-b279-403dff21539d
# ╟─1bad315e-d9ff-4c7b-9282-b5627deea6df
# ╠═6bf8bfc0-1221-4055-9c65-ea9b04802321
# ╟─f1ed5325-1d96-4693-8a2a-64951a04c0ef
# ╠═4ed19478-f0bd-4579-87ff-dce95737d60d
# ╠═1f054554-f7c4-478e-906b-ce57f451ce6d
# ╟─c123f000-bcd6-4a37-b715-759473365b60
# ╟─1f7d6f70-0bc3-48ee-ba87-e25f6ba4b907
# ╟─477c0dc2-9141-49a2-a4c8-fdab84ea586c
# ╟─8c2c6e7c-53fa-4604-b5dd-85782443ffca
# ╟─4718dd2b-9c0f-4c15-b249-52deffee46b6
# ╠═6691e0c2-a440-4f24-855a-6c0c3d746b2e
# ╟─6c308ebe-ca45-4774-81cc-bfafc46ba2a4
# ╠═758496fe-edae-4a3a-9d04-5c09362ec037
# ╟─34c7ebc0-d137-4572-b68d-3c79d62592d4
# ╟─1e27cffe-c86c-4b3e-91f4-22e1b429a9cd
# ╠═65162b5e-23d0-4072-b159-6d0f4ce01a2a
