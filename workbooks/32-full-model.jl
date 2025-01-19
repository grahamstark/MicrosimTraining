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
using MicrosimTraining
# initialise parameters - 2024 system, annual and pre-weeklyised system

settings = Settings()
settings.num_households, settings.num_people = 
	FRSHouseholdGetter.initialise( settings; reset=false )

const default_tax_allowance = 12_570.0
const default_income_tax_rate = 20.0
const default_uc_taper = 55.0
const default_child_benefit = 25.60
const default_pension = 221.20

function all_defaults(tax_allowance, income_tax_rate, uc_taper, child_benefit, pension)::Bool
	return (default_tax_allowance == tax_allowance) &&
		(default_income_tax_rate == income_tax_rate) &&
		(default_uc_taper == uc_taper) &&
		(default_child_benefit == child_benefit) &&
		(default_pension == pension)
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
The Government of Unicoria has pledged to reduce the headcount measure of poverty by 3 percentage points. Your task is to design a policy package that delivers this in the most effective way possible. The economy is doing well, and net extra spending of up to £4 billion has been agreed.
* *cost* any costs above £4bn will have to be raised from somewhere;
* *targetting vs. incentives*: well targetted benefit increases may force poor people into poverty traps, whilst more widely spread increases may require tax increases to keep within budget; 
* *alternative measures of poverty* have you cheated at all, and reduced poverty headcounts by concentrating on the near-poor, perhaps through increasing in-work benefits? (You may need to do this in order to meet the political objectives)
    """
end 

# ╔═╡ 4aa314f2-3415-4482-a042-d4c7ebd1cb21
begin
function make_inps()
	return PlutoUI.combine() do Child
		inputs = [
md"""
Tax Allowance: $(
Child( "tax_allowance", NumberField(0:10:25000,default=12_570)))(£p.a.; *default £12,570*)
""",
md"""
Income Tax Rate: $(Child("income_tax_rate", NumberField(0:1:100,default=20))) (%; *default 20*)
""",
md"""
Benefit Withdrawal Rate: $(Child("uc_taper", NumberField(0:1:100,default=55))) (%; *default 55*)
""",
md"""
Child Benefit: $(Child("child_benefit", NumberField(0:0.01:100,default=25.60))) (£s pw; *default £25.60p*)
""",
md"""
Pension: $(Child("pension", NumberField(0:0.01:500,default=221.20))) (£s pw; *default £221.20p*)
"""]

md"""
## Taxes and Benefits
$(inputs)
"""
end
	
end # func
		
end


# ╔═╡ 58d7230e-36da-48e5-a445-777cddbd640b
@bind pps make_inps()

# ╔═╡ 627959cf-6a7c-4f87-82f7-406f5c7eb76a
# ╠═╡ show_logs = false
summary, data, short_summary = run_model( pps, settings );

# ╔═╡ 4f94f598-8ffc-40c1-9911-bc0afad14e84
begin
	s = if ! all_defaults(pps.tax_allowance, pps.income_tax_rate, pps.uc_taper, pps.child_benefit, pps.pension)
		short_summary.response
	else
		""
	end
	s
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

# ╔═╡ 54f33d47-2105-4e8c-a79a-77753fa7bcdd
pps

# ╔═╡ a1318fc7-9d20-4c00-8a89-b5ae90b5cc0c
md"## Poverty Transitions"

# ╔═╡ aa9d43a0-a45c-48bd-ae28-7b525be605ce
# ╠═╡ show_logs = false
begin
	t = make_pov_transitions( data )
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
# ╟─72c7843c-3698-4045-9c83-2ad391097ad8
# ╟─5c5b2176-148b-4f5c-a02c-5e9e82df11c3
# ╟─58d7230e-36da-48e5-a445-777cddbd640b
# ╟─4aa314f2-3415-4482-a042-d4c7ebd1cb21
# ╠═4f94f598-8ffc-40c1-9911-bc0afad14e84
# ╟─d069cd4d-7afc-429f-a8fd-3f1c0a640117
# ╟─d2188dd8-1240-4fdd-870b-dcd15e91f4f2
# ╟─2fe134f3-6d6d-4109-a2f9-faa583be1189
# ╠═627959cf-6a7c-4f87-82f7-406f5c7eb76a
# ╠═54f33d47-2105-4e8c-a79a-77753fa7bcdd
# ╟─a1318fc7-9d20-4c00-8a89-b5ae90b5cc0c
# ╟─aa9d43a0-a45c-48bd-ae28-7b525be605ce
# ╟─8cff2a32-35b5-4330-8bfe-0dc604438dba
# ╟─67813f80-f4bd-41b3-8963-937e015614c5
# ╟─bada072d-d79b-4bfe-a546-d5df15bf2ea1
