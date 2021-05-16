ENV["JULIA_EDITOR"] = "emacsclient"
atreplinit() do repl
    try
        @eval using OhMyREPL
    catch e
        @warn "error while importing OhMyREPL" e
    end

    try
        @eval using Revise
    catch e
        @warn "Error initializing Revise" exception=(e, catch_backtrace())
    end
end
