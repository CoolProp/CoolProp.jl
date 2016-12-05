push!(Libdl.DL_LOAD_PATH, abspath(joinpath(@__FILE__, "..", "..", "deps", "lib")));

if(haskey(ENV, "testCoolProp") && haskey(ENV, "TestingPath") && ENV["testCoolProp"]=="on" && isfile(ENV["TestingPath"]))
  include(ENV["TestingPath"]);
  warn("** TestingMode is enabeled for: " * ENV["TestingPath"] * " **");
else
  include("../deps/lib/CoolProp.jl");
end
