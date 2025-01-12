# DD226 Interactive Content

Dear Iain,

we spoke last Friday about some interactive material for the DD226 course.

I promised you that I would give you a demonstration server and some documentation on Monday. I'm a week late but I have something now.

The server is here:

http://oustb.mazegreenyachts.com

that's a simple Apache front end. The model is behind this, and, as you suggested, the two communicate using a simple Ajax API.

The model runs using a [little Julia native server](https://github.com/JuliaWeb/Mux.jl) on port 8000. The front-end makes simple GET requests and receives JSON in return. There is no authentication, session handling (or encryption); instead, I've tried hard to make it fast and simple enough that it should work fine without sessions and logins.

The web front end pages are broken in multiple ways but there is hopefully enough there to show how I think this should work.

I enclose a zip file with examples of the json output and accompanying notes. The Julia code and my very basic front-end Javascript handler is on [GitHub](https://github.com/grahamstark/stb.jl/)_

I still have a lot to do. Although I've got the data, output and input parts of the model done, the actual calculations are just a very basic test case. And I'm badly behind on actually writing the course material, so I'll have to go back to that now.

Could we possibly have a chat on Monday, please? The next meeting is on the 15th, I think, but, as we discussed, I need to have something to show the course team preferably in the next few days, so I'd appreciate your input. As we discussed, I'll likely need to contact someone on the Server side of the OU, so any contacts you might there have would be useful.

many thanks, and have a good weekend,

Graham
