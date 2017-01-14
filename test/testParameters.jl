missed = Set();
const parameterswithnumval = union(trivalwithnumval, Set(["P_TRIPLE","pcrit","p_triple","MOLEMASS","rhomolar_critical",
"MOLARMASS","Pcrit","gas_constant","Tcrit","p_reducing","Tmin","rhocrit","molarmass","T_CRITICAL",
"P_min","pmax","T_min","T_reducing","T_MAX","P_MIN","T_triple","P_MAX","ptriple","Ttriple",
"acentric","p_critical","Tmax","T_TRIPLE","rhomolar_reducing","MOLAR_MASS",
"P_CRITICAL","T_max","molemass","T_MIN","rhomass_critical","T_critical",
"P_max","RHOMASS_CRITICAL","molar_mass","pmin"]));
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
      (!in(p, parameterswithnumval)) && push!(missed, p);
      note *= " **Constant Property** "
      counter+=1;
      break;
    catch err
    end
  end
end
length(missed) > 0 && warn("missed parameters with numerical value:\n $missed)");
@test length(parameterswithnumval) == counter
info("parameters with numerical values are as expected");
