
# ---------------------------------
#        High-level functions
# ---------------------------------

"""
    propssi(fluid::AbstractString, output::AbstractString)

Return a value that does not depend on the thermodynamic state - this is a convenience function that does the call `PropsSI(output, "", 0, "", 0, fluid)`.

# Arguments
* `fluid::AbstractString`: The name of the fluid that is part of CoolProp, for instance "n-Propane", to get a list of different passible fulid types call `get_global_param_string(key)` with `key` one of the following: `["FluidsList", "incompressible_list_pure", "incompressible_list_solution", "mixture_binary_pairs_list", "predefined_mixtures"]`, also there is a list in CoolProp online documentation [List of Fluids](http://www.coolprop.org/fluid_properties/PurePseudoPure.html#list-of-fluids), or simply type `?fluids`
* `output::AbstractString`: The name of parameter to evaluate. to see a list type `?parameters`

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
* `fluid::AbstractString`: The name of the fluid that is part of CoolProp, for instance "n-Propane", to get a list of different passible fulid types call `get_global_param_string(key)` with `key` one of the following: `["FluidsList", "incompressible_list_pure", "incompressible_list_solution", "mixture_binary_pairs_list", "predefined_mixtures"]`, also there is a list in CoolProp online documentation [List of Fluids](http://www.coolprop.org/fluid_properties/PurePseudoPure.html#list-of-fluids)
* `output::AbstractString`: The name of parameter to evaluate. to see a list type `?parameters`
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

Return a string representation of the phase. Valid states are: "liquid", "supercritical", "supercritical_gas", "supercritical_liquid", "critical_point", "gas", "twophase"

# Arguments
* `fluid::AbstractString`: The name of the fluid that is part of CoolProp, for instance "n-Propane", to get a list of different passible fulid types call `get_global_param_string(key)` with `key` one of the following: `["FluidsList", "incompressible_list_pure", "incompressible_list_solution", "mixture_binary_pairs_list", "predefined_mixtures"]`, also there is a list in CoolProp online documentation [List of Fluids](http://www.coolprop.org/fluid_properties/PurePseudoPure.html#list-of-fluids)
* `name1::AbstractString`: The name of parameter for first state point
* `value1::AbstractString`: Value of the first state point
* `name2::AbstractString`: The name of parameter for second state point
* `value2::AbstractString`: Value of the second state point

# Example
```julia
julia> phasesi("T",propssi("TCRIT", "Water"),"P",propssi("PCRIT", "Water"),"Water")
"critical_point"
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
