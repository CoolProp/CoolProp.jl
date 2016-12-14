using CoolProp
using Compat
using Base.Test
const coolpropfluids = map(Compat.String, split(get_global_param_string("FluidsList"),','));
const coolpropparameters = map(Compat.String, split(get_global_param_string("parameter_list"),','));
const coolpropmix = map(Compat.String, split(get_global_param_string("predefined_mixtures"), ','));
#all trivials taken from http://www.coolprop.org/coolprop/HighLevelAPI.html#table-of-string-inputs-to-propssi-function
const coolproptrivialparameters = ["ACENTRIC", "DIPOLE_MOMENT", "FH", "FRACTION_MAX", "FRACTION_MIN",
  "GAS_CONSTANT", "GWP100", "GWP20", "GWP500", "HH", "M", "ODP", "PCRIT", "PH", "PMAX", "PMIN", "PTRIPLE",
  "P_REDUCING", "RHOCRIT", "RHOMASS_REDUCING", "RHOMOLAR_CRITICAL", "RHOMOLAR_REDUCING", "TCRIT", "TMAX",
  "TMIN", "TTRIPLE", "T_FREEZE", "T_REDUCING"];
const trivalwithnumval = ["FH","GWP100","PMIN","TMIN","P_REDUCING","PCRIT","GWP20","GAS_CONSTANT","PMAX","RHOCRIT","TCRIT","T_REDUCING","ACENTRIC","GWP500","RHOMOLAR_REDUCING","TMAX","TTRIPLE","PH","M","PTRIPLE","RHOMOLAR_CRITICAL","ODP","HH"];
const fails_any_props_trivals = ["DIPOLE_MOMENT","FRACTION_MAX","FRACTION_MIN","RHOMASS_REDUCING","T_FREEZE"];
const fails_critical_point = ["trans-2-Butene", "SulfurDioxide", "SES36", "R507A", "R410A", "R41", "R407C", "R404A", "R245fa", "R236FA", "R227EA", "R134a", "R116", "R11", "Oxygen", "Neon", "n-Undecane", "n-Propane", "n-Pentane", "n-Nonane", "MM", "MDM", "Air", "CycloPropane", "D5", "DimethylCarbonate", "Fluorine", "Helium", "IsoButane", "Isohexane", "MD4M"];
const fails_tcrit_eq_treducing = ["R134a","R116","n-Pentane","R11","n-Nonane","MDM","Oxygen","R41","MM","Neon","Fluorine","n-Undecane","Isohexane","Helium","IsoButane","D5"];
#high
info("********* High Level Api *********");
#get_global_param_string
for param in ["version", "gitrevision", "errstring", "warnstring", "FluidsList", "incompressible_list_pure", "incompressible_list_solution", "mixture_binary_pairs_list", "parameter_list", "predefined_mixtures", "HOME", "cubic_fluids_schema"]
  try
    get_global_param_string(param);
  catch err
    warn("get_global_param_string($param) fails with $err");
  end
end
#PropsSI
@test (CoolProp.PropsSI("T","P",101325.0,"Q",0.0,"Water")-373.1242958476879)<1e-5
#get_fluid_param_string PhaseSI PropsSI
include("AllFluids.jl");
#get_parameter_information_string PropsSI
include("AllParameters.jl");
include("AllConstants.jl");
include("Low.jl");


#set_reference_stateS
#get_param_index
#get_input_pair_index
#F2K
#K2F
#HAPropsSI
#AbstractState_factory
#AbstractState_free
#AbstractState_set_fractions
#AbstractState_update
#AbstractState_keyed_output
