push!(Libdl.DL_LOAD_PATH, abspath(@__FILE__, "..", "..", "deps", "lib"));

if (haskey(ENV, "includelocalwrapper") && ENV["includelocalwrapper"]=="on")
  haskey(ENV, "TestingPath") || (ENV["TestingPath"] = abspath(@__FILE__, "..", "..", "test/CoolProp.jl"));
  if (isfile(ENV["TestingPath"]))
    include(ENV["TestingPath"]);
    warn("** TestingMode is enabeled for: " * ENV["TestingPath"] * " **");
  else
    warn("** $(ENV["TestingPath"]) not exists **");
  end
else
  include("../deps/lib/CoolProp.jl");
end
