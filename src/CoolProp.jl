push!(Libdl.DL_LOAD_PATH, abspath(joinpath(@__FILE__, "..", "..", "deps", "lib")));
include("../deps/lib/CoolProp.jl");
