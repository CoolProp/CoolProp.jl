module CoolProp
using Compat
export PropsSI, PhaseSI, get_global_param_string, get_parameter_information_string, get_fluid_param_string, set_reference_stateS, get_param_index, get_input_pair_index, set_config, F2K, K2F, HAPropsSI, AbstractState_factory, AbstractState_free, AbstractState_set_fractions, AbstractState_update, AbstractState_specify_phase, AbstractState_unspecify_phase, AbstractState_keyed_output, AbstractState_output, AbstractState_update_and_common_out, AbstractState_update_and_1_out, AbstractState_update_and_5_out, AbstractState_set_binary_interaction_double, AbstractState_set_cubic_alpha_C, AbstractState_set_fluid_parameter_double
export propssi, phasesi, k2f, f2k, hapropssi, cair_sat, set_reference_state
export abstractstate_factory, abstractstate_free, abstractstate_set_fractions, abstractstate_update, abstractstate_keyed_output, abstractstate_specify_phase, abstractstate_unspecify_phase, abstractstate_update_and_common_out!, abstractstate_update_and_5_out!, abstractstate_update_and_1_out!, abstractstate_set_binary_interaction_double, abstractstate_set_cubic_alpha_c, abstractstate_set_fluid_parameter_double, abstractstate_output
export saturation_ancillary, set_departure_functions
export AbstractState_first_saturation_deriv, AbstractState_first_partial_deriv
export abstractstate_first_saturation_deriv, abstractstate_first_partial_deriv, abstractstate_build_phase_envelope, abstractstate_get_phase_envelope_data!, abstractstate_build_spinodal, abstractstate_get_spinodal_data!, abstractState_all_critical_points!
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

const PropsSI = propssi
const PhaseSI = phasesi
const K2F = k2f
const F2K = f2k
const HAPropsSI = hapropssi
const AbstractState_factory = abstractstate_factory
const AbstractState_free = abstractstate_free
const AbstractState_set_fractions = abstractstate_set_fractions
const AbstractState_update = abstractstate_update
const AbstractState_keyed_output = abstractstate_keyed_output
const AbstractState_output = abstractstate_output
const AbstractState_specify_phase = abstractstate_specify_phase
const AbstractState_unspecify_phase = abstractstate_unspecify_phase
const AbstractState_update_and_common_out = abstractstate_update_and_common_out!
const AbstractState_update_and_1_out = abstractstate_update_and_1_out!
const AbstractState_update_and_5_out = abstractstate_update_and_5_out!
const AbstractState_set_binary_interaction_double = abstractstate_set_binary_interaction_double
const AbstractState_set_cubic_alpha_C = abstractstate_set_cubic_alpha_c
const AbstractState_set_fluid_parameter_double = abstractstate_set_fluid_parameter_double
const set_reference_stateS = set_reference_state
const set_reference_stateD = set_reference_state
const AbstractState_first_saturation_deriv = abstractstate_first_saturation_deriv
const AbstractState_first_partial_deriv = abstractstate_first_partial_deriv
end #module
