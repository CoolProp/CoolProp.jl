# ---------------------------------
#        Humid Air Properties
# ---------------------------------

"""
    hapropssi(output::AbstractString, name1::AbstractString, value1::Real, name2::AbstractString, value2::Real, name3::AbstractString, value3::Real)

DLL wrapper of the HAPropsSI function.

# Arguments
* `output`:
* `name1`, `name2`, `name3`:

Description           |Parameter(s) name
:---------------------|:--------------
GIVEN_HUMRAT          |Omega HumRat W
GIVEN_PSIW            |psi_w Y
Dew point             |Tdp T_dp DewPoint D
Wet bulb temperature  |Twb T_wb WetBulb B
Enthalpy              |Enthalpy H Hda
GIVEN_ENTHALPY_HA     |Hha
Internal energy       |InternalEnergy U Uda
GIVEN_INTERNAL_ENERGY_HA |Uha
Entropy               |Entropy S Sda
GIVEN_ENTROPY_HA      |Sha
GIVEN_RH              |RH RelHum R
Temperature           |Tdb T_db T
Pressure              |P
GIVEN_VDA             |V Vda
GIVEN_VHA             |Vha
Viscosity             |mu Visc M
Conductivity          |k Conductivity K
GIVEN_CP              |C cp
GIVEN_CPHA            |Cha cp_ha
GIVEN_CV              |CV
GIVEN_CVHA            |CVha cv_ha
Partial pressure of water |P_w
GIVEN_ISENTROPIC_EXPONENT |isentropic_exponent
Speed of sound        |speed_of_sound
Compressibility factor|Z

# Example
```julia
# Enthalpy (J per kg dry air) as a function of temperature, pressure,
# and relative humidity at STP
julia> h = HAPropsSI("H","T",298.15,"P",101325,"R",0.5)
50423.45039247604
# Temperature of saturated air at the previous enthalpy
julia> T = HAPropsSI("T","P",101325,"H",h,"R",1.0)
290.9620891952412
# Temperature of saturated air - order of inputs doesn't matter
julia> T = HAPropsSI("T","H",h,"R",1.0,"P",101325)
290.9620891952412
```

# Ref
HumidAir::HAPropsSI(const char* OutputName, const char* Input1Name, double Input1, const char* Input2Name, double Input2, const char* Input3Name, double Input3);
"""
function hapropssi(output::AbstractString, name1::AbstractString, value1::Real, name2::AbstractString, value2::Real, name3::AbstractString, value3::Real)
  val = ccall( (:HAPropsSI, "CoolProp"), Cdouble, (Ptr{UInt8},Ptr{UInt8},Float64,Ptr{UInt8},Float64,Ptr{UInt8},Float64), output,name1,value1,name2,value2,name3,value3)
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
function cair_sat(t::Number)
  val = ccall( (:cair_sat, "CoolProp"), Cdouble, (Float64, ), t)
  return val;
end
