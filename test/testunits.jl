using CoolProp, Test
using Unitful: K, °C, Pa, m, s, kg, μPa, atm, g, FreeUnits

let fluid="air"
  ρ = PropsSI("D", "T", 20°C, "P", 101325Pa, fluid)
  @test round(kg/m^3, ρ; digits=2) == 1.2kg/m^3
  μ = PropsSI("VISCOSITY", "T", 293K, "P", 101325Pa, fluid)
  @test round(μPa*s, μ; digits=2) == 18.2μPa*s

  # Test that all parameters return a unit
  for param in split(get_global_param_string("parameter_list"),',')
    @test CoolProp._get_unit(param,false) isa FreeUnits
  end
end

let p=1atm, Tdb = 20°C, φ = 0.6
  x = HAPropsSI("HumRat", "Tdb", Tdb, "RH", φ, "P", p) |> g/kg
  @test round(g/kg, x; digits=2) == 8.77g/kg
  Tdp = HAPropsSI("D", "T", 300K, "P", 101325Pa, "W", 0.01)
  @test round(K,Tdp) == 287K
end

@test length(CoolProp.get_fluid_param_string("Methane","JSON")) > 188000