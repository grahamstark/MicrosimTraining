begin
	import Pkg
    # activate the shared project environment
    Pkg.activate(Base.current_project())
    # instantiate, i.e. make sure that all packages are downloaded
	#Pkg.resolve()
    #Pkg.instantiate()
	using MicrosimTraining
	# initialise parameters - 2024 system, annual and pre-weeklyised system
	const settings = Settings()
	const EXAMPLE_HH = ExampleHouseholdGetter.get_household("example_hh3")
	const BASE_SYS = 
		get_default_system_for_fin_year( 2024; scotland=true, autoweekly = true )
	const ANNUAL_BASE_SYS = 
		get_default_system_for_fin_year( 2024; scotland=true, autoweekly = false )
	const DEFAULT_WAGE = 10.0
	const BASE_BC = BCCalcs.makebc(
        EXAMPLE_HH, 
        BASE_SYS, 
        settings, 
        DEFAULT_WAGE );
	
	function makebcs( allowance, rate, taper )
		sys = deepcopy( ANNUAL_BASE_SYS )
		sys.it.personal_allowance = allowance
		sys.it.non_savings_rates[3] = rate
		sys.uc.taper = taper
		weeklyise!( sys )
		
		sys_bc = BCCalcs.makebc(
	        EXAMPLE_HH, 
	        sys, 
	        settings, 
	        DEFAULT_WAGE )
		return drawbc( BASE_BC, sys_bc )
	end
	
	function drawbc( base_bc, sys_bc )
		f = Figure(;)
		ax = Axis(f[1,1]; xlabel="Gross Income £s pw", ylabel="Net Income £s pw",title="Budget Constraint")
		
		sc = lines!(ax, base_bc.gross, base_bc.net;label = "Before")
		sys_ln = lines!(ax, sys_bc.gross, sys_bc.net;label = "After",)
		axislegend(ax; position = :rb)
		f
	end
	PlutoUI.TableOfContents(aside=true)
end