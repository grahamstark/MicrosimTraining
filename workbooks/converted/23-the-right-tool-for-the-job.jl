### A Pluto.jl notebook ###
# v0.20.4

using Markdown
using InteractiveUtils

# ╔═╡ 2f08faea-0a93-416f-8fa7-c7d954953ff9
begin
	import Pkg
    # activate the shared project environment
    Pkg.activate(Base.current_project())
    # instantiate, i.e. make sure that all packages are downloaded
	Pkg.resolve()
    Pkg.instantiate()
	using MicrosimTraining
    PlutoUI.TableOfContents(aside=true)
end

# ╔═╡ d2e4a54c-fadc-4f97-8c39-e52498a362c8
begin
    md"""
    #### Picking the Right Tool for the Job
    """
end 

# ╔═╡ 14c8d327-8295-466f-8691-3f9bfc4237cf
begin
    md"""
    Up to this point in the course you've used Excel spreadsheets for all the activities that required calculations or drawing charts. But this model you're exploring this week is instead written in Julia, a high-level programming language, and you will interact with it through web forms embedded in this VLE. One of the key skills you'll need as an applied economist is the ability to pick an appropriate tool for the job at hand, so it's worth us briefly exploring this change of tack.
    """
end 

# ╔═╡ bb69bce5-559a-4dd3-9a7e-9331497d9eb0
begin
    md"""
    As you've seen throughout the course, spreadsheets are tremendously useful tools. But, like all tools, they are more appropriate for some tasks than others. Spreadsheets have been extensively studied[^FN_SPREADSHEETS] and it is known that they are especially error-prone when dealing with complex logic or large amounts of data. So, in your career as a professional economist, there may be times when you may want to reach for a different tool.
    """
end 

# ╔═╡ 4ebd7e0a-d60d-4d58-a304-92b8126ab59b
begin
    md"""
    Other tools that have been found useful in economics include:
    """
end 

# ╔═╡ 7ed4847d-ace6-4730-8da8-46311becc4b8
begin
    md"""
    * *pencil and paper*: economics has a large inventory of simple but powerful graphics that can be applied to many situations- supply and demand diagrams, IS/LM, budget constraints and many others. The ability to sketch these is a key skill for an applied economist;* *statistical packages*: these are large computer programs that are optimised to produce, for example, the linear regressions you encountered earlier in this week, and in the macroeconomics week. Examples commonly used in economics include [SAS](https://www.sas.com/en_gb/home.html), [SPSS](https://www.ibm.com/analytics/spss-statistics-software) and [Stata](https://www.stata.com/). Excellent free statistical packages are [R](https://www.r-project.org/) and [Gretl](http://gretl.sourceforge.net/), amongst others;* *databases*: these are specialised programs that allow modelling, retrieval and update of large amounts of complex data. Examples include [Postgres](https://www.postgresql.org/) and [Oracle](https://www.oracle.com/database/). Systems specialised in the fast processing of 'Big Data' are now appearing; an example is [Apache Hadoop](http://hadoop.apache.org/);* *high-level programming languages*: these are designed to express complex logic, such as the rules of the tax system, in a clear and efficient way. Examples that are widely used in economics include [Fortran](https://en.wikipedia.org/wiki/Fortran), [Python](https://www.python.org/) and [Julia](https://julialang.org/).
    """
end 

# ╔═╡ 987a3ef8-5993-49b4-a4f8-b3d8218644a4
begin
    md"""
    Sometimes large projects use many different tools, organised as *toolchains*; for example, a database to accumulate and retrieve data, a programming language to process it, and a spreadsheet to display the results.
    """
end 

# ╔═╡ 4b5dccff-0d9d-4596-9ec4-01bd3e0c0927
begin
    md"""
    Although it's good to be aware of the options, it's impossible for a single person to master all of these things. But there may come a time in a large project where the best course is to employ a specialist, or to learn a new skill yourself - professional economists would normally be expected to know at least one statistical package, for instance.
    """
end 

# ╔═╡ Cell order:
# ╠═2f08faea-0a93-416f-8fa7-c7d954953ff9
# ╟─d2e4a54c-fadc-4f97-8c39-e52498a362c8
# ╟─14c8d327-8295-466f-8691-3f9bfc4237cf
# ╟─bb69bce5-559a-4dd3-9a7e-9331497d9eb0
# ╟─4ebd7e0a-d60d-4d58-a304-92b8126ab59b
# ╟─7ed4847d-ace6-4730-8da8-46311becc4b8
# ╟─987a3ef8-5993-49b4-a4f8-b3d8218644a4
# ╟─4b5dccff-0d9d-4596-9ec4-01bd3e0c0927
