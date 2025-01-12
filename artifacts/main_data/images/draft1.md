author: Graham Stark
topics: Microsimulation
title: Introduction
date: 01/10/2019

# Microsimulation

## Introduction

Let's start with some recent headlines:

* [BBC Poverty]()
* [Scotsman Income Tax]()
* [Howards EHCR]()
* [Scottish Low Income Supplment Herald]
* [Minimum Wage Increase]
* [Fuel Tax Freeze Guardian]()

How can we analyse what's going on in cases like this? How can we understand the reasoning behind the decisions that were made in each case?

In this chapter we want to do two things:

1. discuss some ideas that can help you to think systematically about questions like these; and
2. give you a chance to experiment with a simple example of the most important tool used in this field - a Microsimulation Tax Benefit model.

What all our headlines have in common is that they are concerned with the impact on the a diverse society of broad Government policies - on Social Security, wage setting, or the taxation of income and spending. This diversity is important: Microsimulation is a way of confronting what may seem on paper a good, simple idea with the reality of a society with rich and poor, able and disabled, young and old, conventional nuclear families and those living in very different arrangements. But the very complexity of a modern society makes it all the more important that we have a few organising principles to guide us - it's no use just holding our hands up and saying "it's all very complicated" - even if it is.

All the examples above and almost all of what follows are about things that directly affect people, by, for example, taking some of their income in tax, raising their wages, or paying them benefits. But much of this can also be applied to the study of, for example, policy changes affecting companies, industries, schools, Local Authorities and the like. This raises an important point: ultimately the effects of a change to, say, the taxation of corporations or the funding of local councils falls on individuals [example] but the effect is indirect. Resolving this indirection is know as finding the *incidence* of the change. Considering the ultimate incidence of policy changes is very important, but can be very difficult. Even the direct changes we're concentrating on here can have an incidence beyond the those immediately affected - an income tax increase might cause higher prices in some industry, and so be 'passed on' to consumers who weren't the direct targets of the tax. For the most part we'll be considering first-round effects on the people directly affected by our policy changes, but incidence effects are worth keeping in mind, and are central to the how we'd analyse, say, changes to corporation tax or central Government support for Local Authorities .

Broadly, we can group the questions we might want to ask about our policies changes into two:

1. they inevitably produce gainers and losers: some people might be better off, and some worse off, and we want to summarise those changes in an intelligible way. This leads us to the study of measures such as poverty and inequality; when we come to do some modelling we'll also consider some more prosaic measures such as counts of gainers and losers disaggregated in various ways, aggregate costings and the like;
2. our policy changes may alter the way the economy works in some way - for example an income tax cut might make people work more (or, as we'll see, less), or a tax on plastic bags might lead people to use less of them. Some of these effects may be beneficial and part of the intention of the change, others may be harmful and unintentional. A useful () is [fiscal neutrality] - by default, taxes and benefits should be designed to alter the behaviour of the economy as little as possible; we return to this below.

Much of the art of policy analysis and policy design lies in balancing these two aspects; for example, redistributing income whilst maintaining incentives to work, or raising taxes on some harmful good without hurting the poorest and most vulnerable.

The distributional and incentive analysis of policy changes, and the art of balancing between these things, are huge and technical subjects that go well beyond this course, but we aim to equip you with many of the key ideas and give you a flavour or where more advanced treatments might take you. As you'll see, you can get remarkably far with a few simple measures.

One last point before we begin. We are mainly concerned with analysing *changes* to policy here. It's an important truth about applied economics that modelling and predicting *changes* is a different thing from modelling *levels*. For example, elaborate, multi-dimensional measures of poverty *levels* have become popular but often a simple, one-dimensional, measure works better for understanding changes to the benefit system.

We'll now proceed by briefly  our key ideas, before turning to practical matters with our little tax-benefit model.

## Some Concepts

### Poverty, inequality (and sometimes concentration).

Likely everyone has an intuitive idea of what inequality and poverty are. Many of us will feel we've been on the wrong side of these things at some point: perhaps being trapped in poverty or treated unequally. Our job here is to discuss the attempts of analysts and theorists to make the ideas of poverty and inequality (and a closely related notion - concentration) precise and operational. But before we do that, we should discuss why we should care - are poverty or inequality worth discussing at all, and, if so, why might we think that reducing them - egalitarianism - might be a good thing. There is a huge literature on this, going back to the Ancient Greeks, and we can of course only give the briefest outline here. Your rough intuition of what poverty and inequality are is all that's needed at this point, not least because much of the important arguments pre-date (or just ignore) the technical literature.

#### Three Arguments for worrying about increasing poverty and inequality, and three arguments against

There are of course many arguments for why we should care above poverty, inequality and the fair distribution of resources more generally; here we'll focus on the three that have arguably had the most influence on economic thought:

* utilitarian arguments based on the notion of *diminishing marginal utility of income*;
* the idea of inequality and poverty being intrinsically harmful to society; and
* Marxist arguments about the struggle between capitalists and workers.

There are of course arguments against egalitarianism, and we'll discuss three influential examples of these:

* the idea of inequality being an intrinsic good;
* the contention that the whole idea of inequality is meaningless in some way; one important strand of this is the 'ordinalist' approach to social welfare; and
* the notion that egalitarian and pro-poor policies, whilst in principle worthwhile, inevitably do more harm than good in practice, especially through harming incentives to work and earn.

##### Utilitarianism and the Diminishing Marginal Utility of Income

*Diminishing Marginal Utility of Income* is an imposing name for a simple idea, originally dating from the ancient Greeks but put forward in its modern form by the Utilitarian school in the mid 19th century and revived again in the early part of this century by the British economist Richard Layard. It is argued that giving an extra pound to a poor person creates more happiness (or 'utility') than giving that pound to a rich person, since more of the rich person's needs will already have been met. So if you take a pound from a rich person and give it to a poor one, the sum of human happiness goes up, since the rich person is hurt by less than the poor person is helped. Since this is true of any transfer from a richer to a poorer person, it follows that human happiness is at its peak (in economist's terms, society's utility is maximised) when no more rich to poor transfers are possible; that is, when we have complete equality.  

This is a startling and powerful conclusion from a seemingly simple premise, and it of course wants some arguing. One simple but powerful counter argument [Robbins, Dobb] is simply to deny that adding up peoples happiness means anything at all. Utility, in this view, is a purely internal mental state; thinking about utility can be useful when trying to model people's behaviour but it has no meaning beyond; it's certainly not a property that can be added or averaged like peoples height, weight or age. This view, known as the 'New Welfare Economics' came to dominate orthodox economic thought from the early 20th century onwards.

Also - high wages and profits for some people may have social harm, for example by incentivising risk taking and financial manipulation amongst executives [REF], or by encouraging wasteful social displays.

#### Aside: Poverty and Inequality of What?

We've used the term 'income' loosely above without worrying about what that means, or whether it's really the thing we care about. Discuss income, consumption, wealth, fuel and food poverty, multi-dimensional measures. Equivalisation

* complex multi-dimensional measures often poor guide to changes (items both up and down);
* good arguments for consumption over income, esp. in 3rd world;
* income often most practical - most measures are income
* wealth hard to measure

exercise: some simple thing to distinguish income, wealth, consumption

Despite this, in what follows we'll mostly talk about incomes and gloss over these difficulties.

### Aside: individuals/Families/Households?

Ulimately, we're interested in people, but people are social beings. We live in families, households, prisons..:

* practical definitions: benefit units, households (FRS, HBAI)
* feminist arguments - everyone effected equally?
* equivalisation - are big families more efficient? One approach to this using the LCF and Engel.

exercise: simple LCF Engel curves for childless vs with children & Engel's approach.
### Aside: individuals/Families/Households?

Interested in people but people live in families, households, prisons..:

* practical definitions: benefit units, households (FRS, HBAI)
* feminist arguments - everyone effected equally?
* equivalisation - are big families more efficient? One approach to this using the LCF and Engel.

exercise: simple LCF Engel curves for childless vs with children & Engel's approach.

#### Income Lines

A useful device for what follows. Imagine making a list of everyone's income and arranging them in a line, from poorest on the left to richest on the right.

[Javascript example]

Moves holding total income constant.
Dalton's principle: poor person moves up, poverty and inequality should at least not get worse.

#### Means, Medians, Modes

Jumping ahead a little, here's a picture of one measure of the UK income distribution, as a bar chart.

[Pic IFS]
What it shows: income in £pa. on X-axis (running along the way) and numbers of [xx] on the y-axis (up the way). Data from the same source as the model you'll be using presently.

Bunched up on the left. Lots of relatively small incomes some very big ones.

* Mean: add up all the incomes, divide by the number of people.
* Median: the one in the middle
* Mode: most common one

An example. Suppose there are 7 incomes  (1,2,2,5,10,12,20)

mean is (1+2+2+5+10)/5 = 7.42
median is 5 (number in the middle)
mode is 2 (most common number)

[Some exercise] - suppose the top number was 50:

what happens to the mean and median?
This insensitivity to changing top numbers is why the median is often used - top incomes hard to measure/volatile [ref SPI adjustment paper]

#### Poverty

Relative to some standard. We imagine drawing a line cutting our income line: people below the line  are in poverty, those above it are not.

Where would such a line come from? [IMF discussion of stress levels studies of stress vs income - no big break?].

The Introduce HBAI.

Headcounts

Problems with poverty measures - Dalton's principle - transfers up reduce poverty; show this is a real-world problem;
More sophisticated poverty measures: poverty gaps, FGT, time to exit measures. Trade off between correctness and intelligibility to non-specialists

Exercises: play with an income line, think about your own circumstances


#### Inequality

Introduce Lorenz Curve - complete equality vs complete inequality. Introduce Gini coefficient. Real world Lorenz curves SA vs Denmark.

Formal - something that goes down as all the gaps get smaller; Dalton again. Alternative measures of inequality - correctness vs intelligibility. Briefly mention decomposable and Atkinson measures.

#### Concentration

Stab
We might be primarily with how society

##### A simple summary measure


## Incentives

### Introduction


### Fiscal neutrality

Invisible hand one of main achievements - GE model (copy from DD309). Gives a direction of travel - competitive markets, prices reflect relevant (marginal) costs. Distort this as little as possible. So low *marginal* rates so the prices of things don't move away from their efficient level too much (wages and prices are considered ), broad based taxation.

Sometimes subtleties in tax code matter more than the headline tax rates. Consider corporation taxes - taxes on profits of companies. If a company is operating efficiently, and making the most profit it can (maximising profits), then in principle it has no reason to change what it's doing if you take away half its profits - its before-tax plan is still the best it can do. Neutrality in this case means careful attention to the detail of the tax code so the notion of profit for the tax corresponds to the notion of profit that the company seeks to maximise.

Counter examples - where prices don't reflect the true cost of something; so petrol pollutes, alcohol causes crime and illness and so on. Externalities - taxes are imposed to raise the price so it reflects the full 'social' cost of a thing. [FN] It's possible to argue that high incomes have social costs.

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

### Analysing The Results

[How to lie about taxes]
[Government Site]
Roles important
In what follows:

* Senior Civil Servant in the Finance Department - impartial, but working for the Government of the day. Should offer 'pure' economics advice subject to policy of the day. Misters are busy people, and may not have a technical background so don't drown them in detail;
* Special Advisor to the Finance Secretary - advice on 'lines to take', but also, does this policy fit with the Government's aims, are there any traps the ministers should be aware of?
* Special Advisor to the opposition - mirror-image - also, what should an alternative policy be?
* Journalist for a right-of centre popular newspaper - journalism is structured differently - top down. Emphasis on concrete examples: what does the change mean for *you*?
* Journalist for a sympathetic to the Govt broadsheet - may have more time & space for context than her red-top colleague.

None of these actors are in the business of "fake news". It is in none of their interests to report outright falsehoods, but they will report with a different emphasis and in different styles. It can be very instructive to put yourself in the shoes of someone you are personally unsympathetic to.    

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
