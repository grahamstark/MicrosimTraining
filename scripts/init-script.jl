using Pkg
Pkg.activate(".")
Pkg.gc()
# STB is unregistered, so ...
Pkg.add(; url="https://github.com/grahamstark/ScottishTaxBenefitModel.jl") 
Pkg.instantiate()
# Pkg.update()
# using Revise
using MicrosimTraining
Pluto.run()