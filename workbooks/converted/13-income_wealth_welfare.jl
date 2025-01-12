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

# ╔═╡ 1c8581bc-0013-45ad-bec4-95bd07f8ae96
begin
    md"""
    ### Poverty and Inequality of What? Income, Consumption and Beyond
    """
end 

# ╔═╡ ce4717be-c8ae-41cb-8e82-96cf460375d6
begin
    md"""
    #### Income vs Consumption
    """
end 

# ╔═╡ fcc1fda5-f960-45a0-8328-97d40015759f
begin
    md"""
    Up to now we've used the term 'income', without worrying about what exactly we mean by it, or whether income is really the best thing focus on.
    """
end 

# ╔═╡ 212476f2-fe6b-4618-ae55-8f9bc768a856
begin
    md"""
    You may well have a reasonable idea of your family's income. But it's notoriously difficult to find a definition of income that fits every case, and which can be made operational[^FN_MEADE].  To see the problem, consider Alice and Bob. They have steady jobs on the same monthly salary, so on the face of it the same income, but Bob knows he will come into a large inheritance on retirement and Alice knows she won't.  Clearly, Bob can enjoy a better lifestyle now than Alice, since Alice may have to divert much of her salary into pensions and savings. Likewise, compare Bob, on his steady income, with Cynthia, an Youtube sensation who has made a million this year but who worries about being replaced by the next big thing in a matter of months. In the eyes of the FRS, or indeed the tax authorities, Cynthia is by far the richer. But, if this is her one chance at success, can Cynthia really afford a lavish lifestyle?
    """
end 

# ╔═╡ ae027110-751a-4f80-a714-2f92f00e0fc6
begin
    md"""
    This naturally leads to the thought that *consumption* would a better thing to measure than income. The amount that Alice, Bob, and Cynthia are consuming could be a good indicator of their view of their sustainable, or *permanent* income. But in practice consumption has problems of its own. Consider durable goods: in any given month, you either buy a fridge or you don't, and in either case your spending on fridges is a poor indicator of your consumption of the service your fridge provides[^FN_KAY_KEEN]. So a comprehensive measure of consumption requires the imputation of some notional 'rental value' from all of a household's durable assets.
    """
end 

# ╔═╡ 3d11be44-33cd-4041-8969-b6759020ab45
begin
    md"""
    Housing is a particular problem in this regard, both for income and consumption measures. For those who own their houses, an 'imputed rent' would for many people be the largest element in their income, and, as can be seen from the frequent disputes over house valuations for local taxes, it can be very difficult to agree on what such a rental value should be. Many renters may have little or no choice about how much they pay. It's hard to tell whether rising rents reflect better quality housing, or simply a situation renters can't escape from. For these reasons, our official poverty and inequality measures are offered in before- and after- housing cost versions[^FN_RENT].
    """
end 

# ╔═╡ 46390082-d2a1-41ff-93f6-74a21296ce74
begin
    md"""
    Most studies of the poverty Developing World measure consumption rather than income, for a related but distinct reason - small farmers, sharecroppers and  peasants may well consume much of what they produce, only selling some, so any measure of cash income may well understate their wellbeing.
    """
end 

# ╔═╡ b212c82a-d74a-4326-b89d-76f7588242ae
begin
    md"""
    ##### Activity
    """
end 

# ╔═╡ 86db8d66-124e-4ed9-87e7-e2fbb3f59414
begin
    md"""
    Reopen the [LCF subset you used in the Equivalence Scale Activity](/activities/activity_3.xlsx). As well as the consumption data you explored then, it also contains a weekly income variable (`weekly_net_inc`). Try exploring the relationship between total spending and income. Are there any interesting patterns you can find?
    """
end 

# ╔═╡ 40308ee0-4e66-4be5-ae8e-76f145f28720
begin
    md"""
    Answer:
    """
end 

# ╔═╡ b83e3ed2-ba0a-44a3-9ffd-cb80cfb62d98
begin
    md"""
    Here are some scatterplots of consumption against income, broken down by the economic position of the household head. There seem to be a number of cases where recorded consumption seems much higher than recorded income. The point above about durables might account for some of this, or perhaps there is under-reporting of some incomes - it's noticeable that there is a lot of variation for the self-employed, a group I highlighted earlier as having expecially unreliable income data.
    """
end 

# ╔═╡ e66a032e-fb19-490f-81e9-6b90accd4a66
begin
    md"""
    ![Scatterplots of income vs consumption](./images/activity_5.png)
    """
end 

# ╔═╡ b928a5f0-bd6d-44e5-a690-a3e2c68fcf54
begin
    md"""
    #### Incomes over Time
    """
end 

# ╔═╡ 57ebdb22-57d1-400c-bc65-10e539a4c62e
begin
    md"""
    The differing fates of Alice, Bob and Cynthia highlight the importance of considering the *intertemporal* nature of income and consumption. There are fewer steady jobs than there were in previous decades, but our surveys are mostly short-term; if they happened to pick Cynthia during her moment of fame she'll be recorded as very rich, and otherwise as very poor, whereas in reality if she's sensible she may have a modest but reasonable lifestyle for life. So our surveys be may mistake *instability* in income for inequality[^FN_BLUNDELL]. With the rise of the 'Gig Economy', it's possible that much of recorded poverty represents people flitting in and out of jobs rather than permanent poverty.
    """
end 

# ╔═╡ 5e2b1e6f-f3b4-43ee-973f-9fea2b4525dd
begin
    md"""
    There is another important intertemporal aspect: people likely start out as a net recipient of benefits (such as Child Benefit) and public spending on education and health. As they age, there's a good chance they become a net contributor through taxation, perhaps with a period as a net recipient if they have a family of their own, before receiving state pensions and perhaps social care towards the end of their life. So, you can view much of the tax-benefit system as adjusting a person's lifetime income rather than redistributing between groups. To capture this aspect a long-run multi-year model is needed; that's not what we're presenting here, but we'll briefly discuss such a model at the end of this week[^FN_HILLS].
    """
end 

# ╔═╡ 48fe89b7-0f8a-4948-85a1-a0685a1f6c53
begin
    md"""
    ####  Broader Indicators of Wellbeing
    """
end 

# ╔═╡ 6aed4292-9c4f-4096-bc63-53777b47f572
begin
    md"""
    Instead of single measures such as income or consumption, some advocate multi-dimensional measures. These attempt to condense measures of income, education, health and personal freedom into a single index. Examples of these are the 'capabilities framework' of  Amartya Sen[^FN_SEN], the United Nations Multidimensional Poverty Index[^FN_UN_MULTI] and, for the UK, the Social Metrics Commission Poverty Index[^FN_SOCIAL_METRICS]. These are appealing in some respects: reducing wellbeing to how much you earn, or how much you consume can seem distasteful, and, especially at the levels of countries or regions, it's certainly possible to have high incomes but poor outcomes for, say, health or education attainment. But there are problems with multidimensional indexes, too: if one aspect improves (health, say) but another worsens (education, perhaps), it's hard to say definitively that your index has gone up or down. And, although our main datasets have reasonably good data on many of the components of these indexes, in practice it can be very hard to operationalise these measures: as you'll see, we can predict quite accurately the effects of fiscal changes on incomes or consumption, but predicting the effect on health or education attainment is much harder.
    """
end 

# ╔═╡ 11e3122e-41f5-4687-8ce7-cb64995c4a57
begin
    md"""
    As well as these broad measures, there is sometimes concern about individual aspects; for example fuel poverty[^FN_FUEL-POV], food poverty[^FN_FOOD], and recently period poverty[^FN_PERIODS]. As with the multidimensional measures, it may be difficult to operationalise these - you might need to augment the model we're about to look at with a *demand system* - a model which predicts how consumption of (e.g.) domestic fuel varies with income and prices[^FN_DEMAND].
    """
end 

# ╔═╡ Cell order:
# ╟─72c7843c-3698-4045-9c83-2ad391097ad8
# ╟─1c8581bc-0013-45ad-bec4-95bd07f8ae96
# ╟─ce4717be-c8ae-41cb-8e82-96cf460375d6
# ╟─fcc1fda5-f960-45a0-8328-97d40015759f
# ╟─212476f2-fe6b-4618-ae55-8f9bc768a856
# ╟─ae027110-751a-4f80-a714-2f92f00e0fc6
# ╟─3d11be44-33cd-4041-8969-b6759020ab45
# ╟─46390082-d2a1-41ff-93f6-74a21296ce74
# ╟─b212c82a-d74a-4326-b89d-76f7588242ae
# ╟─86db8d66-124e-4ed9-87e7-e2fbb3f59414
# ╟─40308ee0-4e66-4be5-ae8e-76f145f28720
# ╟─b83e3ed2-ba0a-44a3-9ffd-cb80cfb62d98
# ╟─e66a032e-fb19-490f-81e9-6b90accd4a66
# ╟─b928a5f0-bd6d-44e5-a690-a3e2c68fcf54
# ╟─57ebdb22-57d1-400c-bc65-10e539a4c62e
# ╟─5e2b1e6f-f3b4-43ee-973f-9fea2b4525dd
# ╟─48fe89b7-0f8a-4948-85a1-a0685a1f6c53
# ╟─6aed4292-9c4f-4096-bc63-53777b47f572
# ╟─11e3122e-41f5-4687-8ce7-cb64995c4a57

