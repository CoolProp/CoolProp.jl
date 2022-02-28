export CoolProp_parameters, CoolProp_fluids;
"""
# CoolProp parameters table, to build run `CoolProp.buildparameters()`

$(isfile(abspath(@__FILE__, "..", "parameters.table")) ? readstring(abspath(@__FILE__, "..", "parameters.table")) : "")
"""
const CoolProp_parameters = "Type `?CoolProp_arameters` to get a list of all CoolProp parameters."
buildparameters() = begin
    logf = open("parameters.table", "w");
    println(logf, "Paramerer |Description |Unit |Comment ");
    println(logf, ":---------|:-----------|:----|:-------" );
    counter = 0;
    longunits = Set();
    for p in coolpropparameters
        longunit = get_parameter_information_string(p, "long") * " | " * get_parameter_information_string(p, "units");
        note = "";
        if (!in(longunit, longunits))
            push!(longunits, longunit);
        else
            note = " *Duplicated* "
        end
        for fluid in coolpropfluids
            try
                res = ("$(PropsSI(p, fluid))");
                note *= " **Constant Property** "
            break;
            catch err
            end
        end
        println(logf, "$p" * " | " * longunit * " | " * note);
    end
    close(logf);
end
"""
# CoolProp fluids table, to build run `CoolProp.buildfluids()`

$(isfile(abspath(@__FILE__, "..", "fluids.table")) ? readstring(abspath(@__FILE__, "..", "fluids.table")) : "")
"""
const CoolProp_fluids = "Type `?CoolProp_fluids` to get a list of all CoolProp fluids."
buildfluids() = begin
    logf = open("fluids.table", "w");
    println(logf, "ID |Name |Alias |CAS |Pure |Formula |BibTeX ");
    println(logf, ":--|:----|:-----|:---|:----|:-------|:------");
    id = 0;
    for fluid in coolpropfluids
        id+=1;
        print(logf, "$id | $fluid | $(get_fluid_param_string(fluid, "aliases"))");
        print(logf, " | $(get_fluid_param_string(fluid, "CAS"))");
        pure = get_fluid_param_string(fluid, "pure");
        print(logf, " | $pure");
        print(logf, " | $(get_fluid_param_string(fluid, "formula")) | ");
        for bi in ["BibTeX-CONDUCTIVITY", "BibTeX-EOS", "BibTeX-CP0", "BibTeX-SURFACE_TENSION","BibTeX-MELTING_LINE","BibTeX-VISCOSITY"]
            print(logf, " $bi:$(get_fluid_param_string(fluid, bi))");
        end
        print(logf, "\n");
     end
     close(logf);
end
# ---------------------------------
#       Information functions
# ---------------------------------

"""
    get_global_param_string(key::AbstractString)

Get a globally-defined string.

# Ref
ref CoolProp::get_global_param_string

# Arguments
* `key`: A string represents parameter name, could be one of $inputs_to_get_global_param_string
"""
function get_global_param_string(key::AbstractString)
    val = ccall( (:get_global_param_string, "CoolProp"), Clong, (Cstring, Ptr{UInt8}, Int), key, message_buffer::Array{UInt8, 1}, buffer_length)
    if val == 0
        error("CoolProp: ", get_global_param_string("errstring"))
    end
    return unsafe_string(convert(Ptr{UInt8}, pointer(message_buffer::Array{UInt8, 1})))
end

"""
    get_parameter_information_string(key::AbstractString, outtype::AbstractString)
    get_parameter_information_string(key::AbstractString)

Get information for a parameter.

# Arguments
* `key`: A string represents parameter name, to see full list check "Table of string inputs to PropsSI function": http://www.coolprop.org/coolprop/HighLevelAPI.html#parameter-table, or simply type `get_global_param_string("parameter_list")`
* `outtype="long"`: Output type, could be one of the `["IO", "short", "long", "units"]`, with a default value of "long"

# Example
```julia
julia> get_parameter_information_string("HMOLAR")
"Molar specific enthalpy"
julia> get_parameter_information_string("HMOLAR", "units")
"J/mol"
```

# Note
A tabular output for this function is available with `?CoolProp_parameters`
"""
function get_parameter_information_string(key::AbstractString, outtype::AbstractString)
    message_buffer[1:length(outtype)+1] = [Vector{UInt8}(outtype); 0x00]
    val = ccall( (:get_parameter_information_string, "CoolProp"), Clong, (Cstring, Ptr{UInt8}, Int), key, message_buffer::Array{UInt8, 1}, buffer_length)
    if val == 0
        error("CoolProp: ", get_global_param_string("errstring"))
    end
    return unsafe_string(convert(Ptr{UInt8}, pointer(message_buffer::Array{UInt8, 1})))
end

function get_parameter_information_string(key::AbstractString)
    return get_parameter_information_string(key, "long")
end

"""
    get_fluid_param_string(fluid::AbstractString, param::AbstractString)

Get a string for a value from a fluid (numerical values for the fluid can be obtained from Props1SI function).

# Arguments
* `fluid`: The name of the fluid that is part of CoolProp, for instance "n-Propane"
* `param`: A string, can be in one of the terms described in the following table

ParamName                    | Description
:----------------------------|:----------------------------------------
"aliases"                    | A comma separated list of aliases for the fluid
"CAS", "CAS_number"          | The CAS number
"ASHRAE34"                   | The ASHRAE standard 34 safety rating
"REFPROPName", "REFPROP_name"| The name of the fluid used in REFPROP
"Bibtex-XXX"                 | A BibTeX key, where XXX is one of the bibtex keys used in get_BibTeXKey
"pure"                       | "true" if the fluid is pure, "false" otherwise
"formula"                    | The chemical formula of the fluid in LaTeX form if available, "" otherwise

# Note
A tabular output for this function is available with `?CoolProp_fluids`
"""
function get_fluid_param_string(fluid::AbstractString, param::AbstractString)
    val = ccall( (:get_fluid_param_string, "CoolProp"), Clong, (Cstring, Cstring, Ptr{UInt8}, Int), fluid, param, message_buffer::Array{UInt8, 1}, buffer_length)
    if val == 0
        error("CoolProp: ", get_global_param_string("errstring"))
    end
    return unsafe_string(convert(Ptr{UInt8}, pointer(message_buffer::Array{UInt8, 1})))
end

"""
    F2K(tf::Real)

Convert from degrees Fahrenheit to Kelvin (useful primarily for testing).
"""
function F2K(tf::Real)
    return ccall( (:F2K, "CoolProp"), Cdouble, (Cdouble,), tf)
end

"""
    K2F(tk::Real)

Convert from Kelvin to degrees Fahrenheit (useful primarily for testing).
"""
function K2F(tk::Real)
    return ccall( (:K2F, "CoolProp"), Cdouble, (Cdouble,), tk)
end

"""
    get_param_index(param::AbstractString)

Get the index as a long for a parameter "T", "P", etc, for `abstractstate_keyed_output()` function.

# Arguments
* `param`: A string represents parameter name, to see full list check "Table of string inputs to PropsSI function": http://www.coolprop.org/coolprop/HighLevelAPI.html#parameter-table, or simply type `get_global_param_string("parameter_list")`
"""
function get_param_index(param::AbstractString)
    val = ccall( (:get_param_index, "CoolProp"), Clong, (Cstring,), param)
    if val == -1
        error("CoolProp: Unknown parameter: ", param)
    end
    return val
end

"""
    get_input_pair_index(pair::AbstractString)

Get the index for an input pair "PT_INPUTS", "HmolarQ_INPUTS", etc, for `abstractstate_update()` function.

# Arguments
* `pair::AbstractString`: The name of an input pair, described in the following table

Input Pair          |Description
:-------------------|:------------------------------------------------
QT_INPUTS           |Molar quality, Temperature in K
QSmolar_INPUTS      |Molar quality, Entropy in J/mol/K
QSmass_INPUTS       |Molar quality, Entropy in J/kg/K
HmolarQ_INPUTS      |Enthalpy in J/mol, Molar quality
HmassQ_INPUTS       |Enthalpy in J/kg, Molar quality
DmassQ_INPUTS       |Molar density kg/m^3, Molar quality
DmolarQ_INPUTS      |Molar density in mol/m^3, Molar quality
PQ_INPUTS           |Pressure in Pa, Molar quality
PT_INPUTS           |Pressure in Pa, Temperature in K
DmassT_INPUTS       |Mass density in kg/m^3, Temperature in K
DmolarT_INPUTS      |Molar density in mol/m^3, Temperature in K
HmassT_INPUTS       |Enthalpy in J/kg, Temperature in K
HmolarT_INPUTS      |Enthalpy in J/mol, Temperature in K
SmassT_INPUTS       |Entropy in J/kg/K, Temperature in K
SmolarT_INPUTS      |Entropy in J/mol/K, Temperature in K
TUmass_INPUTS       |Temperature in K, Internal energy in J/kg
TUmolar_INPUTS      |Temperature in K, Internal energy in J/mol
DmassP_INPUTS       |Mass density in kg/m^3, Pressure in Pa
DmolarP_INPUTS      |Molar density in mol/m^3, Pressure in Pa
HmassP_INPUTS       |Enthalpy in J/kg, Pressure in Pa
HmolarP_INPUTS      |Enthalpy in J/mol, Pressure in Pa
PSmass_INPUTS       |Pressure in Pa, Entropy in J/kg/K
PSmolar_INPUTS      |Pressure in Pa, Entropy in J/mol/K
PUmass_INPUTS       |Pressure in Pa, Internal energy in J/kg
PUmolar_INPUTS      |Pressure in Pa, Internal energy in J/mol
DmassHmass_INPUTS   |Mass density in kg/m^3, Enthalpy in J/kg
DmolarHmolar_INPUTS |Molar density in mol/m^3, Enthalpy in J/mol
DmassSmass_INPUTS   |Mass density in kg/m^3, Entropy in J/kg/K
DmolarSmolar_INPUTS |Molar density in mol/m^3, Entropy in J/mol/K
DmassUmass_INPUTS   |Mass density in kg/m^3, Internal energy in J/kg
DmolarUmolar_INPUTS |Molar density in mol/m^3, Internal energy in J/mol
HmassSmass_INPUTS   |Enthalpy in J/kg, Entropy in J/kg/K
HmolarSmolar_INPUTS |Enthalpy in J/mol, Entropy in J/mol/K
SmassUmass_INPUTS   |Entropy in J/kg/K, Internal energy in J/kg
SmolarUmolar_INPUTS |Entropy in J/mol/K, Internal energy in J/mol

# Example
```julia
julia> get_input_pair_index("PT_INPUTS")
9
```
"""
function get_input_pair_index(pair::AbstractString)
    val = ccall( (:get_input_pair_index, "CoolProp"), Clong, (Cstring,), pair)
    if val == -1
        error("CoolProp: Unknown input pair: ", pair)
    end
    return val
end
const coolpropparameters = map(String, split(get_global_param_string("parameter_list"),','));
const coolpropfluids = map(String, split(get_global_param_string("FluidsList"),','));
