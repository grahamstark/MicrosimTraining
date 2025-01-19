export fb, fp, fc, fm, fmz
export make_short_summary
export make_pov_transitions, draw_summary_graphs
export make_artifact
export run_model
export BASE_SYS, ANNUAL_BASE_SYS, DEFAULT_PLUTO_INPUTS
export make_pluto_inputs, map_pluto_inputs
export make_pluto_combined_input_fields

const BASE_SYS = 
    get_default_system_for_fin_year( 2024; scotland=true, autoweekly = true )
const ANNUAL_BASE_SYS = 
    get_default_system_for_fin_year( 2024; scotland=true, autoweekly = false )
    
function make_pluto_inputs(sys2::TaxBenefitSystem)::NamedTuple
    sys2 = deepcopy(ANNUAL_BASE_SYS)
    (; 
    tax_allowance = sys2.it.personal_allowance,
    income_tax_rate = sys2.it.non_savings_rates[2],
    uc_taper = sys2.uc.taper,
    child_benefit = sys2.nmt_bens.child_benefit.first_child,
    pension = sys2.nmt_bens.pensions.new_state_pension )
 end 

function map_pluto_inputs( pps :: NamedTuple)::TaxBenefitSystem
    sys2 = deepcopy(ANNUAL_BASE_SYS)
    sys2.it.personal_allowance = pps.tax_allowance
    itdiff = sys2.it.non_savings_rates[2] - pps.income_tax_rate
    sys2.it.non_savings_rates .-= itdiff
    sys2.uc.taper = pps.uc_taper
    sys2.nmt_bens.child_benefit.first_child = pps.child_benefit
    sys2.nmt_bens.pensions.new_state_pension = pps.pension
    sys2.nmt_bens.pensions.cat_a *= 
        (pps.pension/sys2.nmt_bens.pensions.new_state_pension)
    weeklyise!( sys2 )
    return sys2
end

const DEFAULT_PLUTO_INPUTS = make_pluto_inputs(ANNUAL_BASE_SYS)

# some formatting
function fmz(v::Number)
    vm = v/1_000_000
    return if vm ≈ 0.0
        "No Change"
    else
        "£"*format( vm, commas=true, precision=0 )*"mn"
    end
end

fm(v::Number) = "£"*format( v/1_000_000, commas=true, precision=0 )*"mn"
fp(v::Number) = format( v*100, precision=1 )*"%"
fc(v::Number) = format( v, precision=0, commas=true )
fpw(v::Number) = "£"*format( v, precision=2, commas=true )
fpa(v::Number) = "£"*format( v, precision=0, commas=true )

function fb(v::Number)
    if v ≈ 0
        return "-"
    end
    format( v, precision=0, commas=true )
end  

"""
Make input fields in a form suitable for:
     @bind pps make_pluto_combined_input_fields(DEFAULT_PLUTO_INPUTS)
see: https://featured.plutojl.org/basic/plutoui.jl#8c51343f-cb35-4ff9-9fd8-642ffab57e22
FIXME I don't really understand this code.
"""
function make_pluto_combined_input_fields( pps :: NamedTuple )
	return PlutoUI.combine() do Child
		inputs = [
            md"""
            Tax Allowance: $(
            Child( "tax_allowance", NumberField(0:10:25000,default=pps.tax_allowance)))(£p.a.; *default $(fpa(pps.tax_allowance))*)
            """,
            md"""
            Income Tax Rate: $(Child("income_tax_rate", NumberField(0:1:100,default=pps.income_tax_rate))) (%; *default $(fc(pps.income_tax_rate))*)
            """,
            md"""
            Benefit Withdrawal Rate: $(Child("uc_taper", NumberField(0:1:100,default=pps.uc_taper))) (%; *default $(fc(pps.uc_taper))*)
            """,
            md"""
            Child Benefit: $(Child("child_benefit", NumberField(0:0.01:100,default=pps.child_benefit))) (£s pw; *default $(fpw(pps.child_benefit))*)
            """,
            md"""
            Pension: $(Child("pension", NumberField(0:0.01:500,default=pps.pension))) (£s pw; *default $(fpw(pps.pension))*)
            """]

        md"""
            ## Taxes and Benefits
            $(inputs)
            """
    end # do
end

function make_pluto_combined_input_fields()
    make_pluto_combined_input_fields(DEFAULT_PLUTO_INPUTS)
end

function all_defaults(pps::NamedTuple)::Bool
    # tax_allowance, income_tax_rate, uc_taper, child_benefit, pension)::Bool
	return (tax_allowance == tax_allowance) &&
		(default_income_tax_rate == income_tax_rate) &&
		(default_uc_taper == uc_taper) &&
		(default_child_benefit == child_benefit) &&
		(default_pension == pension)
end

function make_short_summary( summary :: NamedTuple )::NamedTuple
    r1 = summary.income_summary[1][1,:]
    r2 = summary.income_summary[2][1,:]
    ben1 = r1.total_benefits
    ben2 = r2.total_benefits
    tax1 = r1.income_tax+r1.national_insurance+r1.employers_ni	
    tax2 = r2.income_tax+r2.national_insurance+r2.employers_ni	
    dtax = tax2 - tax1
    dben = ben2 - ben1 
    netcost = dben - dtax
    palma1 = summary.inequality[1].palma
    palma2 = summary.inequality[2].palma
    dpalma = palma2 - palma1
    gini1 = summary.inequality[1].gini
    gini2 = summary.inequality[2].gini
    dgini = gini2 - gini1
    s1 = summary.poverty[1]
    s2 = summary.poverty[2]
    pr1 = s1.foster_greer_thorndyke[1]
    pr2 = s2.foster_greer_thorndyke[1]
    prch = s2.foster_greer_thorndyke[1]-s1.foster_greer_thorndyke[1]
    ncexcess = (netcost/1_000_000) - 4_000 # fixme parameterise
    ncpts = if ncexcess > 500 #res.netcost 
        4 # "much too high"
    elseif ncexcess > 100
        3 # "slightly too high"
    elseif ncexcess < -100
        0 # "money to spend"
    else 
        0 # "fine"
    end
    povexess = 0.03 - prch
    povpts = if povexess > 0.04
        4 # "too high"
    elseif povexess > 0.01
        2
    else
        0 # fine
    end
    score = povpts + ncpts
    response = if score == 0
        msg = "Well done: you've hit the poverty target and remained within budget."
        correct( md"$msg")
    elseif score < 3
        msg = "You're close to getting a successful policy, but not quite there. "
        if povpts > 0
            msg *= "Poverty, at $(fp(pr2)) represents a cut of less than 3%.Consider increasing the social security benefits, or targetting social security more on the poor. "
        end
        if ncpts > 0
            msg *= "At $(fm(netcost)), you are quite a bit over your £4bn net spend budget. Consider increasing taxes or cutting benefits. "
        end
        almost( msg )
    else
        msg = "You're quite far away. "
        if povpts > 0
            msg *= "Poverty, at $(fp(pr2)) represents a cut of less than 3%.Consider increasing the social security benefits, or targetting social security more on the poor. "
        end
        if ncpts > 0
            msg *= "At $(fm(netcost)), you are quite a bit over your £4bn net spend budget. Consider increasing taxes or cutting benefits. "
        end
        keep_working( msg )
    end

    (; 
    response = response,
    netcost = fmz( netcost ),
    povrate1 = fp(pr1),
    povrate2 = fp(pr2),
    dpovrate = fp( prch ),
    ben1 = fm( ben1 ),
    ben2 = fm( ben2 ),
    dben = fm(dben),
    gini1=fp(gini1), 
    gini2=fp(gini2),
    palma1=fp(palma1),
    palma2=fp(palma2),
    dpalma=fp(dpalma),
    dgini=fp(dgini),
    tax1=fm( tax1 ),
    tax2=fm( tax2 ),
    dtax=fm( dtax ),
    gainers=fc( summary.gain_lose[2].gainers ),
    losers=fc( summary.gain_lose[2].losers ),
    nc = fc( summary.gain_lose[2].nc) )
end

function pstate(m, povs )::Int
    i = 0
    for p in povs
        i += 1
        if m <= p
            return i
        end
    end
    return i+1
end

function make_povtrans_mat( results :: NamedTuple )::Matrix
    trans = zeros(6,6)
    med1 = median(results.indiv[1].eq_bhc_net_income, Weights(results.indiv[1].weight ))
    @show med1
    povs = med1 .* [ 0.3, 0.4, 0.6, 0.8 ]
    @show povs
    nrows, ncols = size( results.indiv[1] )
    for r in 1:nrows
        i1 = results.indiv[1][r,:]
        i2 = results.indiv[2][r,:]
        p1 = pstate(i1.eq_bhc_net_income, povs)
        p2 = pstate(i2.eq_bhc_net_income, povs)
        trans[p1,p2] += i1.weight
        trans[p1,6]+= i1.weight
        trans[6,p2]+= i1.weight
        trans[6,6]+= i1.weight
    end
    trans
end

function draw_summary_graphs( summary :: NamedTuple, data::NamedTuple )::Figure
    f = Figure()
    ax1 = Axis(f[1,1]; title="Lorenz Curve", xlabel="Population Share", ylabel="Income Share")
    popshare = summary.quantiles[1][:,1]
    incshare_pre = summary.quantiles[1][:,2]
    incshare_post = summary.quantiles[2][:,2];
    insert!(popshare,1,0)
    insert!(incshare_pre,1,0)
    insert!(incshare_post,1,0)
    lines!(ax1, popshare, incshare_pre; label="Before", color=(:lightsteelblue, 1))
    lines!(ax1,popshare,incshare_post; label="After", color=(:gold2, 1))
    lines!(ax1,[0,1],[0,1]; color=:grey)
    ax2 = Axis(f[1,2]; title="Income Changes By Decile", 
        ylabel="Change in £s per week", xlabel="Decile" )
    dch = summary.deciles[2][:, 3] .- summary.deciles[1][:, 3]
    barplot!( ax2, dch)
    ax3 = Axis(f[2,1:2]; title="Income Distribution", xlabel="£s pw", ylabel="")
    density!( ax3, data.indiv[1].eq_bhc_net_income; 
        weights=data.indiv[1].weight, label="Before", color=(:lightsteelblue, 0.5))
    density!( ax3, data.indiv[2].eq_bhc_net_income; 
        weights=data.indiv[2].weight, label="After", color=(:gold2, 0.5) )
    f
end

const sevcols = [
        "#ee0000",
        "#cc2222",
        "#990000",
        "#666666",
        "#333333",
        "#333333"]


function one_row( label::String, v :: Vector, r::Int )::String
    s = "<tr><th style='color:$(sevcols[r])'>$label</th>"	
    for i in 1:5
        bgcol = if r == 6
            "#dddddd"
        elseif i < r
            "#ffccbb"
        elseif i > r
            "#bbffdd"
        else 
            "#dddddd"
        end
        cell = "<td style='text-align:right;background:$bgcol;color:$(sevcols[i])'>$(v[i])</td>"
        s *= cell
    end
    cell = "<td style='text-align:right;background:#cccccc;color:$(sevcols[r])'>$(v[6])</td>"
    s *= cell
    s *= "</tr>"
    s
end

function make_pov_transitions( results::NamedTuple )::String
    labels = ["V.Deep (<=30%)",
              "Deep (<=40%)",
              "In Poverty (<=60%)",
              "Near Poverty (<=80%)",
              "Not in Poverty",
             "Total"]
    trans = make_povtrans_mat( results )
    vs = fb.(trans)
    cells = ""
    for r in 1:6
        cells *= one_row( labels[r], vs[r,:], r )
    end
    
    return """
<table width='100%' style=''>
<thead></thead>
<tr><th colspan='7'>After</th>
<tr><th rowspan='9'>Before</th>
<tr>
    <th></th>
    <th style='color:$(sevcols[1])'>$(labels[1])</th>
    <th style='color:$(sevcols[2])'>$(labels[2])</th>
    <th style='color:$(sevcols[3])'>$(labels[3])</th>
    <th style='color:$(sevcols[4])'>$(labels[4])</th>
    <th style='color:$(sevcols[5])'>$(labels[5])</th>
    <th style='color:$(sevcols[6])'>$(labels[6])</th>
</tr>
$cells
</table>
"""
end # pov_summary

"""
Given a directory in `tmp/` with some data, make a gzipped tar file, upload this to a server 
defined in Project.toml and add an entry to `Artifacts.toml`. Artifact
is set to lazy load. Uses `ArtifactUtils`.

"""
function make_artifact()::Int 
    artifact_name = "main_data"
    toml_file = "Artifacts.toml"
    gzip_file_name = "microsim-training.tar.gz"
    dir = "artifacts/"
    artifact_server_upload = @load_preference( "public-artifact_server_upload" )
    artifact_server_url = @load_preference( "public-artifact_server_url" )
    tarcmd = `tar zcvf $(dir)/tmp/$(gzip_file_name) -C $(dir)/$(artifact_name)/ .`
    run( tarcmd )
    dest = "$(artifact_server_upload)/$(gzip_file_name)"
    println( "copying |$(dir)/tmp/$gzip_file_name| to |$dest| ")
    upload = `scp $(dir)/tmp/$(gzip_file_name) $(dest)`
    println( "upload cmd |$upload|")
    url = "$(artifact_server_url)/$gzip_file_name"
    try
        run( upload )
        add_artifact!( toml_file, artifact_name, url; force=true, lazy=true )
    catch e 
        println( "ERROR UPLOADING $e")
        return -1
    end
    return 0
end

# just silly ...
const uuid :: UUID = UUID("c2ae9c83-d24a-431c-b04f-74662d2ba07e")
run_progress = Observable( Progress(uuid,"",0,0,0,0))

running_total = 0
phase = "Not Running"

function obs_processor( progress::Progress )
	global running_total, phase
	# sizep = progress.size
	running_total += progress.step
	phase = progress.phase
end 

observer_function = on( obs_processor, run_progress )

"""
pps - params from plutoui @bind
tax_allowance
income_tax_rate
uc_taper
child_benefit
pension
"""
function run_model( 
    pps :: NamedTuple )::Tuple
    global running_total
    running_total = 0
    @show pps
    sys2 = map_pluto_inputs( pps )
    sys = [BASE_SYS, sys2]
    running_total = 0
    settings = Settings()
    settings.num_households, settings.num_people = 
	    FRSHouseholdGetter.initialise( settings; reset=false )

    results = Runner.do_one_run( settings, sys, run_progress )
    summary = summarise_frames!( results, settings )
    short_summary = make_short_summary( summary )
    summary, results, short_summary
end

	
	