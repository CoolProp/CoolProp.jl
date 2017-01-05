# ---------------------------------
#        Humid Air Properties
# ---------------------------------

"""
    hapropssi(output::AbstractString, name1::AbstractString, value1::Real, name2::AbstractString, value2::Real, name3::AbstractString, value3::Real)

DLL wrapper of the HAPropsSI function.

# Arguments
* `output`: Output name for desired property, accepetd values are listed in the following table
* `name1`, `name2`, `name3`: Input name of  given state values, one must be "P"

# Note
Here, all outputs calculated as functions of these three: "Y"(Water mole fraction), "T" and "P", as "P" is mandatory so more perfomance achived when "Y" and "T" is given (or at least one of them).

Parameter(s) name     |Description                                 |Unit      |Formula
:---------------------|:-------------------------------------------|:---------|:-------------------------------
Omega HumRat W        |Humidity ratio                              |          |
psi_w Y               |Water mole fraction                         |mol_w/mol |
Tdp T_dp DewPoint D   |Dew point temperature                       |K         |
Twb T_wb WetBulb B    |Wet bulb temperature                        |K         |
Enthalpy H Hda        |Enthalpy                                    |J/kg_da   |
Hha                   |Enthalpy per kg of humid air                |J/kg_ha   |
InternalEnergy U Uda  |Internal energy                             |J/kg_da   |
Uha                   |Internal energy per kg of humid air         |J/kg_ha   |
Entropy S Sda         |Entropy                                     |J/kg_da/K |
Sha                   |Entropy per kg of humid air                 |J/kg_ha/K |
RH RelHum R           |Relative humidity                           |          |
Tdb T_db T            |Temperature                                 |K         |
P                     |Pressure                                    |Pa        |
V Vda                 |Specific volume                             |m^3/kg_da |``MolarVolume*(1+HumidityRatio)/M_ha``
Vha                   |Specific volume per kg of humid air         |m^3/kg_ha |``MolarVolume/M_ha``
mu Visc M             |Viscosity                                   |          |
k Conductivity K      |Conductivity                                |          |
C cp                  |Heat cap. const. press.                     |J/kg_da/K |
Cha cp_ha             |Heat cap. const. press. per kg of humid air |J/kg_ha/K |
CV                    |Heat cap. const. vol.                       |J/kg_da/K |
CVha cv_ha            |Heat cap. const. vol. per kg of humid air   |J/kg_ha/K |
P_w                   |Partial pressure of water                   |          |
isentropic_exponent   |Isentropic exponent                         |          |
speed_of_sound        |Speed of sound                              |          |``sqrt(1/M_ha*cp/cv*dpdrho__constT)``
Z                     |Compressibility factor                      |          |``P*MolarVolume/(R*T)``

# Example
```julia
# Enthalpy (J per kg dry air) as a function of temperature, pressure,
# and relative humidity at STP
julia> h = hapropssi("H", "T", 298.15, "P", 101325, "R", 0.5)
50423.45039247604
# Temperature of saturated air at the previous enthalpy
julia> T = hapropssi("T", "P", 101325, "H", h, "R", 1.0)
290.9620891952412
# Temperature of saturated air - order of inputs doesn't matter
julia> T = hapropssi("T", "H", h, "R", 1.0, "P", 101325)
290.9620891952412
```

# Ref
HumidAir::HAPropsSI(const char* OutputName, const char* Input1Name, double Input1, const char* Input2Name, double Input2, const char* Input3Name, double Input3);
"""
function hapropssi(output::AbstractString, name1::AbstractString, value1::Real, name2::AbstractString, value2::Real, name3::AbstractString, value3::Real)
  val = ccall( (:HAPropsSI, "CoolProp"), Cdouble, (Cstring, Cstring, Cdouble, Cstring, Cdouble, Cstring, Cdouble), output, name1, value1, name2, value2, name3, value3)
  if val == Inf
    error("CoolProp: ", get_global_param_string("errstring"))
  end
  return val
end

"""
    cair_sat(t::Real)

Air saturation specific heat in [kJ/kg-K] based on a correlation from EES, good from 250K to 300K.

# Arguments
* `t`: Temperature in Kelvin

# Ref
HumidAir::cair_sat(double);

# Note
No error bound checking is carried out
"""
function cair_sat(t::Real)
  val = ccall( (:cair_sat, "CoolProp"), Cdouble, (Cdouble, ), t)
  return val;
end
