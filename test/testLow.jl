#low
info("********* Low Level Api *********")
const HEOS_BACKEND_FAMILY = "HEOS";
const REFPROP_BACKEND_FAMILY = "REFPROP";#Need Install
const INCOMP_BACKEND_FAMILY = "INCOMP";
const IF97_BACKEND_FAMILY = "IF97";
const TREND_BACKEND_FAMILY = "TREND";#Not Imple
const TTSE_BACKEND_FAMILY = "TTSE";
const BICUBIC_BACKEND_FAMILY = "BICUBIC";
const SRK_BACKEND_FAMILY = "SRK";
const PR_BACKEND_FAMILY = "PR";
const VTPR_BACKEND_FAMILY = "VTPR";#Need Install
HEOS = AbstractState_factory(HEOS_BACKEND_FAMILY, "R245fa");
TTSE = AbstractState_factory(HEOS_BACKEND_FAMILY * "&" * TTSE_BACKEND_FAMILY, "R245fa");
BICU = AbstractState_factory(HEOS_BACKEND_FAMILY * "&" * BICUBIC_BACKEND_FAMILY, "R245fa");
SRK = AbstractState_factory(SRK_BACKEND_FAMILY, "R245fa");
PR = AbstractState_factory(PR_BACKEND_FAMILY, "R245fa");
PT_INPUTS = get_input_pair_index("PT_INPUTS");
AbstractState_update(HEOS, PT_INPUTS, 101325, 300);
AbstractState_update(TTSE, PT_INPUTS, 101325, 300);
AbstractState_update(BICU, PT_INPUTS, 101325, 300);
AbstractState_update(SRK, PT_INPUTS, 101325, 300);
AbstractState_update(PR, PT_INPUTS, 101325, 300);
rhmolar = get_param_index("DMOLAR");
println("HEOS:", AbstractState_keyed_output(HEOS, rhmolar));
@time AbstractState_keyed_output(HEOS, rhmolar);
println("TTSE:", AbstractState_keyed_output(TTSE, rhmolar));
@time AbstractState_keyed_output(TTSE, rhmolar);
println("BICU:", AbstractState_keyed_output(BICU, rhmolar));
@time AbstractState_keyed_output(BICU, rhmolar);
println("SRK:", AbstractState_keyed_output(SRK, rhmolar));
@time AbstractState_keyed_output(SRK, rhmolar);
println("PR:", AbstractState_keyed_output(PR, rhmolar));
@time AbstractState_keyed_output(PR, rhmolar);
AbstractState_free(HEOS);
AbstractState_free(TTSE);
AbstractState_free(BICU);
AbstractState_free(SRK);
AbstractState_free(PR);
IF97 = AbstractState_factory(IF97_BACKEND_FAMILY, "");
pin = 101325;
tin = 308.15;
println("IF97::Water property for PT_INPUTS $pin $tin");
AbstractState_update(IF97, PT_INPUTS, pin, tin);
for p in "PTHDSAUCO"
  pi = get_param_index("$p");
  println("IF97 $p = ", AbstractState_keyed_output(IF97, pi));
end
qin = 0.5;
try
  println("IF97::Water property for QT_INPUTS $qin $tin")
  QT_INPUTS = get_input_pair_index("QT_INPUTS");
  AbstractState_update(IF97, QT_INPUTS, qin, tin);
  for p in "PTHDSAUQ"
    pi = get_param_index("$p");
    println("IF97 $p = ", AbstractState_keyed_output(IF97, pi));
  end
catch
  warn("QT_INPUTS not ready");
end
AbstractState_free(IF97);
