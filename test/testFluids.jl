global id = 0;
counter = 0;
global maxdiffreduvscriti = 0.0;
maxfluid = "";
uneq = Set();
critphasefail = Set();
for fluid in coolpropfluids
    global id+=1;
    pure = get_fluid_param_string(fluid, "pure");
    tcrit = PropsSI("TCRIT", fluid);
    pcrit = PropsSI("PCRIT", fluid);
    try
        (PhaseSI("P", pcrit, "T", tcrit, fluid) != "critical_point") && push!(critphasefail, fluid);
    catch err
        push!(critphasefail, fluid);
    end
    @test PhaseSI("P", pcrit+50000, "T", tcrit+3, fluid)=="supercritical";
    @test PhaseSI("P", pcrit+50000, "T", tcrit-3, fluid)=="supercritical_liquid";
    @test PhaseSI("P", pcrit-50000, "T", tcrit+3, fluid)=="supercritical_gas";
    psat = PropsSI("P","T",tcrit-3,"Q",1, fluid);
    t3 = PropsSI("Ttriple", fluid);
    p3 = PropsSI("ptriple", fluid);
    @test PhaseSI("P", p3, "T", (t3+tcrit)/2, fluid)=="gas";
    @test PhaseSI("P", (pcrit+p3)/2, "T", (t3+tcrit)/2, fluid)=="liquid";
    (pure == "true") && (tcrit != PropsSI("T_REDUCING", fluid)) && push!(uneq, fluid);
    global diffreduvscriti = abs(PropsSI("TCRIT", fluid) - PropsSI("T_REDUCING", fluid));
    if (diffreduvscriti > maxdiffreduvscriti)
        maxfluid = fluid;
        global maxdiffreduvscriti = diffreduvscriti;
    end
end
println("max diff between reducing vs critical point T: $maxdiffreduvscriti for $maxfluid");
@test uneq == Set(fails_tcrit_eq_treducing);
println("different reducing vs critical point: $uneq");
@test issubset(critphasefail, Set(fails_critical_point));
println("fails to get phase for critical point: $critphasefail");
