module MicrosimTraining

#=

use like:
see: https://plutojl.org/en/docs/packages-advanced/

Pluto.run(capture_stdout=false)

1st cell:

import Pkg
# activate the shared project environment
Pkg.activate(Base.current_project())
# instantiate, i.e. make sure that all packages are downloaded
Pkg.instantiate()

pluto.run(;notebook=abspath(notebook))

=#
using Reexport

@reexport using Agents
@reexport using Pkg.Artifacts
@reexport using CSV
@reexport using DataFrames
@reexport using Format
@reexport using GLM
#@reexport using Makie
@reexport using Bonito
@reexport using HypertextLiteral
@reexport using CairoMakie
@reexport using Images: load
@reexport using StatsBase

@reexport using Pluto
@reexport using PlutoLinks
@reexport using PlutoHooks
@reexport using PlutoTeachingTools
@reexport using PlutoUI

@reexport using ProgressLogging

@reexport using MarkdownLiteral
@reexport using ShortCodes

@reexport using BudgetConstraints
@reexport using SurveyDataWeighting
@reexport using PovertyAndInequalityMeasures

@reexport using ScottishTaxBenefitModel

@reexport using ScottishTaxBenefitModel.BCCalcs
@reexport using ScottishTaxBenefitModel.Definitions
@reexport using ScottishTaxBenefitModel.Definitions
@reexport using ScottishTaxBenefitModel.ExampleHelpers
@reexport using ScottishTaxBenefitModel.ExampleHouseholdGetter
@reexport using ScottishTaxBenefitModel.GeneralTaxComponents
@reexport using ScottishTaxBenefitModel.ModelHousehold
@reexport using ScottishTaxBenefitModel.Monitor
@reexport using ScottishTaxBenefitModel.Results
@reexport using ScottishTaxBenefitModel.Runner
@reexport using ScottishTaxBenefitModel.RunSettings
@reexport using ScottishTaxBenefitModel.SingleHouseholdCalculations
@reexport using ScottishTaxBenefitModel.STBIncomes
@reexport using ScottishTaxBenefitModel.STBOutput
@reexport using ScottishTaxBenefitModel.STBParameters
@reexport using ScottishTaxBenefitModel.Utils

using ArtifactUtils
using Preferences

export MAINDIR 
const MAINDIR=artifact"main_data"

export draw_pov_table

# ╔═╡ d2e1f7d5-f2d1-4320-ad8f-426a74c4420b
function draw_pov_table( phase :: String, pct :: Int)
	t = if phase == "queued" 
        "<div class='alert alert-info' role='alert'>Run is starting up.</div>"
    elseif phase == "do-one-run-start" 
        "<div class='alert alert-info' role='alert'>Run starting: starting pre-run routines.</div>"
    elseif phase == "weights" 
        "<div class='alert alert-info' role='alert'>Generating sample weights (may take some time..).</div>"        
    elseif phase == "disability_eligibility" 
        "<div class='alert alert-info' role='alert'>Calibrating Disability Benefits.</div>"        
    elseif phase == "starting" 
        "<div class='alert alert-info' role='alert'>Pre-routines completed; run starting.</div>"
    elseif phase == "run" || phase == "health" 
        """
        <table width='100%' 
            style='border:0;background:#ddeedd; color:black; padding:1px; align=center'>
        <tr>
            <td width="100%" >Model Running</b>
                <table width='80%' style='border:0'>
                    <tr>
                        <td style='background:#3366aa; color:white'>$pct%&nbsp;Done</td>
                        <td style='background:#ffcc33'></td>
                    </tr>
                </table>
            </td>
        </tr>
        </table>
        """
    elseif phase == "do-one-run-end" 
        "<div class='alert alert-info' role='alert'>Main calculations complete.</div>"
        
    elseif phase == "dumping_frames" 
        "<div class='alert alert-info' role='alert'>Calculations complete; now generating output.</div>"
    elseif phase == "results-generation" 
        "<div class='alert alert-info' role='alert'>Calculations complete; Creating Results.</div>"
    elseif phase == "end" 
        "<div></div>" 
    else
        "<div class='alert alert-danger' role='alert'>Problem</div>"
    end                                      
	Show(MIME"text/html"(), t )
end


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

function __init__()
    CairoMakie.activate!()
    # pre loading data doesn't work for Pluto, sadly
    # settings = Settings()
    # settings.included_data_years = [2019,2020,2021]
    # settings.weighting_strategy = use_runtime_computed_weights
    # FRSHouseholdGetter.initialise( settings )
    # ExampleHouseholdGetter.initialise( get_settings() )
end 

end
