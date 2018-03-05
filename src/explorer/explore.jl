## Mimi UI

global app = nothing

#function to get variable data
include("buildspecs.jl")
include("getparameters.jl")

function explore(model)
    
    #get variable data
    speclist = getspeclist(model)
    speclistJSON = JSON.json(speclist)

    #start Electron app
    if app == nothing
        global app = Application()
    end

    #load main html file
    mainpath = replace(joinpath(@__DIR__, "assets", "main.html"), "\\", "/")

    if is_windows()
        w = Window(app, URI("file:///$(mainpath)"))
    else
        w = Window(app, URI("file://$(mainpath)"))
    end

    #refresh variable list
    result = run(w, "refresh($speclistJSON)")
    
end
