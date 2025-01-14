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

# ╔═╡ 80cd5f60-0830-4aa2-a42e-a34a2181f982
begin
    md"""
    ### Policy Analysis Using the Model
    """
end 

# ╔═╡ 1166faa9-1259-4bb7-8c3f-4a1674ef3bfe
begin
    md"""
    The users of microsimulation models include teachers, students, and interested members general public. We should definitely encourage this - the model you're using is intended as a small contribution to that. But for the most part users will be professions fulfilling some role in Government, Politics, Journalism or "Civil Society" more generally. It's worth considering these different roles a little, and in the sections that follow we'll invite you to assume some of these roles, and so look at our model's output from different angles.
    """
end 

# ╔═╡ 8f8e91a6-4a7f-4627-ac22-bbd4cb61ff9c
begin
    md"""
    This is the era of "Fake News", and in response Fact Checking services such as Full Fact[^FN_FULL-FACT] and The Ferret[^FN_FERRET] have sprung up to assign "True" or "False" to claims of all sorts, including the things we're studying here. But in fact in fiscal policy-making you very rarely see any outright lies, or even many serious mistakes. There's rarely any need: the world we're dealing with is so multi-faceted that there is a ways going to be *something* that tells the story that you want to tell, whatever your angle may be[^FN_LIE].
    """
end 

# ╔═╡ 785c2a54-1256-4b01-8fdd-c0882c4a654d
begin
    md"""
    So, lets consider the roles we'd like you to play:
    """
end 

# ╔═╡ 992547cc-6337-4be2-9eff-31ebcbadfaee
begin
    md"""
    * *A Senior Civil Servant in the Finance Department* You must try to be impartial, but you are working for the Government of the day. You should offer 'pure' economics advice, subject to policy of the day; it's for the minster's political advisors to knock down politically dangerous but economically sound ideas. Misters are busy people, and may not have a technical background so don't drown them in detail[^FN_GOVT];* *Special Advisor ('SPAD') to the Finance Secretary* - your job is to protect the minister, and to keep her on track with the Government's broad aims. You need to give advice on 'lines to take' - the best way to present the results of a policy, but also keep her aware of where the bodies are buried: are there any traps the ministers should be aware of, for example, vulnerable groups that will be made unavoidably worse off? And you need to shoot down politically dangerous ideas, wherever they originate from;* *Special Advisor to the opposition party* - is mirror-image: you need to *find* where the bodies are buried. You also need to think of policies of your own, though it's often wise to keep them fairly vague;* *A journalist for a right-of centre popular newspaper*. Your emphasis should on concrete examples: what does the change mean for *you*? (Where the 'you' in question is often some person or family that makes the point you want to make). A wider perspective can also be useful, but isn't the main priority;* *A journalist for a sympathetic to the Government broadsheet* - you may have more time and space for context than your red-top colleague;* *A researcher for an anti-poverty charity*. Your emphasis is obvious, but you need to balance lobbying for your charities cause with needlessly antagonising a government that you ultimately need to work with;* A researcher for an Employer's Organisation.
    """
end 

# ╔═╡ df3f5ad7-8948-445f-84b2-0f03a8fdacd2
begin
    md"""
    None of these actors are in the business of "fake news". It is in none of their interests to report outright falsehoods, but they will report with a different emphasis and in different styles. SPADs and Civil servants usually write in traditional essay style, arguing from premise to conclusion, whereas journalism is usually 'top down' with the most important, or shocking, things first. But in all cases, brevity is welcome.
    """
end 

# ╔═╡ Cell order:
# ╟─72c7843c-3698-4045-9c83-2ad391097ad8
# ╟─80cd5f60-0830-4aa2-a42e-a34a2181f982
# ╟─1166faa9-1259-4bb7-8c3f-4a1674ef3bfe
# ╟─8f8e91a6-4a7f-4627-ac22-bbd4cb61ff9c
# ╟─785c2a54-1256-4b01-8fdd-c0882c4a654d
# ╟─992547cc-6337-4be2-9eff-31ebcbadfaee
# ╟─df3f5ad7-8948-445f-84b2-0f03a8fdacd2

