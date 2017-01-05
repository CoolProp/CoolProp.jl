module CoolProp
using Compat
export PropsSI, PhaseSI, get_global_param_string, get_parameter_information_string, get_fluid_param_string, set_reference_stateS, get_param_index, get_input_pair_index, set_config, F2K, K2F, HAPropsSI, AbstractState_factory, AbstractState_free, AbstractState_set_fractions, AbstractState_update, AbstractState_specify_phase, AbstractState_unspecify_phase, AbstractState_keyed_output, AbstractState_output, AbstractState_update_and_common_out, AbstractState_update_and_1_out, AbstractState_update_and_5_out, AbstractState_set_binary_interaction_double, AbstractState_set_cubic_alpha_C, AbstractState_set_fluid_parameter_double
export propssi, phasesi, k2f, f2k, hapropssi, cair_sat, set_reference_state
export abstractstate_factory, abstractstate_free, abstractstate_set_fractions, abstractstate_update, abstractstate_keyed_output, abstractstate_specify_phase, abstractstate_unspecify_phase, abstractstate_update_and_common_out!, abstractstate_update_and_5_out!, abstractstate_update_and_1_out!, abstractstate_set_binary_interaction_double, abstractstate_set_cubic_alpha_c, abstractstate_set_fluid_parameter_double
errcode = Ref{Clong}(0)

const buffer_length = 20000
message_buffer = Array(UInt8, buffer_length)

const inputs_to_get_global_param_string = ["version", "gitrevision", "errstring", "warnstring", "FluidsList", "incompressible_list_pure", "incompressible_list_solution", "mixture_binary_pairs_list", "parameter_list", "predefined_mixtures", "HOME", "cubic_fluids_schema"];

include("CoolPropHighLevel.jl");
include("CoolPropConfig.jl");
include("CoolPropInformation.jl");

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
    set_debug_level(level::Int)

Set the debug level.

# Arguments
* `level::Int` The level of the verbosity for the debugging output (0-10) 0: no debgging output
"""
function set_debug_level(level::Integer) # change ::Int to ::Integer to make set_debug_level(get_debug_level()) works on different machine
  ccall( (:set_debug_level, "CoolProp"), Void, (Cint,), level)
end

###
#    /* \brief Extract a value from the saturation ancillary
#     *
#     * @param fluid_name The name of the fluid to be used - HelmholtzEOS backend only
#     * @param output The desired output variable ("P" for instance for pressure)
#     * @param Q The quality, 0 or 1
#     * @param input The input variable ("T")
#     * @param value The input value
#     */
#    EXPORT_CODE double CONVENTION saturation_ancillary(const char *fluid_name, const char *output, int Q, const char *input, double value);
###

include("CoolPropHA.jl");
include("CoolPropLowLevel.jl");

#    /**
#    * @brief Calculate a saturation derivative from the AbstractState using integer values for the desired parameters
#    * @param handle The integer handle for the state class stored in memory
#    * @param Of The parameter of which the derivative is being taken
#    * @param Wrt The derivative with with respect to this parameter
#    * @param errcode The errorcode that is returned (0 = no error, !0 = error)
#    * @param message_buffer A buffer for the error code
#    * @param buffer_length The length of the buffer for the error code
#    * @return
#    */
#    EXPORT_CODE double CONVENTION AbstractState_first_saturation_deriv(const long handle, const long Of, const long Wrt, long *errcode, char *message_buffer, const long buffer_length);
#
#    /**
#    * @brief Calculate the first partial derivative in homogeneous phases from the AbstractState using integer values for the desired parameters
#    * @param handle The integer handle for the state class stored in memory
#    * @param Of The parameter of which the derivative is being taken
#    * @param Wrt The derivative with with respect to this parameter
#    * @param Constant The parameter that is not affected by the derivative
#    * @param errcode The errorcode that is returned (0 = no error, !0 = error)
#    * @param message_buffer A buffer for the error code
#    * @param buffer_length The length of the buffer for the error code
#    * @return
#    */
#    EXPORT_CODE double CONVENTION AbstractState_first_partial_deriv(const long handle, const long Of, const long Wrt, const long Constant, long *errcode, char *message_buffer, const long buffer_length);


#    /**
#     * @brief Build the phase envelope
#     * @param handle The integer handle for the state class stored in memory
#     * @param level How much refining of the phase envelope ("none" to skip refining (recommended))
#     * @param errcode The errorcode that is returned (0 = no error, !0 = error)
#     * @param message_buffer A buffer for the error code
#     * @param buffer_length The length of the buffer for the error code
#     * @return
#     *
#     * @note If there is an error in an update call for one of the inputs, no change in the output array will be made
#     */
#    EXPORT_CODE void CONVENTION AbstractState_build_phase_envelope(const long handle, const char *level, long *errcode, char *message_buffer, const long buffer_length);
#
#    /**
#     * @brief Get data from the phase envelope for the given mixture composition
#     * @param handle The integer handle for the state class stored in memory
#     * @param length The number of elements stored in the arrays (both inputs and outputs MUST be the same length)
#     * @param T The pointer to the array of temperature (K)
#     * @param p The pointer to the array of pressure (Pa)
#     * @param rhomolar_vap The pointer to the array of molar density for vapor phase (m^3/mol)
#     * @param rhomolar_liq The pointer to the array of molar density for liquid phase (m^3/mol)
#     * @param x The compositions of the "liquid" phase (WARNING: buffer should be Ncomp*Npoints in length, at a minimum, but there is no way to check buffer length at runtime)
#     * @param y The compositions of the "vapor" phase (WARNING: buffer should be Ncomp*Npoints in length, at a minimum, but there is no way to check buffer length at runtime)
#     * @param errcode The errorcode that is returned (0 = no error, !0 = error)
#     * @param message_buffer A buffer for the error code
#     * @param buffer_length The length of the buffer for the error code
#     * @return
#     *
#     * @note If there is an error in an update call for one of the inputs, no change in the output array will be made
#     */
#    EXPORT_CODE void CONVENTION AbstractState_get_phase_envelope_data(const long handle, const long length, double* T, double* p, double* rhomolar_vap, double *rhomolar_liq, double *x, double *y, long *errcode, char *message_buffer, const long buffer_length);
#
#    /**
#     * @brief Build the spinodal
#     * @param handle The integer handle for the state class stored in memory
#     * @param errcode The errorcode that is returned (0 = no error, !0 = error)
#     * @param message_buffer A buffer for the error code
#     * @param buffer_length The length of the buffer for the error code
#     * @return
#     */
#    EXPORT_CODE void CONVENTION AbstractState_build_spinodal(const long handle, long *errcode, char *message_buffer, const long buffer_length);
#
#    /**
#     * @brief Get data for the spinodal curve
#     * @param handle The integer handle for the state class stored in memory
#     * @param length The number of elements stored in the arrays (all outputs MUST be the same length)
#     * @param tau The pointer to the array of reciprocal reduced temperature
#     * @param delta The pointer to the array of reduced density
#     * @param M1 The pointer to the array of M1 values (when L1=M1=0, critical point)
#     * @param errcode The errorcode that is returned (0 = no error, !0 = error)
#     * @param message_buffer A buffer for the error code
#     * @param buffer_length The length of the buffer for the error code
#     * @return
#     *
#     * @note If there is an error, no change in the output arrays will be made
#     */
#    EXPORT_CODE void CONVENTION AbstractState_get_spinodal_data(const long handle, const long length, double* tau, double* delta, double* M1, long *errcode, char *message_buffer, const long buffer_length);
#
#    /**
#     * @brief Calculate all the critical points for a given composition
#     * @param handle The integer handle for the state class stored in memory
#     * @param length The length of the buffers passed to this function
#     * @param T The pointer to the array of temperature (K)
#     * @param p The pointer to the array of pressure (Pa)
#     * @param rhomolar The pointer to the array of molar density (m^3/mol)
#     * @param stable The pointer to the array of boolean flags for whether the critical point is stable (1) or unstable (0)
#     * @param errcode The errorcode that is returned (0 = no error, !0 = error)
#     * @param message_buffer A buffer for the error code
#     * @param buffer_length The length of the buffer for the error code
#     * @return
#     *
#     * @note If there is an error in an update call for one of the inputs, no change in the output array will be made
#     */
#    EXPORT_CODE void CONVENTION AbstractState_all_critical_points(const long handle, const long length, double *T, double *p, double *rhomolar, long *stable, long *errcode, char *message_buffer, const long buffer_length);

const PropsSI = propssi;
const PhaseSI = phasesi;
const K2F = k2f;
const F2K = f2k;
const HAPropsSI = hapropssi;
const AbstractState_factory = abstractstate_factory;
const AbstractState_free = abstractstate_free;
const AbstractState_set_fractions = abstractstate_set_fractions;
const AbstractState_update = abstractstate_update;
const AbstractState_keyed_output = abstractstate_keyed_output;
const AbstractState_output = abstractstate_output;
const AbstractState_specify_phase = abstractstate_specify_phase;
const AbstractState_unspecify_phase = abstractstate_unspecify_phase;
const AbstractState_update_and_common_out = abstractstate_update_and_common_out!;
const AbstractState_update_and_1_out = abstractstate_update_and_1_out!;
const AbstractState_update_and_5_out = abstractstate_update_and_5_out!;
const AbstractState_set_binary_interaction_double = abstractstate_set_binary_interaction_double;
const AbstractState_set_cubic_alpha_C = abstractstate_set_cubic_alpha_c;
const AbstractState_set_fluid_parameter_double = abstractstate_set_fluid_parameter_double;
const set_reference_stateS = set_reference_state;
const set_reference_stateD = set_reference_state;
end #module
