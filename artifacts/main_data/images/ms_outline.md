# Microsimulation Section Outline

# Introduction

Dive straight in. Start with some headlines:

* child poverty
* [Howard's EHRC]()
* [Scottish Low Income Supplement Herald]
* [Minimum Wage Increase]
* [Fuel Tax Freeze Guardian]

How can we analyse these? Emphasise:

* very diverse population
* hence: need for some simple organising ideas so we don't get overwhelmed

Microsimulation - Tax Benefit Models - big data on diverse population + detailed modelling of system that affects them + some simple organising ideas

Aside - Microsimulation of other things - councils, corporations etc. Use this as intro to *incidence* - who pays isn't always who is affected. We're only doing people here, and ignoring incidence.

Analysing, we're interested in 2 main aspects:

1. people gain and lose, and so the income distribution changes - so poverty, inequality, concentration, and simpler summary measures (deciles, tabulations..);
2. changing policy changes behaviour: work less, spend differently, etc..

Balancing these is key to good policy - more equality -> less work -> less income.

Both huge areas well beyond this course, but we can get quite far with some simple ideas.

*Fiscal neutrality* invisble hand one of main achievements - GE model (copy from DD309). Gives a direction of travel - competitive markets, prices reflect relevant (marginal) costs. Distort this as little as possible. So low *marginal* rates so the prices of things don't move away from their efficient level too much (wages and prices are considered ), broad based taxation. Sometimes subtleties in tax code matter - consider corporation taxes - taxes on profits of companies. If a company is operating efficiently, and making the most profit it can (maximising profits), then in principle it has no reason to change what it's doing if you take away half its profits - its before-tax plan is still the best it can do. neutrality  in that case means careful attention to the detail of the tax code so the notion of profit in the taxe corresponds to the notion of profit that the company seeks to maximise. Counter examples - where prices don't reflect the true cost of something; so petrol pollutes, alcohol causes crime and illness and so on. Externalities - taxes are imposed to raise the price so it reflects the full 'social' cost of a thing. Arguments exist for why

Simple ideas are best for 2 reasons:

* We need present our results to policy makers, journalists and the general public;
* we're mostly interested in policy *changes* and simple, robust measures often work better as a guide to change than more sophisticated ones.

So: study some simple organising concepts, then hands-on with a live tax-benefit model.

A flavour of big data. Introduce LCF dataset. Show some simple regressions of food vs total spending (online). A simple thing we can get to straight away: simple Engel curves

Exercises: find own examples from new-sites. Look at some examples of summary reports - are they intelligible to non-specialists? How do [recent changes] affect you and your family? Play with LCF a little.

## Some Organising Principles

### Summarising distributional effects

We're changing the distribution of income so..
We all have an intuitive idea about what poverty and inequality are.
Our job here is make our rough ideas reasonably precise and operational.

#### Aside: Poverty and Inequality of What?

Discuss income, consumption, wealth, fuel and food poverty, multi-dimensional measures:

* complex multi-dimensional measures often poor guide to changes (items both up and down);
* good arguments for consumption over income, esp. in 3rd world;
* income often most practical - most measures are income
* wealth hard to measure

exercise: some simple thing to distinguish income, wealth, consumption

#### Aside: (?? not needed ??) Why should we care?

Arguments for and against caring about poverty and inequality at all:

* utilitarian: classical vs new welfare economics, Layard and happiness. Is happiness really a thing? Is it related to income (Khaneman/Deaton), can we meaningfully add it?
* inequality as intrinsically harmful (Spirit Level) vs intrinsically good (TS Elliot, Pareto)
* Chicago type arguments - redistributing doing more harm than good.

[Exercise] Play online with Spirit Level, Anand, Gallup data - Lines between income&happiness, inequality and crime..

### Aside: individuals/Families/Households?

Interested in people but people live in families, households, prisons..:

* practical definitions: benefit units, households (FRS, HBAI)
* feminist arguments - everyone effected equally?
* equivalisation - are big families more efficient? One approach to this using the LCF and Engel.

exercise: simple LCF Engel curves for childless vs with children & Engel's approach.

### Poverty

Relative to some standard. Above not in poverty, below in poverty.

Introduce HBAI.

Income Lines

studies of stress vs income - no big break?

Headcounts

Problems with poverty measures - Dalton's principle - transfers up reduce poverty; show this is a real-world problem;
More sophisticated poverty measures: poverty gaps, FGT, time to exit measures. Trade off between correctness and intelligibility to non-specialists

Exercises: play with an income line, think about your own circumstances

### Summarising Inequality

Introduce Lorenz Curve - complete equality vs complete inequality. Introduce Gini coefficient. Real world Lorenz curves SA vs Denmark.

Formal - something that goes down as all the gaps get smaller; Dalton again. Alternative measures of inequality - correctness vs intelligibility. Briefly mention decomposable and Atkinson measures.

## Incentives

### Introduction

premise: competitive economy works reasonably well (v.v.v briefly discussed) so long as prices reflect social costs. Hence *fiscal neutrality*. Distort as little as possible *unless a good reason not to*.

### Budget Constraints

Orthodox economics centres on an elaborate and controversial model of rational choice [Kay] alternatives [Khaneman, Satisficing] exist .. But it turns out we don't need much of this to get far in understanding choice - all we need is to enumerate the options open to them (and how these trade off..); the best choice is often then self-evident; for other cases we have some general principles to guide us.

* This is all interactive *

Start with a simple diagram: gross income (earnings) on x- net income (take-home) on y-

no taxes and benefits - 45°. Undistorted

[Digression on income/consumption/wealth]
[Digression on wages - map gross to hours on assumption of constant wage/reward for effort. Brief discussion of earnings/leisure choice Note we have this diagram backwards to standard economics treatment]

Now an income tax. 50% on income over £100.
3 ideas here:

* marginal tax rate - 0 then 50 key to understand how tax influences/distorts choice
* average tax rate share of tax in income. Key to non-marginal choices, such as migration (Scottish Higher rate);
* .. allowance has a 'cash value' of £50 (£100 * 50%). No universal name, but 'tax credit' is common. Useful tool for understanding distribution - 'cash value' of change.

1,3 and gross are enough to completely describe position, at least locally.

We'll come to a fourth below.

#### Cash Benefits

In might be impossible to live on the low incomes on the left of the diagram. So introduce a cash benefit. This could be:

* universal
* means-tested - withdrawn with incomes
* contingent - just to people who can't work through ..  or have extra needs because ..

example of each ...

4th measure: replacement rate

show how our measures still work - mtr 100, then 0, then 50 .. atr negative then positive

whole thing understandable as a system, but dangers there..

exercise: play around with graduated income tax, universal vs means tested benefits.. play with 100% vs < 100 benefit withdrawal - mention Universal Credit vs JSA/WTC/HB as real example.

some discussion:

* complexity,
* pros and cons of seeing Tax Benefit system as a single system;
* means testing vs universalism vs contingency
* equivalence of taxes and benefits

## A Tax Benefit Model

### Where we're going

IFS page on taxes and benefits; cost, clients, broadly into means tested, contingent, direct, indirect

Impact of taxes and benefits in aggregate (ONS)

Reminder of other taxes & incidence

### Building a tax-benefit model

open source [GIT] but you don't need to follow the code

* data - FRS/LCF
* weighting -
* uprating
* calculations - show an example
* our measures - library for poverty inequality code, data changes for rest; add-a-penny for mrs

limitations:

* behaviour implicit in MRs, not explicit
* takeup, compliance
* macro/timing issues

### Universal Credit

we assume this is in-place and fully working; brief discursion on HB and Tax Credits; example of simple idea gone awry, but it's there (partly) and we start from where we are (or will be shortly).

### extensions:

* micro-macro
* forecasting - uprating and reweighting

## Live with the model

### Introduction

Tour of the model:

Changing a parameter - 1 tax rate
Running the model
A tour of output

Exercise - simple tax change - summarise in terms of

* gainers and losers
* by demographics, income groups
* our poverty and inequality measures
* our incentive measures
* gross costs
* interaction with benefit system

exercise: contrast an allowance change to a rate change

### Benefits

Quick tour of benefit system:

* play with UC Tapers
* child benefit
* play with supplements to UC

recall cost of a child stuff

#### Basic Incomes - Another simple idea meets reality

the idea - sweep all the complicated and intrusive stuff away
Analysis - level up tax credit level for working population, level down benefits for non-working.

Exercise: introduce a Basic Income with
a) minimal losses amongst poor
b) no extra spending on social security

discuss the trade-offs. Report using our measures.

### Minimum wages

Discuss how we do this? Brief history of the MW. Para on labour supply/demand

Living Wage

Exercise: relationship between MW and Benefit Spending. Find the  living wage for different family types

### Feminist Economics

Women's budget group reports. Discuss the assumptions needed. Example from Deaton of food shares & women's earnings

Exercise: design a women friendly budget?

### What's Left Out

Spending Taxes - data: discuss matching/imputation - matching in next module.

Imputation of Government Spending, incidence of corporation taxes & others - simple argument for falling on wages in small open economy.

### Model as  Forecasting Tool

#### A) Micro Only

Poverty forecasting example.

* weighting;
* uprating;
* examples of different population forecasts.

Nick stuff from Hendry book.

Artificial ageing briefly discussed - needed for pensions, lifetime care funds, etc.

#### B) Micro to Macro

* check with Asghar?? South African model [DIMMSIM](http://adrs-global.com). Micro produces revenues, expenditures - feed into macro until equilibrium reached
