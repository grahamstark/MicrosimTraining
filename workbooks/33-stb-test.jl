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

# ╔═╡ 135d4bcd-9000-48aa-b433-70864ba1be2e
begin
	r = BigInt(0)
	N = 1000000
	@progress for i in 1:N # 1:100_000_000
		global r
		r += rand(Int)
	end
	r
end

# ╔═╡ 8e0683f5-9ca1-4020-9613-c42525673283
@htl("""
<script>

console.info("Can you find this message in the console?")

</script>
""")

# ╔═╡ 5a166877-7f66-474c-bdfe-f7176dd7a703
begin
ProgressTable(pct) = PlutoUI.wrapped() do Child
md"""

### How many dogs do you have? $pct

"""

end

end

# ╔═╡ dd3a47e6-890a-4c3a-976f-e7851c8dae24
@bind nds ProgressTable( 10 )

# ╔═╡ 92dd4f04-932e-47cc-a916-9c8c10f44cbd
begin

	tot = 0
	obs = Observable( Progress(settings.uuid,"",0,0,0,0))
	tab = @htl("""
		<table>
			<tr width="100%"><td with="80%" style="bgcolor:red">GESS</td><td with="20%"></td></tr>
		</table>
	"""
	)

@bind progtable @htl("""
<script id='progress'>
console.log( "tot = " + tot );
</script>
""")
	
	of = on(obs) do p
	    global tot
	    
	
	    tot += p.step
	    
		println( tot )
		details("XX", tab )
	end
	
	sys2 = deepcopy(AN_BASE)
	weeklyise!( sys2 )
	sys = [BASE, sys2]
	results = do_one_run( settings, sys, obs )
end

# ╔═╡ 324a71e5-4416-4de6-a469-cab328aadebe
almost(
    md"You're right that the answer is a positive number, but the value isn't quite right."
)

# ╔═╡ 3e1f5775-ecd4-4e45-89a4-4027b132d1ce
if N == 100_000
	correct()
else
	keep_working()
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
# ╠═135d4bcd-9000-48aa-b433-70864ba1be2e
# ╠═8e0683f5-9ca1-4020-9613-c42525673283
# ╠═5a166877-7f66-474c-bdfe-f7176dd7a703
# ╠═dd3a47e6-890a-4c3a-976f-e7851c8dae24
# ╠═92dd4f04-932e-47cc-a916-9c8c10f44cbd
# ╟─324a71e5-4416-4de6-a469-cab328aadebe
# ╟─3e1f5775-ecd4-4e45-89a4-4027b132d1ce
# ╟─2fbac8f8-3ced-40e6-81b2-6a0b581bcd75
# ╟─74645ef7-8ce3-41fc-95e5-cfdb48f9903f
# ╟─4e1616f9-90f1-4079-bdcf-54cab3aa928e
# ╠═e435bad3-3208-4cef-9ab3-feb50461a10c
# ╠═f530f068-acc2-4a21-a309-427f00009cf0
