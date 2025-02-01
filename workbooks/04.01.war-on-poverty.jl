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

# ╔═╡ a1318fc7-9d20-4c00-8a89-b5ae90b5cc0c
md"### Poverty Transitions"

# ╔═╡ 7462d54c-aed5-4245-a206-f9f6641148b5
@bind reset PlutoUI.Button("Reset")

# ╔═╡ df4ccba6-6e0e-4044-94ce-b89e3c31d7ec
begin
x=reset# react to run being pressed
nruns = incr(runs)
end;

# ╔═╡ 58d7230e-36da-48e5-a445-777cddbd640b
begin
reset
@bind pps make_pluto_combined_input_fields()
end

# ╔═╡ 8cff2a32-35b5-4330-8bfe-0dc604438dba
hint(md"Try changing the withdrawal rate. A rate of 100% gives you a MIG, 0 a basic Income.")

# ╔═╡ 67813f80-f4bd-41b3-8963-937e015614c5
danger(md"Don't forget to commit your saved notebook to your repository.")

# ╔═╡ 627959cf-6a7c-4f87-82f7-406f5c7eb76a
# ╠═╡ show_logs = false
summary, data, short_summary = run_model( pps );

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
### Poverty Measures

* **Count:** before: **$(povrate1)** after: **$(povrate2)** change: **$(dpovrate)**
* **Gap:** before: **$(povgap1)** after: **$(povgap2)** change: **$(dpovgap)**
* **Severity:** before: **$(povsev1)** after: **$(povsev2)** change: **$(dpovsev)**
* **Child Poverty:** before: **$(cp1)** after: **$(cp2)** change: **$(dcp)**	 
	""" 
end

# ╔═╡ aa9d43a0-a45c-48bd-ae28-7b525be605ce
# ╠═╡ show_logs = false
begin
	t = make_pov_transitions( data )
	Show(MIME"text/html"(), t )
end

# ╔═╡ 4f94f598-8ffc-40c1-9911-bc0afad14e84
begin
	s = if pps != DEFAULT_PLUTO_INPUTS
		# ! all_defaults(pps.tax_allowance, pps.income_tax_rate, pps.uc_taper, pps.child_benefit, pps.pension)
		short_summary.response
	else
		nothing
	end
	s
end

# ╔═╡ bada072d-d79b-4bfe-a546-d5df15bf2ea1
# summary

# ╔═╡ Cell order:
# ╟─3a2a55d5-8cf8-4d5c-80a7-84a03923bba8
# ╟─72c7843c-3698-4045-9c83-2ad391097ad8
# ╟─5c5b2176-148b-4f5c-a02c-5e9e82df11c3
# ╟─d069cd4d-7afc-429f-a8fd-3f1c0a640117
# ╟─0d8df3e0-eeb9-4e61-9298-b735e9dcc284
# ╟─df4ccba6-6e0e-4044-94ce-b89e3c31d7ec
# ╠═d2188dd8-1240-4fdd-870b-dcd15e91f4f2
# ╟─2fe134f3-6d6d-4109-a2f9-faa583be1189
# ╟─a1318fc7-9d20-4c00-8a89-b5ae90b5cc0c
# ╟─aa9d43a0-a45c-48bd-ae28-7b525be605ce
# ╟─4f94f598-8ffc-40c1-9911-bc0afad14e84
# ╟─58d7230e-36da-48e5-a445-777cddbd640b
# ╟─7462d54c-aed5-4245-a206-f9f6641148b5
# ╟─8cff2a32-35b5-4330-8bfe-0dc604438dba
# ╟─67813f80-f4bd-41b3-8963-937e015614c5
# ╠═627959cf-6a7c-4f87-82f7-406f5c7eb76a
# ╟─bada072d-d79b-4bfe-a546-d5df15bf2ea1
