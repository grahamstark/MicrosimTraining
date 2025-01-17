
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

	function draw_summary_graphs( summary :: NamedTuple )::Figure
		f = Figure()
		ax1 = Axis(f[1,1]; title="Lorenz Curve", xlabel="Population Share", ylabel="Income Share")
		popshare = summary.quantiles[1][:,1]
		incshare_pre = summary.quantiles[1][:,2]
		incshare_post = summary.quantiles[2][:,2];
		insert!(popshare,1,0)
		insert!(incshare_pre,1,0)
		insert!(incshare_post,1,0)
		lines!(ax1, popshare, incshare_pre; label="Before")
		lines!(ax1,popshare,incshare_post; label="After")
		lines!(ax1,[0,1],[0,1]; color=:grey)
		ax2 = Axis(f[1,2]; title="Income Changes By Decile", 
			ylabel="Change in £s per week", xlabel="Decile" )
		dch = summary.deciles[2][:, 3] .- summary.deciles[1][:, 3]
		barplot!( ax2, dch)
		f
	end
	
	# some formatting
    function fm(v)
			"£"*format( v/1_000_000, commas=true, precision=0 )*"mn"
	end

	function fp(v)
			format( v*100, precision=1 )*"%"
	end

	function fc(v)
			format( v, precision=0, commas=true )
	end     

	function make_short_summary( summary :: NamedTuple )::NamedTuple
		r1 = summary.income_summary[1][1,:]
		r2 = summary.income_summary[1][1,:]
		ben1 = r1.total_benefits
		ben2 = r2.total_benefits
		tax1 = r1.income_tax+r1.national_insurance+r1.employers_ni	
		tax2 = r2.income_tax+r2.national_insurance+r2.employers_ni	
		dtax = tax2 - tax1
		dben = ben2 - ben1 
		palma1 = summary.inequality[1].palma
		palma2 = summary.inequality[2].palma
		dpalma = palma2 - palma1
		gini1 = summary.inequality[1].gini
		gini2 = summary.inequality[2].gini
		dgini = gini2 - gini1
		(; 
		ben1 = fm( ben1 ),
		ben2 = fm( ben2 ),
		dben = fm(dben),
		gini1=fp(ineq1.gini), 
		gini2=fp(ineq2.gini),
		palma1=fp(ineq1.palma),
		palma2=fp(ineq2.palma),
		dpalma=fp(dpalma),
		dgini=fp(dgini),
		tax1=fm( tax1 ),
		tax2=fm( tax2 ),
		dtax=fm( dtax ),
		gainers=fc( summary.gain_lose[1].gainers ),
		losers=fc( summary.gain_lose[1].losers ),
		nc = fc( summary.gain_lose[1].nc))
	end

    PlutoUI.TableOfContents(aside=true)
end


begin
	res = make_short_summary( summary 
	
	md"""
		### Tax revenue 
	before: **$(res.tax1)** after: **$(res.tax2)** change: **$(res.dtax)** £mn pa
	
	### Benefit Spending
	before: **$(res.ben1)** after: **$(res.ben2)** change: **$(res.dben)** £m pa

	### Inequality
	Gini before: **$(res.gini1)** after: **$(res.gini2)** change: **$(res.dgini)**
	
	Palma before: **$(res.palma1)** after: **$(res.palma2)** change: **$(res.dpalma)**
	
	### Gainers & Losers
	Households gaining: **$(res.gainers)** losing: **$(res.losers)** unchanged: **$(res.nc)**
	"""
end
