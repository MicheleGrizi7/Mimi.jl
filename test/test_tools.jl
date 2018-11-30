module TestTools

using Test
using Mimi
using Logging

import Mimi:
    getproperty, reset_compdefs, prettify, log_info, log_debug

log_info()

old = log_debug()
@test old.min_level == Logging.Info   # prev. level

old = log_info()
@test old.min_level == Logging.Debug

reset_compdefs()

#utils: prettify
@test prettify("camelCaseBasic") == prettify(:camelCaseBasic) == "Camel Case Basic"
@test prettify("camelWithAOneLetterWord") == prettify(:camelWithAOneLetterWord) == "Camel With A One Letter Word"
@test prettify("snake_case_basic") == prettify(:snake_case_basic) == "Snake Case Basic"
@test prettify("_snake__case__weird_") == prettify(:_snake__case__weird_) == "Snake Case Weird"

#utils: interpolate
stepsize = 2       # N.B. ERROR: cannot assign variable Base.step from module Main
final = 10         # N.B. ERROR: cannot assign variable Base.last from module Main
ts = 10
@test Mimi.interpolate(collect(0:stepsize:final), ts) == collect(0:stepsize/ts:final)

@defcomp Foo begin
    input = Parameter()
    intermed = Variable(index=[time])
    
    function run_timestep(p, v, d, t)
        v.intermed[t] = p.input
    end
end

@defcomp Bar begin
    intermed = Parameter(index=[time])
    output = Variable(index=[time])
    
    function run_timestep(p, v, d, t)
        v.output[t] = p.intermed[t]
    end
end

m = Model()
set_dimension!(m, :time, 2)
foo = add_comp!(m, Foo)
bar = add_comp!(m, Bar)

foo[:input] = 3.14
bar[:intermed] = foo[:intermed]

run(m)

end #module