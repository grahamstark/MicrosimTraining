#=

A Hands-on introduction to Julia

1) The very basics. 

=#

# a comment

x = 10
y ::Float64 = 10 # y has an explicit type
v = [10,11,12] # vector - also collect(10:12)
m = [1 2
     3 4
     5 6] # a 3 rows x 2 cols matrix

size(m)

s = "HELLO"

println(s)
println("s = $s")

# a function

function mu( x ) # accepts any type, same as mu( x :: Any )
    x *= 2
end

function mu( x :: Int )::Int # needs an Int 
    x *= 3
end

function mu( x :: Number )::Number # accepts any number () 
    x *= 5
end

mu(10.2)
mu(10)
# mu( s ) # this is illegal

mu.(m) # broadcast - the '.' applies the function to each element

m'
inv(m[1:2,:]) # square bit

# loops are as fast in Julia as vector operations

for r in 1:3    
    for c in 1:2
        m[r,c] *= 10
    end
end

# same as

m .*= 10

# compound types

t1 = ( x, y ) # a tuple t1[1] 
t2 = ( x=x, y=y ) # named tuple
struct MyStruct # y can be anything, x needs to be numeric
    x :: Number
    y 
end
ms = MyStruct( 10, "Hello")
# all these are *immutable*

mutable struct MutStruct
    x :: Number
    y 
end
mus = MutStruct(11,m)
mus.x = 102 # you can assign. 

# metaprogramming - create code on-the-fly. Powerful but dangerous e,g 
# @time - expands into a timer for a block of code,
# @threads - breaks a loop into parallel execution threads 

        

# .. and so on

#=

Part 2) Some 
Julia code is organised into Packages. We will be using a bunch of packages, but won't have time to create one of our own.

=#

using Pkg # the package manager is itself a package.

# add some packages we'll need.
Pkg.add( "CSV" )        # delimted file reader
Pkg.add( "DataFrames" ) # tables of data
Pkg.add( "Downloads" )  # allow file reading from websites
Pkg.add( "GLM" )        # linear regressions
Pkg.add( "Plots" )      # simple but powerful graphics package - Makie.jl is an alternative
Pkg.add( "Pluto" )      # Beautiful interactive workbooks
Pkg.add( "PlutoUI" )    # controls for Pluto
Pkg.add( "PovertyAndInequalityMeasures" ) # One of mine! Ginis and the like 
Pkg.add( "StatsBase" )  # means, medians ..
Pkg.add( "StatsPlots")  # specialised plots for data from dataframes

# now we have them installed, bring the packages into our code 
using CSV
using DataFrames
using Downloads
using GLM
using Plots
using Pluto
using PlutoUI
using PovertyAndInequalityMeasures
using StatsBase
using StatsPlots

#= 
  Part 1) of the 2-language problem: julia as a data-science tool.
  We'll try esimating some simple Engel curves and, from there, kinda-sorta equivance scales 
=#

# this a publicly available subset of a rather old UK Living Costs and Food Survey (2005-6)
url="https://virtual-worlds.scot/ou/uk-lcf-subset-2005-6.csv"

# load LCF into a DataFrame (a spreadsheet-like structure, like Python Pandas, R Tibble)
lcf = CSV.File(Downloads.download(url))|>DataFrame

# simple examples of filtering and transforming a dataframe:
lcf = lcf[lcf.hhincome .> 100, : ] # remove all hhlds with tiny or negative gross incomes (e.g. self-employment losses)
lcf.has_kids = lcf.children .> 0 # create a column which is true if famiy with children
lcf.sh_food = lcf.food_and_drink./lcf.hhincome
lcf.log_income  = log.( lcf.hhincome ) # not the '.' broadcast 

summarystats( lcf.sh_food )
# plot of income vs food consumption, split by child/no child hhlds. Note the metaprogramming '@df' which allows easier use of the dataframe.
engel_1 = @df lcf scatter(
    :log_income, 
    :sh_food; 
    title="Food Share vs Log Income",
    xlabel = "Log( Gross income £s pw)",
    ylabel = "Share of food in Gross Income",
    group=:has_kids )
savefig( engel_1, "output/engel-food.svg" )

# basic linear engel curve for food via OLS
lm( @formula( food_and_drink ~ hhincome ), lcf ) # sometimes total expenditure in place of income

# more kosher Engel curves: shares vs log of income, dummies, with seperate regressions for with & without children 
fd_kids = lm( @formula( sh_food ~ log(hhincome) + region + tenure ), lcf[lcf.has_kids.==1,:] )
fd_nokids = lm( @formula( sh_food ~ log(hhincome) + region + tenure  ), lcf[lcf.has_kids.==0,:] )

predict(fd_kids)

# things to try: Barton eq scales - adult expenditure linear 

#= no time for this
exps = 20:1:3_000
coeffs_kids = coef(fd_kids)
regression_kids = coeffs_kids[1].+(coeffs_kids[2].*log.(exps))
coeffs_nokids = coef(fd_nokids)
regression_nokids = coeffs_kids[1].+(coeffs_nokids[2].*log.(exps))

p2 = @df lcf scatter!(p1, :hhincome, :food_and_drink, group=:has_kids )
=# 

#==
 The other half of the two-language problem: let's build a microsimulation. We'll do this in a Pluto notebook
=#

# Pluto.run()
