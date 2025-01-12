using UUIDs
using Format

HUID = UUIDs.uuid4()
HEADER = 
"""
### A Pluto.jl notebook ###
# v0.20.4

using Markdown
using InteractiveUtils

# ╔═╡ $(HUID)
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

"""

FOOTER = """
# ╔═╡ Cell order:
"""

WDIR = "workbooks/converted/"
BDIR = "docs/book/src/sections/"

function makeblock( s :: String )::NamedTuple
    uu = UUIDs.uuid4()
    s = 
"""
# ╔═╡ $uu
begin
    md\"\"\"
    $s
    \"\"\"
end 

"""
    return (; s, uu )
end

function process_one( i :: Int, name :: AbstractString )
    inf = joinpath( BDIR, "$(name).md")
    istr = format(i;width=2,zeropadding=true)
    of = joinpath( WDIR, "$(istr)-$(name).jl")
    lines = readlines( inf )
    outf = open(of,"w")
    write(outf, HEADER )    
    block = ""
    uuids = [HUID]
    for line in lines 
        line = strip( line )
        block *= line
        if line == ""
            s, uu = makeblock(block)
            write( outf, s )
            push!( uuids, uu )
            block = ""
        end
    end
    write(outf, FOOTER )    
    for u in uuids
        write(outf, "# ╟─$(u)\n")
    end
    write( outf, "\n")
    close(outf)
end

TARGETS = [
    "intro",
    "concepts",
    "households",
    "incentives",
    "incidence",
    "large-sample-datasets",
    "income_wealth_welfare",
    "poverty",
    "inequality",
    "tax-benefit-tour",
    "tax-benefit-what-could-go-wrong",
    "the-right-tool-for-the-job",
    "welcome-to-unicornia",    
    "bc-intro",
    "bc-cash-benefits",
    "bc-full",
    "policy-intro",
    "policy_intro",
    "roles-and-results",
    "tax-benefit-benefits",
    "tax-benefit-direct-taxation",
    "tax-benefit-extensions",
    "tax-benefit-indirect-taxation",
    "tax-benefit-intro",
    "tax-benefit-intro-2",
    "tax-benefit-minimum-wages",
    "tax-benefit-package-1-poverty",
    "tax-benefit-package-2-incentives",
    "tax-benefit-package-3-women-and-children",
]

function process_all(targets)
    i = 1
    for t in targets
        fn = process_one( i, t )
        i+= 2
    end
end
