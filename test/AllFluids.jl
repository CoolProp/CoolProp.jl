id = 0;
counter = 0;
maxdiffreduvscriti = 0.0;
maxfluid = "";
uneq = Set();
logf = open("fluids.table", "w");
println(logf, "ID |Name |Alias |CAS |Pure |Formula |BibTeX ");
println(logf, ":--|:----|:-----|:---|:----|:-------|:------");
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
  tcrit = PropsSI("TCRIT", fluid);
  pcrit = PropsSI("PCRIT", fluid);
  !(fluid in fails_critical_point) && begin
    #DiethylEther
    @test PhaseSI("P", pcrit, "T", tcrit, fluid)=="critical_point";
    @test PhaseSI("P", pcrit+100, "T", tcrit+10, fluid)=="supercritical";
    @test PhaseSI("P", pcrit+100, "T", tcrit-10, fluid)=="supercritical_liquid";
    @test PhaseSI("P", pcrit-100, "T", tcrit+10, fluid)=="supercritical_gas";
    psat = PropsSI("P","T",tcrit-10,"Q",1, fluid);
    @test PhaseSI("P", psat+100, "T", tcrit-10, fluid)=="liquid";
    @test PhaseSI("P", psat-100, "T", tcrit-10, fluid)=="gas";
  end
  (pure == "true") && (tcrit != PropsSI("T_REDUCING", fluid)) && push!(uneq, fluid);
  diffreduvscriti = abs(PropsSI("TCRIT", fluid) - PropsSI("T_REDUCING", fluid));
  if (diffreduvscriti > maxdiffreduvscriti)
    maxfluid = fluid;
    maxdiffreduvscriti = diffreduvscriti;
  end
end
close(logf);
println("max diff between reducing vs critical point temp: $maxdiffreduvscriti for $maxfluid");
@test uneq == Set(fails_tcrit_eq_treducing);
println("fails_tcrit_eq_treducing $uneq");
