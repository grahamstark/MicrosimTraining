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
using Markdown
using UUIDs

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

include("runner-functions.jl")


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
