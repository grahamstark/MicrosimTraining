### A Pluto.jl notebook ###
# v0.20.4

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

# ╔═╡ cd1d2c4e-7f12-4f91-94ee-33e14708a53e
begin
	using Observables
end

# ╔═╡ 47bd5a91-c963-4fed-bbfd-2c3c28eaf366
using PlutoLinks: @use_task

# ╔═╡ b8b2c431-a18d-4b65-8207-8cc87e990ddf
using PlutoHooks: @use_state

# ╔═╡ 13946695-d509-4820-921d-9f1a23ea3ab0
using PlutoUI

# ╔═╡ 71065965-44d1-4e54-a739-6d21f0c59310
begin
	
struct SomeData
	a::Int
	b::Float64
	c::Char
	state :: String
end

observer = Observable( SomeData(-1,-1,'X', "unstarted") )

function do_long_thing( observer )
	observer[] = SomeData(-1,-1,'X', "starting") 
	for i in 1:1000_000_000
		a = rand(1:20)
		b = randn()
		c = rand('A':'Y')
		if(i % 10_000) == 0
			observer[] = SomeData(a,b,c, "running") 
		end
	end
	observer[] = SomeData(-1,-1,'X', "finished") 
end

const DEFAULT_SDATA = SomeData(-1,-1,'X', "unstarted")
global_sdata = deepcopy( DEFAULT_SDATA )
	
function obs_process( progress )
	global global_sdata
	global_sdata = deepcopy( progress )
	#=
	.a = progress.a
	global_sdata.b = progress.b
	global_sdata.c = progress.c
	global_sdata.state = progress.state
	=#
	# println( progress )
end

obsfuncc = on( obs_process, observer )

function get_data()
	global global_sdata
	return deepcopy( global_sdata )
end

end

# ╔═╡ e375bdc8-1198-47db-adf1-1e9cfb84af50
begin 
	@use_task([]) do
		do_long_thing( observer )
	end
end
	

# ╔═╡ aa6db828-4418-46e9-bc90-5036d267ffde
begin
	
some_data, set_some_data = @use_state( deepcopy( DEFAULT_SDATA ))
	
@use_task([]) do
	# capture the value of count in a new variable
	new_some_data = some_data
	# start the event loop
	while true # new_some_data.state != "finished" # new_count < 10
		# a,b,c = get_some_stuff()
		new_some_data = get_data()
		set_some_data(new_some_data) # <- update the value of count (this will trigger a re-run)
	end
end
Show(MIME"text/html"(), "<b>$(some_data.a) $(some_data.state)</b>" )

end

# ╔═╡ 1ce83536-9746-11ec-342a-9db71b8eba53
md"""
# `@use_task`

```julia
@use_task(f::Function, dependencies::Vector{Any})::Task
```

`@use_task` is a macro to run a function asynchronously without blocking the Pluto cell execution. The created task can be used to provide updates to the notebook asynchronously. `@use_task` has several advantages over simply creating a `Task` in your cell because it manages the task lifecycle automatically.

## Explicit runs & dependencies

It terminates the previous task when a new task is created by sending an `InterruptException` to the previous task. The previous task will be automatically replaced or terminated in the following cases:

 - If the cell containing the `@use_task()` call is **explicitely** run. An explicit run means that the "Run cell" button was pressed for this cell or that the code for this cell was edited. If the cell is run because it is dependent on a cell which was explicitely run, this is not an explicit run and will not replace the task.

 - If one of the value in the `dependencies` array parameter has changed, the task will be replaced. This can be useful if the task has some initialization to do and must be reset when a parameter has changed.

Let's try using `@use_task` for simple function that sleeps for 3 seconds:
"""

# ╔═╡ 4f1b81f4-5262-4063-a8ce-1ce7da56a69b
@use_task(() -> sleep(3), [])

# ╔═╡ 360c71c5-5f4e-4118-93af-e8fd3c3f163f
md"""
When trying this yourself, you can see the task starting by being:

```
Task (runnable) @0x00007f7e61e136b0
```

and then after 3 seconds, the cell will update because the task is done:

```
Task (done) @0x00007f7e61e136b0
```

!!! note
	Notice that the cell is surrounded in blue! This means that the cell is using features from [PlutoHooks.jl](https://github.com/JuliaPluto/PlutoHooks.jl) and some of its state will be reset on explicit runs.

Now, let's try to bind the sleep duration to a julia variable instead of hardcoding 3 seconds:
"""

# ╔═╡ 994ab3fa-35e0-41a2-9f24-60b5024c8008
@bind sleeping_time PlutoUI.Slider(1:10, show_value=true)

# ╔═╡ f5b08153-58b2-45d6-8882-f593caba70f4
# We use the Julia do end syntax here to pass a function as the first argument
@use_task([]) do
	sleep(sleeping_time)
end

# ╔═╡ e7a2f49e-3551-4185-bc16-21ec5b2ac252
md"""
The task is not recreated when the `sleeping_time` value changes! This is because we are not doing an explicit run here. The cell is run because the value of `sleeping_time` changed. We need to explicitely add `sleeping_time` as a dependency to reset the task when it has a new value:
"""

# ╔═╡ af6b1697-d127-4865-8347-e80c73e27194
@use_task([sleeping_time]) do
	#      ^^^^^^^^^^^^^
	#      sleeping_time is added as an explicit dependency
	sleep(sleeping_time)
end

# ╔═╡ 0e8057e7-3f69-4ed2-9fe1-d5af8e7e50ef
md"""
With the added dependencies, the task is not re-created every time the value of `sleeping_time` changes!
"""

# ╔═╡ 285fbc70-aa43-44f7-af1d-689545945261
md"""
## Long running tasks & notebook updates

Very often, one wants to do more than sleeping (in a task at least) and run code until an event happens. Let's build a Julia version of `PlutoUI.Clock()` which is a widget that ticks counts from 1 to X.
"""

# ╔═╡ 562c408c-717e-4686-8c03-b315e72050fa
function wait_until_event()
	sleep(1.)
end

# ╔═╡ f6ba42d5-8541-4c3d-95c2-3608a92a1874
function get_some_stuff()
	sleep(1)
	rand(), randn(), rand('A':'Z')
end

# ╔═╡ eb1ce3ae-47d9-436c-be84-8baa2d03879b
md"""
To trigger an update to the notebook from the current cell, the recommanded method is to use `@PlutoHooks.use_state()`. `@use_state` functions much like its React.js counterpart [`useState()`](https://reactjs.org/docs/hooks-state.html) (in Pluto, notebook cells play the role of React.js components) because it returns a tuple containing the state value and a callback to re-run the cell with an updated state. It takes only one argument which is the initial state value.
"""

# ╔═╡ 459f0704-5d59-4fde-bfa4-e3e2ff5d85c4
let
	# create a new state with a callback to update it
	count, set_count = @use_state(0.0)
	str, set_str = @use_state('0')
	@use_task([]) do
		# capture the value of count in a new variable
		new_count = count
		new_str = str
		# start the event loop
		while new_str != 'X' # new_count < 10
			a,b,c = get_some_stuff()
			new_count += a
			new_str = c
			set_str(new_str)
			set_count(new_count) # <- update the value of count (this will trigger a re-run)
		end
	end
	Show(MIME"text/html"(), "<b>$count $str</b>" )
end

# ╔═╡ d9619966-e61a-40fa-bd54-f9efb512f14d
md"""
## Reusing hooks

For reusing code using hooks, the easiest thing is to create a macro returning the code:
"""

# ╔═╡ 63a79fa0-366c-4edc-a79d-6a4a78d74ef6
macro use_clock()
	quote
		let
			count, set_count = @use_state(1)
			@use_task([]) do
				# capture the value of count in a new variable
				new_count = count

				# start the event loop
				while new_count < 10
					wait_until_event()
					new_count += 1
					set_count(new_count) # <- update the value of count (this will trigger a re-run)
				end
			end
			count
		end
	end
end

# ╔═╡ b893ec96-90d4-4131-8380-f4f15bc5cf40
@use_clock()

# ╔═╡ 553818c9-2258-4993-a44d-17df498adcd1
md"""
## Common problems

##### 1. The hook does not work

Make sure that the macro call is not inside a function definition. Hooks only work if they are at the top level. To reuse hooks, package them as macros instead of functions.

##### 2. Some values become `nothing` in the task function after a while

Because of how Pluto works internally to redefine consts and structs, it may override the value of variables captured by the task by `nothing`. To prevent this from happening, the variables captured should be deepcopied into local variables before entering the task:

```julia
begin
	local new_variable = deepcopy(variable)
	@use_task([variable]) do
		# use only new_variable here...
		new_variable
	end
end
```

Have one yourself that is not on this list? [Open a discussion](https://github.com/JuliaPluto/PlutoLinks.jl/discussions) or don't hesitate to send a message on the pluto-development Zulip channel.
"""

# ╔═╡ 4bbd2db5-2a21-45e1-8f19-0a0f9a3b56fa
md"""
#### Packages
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Observables = "510215fc-4207-5dde-b226-833fc4488ee2"
PlutoHooks = "0ff47ea0-7a50-410d-8455-4348d5de0774"
PlutoLinks = "0ff47ea0-7a50-410d-8455-4348d5de0420"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
Observables = "~0.5.5"
PlutoHooks = "~0.0.4"
PlutoLinks = "~0.1.4"
PlutoUI = "~0.7.35"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.2"
manifest_format = "2.0"
project_hash = "f6949ba82658445063ed21f43542934486d6edce"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "7eee164f122511d3e4e1ebadb7956939ea7e1c77"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.3.6"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "b6d6bfdd7ce25b0f9b2f6b3dd56b2673a66c8770"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.5"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "10da5154188682e5c0726823c2b5125957ec3778"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.38"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.6.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"
version = "1.11.0"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.7.2+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.11.0"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.LoweredCodeUtils]]
deps = ["JuliaInterpreter"]
git-tree-sha1 = "688d6d9e098109051ae33d126fcfc88c4ce4a021"
uuid = "6f1432cf-f94c-5a45-995e-cdbf5db27b0b"
version = "3.1.0"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.6+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.12.12"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Observables]]
git-tree-sha1 = "7438a59546cf62428fc9d1bc94729146d37a7225"
uuid = "510215fc-4207-5dde-b226-833fc4488ee2"
version = "0.5.5"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.27+1"

[[deps.OrderedCollections]]
git-tree-sha1 = "12f1439c4f986bb868acda6ea33ebc78e19b95ad"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.7.0"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.11.0"
weakdeps = ["REPL"]

    [deps.Pkg.extensions]
    REPLExt = "REPL"

[[deps.PlutoHooks]]
deps = ["InteractiveUtils", "Markdown", "UUIDs"]
git-tree-sha1 = "072cdf20c9b0507fdd977d7d246d90030609674b"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0774"
version = "0.0.5"

[[deps.PlutoLinks]]
deps = ["FileWatching", "InteractiveUtils", "Markdown", "PlutoHooks", "Revise", "UUIDs"]
git-tree-sha1 = "8f5fa7056e6dcfb23ac5211de38e6c03f6367794"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0420"
version = "0.1.6"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "eba4810d5e6a01f612b948c9fa94f905b49087b0"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.60"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "StyledStrings", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Revise]]
deps = ["CodeTracking", "FileWatching", "JuliaInterpreter", "LibGit2", "LoweredCodeUtils", "OrderedCollections", "REPL", "Requires", "UUIDs", "Unicode"]
git-tree-sha1 = "b5e7c125687aa818de948ef8a0b9dc59f043342c"
uuid = "295af30f-e4ad-537b-8983-00126c2a3abe"
version = "3.7.1"

    [deps.Revise.extensions]
    DistributedExt = "Distributed"

    [deps.Revise.weakdeps]
    Distributed = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"
version = "1.11.0"

[[deps.Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"

    [deps.Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

    [deps.Statistics.weakdeps]
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.StyledStrings]]
uuid = "f489334b-da3d-4c2e-b8f0-e476e12c162b"
version = "1.11.0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
version = "1.11.0"

[[deps.Tricks]]
git-tree-sha1 = "7822b97e99a1672bfb1b49b668a6d46d58d8cbcb"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.9"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.59.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╠═cd1d2c4e-7f12-4f91-94ee-33e14708a53e
# ╠═71065965-44d1-4e54-a739-6d21f0c59310
# ╠═e375bdc8-1198-47db-adf1-1e9cfb84af50
# ╠═aa6db828-4418-46e9-bc90-5036d267ffde
# ╠═1ce83536-9746-11ec-342a-9db71b8eba53
# ╠═4f1b81f4-5262-4063-a8ce-1ce7da56a69b
# ╠═360c71c5-5f4e-4118-93af-e8fd3c3f163f
# ╠═994ab3fa-35e0-41a2-9f24-60b5024c8008
# ╠═f5b08153-58b2-45d6-8882-f593caba70f4
# ╟─e7a2f49e-3551-4185-bc16-21ec5b2ac252
# ╠═af6b1697-d127-4865-8347-e80c73e27194
# ╟─0e8057e7-3f69-4ed2-9fe1-d5af8e7e50ef
# ╟─285fbc70-aa43-44f7-af1d-689545945261
# ╠═562c408c-717e-4686-8c03-b315e72050fa
# ╠═f6ba42d5-8541-4c3d-95c2-3608a92a1874
# ╟─eb1ce3ae-47d9-436c-be84-8baa2d03879b
# ╠═459f0704-5d59-4fde-bfa4-e3e2ff5d85c4
# ╟─d9619966-e61a-40fa-bd54-f9efb512f14d
# ╠═63a79fa0-366c-4edc-a79d-6a4a78d74ef6
# ╠═b893ec96-90d4-4131-8380-f4f15bc5cf40
# ╟─553818c9-2258-4993-a44d-17df498adcd1
# ╟─4bbd2db5-2a21-45e1-8f19-0a0f9a3b56fa
# ╠═47bd5a91-c963-4fed-bbfd-2c3c28eaf366
# ╠═b8b2c431-a18d-4b65-8207-8cc87e990ddf
# ╠═13946695-d509-4820-921d-9f1a23ea3ab0
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
