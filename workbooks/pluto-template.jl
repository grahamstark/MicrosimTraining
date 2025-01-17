### A Pluto.jl notebook ###
# v0.20.4

using Markdown
using InteractiveUtils

# ╔═╡ eeae2700-a78e-11ef-34c9-b3f7c1a464cb
begin
	import Pkg
    # activate the shared project environment
    Pkg.activate(Base.current_project())
    # instantiate, i.e. make sure that all packages are downloaded
	Pkg.resolve()
    Pkg.instantiate()
	using MicrosimTraining
	end

# ╔═╡ 6a8bc1bc-6b24-4c27-8451-1a99745355a6
data = CSV.File( artifact"main_data"*"/data/uk-lcf-subset-2005-6.csv" )|>DataFrame

# ╔═╡ 6ac93790-4249-4900-a249-6e94abdfc717
begin
load(artifact"main_data"*"/images/barten_example.png")
end

# ╔═╡ addaf191-0ad7-4538-aa79-7e6fa254beb9
begin
	N = 100_00
	fr(x::AbstractFloat) = Format.format(x,precision=2,commas=true)
	fr(x::Number) = "$x"
	fr(x) = x
end; # colon supresses output

# ╔═╡ c9592c35-ee61-4702-a93a-e392058658e5
PlutoUI.TableOfContents(aside=true)

# ╔═╡ d31bbdb2-0815-4132-aac2-0f529e5e926c


# ╔═╡ 135d4bcd-9000-48aa-b433-70864ba1be2e
begin
	r = BigInt(0)
	@progress for i in 1:N # 1:100_000_000
		global r
		r += rand(Int)
	end
	r
end

# ╔═╡ 34d686ff-d6b4-4c98-aa50-b1ad5cf5b318
begin
	mart = artifact"main_data"
	md"""
	![Thing]($(mart)/images/barten_example.png)
	"""
	load(mart*"/images/barten_example.png")
end

# ╔═╡ 29b7f120-94ff-4f56-a0c7-0373831bff2b
# ╠═╡ disabled = true
#=╠═╡
md"""
![Pluto (dwarf planet)](https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Pluto-01_Stern_03_Pluto_Color_TXT.jpg/1024px-Pluto-01_Stern_03_Pluto_Color_TXT.jpg)
"""
  ╠═╡ =#

# ╔═╡ 2701200a-86ca-4052-bbae-8d9722c0ce28
fr("100000")

# ╔═╡ 324a71e5-4416-4de6-a469-cab328aadebe
almost(
    md"You're right that the answer is a positive number, but the value isn't quite right."
)

# ╔═╡ 3e1f5775-ecd4-4e45-89a4-4027b132d1ce
if N == 100_000
	correct()
else
	keep_working()
end

# ╔═╡ 2fbac8f8-3ced-40e6-81b2-6a0b581bcd75
danger(md"Don't forget to commit your saved notebook to your repository.")

# ╔═╡ 74645ef7-8ce3-41fc-95e5-cfdb48f9903f
hint(md"It may be useful to make use of the identity $\sin \theta^2 + \cos \theta^2 =1$.")

# ╔═╡ 4e1616f9-90f1-4079-bdcf-54cab3aa928e
blockquote(
    "Logic will get you from A to B.  Imagination will take you everywhere.",
    md"-- A. Einstein",
)

# ╔═╡ e435bad3-3208-4cef-9ab3-feb50461a10c
Foldable("Want more?", md"Extra info")

# ╔═╡ f530f068-acc2-4a21-a309-427f00009cf0
answer_box(
	md"""
    The stone has a greater force becasue force is given by Newtons 2nd law: 

    ```math
    F=m \times a
    ```

    It has a greater mass, therefore $m$ is larger. This then results in a larger force $F$
    """
)

# ╔═╡ 6e13d906-c175-4624-b74c-0186d8028276
aside(tip(md"Extra information to consider."))

# ╔═╡ d5f9ea25-c3c9-46b6-8dbf-5ecdbaf156f0
A = rand(1:20,10,10)

# ╔═╡ fa8c544c-f3d6-4afe-b500-b2c7d53c7282
md"""

a = $(latexify_md(A)), which is kind of interesting, don't you think?

"""

# ╔═╡ e00ae4e3-7f25-41bb-9e10-e2f76af72748
md"""

a = $(DataFrame(A,:auto))

"""

# ╔═╡ d28e62eb-bb41-4cf0-8d89-11cd407da0d1
begin
	np = 50_000
	f = Figure()
	ax = Makie.Axis(f[1,1])
	for i in 1:50
		sc = plot!(ax, randn(np).^2, randn(np).*rand(np);
			markersize=1)
	end
	lines!( ax, [(-4,-1),(4,1)];color=:black)
	f
end

# ╔═╡ b065519b-d3ea-4b11-be5f-1ae1887c1fcd
md"""

# xxx
this is interesting !!! !!!
"""

# ╔═╡ Cell order:
# ╠═eeae2700-a78e-11ef-34c9-b3f7c1a464cb
# ╠═6a8bc1bc-6b24-4c27-8451-1a99745355a6
# ╠═6ac93790-4249-4900-a249-6e94abdfc717
# ╠═addaf191-0ad7-4538-aa79-7e6fa254beb9
# ╠═c9592c35-ee61-4702-a93a-e392058658e5
# ╠═d31bbdb2-0815-4132-aac2-0f529e5e926c
# ╟─135d4bcd-9000-48aa-b433-70864ba1be2e
# ╠═34d686ff-d6b4-4c98-aa50-b1ad5cf5b318
# ╠═29b7f120-94ff-4f56-a0c7-0373831bff2b
# ╠═2701200a-86ca-4052-bbae-8d9722c0ce28
# ╟─324a71e5-4416-4de6-a469-cab328aadebe
# ╟─3e1f5775-ecd4-4e45-89a4-4027b132d1ce
# ╟─2fbac8f8-3ced-40e6-81b2-6a0b581bcd75
# ╟─74645ef7-8ce3-41fc-95e5-cfdb48f9903f
# ╠═4e1616f9-90f1-4079-bdcf-54cab3aa928e
# ╠═e435bad3-3208-4cef-9ab3-feb50461a10c
# ╠═f530f068-acc2-4a21-a309-427f00009cf0
# ╠═6e13d906-c175-4624-b74c-0186d8028276
# ╠═d5f9ea25-c3c9-46b6-8dbf-5ecdbaf156f0
# ╠═fa8c544c-f3d6-4afe-b500-b2c7d53c7282
# ╠═e00ae4e3-7f25-41bb-9e10-e2f76af72748
# ╠═d28e62eb-bb41-4cf0-8d89-11cd407da0d1
# ╠═b065519b-d3ea-4b11-be5f-1ae1887c1fcd
