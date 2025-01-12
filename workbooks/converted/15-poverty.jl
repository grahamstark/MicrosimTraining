### A Pluto.jl notebook ###
# v0.20.4

using Markdown
using InteractiveUtils

# ╔═╡ 72c7843c-3698-4045-9c83-2ad391097ad8
begin
	import Pkg
    # activate the shared project environment
    Pkg.activate(Base.current_project())
    # instantiate, i.e. make sure that all packages are downloaded
	# Pkg.resolve()
    # Pkg.instantiate()
	using MicrosimTraining
    PlutoUI.TableOfContents(aside=true)
end

# ╔═╡ 2f1830dd-9fe5-4761-9e67-e5b0fdfc827e
begin
    md"""
    ### Poverty
    """
end 

# ╔═╡ f6268fb0-153a-4dca-89af-c9164e139a55
begin
    md"""
    #### Poverty Standards
    """
end 

# ╔═╡ ce898d4e-5df3-4aa5-9633-8104f0a63a2a
begin
    md"""
    For our purposes, those in poverty are those whose command over resources falls below some minimum acceptable standard. To make this operational - something we can measure, and design programmes to alleviate - we need to establish what this minimum is - our poverty line. In reality there is no single objective point above which people have an acceptable standard of life, and below which they do not; rather there is a continuum. Stress levels, for example, worsen steadily the poorer people get[^FN_STRESS], rather than jumping sharply at some point. There are a variety of ways we could define such a standard; discussing these at length would take us off-topic, but an interesting recent approach is to use focus groups to gauge public opinion on what an acceptable minimum standard might be[@hirsch_cost_2019]. And, as we've briefly noted, there are also multi-dimensional standards - recently the Social Metrics Commission has proposed one such for the UK [@social_metrics_commission_social_2019]. But, for now, it's enough that an official poverty line exists - for the UK, since 1991 it's been defined 2/3rds of median equivalised household income ]. This is the Households Below Average Income (HBAI) measure[^FN_HBAI_2]; looking back at figure 1, this is the line marked "£304pw" to the left of the chart; you can see straight away that, since the line falls towards the top of the second decile, about 18% of the population is in poverty on that measure.
    """
end 

# ╔═╡ 7caeb8eb-fcac-4d70-98d0-36eb46b38161
begin
    md"""
    
    """
end 

# ╔═╡ 7decc835-553d-4f1b-8cc4-a2128b79c644
begin
    md"""
    #### Absolute and Relative Poverty
    """
end 

# ╔═╡ 22611b02-93b6-4e0f-bf32-db4c9c657efe
begin
    md"""
    Because the HBAI line is defined using the income of the year in question,  it drifts up or down each year as median incomes rise and fall: it's a "relative poverty line". Indeed, poverty alleviation programmes will themselves change median incomes, and hence change the poverty line. For some purposes, therefore, we might also want to measure poverty against some unchanging standard: "absolute poverty". This can be done by picking an HBAI line for some reference year and, after adjusting it for price changes, applying it to subsequent years.
    """
end 

# ╔═╡ 686ca8dd-70de-4c27-bc37-687080bf7ed5
begin
    md"""
    #### Aggregate  Measures of Poverty
    """
end 

# ╔═╡ a9a0ea76-e590-422b-a3c7-690ac75c2502
begin
    md"""
    Once we have a poverty line, we can use our survey data to estimate the level of poverty in our society, and when we come to our microsimulation model in the next section we can estimate how policy changes would change that level. The obvious way to do this simply to count the number of people below the poverty line - a 'Headcount' measure - and that is indeed what the official HBAI statistics do.
    """
end 

# ╔═╡ 87519625-80ab-4cf3-a28f-78d665c39077
begin
    md"""
    There is a problem with Headcounts, however, especially when we come to designing anti-poverty programmes. Consider someone with income just below the poverty line -Alice, on (say) £303pw - and someone far below the line - Bob on £203pw. Cut Bob's benefits by £2 and use the money to pay for a £2 increase for Alice. Alice is now above the poverty line, so is removed from the poverty headcount. Bob is further below the poverty line but still counts for one on the headcount measure. So we have reduced the poverty headcount by transferring money from a very poor person to a richer (though still quite poor) person.  This is not just an academic point - some significant reforms to the benefit system have had exactly this effect [^FN_FOWLER], cutting support benefits for those on very low incomes and increasing support for the 'near-poor'. And targets for poverty reduction, such as those in the Scottish Government's recent Child Poverty Bill [^FN_SCOTTISH_CHILD] are always more easily attained by targetting the near-poor than the very poor.
    """
end 

# ╔═╡ deafe701-5b66-46f8-83c5-3b8b4df7233a
begin
    md"""
    It would therefore be good to have a poverty measure that never improves when we transfer money from a poorer person to a richer one - the idea that measures of poverty or inequality should never improve from an upward transfer is known as *Dalton's Principle*[^FN_DALTON].
    """
end 

# ╔═╡ be927579-28a5-42a3-a80a-c11bc309aa7e
begin
    md"""
    One obvious thing to do is to consider how far below the poverty line Alice and Bob are - Alice starts £1 below, and Bob £100. This leads to the poverty gap measure - summing up all the gaps for everyone gives the minimum amount that would have to be spent to eliminate poverty, if spending was perfectly targetted on the poor. (Poverty gaps are usually expressed as a fraction of the poverty line, so Alice's gap is 1/304 ≈ 0.003 and Bob's 100/304 ≈ 0.328). The poverty gap is useful, but still violates Dalton's principle - to see this, suppose now Bob was in the same position as before, but Alice started £50 below the poverty line.  The poverty gap is therefore £150 in total. Our transfer upwards of £2 from Bob to Alice makes no difference at all to this poverty gap - it's still £150, just distributed differently - £152 for Bob and £48 for Alice. So transfers upwards don't always worsen the poverty gap, again violating Dalton.
    """
end 

# ╔═╡ a6a7d1e5-08b3-4a86-9e0a-42d032b2bbed
begin
    md"""
    More sophisticated measures exist that do not violate Dalton's principle. The most commonly used is the Foster-Greer-Thorndyke measure[^FN_FGT] - sometimes known as the 'Poverty Severity Index'. This takes the proportional gaps, squares them, and then sums them - squaring the gaps means that the large gaps of very poor people like Bob become much more important in the final sum than small gaps of near-poor people like Alice. So our FTG measure for Alice and Bob would be 0.003^2 + 0.0328^2 ≈ 0.001. It can be shown mathematically that this measure can never be improved by an upwards transfer.
    """
end 

# ╔═╡ 1e68c0b7-9021-4f0d-bfe0-1cd4e356d840
begin
    md"""
    ##### ActivityOpen [this spreadsheet](/activities/activity_4.xlsx)
    """
end 

# ╔═╡ 6f3b78c2-deee-4fd7-918b-c92f62529556
begin
    md"""
    It contains data on the incomes of eight people from two small countries.  Country A has a poverty line of 200, and country B 150.
    """
end 

# ╔═╡ 191937f6-d30e-4795-b295-45ca1b16be08
begin
    md"""
    I've calculated the poverty headcount, poverty gap and poverty severity index for country A.
    """
end 

# ╔═╡ 38786493-3fa4-42d7-a9d2-36212c419e96
begin
    md"""
    Your tasks are:
    """
end 

# ╔═╡ 6f9fa234-01f7-4d6b-bf61-0a2195f5407d
begin
    md"""
    1	Fill in the poverty calculations for country B, in the same way as for country AAnswer:<table><tr><td></td><td>1</td><td>2</td><td>3</td><td>4</td><td>5</td><td>6</td><td>7</td><td>8</td><td>Poverty Measure</td><td><b><br></b></td></tr><tr><td>Income </td><td>100</td><td>120</td><td>149</td><td>151</td><td>201</td><td>220</td><td>230</td><td>250</td><td><br></td><td><b><br></b></td></tr><tr><td>In Poverty (1=yes,0=no)</td><td>1</td><td>1</td><td>1</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0.375</td><td><b>Poverty Headcount</b></td></tr><tr><td>Poverty Gap</td><td>50</td><td>30</td><td>1</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td></td><td><b><br></b></td></tr><tr><td>Gap/Poverty Line</td><td>0.3333333333</td><td>0.2</td><td>0.0066666667</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0.0675</td><td><b>Poverty Gap</b></td></tr><tr><td>Poverty Severity</td><td>0.1111111111</td><td>0.04</td><td>0.00004444</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0.0188944444</td><td><b>Poverty Severity</b></td></tr></table>(note that the numbers here may differ from yours slightly because of rounding)2.	experiment with the effects of transfers: can you find an example of an upwards transfer that violates Dalton’s principle for some of the poverty measures? Answer: for country A, an example would be:- take 1 away from person 3 and give it to person 4. Person 4 now has 200, and so is no longer in poverty, but person 1 has 149.the poverty *level* falls to 0.375 and the poverty *gap* remains unchanged at 0.144375, but poverty *severity* **increases** to 0.059378125
    """
end 

# ╔═╡ afd6dac0-c21a-4c12-ae1a-bf52da6cadc5
begin
    md"""
    #### More sophisticated Measures
    """
end 

# ╔═╡ 7572eba0-24c7-40b4-8764-f466c8124a22
begin
    md"""
    Even more sophisticated measures of poverty exist; for example, a measure proposed by Amartya Sen [^FN_SEN_POV] combines a measure of poverty with a measure of inequality amongst the poor (we come to inequality next).
    """
end 

# ╔═╡ Cell order:
# ╟─72c7843c-3698-4045-9c83-2ad391097ad8
# ╟─2f1830dd-9fe5-4761-9e67-e5b0fdfc827e
# ╟─f6268fb0-153a-4dca-89af-c9164e139a55
# ╟─ce898d4e-5df3-4aa5-9633-8104f0a63a2a
# ╟─7caeb8eb-fcac-4d70-98d0-36eb46b38161
# ╟─7decc835-553d-4f1b-8cc4-a2128b79c644
# ╟─22611b02-93b6-4e0f-bf32-db4c9c657efe
# ╟─686ca8dd-70de-4c27-bc37-687080bf7ed5
# ╟─a9a0ea76-e590-422b-a3c7-690ac75c2502
# ╟─87519625-80ab-4cf3-a28f-78d665c39077
# ╟─deafe701-5b66-46f8-83c5-3b8b4df7233a
# ╟─be927579-28a5-42a3-a80a-c11bc309aa7e
# ╟─a6a7d1e5-08b3-4a86-9e0a-42d032b2bbed
# ╟─1e68c0b7-9021-4f0d-bfe0-1cd4e356d840
# ╟─6f3b78c2-deee-4fd7-918b-c92f62529556
# ╟─191937f6-d30e-4795-b295-45ca1b16be08
# ╟─38786493-3fa4-42d7-a9d2-36212c419e96
# ╟─6f9fa234-01f7-4d6b-bf61-0a2195f5407d
# ╟─afd6dac0-c21a-4c12-ae1a-bf52da6cadc5
# ╟─7572eba0-24c7-40b4-8764-f466c8124a22

