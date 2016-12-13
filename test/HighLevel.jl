export PARAMETERS, FLUIDS;

"""
# CoolProp parameters table

$(readstring(abspath(@__FILE__, "..", "parameters.table")))
"""
PARAMETERS() = readdlm(abspath(@__FILE__, "..", "parameters.table"), '|', skipstart=2);

"""
# CoolProp fluids table

$(readstring(abspath(@__FILE__, "..", "fluids.table")))
"""
FLUIDS() = readdlm(abspath(@__FILE__, "..", "fluids.table"), '|', skipstart=2);

# ---------------------------------
#        High-level functions
# ---------------------------------


"""
    propssi(fluid::AbstractString, output::AbstractString)

Return a value that does not depend on the thermodynamic state - this is a convenience function that does the call `PropsSI(output, "", 0, "", 0, fluid)`.

# Arguments
* `fluid::AbstractString`: The name of the fluid that is part of CoolProp, for instance "n-Propane", to get a list of different passible fulid types call `get_global_param_string(key)` with `key` one of the following: `["FluidsList", "incompressible_list_pure", "incompressible_list_solution", "mixture_binary_pairs_list", "predefined_mixtures"]`, also there is a list in CoolProp online documentation [List of Fluids](http://www.coolprop.org/fluid_properties/PurePseudoPure.html#list-of-fluids), or simply type `?FLUIDS`
* `output::AbstractString`: The name of parameter to evaluate. to see a list type `?PARAMETERS`

# Example
```julia
julia> propssi("n-Butane","rhomolar_critical")
3922.769612987809
```

# Ref
CoolProp::Props1SI(std::string, std::string)
"""
function propssi(fluid::AbstractString, output::AbstractString)
  val = ccall( (:Props1SI, "CoolProp"), Cdouble, (Ptr{UInt8}, Ptr{UInt8}), fluid, output)
  if val == Inf
    error("CoolProp: ", get_global_param_string("errstring"))
  end
  return val
end

"""
    propssi(output::AbstractString, name1::AbstractString, value1::Real, name2::AbstractString, value2::Real, fluid::AbstractString)

Return a value that depends on the thermodynamic state.
> For pure and pseudo-pure fluids, two state points are required to fix the state. The equations of state are based on T and ρ as state variables, so T,ρ will always be the fastest inputs. P,T will be a bit slower (3-10 times), and then comes inputs where neither T nor ρ are given, like p,h. They will be much slower. If speed is an issue, you can look into table-based interpolation methods using TTSE or bicubic interpolation.

# Arguments
* `fluid::AbstractString`: The name of the fluid that is part of CoolProp, for instance "n-Propane", to get a list of different passible fulid types call `get_global_param_string(key)` with `key` one of the following: `["FluidsList", "incompressible_list_pure", "incompressible_list_solution", "mixture_binary_pairs_list", "predefined_mixtures"]`, also there is a list in CoolProp online documentation [List of Fluids](http://www.coolprop.org/fluid_properties/PurePseudoPure.html#list-of-fluids), or simply type `?FLUIDS`
* `output::AbstractString`: The name of parameter to evaluate. to see a list type `?PARAMETERS`
* `name1::AbstractString`: The name of parameter for first state point
* `value1::AbstractString`: Value of the first state point
* `name2::AbstractString`: The name of parameter for second state point
* `value2::AbstractString`: Value of the second state point

# Example
```julia
julia> propssi("D","T",300,"P",101325,"n-Butane")
2.4325863624814326
julia> propssi("D","T",300,"P",101325,"INCOMP::DEB") # incompressible pure
857.1454
julia> propssi("D","T",300,"P",101325,"INCOMP::LiBr[0.23]") # incompressible mass-based binary mixture
1187.5438243617214
julia> propssi("D","T",300,"P",101325,"INCOMP::ZM[0.23]") # incompressible volume-based binary mixtures
1028.7273860290911
julia> propssi("Dmass","T",300,"P",101325,"R125[0.5]&R32[0.5]")
3.5413381483914512
julia> split(get_global_param_string("mixture_binary_pairs_list"),',')[1] # a random binary pair
"100-41-4&106-42-3"
julia> propssi("Dmass","T",300,"P",101325,"100-41-4[0.5]&106-42-3[0.5]") # ethylbenzene[0.5]&p-Xylene[0.5]
857.7381127561846
```

# Ref
CoolProp::PropsSI(const std::string &, const std::string &, double, const std::string &, double, const std::string&)
"""
function propssi(output::AbstractString, name1::AbstractString, value1::Real, name2::AbstractString, value2::Real, fluid::AbstractString)
  val = ccall( (:PropsSI, "CoolProp"), Cdouble, (Ptr{UInt8}, Ptr{UInt8}, Float64, Ptr{UInt8}, Float64, Ptr{UInt8}), output, name1, value1, name2, value2, fluid)
  if val == Inf
    error("CoolProp: ", get_global_param_string("errstring"))
  end
  return val
end

"""
    phasesi(name1::AbstractString, value1::Real, name2::AbstractString, value2::Real, fluid::AbstractString)

Return a string representation of the phase.

# Arguments
* `fluid::AbstractString`: The name of the fluid that is part of CoolProp, for instance "n-Propane", to get a list of different passible fulid types call `get_global_param_string(key)` with `key` one of the following: `["FluidsList", "incompressible_list_pure", "incompressible_list_solution", "mixture_binary_pairs_list", "predefined_mixtures"]`, also there is a list in CoolProp online documentation [List of Fluids](http://www.coolprop.org/fluid_properties/PurePseudoPure.html#list-of-fluids), or simply type `?FLUIDS`
* `name1::AbstractString`: The name of parameter for first state point
* `value1::AbstractString`: Value of the first state point
* `name2::AbstractString`: The name of parameter for second state point
* `value2::AbstractString`: Value of the second state point

# Example
```julia
julia> phasesi("T",300,"Q",1,"Water")
"twophase"
julia> propssi("P","T",300,"Q",1,"Water")
3536.806750422325
julia> phasesi("T",300,"P",3531,"Water")
"gas"
julia> phasesi("T",300,"P",3541,"Water")
"liquid"
```

# Ref
CoolProp::PhaseSI(const std::string &, double, const std::string &, double, const std::string&)
"""
function phasesi(name1::AbstractString, value1::Real, name2::AbstractString, value2::Real, fluid::AbstractString)
  val = ccall( (:PhaseSI, "CoolProp"), Int32, (Ptr{UInt8},Float64,Ptr{UInt8},Float64,Ptr{UInt8}, Ptr{UInt8}, Int), name1,value1,name2,value2,fluid,message_buffer::Array{UInt8,1},buffer_length)
  val = unsafe_string(convert(Ptr{UInt8}, pointer(message_buffer::Array{UInt8,1})))
  if val == ""
    error("CoolProp: ", get_global_param_string("errstring"))
  end
  return val
end
"""
    get_global_param_string(key::AbstractString)

Get a globally-defined string.

# Ref
ref CoolProp::get_global_param_string
# Arguments
* `key`: A string represents parameter name, could be one of $inputs_to_get_global_param_string
"""
function get_global_param_string(key::AbstractString)
  val = ccall( (:get_global_param_string, "CoolProp"), Clong, (Ptr{UInt8},Ptr{UInt8},Int), key, message_buffer::Array{UInt8,1}, buffer_length)
  if val == 0
    error("CoolProp: ", get_global_param_string("errstring"))
  end
  return unsafe_string(convert(Ptr{UInt8}, pointer(message_buffer::Array{UInt8,1})))
end

"""
    get_parameter_information_string(key::AbstractString,outtype::AbstractString)
    get_parameter_information_string(key::AbstractString)

Get information for a parameter.

# Arguments

* `key`: A string represents parameter name, to see full list check "Table of string inputs to PropsSI function": http://www.coolprop.org/coolprop/HighLevelAPI.html#parameter-table
* `outtype="long"`: Output type, could be one of the `["IO", "short", "long", "units"]`, with a default value of "long"

# Example
```julia
julia> get_parameter_information_string("HMOLAR")
"Molar specific enthalpy"

julia> get_parameter_information_string("HMOLAR", "units")
"J/mol"
```
# Note
This function return the output string in pre-allocated char buffer.  If buffer is not large enough, no copy is made

"""
function get_parameter_information_string(key::AbstractString,outtype::AbstractString)
  message_buffer[1:length(outtype)+1] = [outtype.data; 0x00]
  val = ccall( (:get_parameter_information_string, "CoolProp"), Clong, (Ptr{UInt8},Ptr{UInt8},Int), key,message_buffer::Array{UInt8,1},buffer_length)
  if val == 0
    error("CoolProp: ", get_global_param_string("errstring"))
  end
  return unsafe_string(convert(Ptr{UInt8}, pointer(message_buffer::Array{UInt8,1})))
end

function get_parameter_information_string(key::AbstractString)
  return get_parameter_information_string(key,"long")
end

"""
    get_fluid_param_string(fluid::AbstractString,param::AbstractString)

Get a string for a value from a fluid (numerical values for the fluid can be obtained from Props1SI function).

# Arguments

* `fluid`: The name of the fluid that is part of CoolProp, for instance "n-Propane"
* `param`: A string, can be in one of the terms described in the following table

ParamName                    | Description
:-------------------------   |:----------------------------------------
"aliases"                    | A comma separated list of aliases for the fluid
"CAS", "CAS_number"          | The CAS number
"ASHRAE34"                   | The ASHRAE standard 34 safety rating
"REFPROPName","REFPROP_name" | The name of the fluid used in REFPROP
"Bibtex-XXX"                 | A BibTeX key, where XXX is one of the bibtex keys used in get_BibTeXKey
"pure"                       | "true" if the fluid is pure, "false" otherwise
"formula"                    | The chemical formula of the fluid in LaTeX form if available, "" otherwise

"""
function get_fluid_param_string(fluid::AbstractString,param::AbstractString)
  val = ccall( (:get_fluid_param_string, "CoolProp"), Clong, (Ptr{UInt8},Ptr{UInt8},Ptr{UInt8},Int), fluid,param,message_buffer::Array{UInt8,1},buffer_length)
  if val == 0
    error("CoolProp: ", get_global_param_string("errstring"))
  end
  return unsafe_string(convert(Ptr{UInt8}, pointer(message_buffer::Array{UInt8,1})))
end

"""
    set_config(key::AbstractString, val::AbstractString)

\brief Set configuration string
@param key The key to configure
@param val The value to set to the key
\note you can get the error message by doing something like get_global_param_string("errstring",output)
ALTERNATIVE_TABLES_DIRECTORY, "ALTERNATIVE_TABLES_DIRECTORY", "", "If provided, this path will be the root directory for the tabular data.  Otherwise, \${HOME}/.CoolProp/Tables is used"
ALTERNATIVE_REFPROP_PATH, "ALTERNATIVE_REFPROP_PATH", "", "An alternative path to be provided to the directory that contains REFPROP's fluids and mixtures directories.  If provided, the SETPATH function will be called with this directory prior to calling any REFPROP functions."
ALTERNATIVE_REFPROP_HMX_BNC_PATH, "ALTERNATIVE_REFPROP_HMX_BNC_PATH", "", "An alternative path to the HMX.BNC file.  If provided, it will be passed into REFPROP's SETUP or SETMIX routines"
VTPR_UNIFAQ_PATH, "VTPR_UNIFAQ_PATH", "", "The path to the directory containing the UNIFAQ JSON files.  Should be slash terminated"
"""
function set_config(key::AbstractString, val::AbstractString)
  ccall( (:set_config_string, "CoolProp"), Void, (Ptr{UInt8},Ptr{UInt8}), key,val)
  return get_global_param_string("errstring")
end

"""
    set_config(key::AbstractString, val::Real)

\brief Set configuration numerical value as double
@param key The key to configure
@param val The value to set to the key
\note you can get the error message by doing something like get_global_param_string("errstring",output)
MAXIMUM_TABLE_DIRECTORY_SIZE_IN_GB, "MAXIMUM_TABLE_DIRECTORY_SIZE_IN_GB", 1.0, "The maximum allowed size of the directory that is used to store tabular data"
PHASE_ENVELOPE_STARTING_PRESSURE_PA, "PHASE_ENVELOPE_STARTING_PRESSURE_PA", 100.0, "Starting pressure [Pa] for phase envelope construction"
R_U_CODATA, "R_U_CODATA", 8.3144598, "The value for the ideal gas constant in J/mol/K according to CODATA 2014.  This value is used to harmonize all the ideal gas constants. This is especially important in the critical region."
SPINODAL_MINIMUM_DELTA, "SPINODAL_MINIMUM_DELTA", 0.5, "The minimal delta to be used in tracing out the spinodal; make sure that the EOS has a spinodal at this value of delta=rho/rho_r"
"""
function set_config(key::AbstractString, val::Real)
  ccall( (:set_config_double, "CoolProp"), Void, (Ptr{UInt8}, Float64), key, val)
  return get_global_param_string("errstring")
end

"""
    set_config(key::AbstractString, val::Bool)

\brief Set configuration value as a boolean
@param key The key to configure
@param val The value to set to the key
\note you can get the error message by doing something like get_global_param_string("errstring",output)
NORMALIZE_GAS_CONSTANTS, "NORMALIZE_GAS_CONSTANTS", true, "If true, for mixtures, the molar gas constant (R) will be set to the CODATA value"
CRITICAL_WITHIN_1UK, "CRITICAL_WITHIN_1UK", true, "If true, any temperature within 1 uK of the critical temperature will be considered to be AT the critical point"
CRITICAL_SPLINES_ENABLED, "CRITICAL_SPLINES_ENABLED", true, "If true, the critical splines will be used in the near-vicinity of the critical point"
SAVE_RAW_TABLES, "SAVE_RAW_TABLES", false, "If true, the raw, uncompressed tables will also be written to file"
REFPROP_DONT_ESTIMATE_INTERACTION_PARAMETERS, "REFPROP_DONT_ESTIMATE_INTERACTION_PARAMETERS", false, "If true, if the binary interaction parameters in REFPROP are estimated, throw an error rather than silently continuing"
REFPROP_IGNORE_ERROR_ESTIMATED_INTERACTION_PARAMETERS, "REFPROP_IGNORE_ERROR_ESTIMATED_INTERACTION_PARAMETERS", false, "If true, if the binary interaction parameters in REFPROP are unable to be estimated, silently continue rather than failing"
REFPROP_USE_GERG, "REFPROP_USE_GERG", false, "If true, rather than using the highly-accurate pure fluid equations of state, use the pure-fluid EOS from GERG-2008"
REFPROP_USE_PENGROBINSON, "REFPROP_USE_PENGROBINSON", false, "If true, rather than using the highly-accurate pure fluid equations of state, use the Peng-Robinson EOS"
DONT_CHECK_PROPERTY_LIMITS, "DONT_CHECK_PROPERTY_LIMITS", false, "If true, when possible, CoolProp will skip checking whether values are inside the property limits"
HENRYS_LAW_TO_GENERATE_VLE_GUESSES, "HENRYS_LAW_TO_GENERATE_VLE_GUESSES", false, "If true, when doing water-based mixture dewpoint calculations, use Henry's Law to generate guesses for liquid-phase composition"
OVERWRITE_FLUIDS, "OVERWRITE_FLUIDS", false, "If true, and a fluid is added to the fluids library that is already there, rather than not adding the fluid (and probably throwing an exception), overwrite it"
OVERWRITE_DEPARTURE_FUNCTION, "OVERWRITE_DEPARTURE_FUNCTION", false, "If true, and a departure function to be added is already there, rather than not adding the departure function (and probably throwing an exception), overwrite it"
OVERWRITE_BINARY_INTERACTION, "OVERWRITE_BINARY_INTERACTION", false, "If true, and a pair of binary interaction pairs to be added is already there, rather than not adding the binary interaction pair (and probably throwing an exception), overwrite it"
"""
function set_config(key::AbstractString, val::Bool)
  ccall( (:set_config_bool, "CoolProp"), Void, (Ptr{UInt8}, UInt8), key, val)
  return get_global_param_string("errstring")
end

###
#    /**
#     * @brief Set the departure functions in the departure function library from a string format
#     * @param string_data The departure functions to be set, either provided as a JSON-formatted string
#     *                    or as a string of the contents of a HMX.BNC file from REFPROP
#     * @param errcode The errorcode that is returned (0 = no error, !0 = error)
#     * @param message_buffer A buffer for the error code
#     * @param buffer_length The length of the buffer for the error code
#     *
#     * @note By default, if a departure function already exists in the library, this is an error,
#     *       unless the configuration variable OVERWRITE_DEPARTURE_FUNCTIONS is set to true
#     */
#    EXPORT_CODE void CONVENTION set_departure_functions(const char * string_data, long *errcode, char *message_buffer, const long buffer_length);
###

"""
    set_reference_stateS(Ref::AbstractString, reference_state::AbstractString)

\ref CoolProp::set_reference_stateS
@returns error_code 1 = Ok 0 = error
"""
function set_reference_stateS(Ref::AbstractString, reference_state::AbstractString)
  val = ccall( (:set_reference_stateS, "CoolProp"), Cint, (Ptr{UInt8},Ptr{UInt8}), Ref,reference_state)
  if val == 0
    error("CoolProp: ", get_global_param_string("errstring"))
  end
  return val
end

###
#    /**
#     * \overload
#     * \sa \ref CoolProp::set_reference_stateD
#     * @returns error_code 1 = Ok 0 = error
#     */
#    EXPORT_CODE int CONVENTION set_reference_stateD(const char *Ref, double T, double rhomolar, double hmolar0, double smolar0);
#    /** \brief FORTRAN 77 style wrapper of the PropsSI function
#     * \overload
#     * \sa \ref CoolProp::PropsSI(const std::string &, const std::string &, double, const std::string &, double, const std::string&)
#     *
#     * \note If there is an error, a huge value will be returned, you can get the error message by doing something like get_global_param_string("errstring",output)
#     */
#    EXPORT_CODE void CONVENTION propssi_(const char *Output, const char *Name1, const double *Prop1, const char *Name2, const double *Prop2, const char * Ref, double *output);
###

"""
    F2K(TF::Real)

Convert from degrees Fahrenheit to Kelvin (useful primarily for testing).
"""
function F2K(TF::Real)
  return ccall( (:F2K, "CoolProp"), Cdouble, (Cdouble,), TF)
end

"""
    K2F(TK::Real)

Convert from Kelvin to degrees Fahrenheit (useful primarily for testing).
"""
function K2F(TK::Real)
  return ccall( (:K2F, "CoolProp"), Cdouble, (Cdouble,), TK)
end

"""
    get_param_index(param::AbstractString)

Get the index for a parameter "T", "P", etc.

@returns index The index as a long.  If input is invalid, returns -1
"""
function get_param_index(param::AbstractString)
  val = ccall( (:get_param_index, "CoolProp"), Clong, (Ptr{UInt8},), param)
  if val == -1
    error("CoolProp: Unknown parameter: ", param)
  end
  return val
end

"""
    get_input_pair_index(param::AbstractString)

Get the index for an input pair for AbstractState.update function.

@returns index The index as a long.  If input is invalid, returns -1
"""
function get_input_pair_index(param::AbstractString)
  val = ccall( (:get_input_pair_index, "CoolProp"), Clong, (Ptr{UInt8},), param)
  if val == -1
    error("CoolProp: Unknown input pair: ", param)
  end
  return val
end
