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
@reexport using WGLMakie
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
    # pre loading data doesn't work for Pluto, sadly
    # settings = Settings()
    # settings.included_data_years = [2019,2020,2021]
    # settings.weighting_strategy = use_runtime_computed_weights
    # FRSHouseholdGetter.initialise( settings )
    # ExampleHouseholdGetter.initialise( get_settings() )
end 

end
