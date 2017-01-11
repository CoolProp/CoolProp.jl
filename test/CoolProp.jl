module CoolProp
using Compat

errcode = Ref{Clong}(0)
const buffer_length = 20000
message_buffer = Array(UInt8, buffer_length)

const inputs_to_get_global_param_string = ["version", "gitrevision", "errstring", "warnstring", "FluidsList", "incompressible_list_pure", "incompressible_list_solution", "mixture_binary_pairs_list", "parameter_list", "predefined_mixtures", "HOME", "cubic_fluids_schema"]

include("CoolPropHighLevel.jl")
include("CoolPropConfig.jl")
include("CoolPropInformation.jl")

# ---------------------------------
# Getter and setter for debug level
# ---------------------------------

"""
    get_debug_level()

Get the debug level.

# Return value
Level The level of the verbosity for the debugging output (0-10) 0: no debgging output
"""
function get_debug_level()
  ccall( (:get_debug_level, "CoolProp"), Cint, () )
end

"""
    set_debug_level(level::Integer)

Set the debug level.

# Arguments
* `level::Integer`: The level of the verbosity for the debugging output (0-10) 0: no debgging output
"""
function set_debug_level(level::Integer) # change ::Int to ::Integer to make set_debug_level(get_debug_level()) works on different machine
  ccall( (:set_debug_level, "CoolProp"), Void, (Cint,), level)
end

include("CoolPropHA.jl")
include("CoolPropLowLevel.jl")

for sym=[:PropsSI, :PhaseSI, :K2F, :F2K, :HAPropsSI, :AbstractState_factory, :AbstractState_free, :AbstractState_set_fractions, :AbstractState_update, :AbstractState_keyed_output, :AbstractState_output, :AbstractState_specify_phase, :AbstractState_unspecify_phase, :AbstractState_update_and_common_out, :AbstractState_update_and_1_out, :AbstractState_update_and_5_out, :AbstractState_set_binary_interaction_double, :AbstractState_set_cubic_alpha_C, :AbstractState_set_fluid_parameter_double, :AbstractState_first_saturation_deriv, :AbstractState_first_partial_deriv, :AbstractState_build_phase_envelope, :AbstractState_build_spinodal]
  symorigin = Symbol(replace(lowercase(string(sym)),r"out$","out!"))
  @eval const $sym = $symorigin
  @eval export $sym, $symorigin
end
const set_reference_stateS = set_reference_state
const set_reference_stateD = set_reference_state
const AbstractState_get_phase_envelope_data = abstractstate_get_phase_envelope_data!
const AbstractState_all_critical_points = abstractstate_all_critical_points!
const AbstractState_get_spinodal_data = abstractstate_get_spinodal_data!
const set_config_string = set_config
export set_reference_stateS, set_reference_stateD, AbstractState_get_spinodal_data, AbstractState_all_critical_points, AbstractState_get_phase_envelope_data
export set_reference_state, abstractstate_get_spinodal_data!, abstractState_all_critical_points!, abstractstate_get_phase_envelope_data!
export get_global_param_string, get_parameter_information_string, get_fluid_param_string, get_param_index, get_input_pair_index, set_config
export saturation_ancillary, set_departure_functions, set_config_string, cair_sat
end #module
