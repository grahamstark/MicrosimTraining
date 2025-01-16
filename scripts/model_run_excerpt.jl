
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
	const BASE_SYS = 
		get_default_system_for_fin_year( 2024; scotland=true, autoweekly = true )
	const ANNUAL_BASE_SYS = 
		get_default_system_for_fin_year( 2024; scotland=true, autoweekly = false )

    settings.num_households, settings.num_people = 
        FRSHouseholdGetter.initialise( settings; reset=false )

	run_progress = Observable( Progress(settings.uuid,"",0,0,0,0))
	
	running_total = 0
	phase = "Not Running"
	
	function obs_processor( progress::Progress )
		global running_total, phase, size
		size = progress.size
	    running_total += progress.step
		phase = progress.phase
	end 
	
	observer_function = on( obs_processor, run_progress )


	function do_one_run( allowance::Real )::NamedTuple
		global running_total
		sys2 = deepcopy(ANNUAL_BASE_SYS)
		sys2.it.personal_allowance *= 1.2
		weeklyise!( sys2 )
		sys = [BASE_SYS, sys2]
		running_total = 0
		results = do_one_run( settings, sys, run_progress )
		summary = summarise_frames!( results, settings )
		summary
	end

    PlutoUI.TableOfContents(aside=true)
end