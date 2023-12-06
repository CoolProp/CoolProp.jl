using CoolProp
using Test

include("testThrows.jl"); 

dl = CoolProp.get_debug_level();
CoolProp.set_debug_level(10);
@test CoolProp.get_debug_level()==10;
CoolProp.set_debug_level(Int(dl));
const coolpropfluids = map(String, split(get_global_param_string("fluids_list"),','));
const coolpropparameters = map(String, split(get_global_param_string("parameter_list"),','));
const coolpropmix = map(String, split(get_global_param_string("predefined_mixtures"), ','));
#all trivials taken from http://www.coolprop.org/coolprop/HighLevelAPI.html#table-of-string-inputs-to-propssi-function
const coolproptrivialparameters = ["ACENTRIC", "DIPOLE_MOMENT", "FH", "FRACTION_MAX", "FRACTION_MIN",
"GAS_CONSTANT", "GWP100", "GWP20", "GWP500", "HH", "M", "ODP", "PCRIT", "PH", "PMAX", "PMIN", "PTRIPLE",
"P_REDUCING", "RHOCRIT", "RHOMASS_REDUCING", "RHOMOLAR_CRITICAL", "RHOMOLAR_REDUCING", "TCRIT", "TMAX",
"TMIN", "TTRIPLE", "T_FREEZE", "T_REDUCING"];
const trivalwithnumval = ["FH","GWP100","PMIN","TMIN","P_REDUCING","PCRIT","GWP20","GAS_CONSTANT","PMAX","RHOCRIT","TCRIT","T_REDUCING","ACENTRIC","GWP500","RHOMOLAR_REDUCING","TMAX","TTRIPLE","PH","M","PTRIPLE","RHOMOLAR_CRITICAL","ODP","HH"];
const fails_any_props_trivals = ["DIPOLE_MOMENT","FRACTION_MAX","FRACTION_MIN","RHOMASS_REDUCING","T_FREEZE"];
const fails_critical_point = ["DiethylEther","R134a","R116","SulfurDioxide","n-Pentane","R11","CycloPropane","MDM","n-Nonane","Oxygen","DimethylCarbonate","R41","R227EA","R245fa","trans-2-Butene","n-Propane","MM","Air","R236FA","Neon","SES36","Fluorine","n-Undecane","Isohexane","MD4M","IsoButane","D5","Ammonia","R1234ze(Z)","HydrogenChloride","R236EA","R1234ze(E)","Cyclopentane"];
const fails_tcrit_eq_treducing = ["R134a","R116","n-Pentane","R11","n-Nonane","MDM","Oxygen","R41","MM","Fluorine","n-Undecane","Isohexane","Helium","IsoButane","HydrogenChloride","R1234ze(E)","Ammonia"];

function compare_sets(fails,reference)
    failsset = Set(fails)
    refset = Set(fails)
    if issubset(failsset, refset)
        return true
    end

    diff = setdiff(failsset, refset)
    println("The set of failures is not a subset of the reference set. Extra failures are: $diff")

    return false
end

#high
@info "********* High Level Api *********"
#get_global_param_string
for param in ["version", "gitrevision", "errstring", "warnstring", "FluidsList", "incompressible_list_pure", "incompressible_list_solution", "mixture_binary_pairs_list", "parameter_list", "predefined_mixtures", "HOME", "cubic_fluids_schema"]
    try
        get_global_param_string(param);
    catch err
        @warn "get_global_param_string($param) fails with $err" 
    end
end
#PropsSI
@test (PropsSI("T","P",101325.0,"Q",0.0,"Water")-373.1242958476879)<1e-5
#get_fluid_param_string PhaseSI PropsSI
include("testFluids.jl");
#get_parameter_information_string PropsSI
include("testParameters.jl");
#PropsSI
include("testConstants.jl");
#AbstractState_factory get_input_pair_index AbstractState_update get_param_index AbstractState_keyed_output AbstractState_free AbstractState_set_binary_interaction_double AbstractState_set_fractions
include("testLow.jl");
#set_reference_stateS
#F2K K2F
@test K2F(F2K(100)) ≈ 100
#HAPropsSI
dt=1e-3;
const Y0 = 1e-16
@test (HAPropsSI("H", "T", 300+dt, "P", 100000, "Y", Y0) - HAPropsSI("H", "T", 300-dt, "P", 100000, "Y", Y0))/2/dt ≈ HAPropsSI("C", "T", 300, "P", 100000, "Y", Y0) atol =2e-9
#PropsSI
h0 = -15870000.0; # J/kg
s0 = 3887.0; #J/kg
rho0 = 997.1;
T0 = 298.15;
M = PropsSI("molemass", "Water");
#set_reference_stateD("Water", T0, rho0/M, h0*M, s0*M);
#@test PropsSI("H", "T", T0, "P", 101325, "Water") ≈ -1.5870107493843542e7
set_reference_stateS("Water", "DEF");
@test PropsSI("H", "T", T0, "P", 101325, "Water") ≈ 104920.1198093371

if (haskey(ENV, "includelocalwrapper") && ENV["includelocalwrapper"]=="on")
    #saturation_ancillary
    @test saturation_ancillary("R410A","I",1,"T", 300) ≈ 0.004877519938463293
    #cair_sat
    @test cair_sat(400) ≈ 202.53656679999574
end
#config
if (haskey(ENV, "includelocalwrapper") && ENV["includelocalwrapper"]=="on")
    set_config_string("ALTERNATIVE_TABLES_DIRECTORY", "")
end
try
    set_config("MAXIMUM_TABLE_DIRECTORY_SIZE_IN_GB", 1.0)
catch err
    @warn "set_config for double fails with: $err"
end
try
    set_config("NORMALIZE_GAS_CONSTANTS", true)
catch err
    @warn "set_config for bool fails with: $err"
end

include("testunits.jl")
