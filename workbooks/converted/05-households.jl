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

# ╔═╡ 1193cff9-59ad-4b9b-ae74-4171429d0739
begin
    md"""
    ### Individuals, Families and Households
    """
end 

# ╔═╡ 44df9732-e4c8-4ba0-8b27-fdee7c35ccce
begin
    md"""
    The HBAI graph we discussed earlier shows the distribution of incomes of individual people, and almost all of what follows is about the welfare of individuals. But people are social beings. Most people live in households (those living alone can be thought of one-person household). Others live in other arrangements: prisons, communes, barracks, care homes and the like, but, as we've seen, these are typically out of scope of our datasets.
    """
end 

# ╔═╡ 559f16f9-7b0d-4553-be75-4f3903457430
begin
    md"""
    The ONS define a household as follows:
    """
end 

# ╔═╡ fde44f6d-5b38-43e5-8576-ea6227184389
begin
    md"""
    > A household comprises of 1 person living alone or a group of people (not necessarily related) living at the same address who: share cooking facilities and share a living room or sitting room or dining area[^FN_HH_DEF]
    """
end 

# ╔═╡ 5359507c-c6c0-4df5-a984-c8bd470fab48
begin
    md"""
    Note the need for shared facilities and shared rooms. The circumstances of the household as a whole affects the wellbeing of each individual member. There are two main issues here:
    """
end 

# ╔═╡ 19b8cb9a-420e-4911-bceb-23217bae5cac
begin
    md"""
    1. Larger households might be more efficient than small ones. A two person household might not need twice the income of a one- person household to have the same standard of living. It's cheaper to buy food in bulk,  household might need only one fridge or cooker regardless of how large it is, and so on. Also member of larger households might be able to specialise, for example in paid or unpaid work;2. household members might not get an equal share of what's available.
    """
end 

# ╔═╡ d1d8a9c8-1a24-4594-a0d2-2b9df4d12da5
begin
    md"""
    We'll consider these in turn.
    """
end 

# ╔═╡ e9083d7a-2256-437c-802e-8c6236d267ac
begin
    md"""
    #### Equivalence Scales
    """
end 

# ╔═╡ fe52db99-c748-4191-815a-73891b830d12
begin
    md"""
    A scale that reflects the different needs and capabilities of households of different sizes is known as an *equivalence scale*. If households didn't get more efficient with size, and everyone had the same needs, then the equivalence scale would simply be 1 for a single person household, 2 for a two-person household and so on. If there are economies of scale, the numbers might be 1 for a single 1.5 for two-person, 1.8 for three. The scale might be lower for multi-person households with children, but higher for households with disabled or very elderly members.
    """
end 

# ╔═╡ b3a6565c-fb07-47ed-b7da-a4938199861d
begin
    md"""
    You divide observed household income by the relevant scale to get *equivalised income* of the household, which is a measure of average wellbeing of the individual members. Recall that the HBAI figures we saw earlier use equivalised income[^FN_HBAI_METHODS].
    """
end 

# ╔═╡ 73548148-93ca-451b-a149-dbc6cfda2410
begin
    md"""
    Where might we get such a scale? There is an equivalence scale implicit in some state benefits; for example, here are the scale rates for Job Seeker's Allowance, a benefit paid to low-income families:
    """
end 

# ╔═╡ 39b8fceb-3541-42e0-876e-8600cfd757f9
begin
    md"""
    type                    |  £ per week |  proportion of single person------------------------|-------------|-------Single Person (age 25+) |  73.10      |  1.0Couple                  |  114.85     |  1.57Child                   |  66.90      |  0.91
    """
end 

# ╔═╡ 1a2fca1e-e403-4939-8f07-fc9d41c4196c
begin
    md"""
    From this, you can see that if the scale for a single adult was 1.0, a 2 adult household would be 1.57, and a a two adult, one child household 2.48 (`1.57+0.91`).
    """
end 

# ╔═╡ 50a2347c-2e6f-436b-a463-44e969e9eeed
begin
    md"""
    However, these benefit amounts must themselves have come from somewhere. Can we derive and equivalence scale from first principles? One approach uses the regression techniques you learned in the previous week and the Living Costs and Food Survey I mentioned last time. The approach here dates back over 150 years, to the first ever systematic budget surveys, carried out in Germany by Ernst Engel. Engel was studying how shares of expenditure on different goods varied with income, and with family size [^FN_ENGEL]. He noticed two things:
    """
end 

# ╔═╡ b67aad56-3a9a-489a-a54e-6b0dcb844b26
begin
    md"""
    1. although on average rich families spent more on food than poor ones, rich families spent a smaller share of their income on food than poor families;2. larger families had a larger share of spending on food than smaller families with the same income.
    """
end 

# ╔═╡ c84a840c-07d5-4ffd-9537-7646fa0c8d92
begin
    md"""
    Taken together, these give us to a simple strategy to estimates equivalence scales: households of different sizes have the same well being on average when their share of spending on food is the same.
    """
end 

# ╔═╡ bc5e81fb-bb9e-43fe-acbe-cda3ca3075c4
begin
    md"""
    Figure XX illustrates one way of doing this, using the 2017/8 edition of the Living Costs and Food Survey (LCF) we discussed last time.
    """
end 

# ╔═╡ 436e1d72-a975-48ab-a618-f3fe91836fd3
begin
    md"""
    I've plotted total spending by each household on the x- axis against the share of food in total spending on the y- axis. Each dot represents spending by one household. I've grouped the LCF households into those with children (marked in <span style='color:#ff762e'>orange</span>), and those without children (in <span style='color:#007aaf'>blue</span>). The two solid lines show the average food consumption at each level of total consumption for our two classes of household - these are known as *Engel Curves*[^FN_ENGEL]. The curves are computed using the regression techniques you studied in the macroeconomics week[^FN_BANKS].
    """
end 

# ╔═╡ 3bbb19b5-56b5-422a-a589-1ab4f630e2d2
begin
    md"""
    You can see that, although there is a good deal of variation, the patterns Engel observed 150 years ago are there in this dataset.
    """
end 

# ╔═╡ ab5155ca-1563-441c-88a3-57a9e4f2c30a
begin
    md"""
    ![Source: author's calculations using 2017/8 Living Costs and Food Survey](./images/food_and_drink_engel_curve.png)
    """
end 

# ╔═╡ 8f1236e7-352e-4803-b8cb-d53b34956ac7
begin
    md"""
    Now we can calculate an empirical equivalence scale. Pick some share of food spending - a good one might be the median food share (11.6%). That's the dashed horizontal line.  Then we look up on the Engel curves the level of total spending the two groups would on average need for this share. These are the points A and B on the diagram -  for households with children, this is £747.90 (point B) and for those without, it's £525.38 (A). The ratio between these is 1.423, which is our simple equivalence scale: our estimate is that families with children need 42% more spending than families without to enjoy the same standard of living.
    """
end 

# ╔═╡ f1582579-bd0c-4297-b5fa-cbb227f29316
begin
    md"""
    A full analysis would do almost every aspect of this differently. You would want to allow for different household sizes and compositions, not just the presence or otherwise of children, and perhaps also other factors such as age, disability and the like. Nonetheless, I hope this shows you how a little bit of theory and a good dataset can be used to produce useful things in a straightforward manner. Much of the work of empirical economists, especially in the public sector, consists of doing simple exercises like this.
    """
end 

# ╔═╡ 40da95e8-869f-48d3-baba-a70a9a6ff844
begin
    md"""
    The HBAI data we looked at earlier is equivalised using the *Modified OECD Scale*[^FN_OECD_1], which is as follows:
    """
end 

# ╔═╡ c6754b38-081a-4e53-9e87-ca1a7c37890f
begin
    md"""
    type                   | proportion of single person-----------------------|-------------One Adult              |  1.0Two Adults             |  1.5Two Adults, 1 child    |  1.8Two Adults  2 children |  2.1Two Adults  3 children |  2.4
    """
end 

# ╔═╡ f40c0bca-0bdf-4848-baf7-227144d93109
begin
    md"""
    and so on, with an extra 0.5 for each extra adult, and an extra 0.3 for each extra child (the OECD defines a child is someone aged 13 or under). The OECD scale is a standard scale used in many countries [^FN_OECD_2].
    """
end 

# ╔═╡ 531f57f4-a7dd-4c33-a881-cbb929c3d71a
begin
    md"""
    ##### Activity
    """
end 

# ╔═╡ 675ae234-08b1-416f-8099-4f0b71b51f2d
begin
    md"""
    For this activity, we invite you to explore the LCF dataset we've just been using.
    """
end 

# ╔═╡ a7f9c737-c31f-4a8d-b17f-2374f2ccec04
begin
    md"""
    Download [our subset of the 2017/8 Living Costs and Food Survey data](/activities/activity_3.xlsx) and its [associated documentation](/activities/activity_3_coding_frame.docx). The dataset contains a small subset of the information on 5,376 households, including spending broken down into 13 groups and some demographic information (a few households with very extreme values have been deleted). Full details of the dataset are in the coding frame.
    """
end 

# ╔═╡ e710b8b9-2bf4-45c8-982f-b9fe22f877f1
begin
    md"""
    Mostly, these are not activities with a single right answer; instead, we invite you to explore the data using either Excel or any other tool you are familiar with. Questions 2,3 and 5 are especially difficult and you should feel under no pressure to attempt them.
    """
end 

# ╔═╡ 8182a24f-e4f5-41e3-b0b5-d227e1a68845
begin
    md"""
    1. generate shares of each expenditure group in total spending (note there are two different definitions of total spending in the dataset);2. explore the relationship between the share (or level) of spending on each good and total spending or household income. You could do this by drawing scatter plots or, if you are ambitious, estimating your own Engel curves **FIXME HOW DO YOU DO RUN A REGRESSION IN EXCEL?**. For this you'd need to generate a column with the logarithm of total spending ;ANSWER: The complete set of Engel Curves for this dataset is as follows:<table><tr><td><img src='/images/share_food_and_drink_single.png' alt='Engel curve'/></td><td><img src='/images/share_alcohol_tobacco_single.png' alt='Engel curve'/></td></tr><tr><td><img src='/images/share_housing_single.png' alt='Engel curve'/></td><td><img src='/images/share_communication_single.png' alt='Engel curve'/></td></tr><tr><td><img src='/images/share_non_consumption_single.png' alt='Engel curve'/></td><td><img src='/images/share_education_single.png' alt='Engel curve'/></td></tr><tr><td><img src='/images/share_recreation_single.png' alt='Engel curve'/></td><td><img src='/images/share_clothing_single.png' alt='Engel curve'/></td></tr><tr><td><img src='/images/share_miscellaneous_single.png' alt='Engel curve'/></td><td><img src='/images/share_transport_single.png' alt='Engel curve'/></td></tr><tr><td><img src='/images/share_restaurants_etc_single.png' alt='Engel curve'/></td><td><img src='/images/share_health_single.png' alt='Engel curve'/></td></tr><tr><td><img src='/images/share_household_goods_single.png' alt='Engel curve'/></td><td></td></tr></table>3. explore how spending on some good appears to vary for different groups. You could do this by sorting the data on economic position of the head, tenure type, or region, and then computing means and medians for subgroups;4. an alternative to Engel's method for computing equivalence scales is Barten's Method[^FN_BANKS_2], which proposes that families with and without children have the same standard of living when they have the same *level* of spending on *adult goods*.What problems do you see in applying Barten's method to this dataset?ANSWER: a) it's hard to define "adult goods" and it would be impossible to identify them in this dataset. The only obvious candidate is the "alcohol and tobacco" group, but there are problems with that group: we know from last time that spending on these things is under-reported, and in our data many people report not spending anything at all on these things, which makes fitting a linear relationship problematic;5. A very ambitious activity might be to actually calculate rough equivalence scales using Barten's method. You could assume the alcohol and tobacco group is representative of "adult goods". Alternatively, try sketching out what you thing the equivalent of the Engel analysis above might look like.ANSWER: should look something like:![Barten Example](./images/barten_example.png)Note that here we've dealt with the large number of zeros simply by deleting them, estimating instead over only those households who consume these goods. Since we're interested in the *level* of spending we've estimated a linear Engel curve. The implied equivalence scale is approximately 1.64.
    """
end 

# ╔═╡ d88f9857-0b29-4e45-bfb1-ff7608c12d45
begin
    md"""
    ##### End activity
    """
end 

# ╔═╡ 670066d2-1532-4c38-8b60-61e70220ac2d
begin
    md"""
    
    """
end 

# ╔═╡ 57ce1e6a-b7fd-4577-961b-4bf48c9111c6
begin
    md"""
    #### Unequal distribution within households
    """
end 

# ╔═╡ 276d7947-6ee9-4889-83ab-101f504f6a04
begin
    md"""
    Once we've equivalised our household incomes, we need to assign it to household member. Typically we just assign give everyone the average household income. But this ignores the possibility of discrimination by gender, or other characteristics such as age or disability.
    """
end 

# ╔═╡ 0b4c082f-7b3b-43f2-8463-cef43a7ce789
begin
    md"""
    Making a different assumption requires somehow looking inside households to infer how sharing of goods and the allocation of tasks actually works in practice[^FN_DEATON_CASE]. In principle can use our budget surveys to examine this question, using variants of the approach above. If we can identify specifically male, female-, or children's goods in our survey (clothing might be an example), then we can measure how spending on these vary between, for example, households where women have significant income of their own (through work or perhaps benefit payments), and households where all the income accrues to men. Alternatively, we could look at health or education outcomes - is shifting income between men and women associated with improvements in female health or school enrolment?  There have been many studies, and the evidence seems mixed[^FN_MIXED]. Consumption based studies tend to find no effect, whilst studies of health and education outcomes often show better outcomes in cases where incomes shifted from men to women.
    """
end 

# ╔═╡ adb55592-cc54-47f7-b458-bcbb79efe64c
begin
    md"""
    #### Benefit Units
    """
end 

# ╔═╡ Cell order:
# ╟─72c7843c-3698-4045-9c83-2ad391097ad8
# ╟─1193cff9-59ad-4b9b-ae74-4171429d0739
# ╟─44df9732-e4c8-4ba0-8b27-fdee7c35ccce
# ╟─559f16f9-7b0d-4553-be75-4f3903457430
# ╟─fde44f6d-5b38-43e5-8576-ea6227184389
# ╟─5359507c-c6c0-4df5-a984-c8bd470fab48
# ╟─19b8cb9a-420e-4911-bceb-23217bae5cac
# ╟─d1d8a9c8-1a24-4594-a0d2-2b9df4d12da5
# ╟─e9083d7a-2256-437c-802e-8c6236d267ac
# ╟─fe52db99-c748-4191-815a-73891b830d12
# ╟─b3a6565c-fb07-47ed-b7da-a4938199861d
# ╟─73548148-93ca-451b-a149-dbc6cfda2410
# ╟─39b8fceb-3541-42e0-876e-8600cfd757f9
# ╟─1a2fca1e-e403-4939-8f07-fc9d41c4196c
# ╟─50a2347c-2e6f-436b-a463-44e969e9eeed
# ╟─b67aad56-3a9a-489a-a54e-6b0dcb844b26
# ╟─c84a840c-07d5-4ffd-9537-7646fa0c8d92
# ╟─bc5e81fb-bb9e-43fe-acbe-cda3ca3075c4
# ╟─436e1d72-a975-48ab-a618-f3fe91836fd3
# ╟─3bbb19b5-56b5-422a-a589-1ab4f630e2d2
# ╟─ab5155ca-1563-441c-88a3-57a9e4f2c30a
# ╟─8f1236e7-352e-4803-b8cb-d53b34956ac7
# ╟─f1582579-bd0c-4297-b5fa-cbb227f29316
# ╟─40da95e8-869f-48d3-baba-a70a9a6ff844
# ╟─c6754b38-081a-4e53-9e87-ca1a7c37890f
# ╟─f40c0bca-0bdf-4848-baf7-227144d93109
# ╟─531f57f4-a7dd-4c33-a881-cbb929c3d71a
# ╟─675ae234-08b1-416f-8099-4f0b71b51f2d
# ╟─a7f9c737-c31f-4a8d-b17f-2374f2ccec04
# ╟─e710b8b9-2bf4-45c8-982f-b9fe22f877f1
# ╟─8182a24f-e4f5-41e3-b0b5-d227e1a68845
# ╟─d88f9857-0b29-4e45-bfb1-ff7608c12d45
# ╟─670066d2-1532-4c38-8b60-61e70220ac2d
# ╟─57ce1e6a-b7fd-4577-961b-4bf48c9111c6
# ╟─276d7947-6ee9-4889-83ab-101f504f6a04
# ╟─0b4c082f-7b3b-43f2-8463-cef43a7ce789
# ╟─adb55592-cc54-47f7-b458-bcbb79efe64c

