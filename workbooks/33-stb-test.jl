### A Pluto.jl notebook ###
# v0.20.4

using Markdown
using InteractiveUtils

# ╔═╡ eeae2700-a78e-11ef-34c9-b3f7c1a464cb
begin
	import Pkg
    # activate the shared project environment
    Pkg.activate(Base.current_project())
    # instantiate, i.e. make sure that all packages are downloaded
	# Pkg.resolve()
    # Pkg.instantiate()
	using MicrosimTraining
end

# ╔═╡ 9a7d1afd-52a9-48f0-8a95-af9145dea90b
begin
	using ScottishTaxBenefitModel.ModelHousehold
	using ScottishTaxBenefitModel.FRSHouseholdGetter
	using ScottishTaxBenefitModel.RunSettings
	using ScottishTaxBenefitModel.Definitions
	using ScottishTaxBenefitModel.STBParameters
	using ScottishTaxBenefitModel.STBIncomes
	using ScottishTaxBenefitModel.Definitions
	using ScottishTaxBenefitModel.GeneralTaxComponents
	using ScottishTaxBenefitModel.SingleHouseholdCalculations
	using ScottishTaxBenefitModel.Utils
	using ScottishTaxBenefitModel.Runner
	using ScottishTaxBenefitModel.BCCalcs
	using ScottishTaxBenefitModel.ExampleHelpers
	using ScottishTaxBenefitModel.Monitor: Progress
end

# ╔═╡ 981ac366-edc0-416b-b8ff-3588f1fca3a3
begin
	settings = Settings()
	settings.requested_threads = 4
	FRSHouseholdGetter.initialise( settings )
	# ExampleHouseholdGetter.KEYMAP # 
	BASE = get_default_system_for_fin_year( 2024; scotland=true, autoweekly = true )
	AN_BASE = get_default_system_for_fin_year( 2024; scotland=true, autoweekly = false )
end;

# ╔═╡ 92dd4f04-932e-47cc-a916-9c8c10f44cbd
begin
	run_progress = Observable( Progress(settings.uuid,"",0,0,0,0))
	
	running_total = 0
	phase = "Not Running"
	size = 1
	
	function obs_processor( progress::Progress )
		global running_total, phase, size
		size = progress.size
	    running_total += progress.step
		phase = progress.phase
		# showp( pct )
	end 
	
	observer_function = on( obs_processor, run_progress )
	
	sys2 = deepcopy(AN_BASE)
	weeklyise!( sys2 )
	sys = [BASE, sys2]
	# tot = 0
	@use_task([settings, sys, run_progress]) do
		results = do_one_run( settings, sys, run_progress )
	end
end;

# ╔═╡ 97a7dda6-d9e9-411b-a968-e27556068b66
begin
		pct = Int(trunc(100*running_total/size))
		println( run_progress )
		t = 
		if (pct >= 100)||(pct<=0)
			"<p><b>0!!!$pct</b></p>"
		else
 """
<table width='100%' style='border:0'>
<tr><td width="100%" style='background:#66aaff; color:white' colspan='2'>$(phase)</td></tr>
<tr><td style='background:#3366aa; color:white'>$pct%&nbsp;Done</td><td style='background:#ffcc33'></td></tr>
</table>
 """
		end
		Show(MIME"text/html"(), t )
end

# ╔═╡ 324a71e5-4416-4de6-a469-cab328aadebe
almost(
    md"You're right that the answer is a positive number, but the value isn't quite right."
)

# ╔═╡ 3e1f5775-ecd4-4e45-89a4-4027b132d1ce
begin
N=90
if N == 100_000
	correct()
else
	keep_working()
end
end

# ╔═╡ 2fbac8f8-3ced-40e6-81b2-6a0b581bcd75
danger(md"Don't forget to commit your saved notebook to your repository.")

# ╔═╡ 74645ef7-8ce3-41fc-95e5-cfdb48f9903f
hint(md"It may be useful to make use of the identity $\sin \theta^2 + \cos \theta^2 =1$.")

# ╔═╡ 4e1616f9-90f1-4079-bdcf-54cab3aa928e
blockquote(
    "Logic will get you from A to B.  Imagination will take you everywhere.",
    md"-- A. Einstein",
)

# ╔═╡ e435bad3-3208-4cef-9ab3-feb50461a10c
Foldable("Want more?", md"Extra info")

# ╔═╡ f530f068-acc2-4a21-a309-427f00009cf0
answer_box(
	md"""
    The stone has a greater force becasue force is given by Newtons 2nd law: 

    ```math
    F=m \times a
    ```

    It has a greater mass, therefore $m$ is larger. This then results in a larger force $F$
    """
)

# ╔═╡ Cell order:
# ╠═eeae2700-a78e-11ef-34c9-b3f7c1a464cb
# ╠═9a7d1afd-52a9-48f0-8a95-af9145dea90b
# ╠═981ac366-edc0-416b-b8ff-3588f1fca3a3
# ╟─92dd4f04-932e-47cc-a916-9c8c10f44cbd
# ╠═97a7dda6-d9e9-411b-a968-e27556068b66
# ╟─324a71e5-4416-4de6-a469-cab328aadebe
# ╠═3e1f5775-ecd4-4e45-89a4-4027b132d1ce
# ╟─2fbac8f8-3ced-40e6-81b2-6a0b581bcd75
# ╟─74645ef7-8ce3-41fc-95e5-cfdb48f9903f
# ╟─4e1616f9-90f1-4079-bdcf-54cab3aa928e
# ╠═e435bad3-3208-4cef-9ab3-feb50461a10c
# ╠═f530f068-acc2-4a21-a309-427f00009cf0
