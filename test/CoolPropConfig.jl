# ---------------------------------
#      Configuration functions
# ---------------------------------

"""
    set_config(key::AbstractString, val::AbstractString)

Set configuration string.

# Arguments
* `key::AbstractString` The key to configure, following table shows possible `key` values, its default setting and its usage.
* `val::AbstractString` The value to set to the key

Key                     |Default|Description
:-----------------------|:-----:|:---------------------------------------------------------------------------------
ALTERNATIVE_TABLES_DIRECTORY | "" | If provided, this path will be the root directory for the tabular data.  Otherwise, \${HOME}/.CoolProp/Tables is used
ALTERNATIVE_REFPROP_PATH | "" | An alternative path to be provided to the directory that contains REFPROP's fluids and mixtures directories.  If provided, the SETPATH function will be called with this directory prior to calling any REFPROP functions.
ALTERNATIVE_REFPROP_HMX_BNC_PATH | "" | An alternative path to the HMX.BNC file.  If provided, it will be passed into REFPROP's SETUP or SETMIX routines
VTPR_UNIFAQ_PATH | "" | The path to the directory containing the UNIFAQ JSON files.  Should be slash terminated
"""
function set_config(key::AbstractString, val::AbstractString)
  ccall( (:set_config_string, "CoolProp"), Void, (Cstring, Cstring), key, val)
  return get_global_param_string("errstring")
end

"""
    set_config(key::AbstractString, val::Real)

Set configuration numerical value as double.

# Arguments
* `key::AbstractString` The key to configure, following table shows possible `key` values, its default setting and its usage.
* `val::Real` The value to set to the key

Key                     |Default|Description
:-----------------------|:-----:|:---------------------------------------------------------------------------------
MAXIMUM_TABLE_DIRECTORY_SIZE_IN_GB |  1.0 | The maximum allowed size of the directory that is used to store tabular data
PHASE_ENVELOPE_STARTING_PRESSURE_PA |  100.0 | Starting pressure [Pa] for phase envelope construction
R_U_CODATA |  8.3144598 | The value for the ideal gas constant in J/mol/K according to CODATA 2014.  This value is used to harmonize all the ideal gas constants. This is especially important in the critical region.
SPINODAL_MINIMUM_DELTA |  0.5 | The minimal delta to be used in tracing out the spinodal; make sure that the EOS has a spinodal at this value of delta=rho/rho_r
"""
function set_config(key::AbstractString, val::Real)
  ccall( (:set_config_double, "CoolProp"), Void, (Cstring, Cdouble), key, val)
  return get_global_param_string("errstring")
end

"""
    set_config(key::AbstractString, val::Bool)

Set configuration value as a boolean.

# Arguments
* `key::AbstractString` The key to configure, following table shows possible `key` values, its default setting and its usage.
* `val::Bool` The value to set to the key

Key                     |Default|Description
:-----------------------|:-----:|:---------------------------------------------------------------------------------
NORMALIZE_GAS_CONSTANTS |  true | If true, for mixtures, the molar gas constant (R) will be set to the CODATA value
CRITICAL_WITHIN_1UK |  true | If true, any temperature within 1 uK of the critical temperature will be considered to be AT the critical point
CRITICAL_SPLINES_ENABLED |  true | If true, the critical splines will be used in the near-vicinity of the critical point
SAVE_RAW_TABLES |  false | If true, the raw, uncompressed tables will also be written to file
REFPROP_DONT_ESTIMATE_INTERACTION_PARAMETERS |  false | If true, if the binary interaction parameters in REFPROP are estimated, throw an error rather than silently continuing
REFPROP_IGNORE_ERROR_ESTIMATED_INTERACTION_PARAMETERS |  false | If true, if the binary interaction parameters in REFPROP are unable to be estimated, silently continue rather than failing
REFPROP_USE_GERG |  false | If true, rather than using the highly-accurate pure fluid equations of state, use the pure-fluid EOS from GERG-2008
REFPROP_USE_PENGROBINSON |  false | If true, rather than using the highly-accurate pure fluid equations of state, use the Peng-Robinson EOS
DONT_CHECK_PROPERTY_LIMITS |  false | If true, when possible, CoolProp will skip checking whether values are inside the property limits
HENRYS_LAW_TO_GENERATE_VLE_GUESSES |  false | If true, when doing water-based mixture dewpoint calculations, use Henry's Law to generate guesses for liquid-phase composition
OVERWRITE_FLUIDS |  false | If true, and a fluid is added to the fluids library that is already there, rather than not adding the fluid (and probably throwing an exception), overwrite it
OVERWRITE_DEPARTURE_FUNCTION |  false | If true, and a departure function to be added is already there, rather than not adding the departure function (and probably throwing an exception), overwrite it
OVERWRITE_BINARY_INTERACTION |  false | If true, and a pair of binary interaction pairs to be added is already there, rather than not adding the binary interaction pair (and probably throwing an exception), overwrite it
"""
function set_config(key::AbstractString, val::Bool)
  ccall( (:set_config_bool, "CoolProp"), Void, (Cstring, UInt8), key, val)
  return get_global_param_string("errstring")
end
