
[![test](https://github.com/CoolProp/CoolProp.jl/actions/workflows/test.yml/badge.svg)](https://github.com/CoolProp/CoolProp.jl/actions/workflows/test.yml)

# CoolProp.jl
A Julia wrapper for CoolProp (http://www.coolprop.org), offering access to thermodynamic properties for fluids and mixtures.

## Installation
```julia
using Pkg
Pkg.add("CoolProp")
```

## Usage
The API is described in http://www.coolprop.org/coolprop/HighLevelAPI.html.

You can obtain e.g. the boiling point of water like this:
```julia
using CoolProp
PropsSI("T", "P", 101325.0, "Q", 0.0, "Water")
373.1242958476844
```

The [Unitful](https://github.com/PainterQubits/Unitful.jl) package is also supported. When you make a call to `PropsSI` using units, the result will also have the relevant units:

```julia
using CoolProp
using Unitful: °C, Pa

PropsSI("P", "T", 100°C, "Q", 0.0, "Water")
101417.99665788244 Pa
```

Humid air properties are available using the `HAPropsSI` function, e.g. getting the enthalpy at 20°c and 50 % relative humidity:

```julia
using CoolProp
using Unitful: °C, Pa

HAPropsSI("H", "Tdb", 20°C, "RH", 0.5, "P", 101325Pa)
38622.83892391293 J kg⁻¹
```
