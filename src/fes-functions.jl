
function fm(v, r,c) 
    return if c == 1
        v
    elseif c < 7
        Format.format(v, precision=0, commas=true)
    else
        Format.format(v, precision=2, commas=true)
    end
    s
end

h1 = HtmlHighlighter( ( data, r, c ) -> (c == 1), HtmlDecoration( font_weight="bold", color="slategrey"))
function f_gainlose( h, data, r, c ) 
    colour = "black"
    if c == 7
        colour = if data[r,c] < -0.1
            "darkred"
        elseif data[r,c] > 0.1
            "darkgreen"
        else
            "black"
        end
    end
    HtmlDecoration( color=colour )
end
h7 = HtmlHighlighter( (data, r, c)->(c == 7), f_gainlose )

"""

"""
function format_gainlose(title::String, gl::DataFrame)
    gl[!,1] = pretty.(gl[!,1])
    io = IOBuffer()
    pretty_table( 
        io, 
        gl[!,1:end-1]; 
        backend = Val(:html),
        formatters=fm, alignment=[:l,fill(:r,6)...],
        highlighters = (h1,h7),
        title = title,
        header=["",
            "Lose £10.01+",
            "Lose £1.01-£10",
            "No Change",
            "Gain £1.01-£10",
            "Gain £10.01+",
            "Av. Change"])
    return String(take!(io))
end



