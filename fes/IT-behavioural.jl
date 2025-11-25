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

# ╔═╡ 1a1c900a-b65c-4a17-b181-da41883be44f
begin
	sys2 = deepcopy( DEFAULT_SYS)	

	
	#=
	settings.run_name = "Net £2bn raised with equal increases in all IT rates ($(it_eq_change)pct)."
	sys2.it.non_savings_rates .+= it_eq_change
	=#
	
    settings.run_name = "Behavioural test"

	newrates = [20,22,22,43,47,50]
	
	sys2.it.non_savings_rates = newrates
	sys2.it.non_savings_thresholds[3] = (40000-12570)

	sys2.name = settings.run_name
	weeklyise!(sys2)
end;


# ╔═╡ 696c6862-1c2b-4d40-a941-44bcbc94e9e2
md"""

The next line runs the model every time one of the blocks above changes. 

"""

# ╔═╡ e08cc570-0d5e-4be7-9038-2e02e3293bc1
DEFAULT_SYS.it

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

# ╔═╡ f750ca33-d975-4f05-b878-ad0b23f968a9
md"""
### Incomes Summary
"""

# ╔═╡ e6816e6d-660c-46ee-b90b-d07b29dac1ad
Show(MIME"text/html"(), MicrosimTraining.costs_table( summary.income_summary[1],
        summary.income_summary[2]))

# ╔═╡ a430c919-98c7-4bfe-89db-445860c62fd0
md"""

### Behavioural adjustment - test

"""

# ╔═╡ 86053509-1446-41a8-9169-23d5a802f6ca
# --- Behavioural response parameters (SFC-style) -------------------------

begin
const TIE_RATES = [0.015, 0.10, 0.20, 0.35, 0.55, 0.75]

const PERSONAL_ALLOWANCE = 12_570.0

# taxable (post-allowance) thresholds, 2025/26 equivalents
const TIE_EDGES = [
    0.0, # gks this treats all the 0.15 group as on (groups 1-4 in spreadsheet)
    50_270.0 - PERSONAL_ALLOWANCE,
    80_000.0 - PERSONAL_ALLOWANCE,
    150_000.0, # because PA withdrawn by now
    300_000.0,
    500_000.0,
    Inf
] # these could be adjusted by inflation... currently same thresholds as 2018/19 paper 


const AETR_RATES = [0.00, 0.06, 0.06, 0.25, 0.25, 0.25]
const AETR_EDGES = copy(TIE_EDGES)

	
const NIC_BREAK_ANNUAL = 37_700.0   # 50_270 - 12_570; check against current system
const NIC_RATE_LOW     = 0.08
const NIC_RATE_HIGH    = 0.02

# --- Helpers -------------------------------------------------------------

"""
    band_value(x, edges, vals)

Return the value in `vals` corresponding to the band that `x` falls into,
where `edges` are monotonically increasing band edges with
length(edges) == length(vals) + 1.
"""
function band_value(x::Real, edges::AbstractVector{<:Real}, vals::AbstractVector{<:Real})
    @assert length(edges) == length(vals) + 1
    for i in 1:length(vals)
        if edges[i] <= x < edges[i+1]
            return vals[i]
        end
    end
    return vals[end]
end

band_value_vec(xs::AbstractVector, edges, vals) =
    [band_value(x, edges, vals) for x in xs]

"""
    marginal_it_rate(annual_taxable, thresholds, rates)

Compute marginal non-savings income tax rate for a given annual taxable income,
given the system thresholds and rates (percent).
Assumes thresholds are band tops, same length as rates, increasing.
"""

function marginal_it_rate(x::Real,
                          thresholds::AbstractVector{<:Real},
                          rates::AbstractVector{<:Real})
    @assert length(rates) == length(thresholds) + 1

    # Band 1: income below first threshold
    if x < thresholds[1]
        return rates[1]
    end

    # Intermediate bands
    for i in 2:length(thresholds)
        if x < thresholds[i]
            return rates[i]
        end
    end

    # Top band: income >= last threshold
    return rates[end]
end
	
marginal_it_rate_vec(xs::AbstractVector,
                     thresholds::AbstractVector,
                     rates::AbstractVector) =
    [marginal_it_rate(x, thresholds, rates) for x in xs]

function marginal_it_thres(x::Real,
                           thresholds::AbstractVector{<:Real},
                           rates::AbstractVector{<:Real})
    @assert length(rates) == length(thresholds) + 1

    # iterate backwards: start from the top band
    for i in length(thresholds):-1:1
        if x > thresholds[i]
            return thresholds[i]
        end
    end

    # if income below first threshold, lower edge is 0
    return 0.0
end

marginal_it_thres_vec(xs::AbstractVector,
                     thresholds::AbstractVector,
                     rates::AbstractVector) =
    [marginal_it_thres(x, thresholds, rates) for x in xs]
	
# --- Main function -------------------------------------------------------

"""
    behavioural_it_loss(data, systems; sys_baseline=1, sys_reform=2)

Compute aggregate income tax lost due to behavioural responses (intensive + extensive)
following an SFC-style TIE/AETR approach, using the microsimulation results
for two systems.

Returns a NamedTuple with:
  - :static_baseline
  - :static_reform
  - :loss_marginal
  - :loss_extensive
  - :loss_total
  - :adjusted_reform
"""
function behavioural_it_loss(data ;
                             sys_baseline::Int = 1,
                             sys_reform::Int   = 2)

    df_b = data.income[sys_baseline]
    df_r = data.income[sys_reform]

    taxable_b_week = df_b.it_non_savings_taxable
    taxable_r_week = df_r.it_non_savings_taxable  
    weight         = df_b.weight
    it_b_week      = df_b.scottish_income_tax
    it_r_week      = df_r.scottish_income_tax

    # Convert taxable base to annual
    taxable_b = 52.0 .* taxable_b_week
    taxable_r = 52.0 .* taxable_r_week
	it_b      = 52.0 .* it_b_week
	it_r      = 52.0 .* it_r_week

    # NIC marginal rate as a function of annual taxable (approximation. ignores Self-Employment difference, and NI specific rules)
    nic_rate = ifelse.(taxable_b .< NIC_BREAK_ANNUAL, NIC_RATE_LOW, NIC_RATE_HIGH)

	#!! same as sys_b = sys1; sys_r = sys2
    # Marginal IT rates under baseline and reform
    sys_b = eval(Meta.parse("sys$(sys_baseline)"))
    sys_r = eval(Meta.parse("sys$(sys_reform)"))

    mtr_b = marginal_it_rate_vec(taxable_b,
                                 sys_b.it.non_savings_thresholds,
                                 sys_b.it.non_savings_rates)

    mtr_r = marginal_it_rate_vec(taxable_r,
                                 sys_r.it.non_savings_thresholds,
                                 sys_r.it.non_savings_rates)
	
	thres_b = marginal_it_thres_vec(taxable_b,
                                 sys_b.it.non_savings_thresholds,
                                 sys_b.it.non_savings_rates)
	
	thres_r = marginal_it_thres_vec(taxable_r,
                                 sys_r.it.non_savings_thresholds,
                                 sys_r.it.non_savings_rates)

    # Marginal retention rates
    mrr_b = 1 .- mtr_b .- nic_rate
    mrr_r = 1 .- mtr_r .- nic_rate

    # Avoid divide-by-zero where mrr_b == 0
    mrr_change = similar(mrr_b)
    for i in eachindex(mrr_b)
        mrr_change[i] = mrr_b[i] == 0 ? 0.0 : (mrr_r[i] / mrr_b[i] - 1.0)
    end

    # TIE by baseline annual taxable income
    tie = band_value_vec(taxable_b, TIE_EDGES, TIE_RATES)

    # % change and level change in taxable income (annual)
    pct_change_taxable = tie .* mrr_change
    dif_taxable        = pct_change_taxable .* taxable_b

    # Behavioural loss on intensive (marginal) margin 
    behav_itchange_marginal = dif_taxable .* mtr_r    

    # Used in Average sec. Total change in IT liability (assumed annual amounts)
    total_it_dif = it_r .- it_b #positive if you pay more tax

    # Non-marginal component of liability change
	marginal_dif     = (mtr_r - mtr_b) .* (taxable_r - max.(thres_r, thres_b)) #positive if you pay more tax
	non_marginal_dif = total_it_dif .- marginal_dif # postive if you pay more tax

    # AETR by baseline taxable income
    aetr = band_value_vec(taxable_b, AETR_EDGES, AETR_RATES)

    # Extensive-margin change
    behav_itchange_extensive = - non_marginal_dif .* aetr #negative if you pay more tax

    # Aggregate with weights
    total_change_marginal  = sum(behav_itchange_marginal  .* weight)
    total_change_extensive = sum(behav_itchange_extensive .* weight)
    total_change_behav     = total_change_marginal + total_change_extensive

    # Static aggregates (no behaviour) – from micro-data rather than short_summary.
    static_baseline = sum(it_b .* weight)
    static_reform   = sum(it_r .* weight)
    static_change   = static_reform - static_baseline
	
    adjusted_reform = static_reform + total_change_behav
	adjusted_change = adjusted_reform - static_baseline

    return (
        static_baseline         = static_baseline,
        static_reform           = static_reform,
		static_change           = static_change,
        change_marginal         = total_change_marginal,
        change_extensive        = total_change_extensive,
        total_change_behav      = total_change_behav,
        adjusted_reform         = adjusted_reform,
		adjusted_change         = adjusted_change
    )
end
end
# The totals don't match the above. Even the ones that just multiplied the Scottish IT value from the data.income table and the weights. Unsure why. Unsure how to QA the behavioural stuff also. Numbers seems reasonable but on the smaller side.

# ╔═╡ fcf1642f-39d7-41d1-8816-a5f737477d2f
behavioural_it_loss(data)

# ╔═╡ 3c2298d5-07d4-482e-ba37-c4003999e1cb
DataFrame(
    :Metric => collect(keys(behavioural_it_loss(data))),
    Symbol("Value £ Million") => round.(collect(values(behavioural_it_loss(data))) ./ 1e6, digits=1)
)

# ╔═╡ 4b8f4734-f980-4b4e-bae0-e379eb20b0a0
    mtr_b = marginal_it_rate_vec(data.income[1].it_non_savings_taxable,
                                 sys2.it.non_savings_thresholds,
                                 sys2.it.non_savings_rates)

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
# ╟─72c7843c-3698-4045-9c83-2ad391097ad8
# ╟─c093e22f-8ec2-4211-b8a0-2391101fbcd2
# ╟─1f2de37a-948e-4651-9276-eb39743ef812
# ╠═35e3f85f-581b-45f2-b078-fef31b917f8d
# ╠═1a1c900a-b65c-4a17-b181-da41883be44f
# ╟─696c6862-1c2b-4d40-a941-44bcbc94e9e2
# ╠═e08cc570-0d5e-4be7-9038-2e02e3293bc1
# ╠═627959cf-6a7c-4f87-82f7-406f5c7eb76a
# ╟─da8d10ef-0ccf-40b9-901c-7214327e0203
# ╟─6a57627d-e592-4845-af8a-60d1db327fab
# ╟─1516e738-7adb-4cb5-9fac-e983ce5d17bd
# ╟─d2188dd8-1240-4fdd-870b-dcd15e91f4f2
# ╟─d069cd4d-7afc-429f-a8fd-3f1c0a640117
# ╟─f750ca33-d975-4f05-b878-ad0b23f968a9
# ╠═e6816e6d-660c-46ee-b90b-d07b29dac1ad
# ╟─a430c919-98c7-4bfe-89db-445860c62fd0
# ╠═86053509-1446-41a8-9169-23d5a802f6ca
# ╠═fcf1642f-39d7-41d1-8816-a5f737477d2f
# ╠═3c2298d5-07d4-482e-ba37-c4003999e1cb
# ╠═4b8f4734-f980-4b4e-bae0-e379eb20b0a0
# ╠═a1bbc2ae-68a2-40de-93a4-2c9a68c9ee91
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
