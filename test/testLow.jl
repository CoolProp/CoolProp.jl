using CoolProp
using Test

#low
@info "********* Low Level Api *********"
const HEOS_BACKEND_FAMILY = "HEOS"
const REFPROP_BACKEND_FAMILY = "REFPROP";#Need Install
const INCOMP_BACKEND_FAMILY = "INCOMP"
const IF97_BACKEND_FAMILY = "IF97"
const TREND_BACKEND_FAMILY = "TREND";#Not Imple
const TTSE_BACKEND_FAMILY = "TTSE"
const BICUBIC_BACKEND_FAMILY = "BICUBIC"
const SRK_BACKEND_FAMILY = "SRK"
const PR_BACKEND_FAMILY = "PR"
const VTPR_BACKEND_FAMILY = "VTPR";#Need Install
HEOS = AbstractState_factory(HEOS_BACKEND_FAMILY, "R245fa")
TTSE = AbstractState_factory(HEOS_BACKEND_FAMILY * "&" * TTSE_BACKEND_FAMILY, "R245fa")
BICU = AbstractState_factory(HEOS_BACKEND_FAMILY * "&" * BICUBIC_BACKEND_FAMILY, "R245fa")
SRK = AbstractState_factory(SRK_BACKEND_FAMILY, "R245fa")
PR = AbstractState_factory(PR_BACKEND_FAMILY, "R245fa")
PT_INPUTS = get_input_pair_index("PT_INPUTS")
AbstractState_update(HEOS, PT_INPUTS, 101325, 300)
AbstractState_update(TTSE, PT_INPUTS, 101325, 300)
AbstractState_update(BICU, PT_INPUTS, 101325, 300)
AbstractState_update(SRK, PT_INPUTS, 101325, 300)
AbstractState_update(PR, PT_INPUTS, 101325, 300)
rhmolar = get_param_index("DMOLAR")
println("HEOS:", AbstractState_keyed_output(HEOS, rhmolar))
@time AbstractState_keyed_output(HEOS, rhmolar)
println("TTSE:", AbstractState_keyed_output(TTSE, rhmolar))
@time AbstractState_keyed_output(TTSE, rhmolar)
println("BICU:", AbstractState_keyed_output(BICU, rhmolar))
@time AbstractState_keyed_output(BICU, rhmolar)
println("SRK:", AbstractState_keyed_output(SRK, rhmolar))
@time AbstractState_keyed_output(SRK, rhmolar)
println("PR:", AbstractState_keyed_output(PR, rhmolar))
@time AbstractState_keyed_output(PR, rhmolar)
AbstractState_free(HEOS)
AbstractState_free(TTSE)
AbstractState_free(BICU)
AbstractState_free(SRK)
AbstractState_free(PR)
IF97 = AbstractState_factory(IF97_BACKEND_FAMILY, "Water")
pin = 101325
tin = 308.15
println("IF97::Water property for PT_INPUTS $pin $tin")
AbstractState_update(IF97, PT_INPUTS, pin, tin)
for p in "PTHDSAUCO"
    pi = get_param_index("$p")
    println("IF97 $p = ", AbstractState_keyed_output(IF97, pi))
end
qin = 0.5
try
    println("IF97::Water property for QT_INPUTS $qin $tin")
    QT_INPUTS = get_input_pair_index("QT_INPUTS")
    AbstractState_update(IF97, QT_INPUTS, qin, tin)
    for p in "PTHDSAUQ"
        pi = get_param_index("$p")
        println("IF97 $p = ", AbstractState_keyed_output(IF97, pi))
    end
catch
    @warn "QT_INPUTS not ready"
end
AbstractState_free(IF97)
#AbstractState_output AbstractState_set_fractions AbstractState_specify_phase
handle = AbstractState_factory("HEOS", "Water&Ethanol")
pq_inputs = get_input_pair_index("PQ_INPUTS")
t = get_param_index("T")
AbstractState_set_fractions(handle, [0.4, 0.6])
AbstractState_update(handle,pq_inputs,101325, 0)
mole_frac = [0.0, 0.0]
AbstractState_get_mole_fractions(handle, mole_frac)
gas_frac = [0.0, 0.0]
AbstractState_get_mole_fractions_satState(handle, "gas", gas_frac)
liq_frac = [0.0, 0.0]
AbstractState_get_mole_fractions_satState(handle, "liquid", liq_frac)
if (haskey(ENV, "includelocalwrapper") && ENV["includelocalwrapper"]=="on")
    T, p, rhomolar, hmolar, smolar = AbstractState_update_and_common_out(handle, pq_inputs, [101325.0], [0.0], 1)
    temp_, p, rhomolar, hmolar, smolar = AbstractState_update_and_common_out(handle, "PQ_INPUTS", [101325.0], [0.0], 1)
    out = AbstractState_update_and_1_out(handle, pq_inputs, [101325.0], [0.0],1, t)
    out_ = AbstractState_update_and_1_out(handle, "PQ_INPUTS", [101325.0], [0.0],1, "T")
    out1, out2, out3, out4, out5 = AbstractState_update_and_5_out(handle, pq_inputs, [101325.0], [0.0],1, [t, t, t, t, t])
    out1_, out2, out3, out4, out5 = AbstractState_update_and_5_out(handle, "PQ_INPUTS", [101325.0], [0.0],1, ["T", "T", "T", "T", "T"])
else
    T = [0.0]; p = [0.0]; rhomolar = [0.0]; hmolar = [0.0]; smolar = [0.0]; temp_=[0.0]; out=[0.0]; out_=[0.0]
    AbstractState_update_and_common_out(handle, pq_inputs, [101325.0], [0.0], 1, T, p, rhomolar, hmolar, smolar)
    AbstractState_update_and_common_out(handle, "PQ_INPUTS", [101325.0], [0.0], 1, temp_, p, rhomolar, hmolar, smolar)
    AbstractState_update_and_1_out(handle, pq_inputs, [101325.0], [0.0],1, t, out)
    AbstractState_update_and_1_out(handle, "PQ_INPUTS", [101325.0], [0.0],1, "T", out_)
    out1=[0.0]; out2=[0.0]; out3=[0.0]; out4=[0.0]; out5=[0.0]; out1_=[0.0]
    AbstractState_update_and_5_out(handle, pq_inputs, [101325.0], [0.0],1, [t, t, t, t, t], out1, out2, out3, out4, out5)
    AbstractState_update_and_5_out(handle, "PQ_INPUTS", [101325.0], [0.0],1, ["T", "T", "T", "T", "T"], out1_, out2, out3, out4, out5)
end
if Sys.isapple()
    @test AbstractState_keyed_output(handle,t) ≈ 352.3522212978604
    @test AbstractState_output(handle,"T") ≈ 352.3522212978604
    @test T[1] ≈ 352.3522212978604
    @test temp_[1] ≈ 352.3522212978604
    @test out[1] ≈ 352.3522212978604
    @test out_[1] ≈ 352.3522212978604
    @test out1[1] ≈ 352.3522212978604
    @test out1_[1] ≈ 352.3522212978604
else
    @test AbstractState_keyed_output(handle,t) ≈ 352.3522212991724
    @test AbstractState_output(handle,"T") ≈ 352.3522212991724
    @test T[1] ≈ 352.3522212991724
    @test temp_[1] ≈ 352.3522212991724
    @test out[1] ≈ 352.3522212991724
    @test out_[1] ≈ 352.3522212991724
    @test out1[1] ≈ 352.3522212991724
    @test out1_[1] ≈ 352.3522212991724
end
for phase in ["phase_liquid", "phase_gas", "phase_twophase", "phase_supercritical", "phase_supercritical_gas", "phase_supercritical_liquid", "phase_critical_point", "phase_unknown", "phase_not_imposed"]
    AbstractState_specify_phase(handle, phase)
end
#AbstractState_set_binary_interaction_double AbstractState_set_fractions
AbstractState_free(handle)
handle = AbstractState_factory("HEOS", "Water&Ethanol")
AbstractState_set_binary_interaction_double(handle, 0, 1, "betaT", 0.987)
pq_inputs = get_input_pair_index("PQ_INPUTS")
t = get_param_index("T")
AbstractState_set_fractions(handle, [0.4, 0.6])
AbstractState_update(handle, pq_inputs, 101325, 0)
res = AbstractState_keyed_output(handle,t)
AbstractState_free(handle)
#AbstractState_set_cubic_alpha_C AbstractState_set_fluid_parameter_double
handle = AbstractState_factory("SRK", "Ethanol")
#AbstractState_set_cubic_alpha_C http://www.cjche.com.cn/EN/article/downloadArticleFile.do?attachType=PDF&id=1635
try
    #do not export on all machines
    AbstractState_set_cubic_alpha_C(handle, 0, "TWU", 1.0, 1.0, 1.0)
catch err
    @warn "AbstractState_set_cubic_alpha_C fails with: $err"
end
AbstractState_set_fluid_parameter_double(handle, 0, "c", 1.0)
AbstractState_free(handle)
if (haskey(ENV, "includelocalwrapper") && ENV["includelocalwrapper"]=="on")
    handle = AbstractState_factory("HEOS", "Water")
    AbstractState_update(handle, "PQ_INPUTS", 15e5, 0)
    @test AbstractState_first_saturation_deriv(handle, get_param_index("Hmolar"), get_param_index("P")) ≈ 0.0025636362140578207
    @test AbstractState_first_partial_deriv(handle, get_param_index("Hmolar"), get_param_index("P"), get_param_index("S")) ≈ 2.07872526058326e-5
    AbstractState_free(handle)
    #envelope
    HEOS=AbstractState_factory("HEOS","Methane&Ethane")
    len=200
    t=zeros(len);p=zeros(len);x=zeros(2*len);y=zeros(2*len);rhomolar_vap=zeros(len);rhomolar_liq=zeros(len);
    tau=zeros(len);delta=zeros(len);m1=zeros(len);
    for x0 in [0.02, 0.2, 0.4, 0.8]
        AbstractState_set_fractions(HEOS, [x0, 1 - x0])
        try
            AbstractState_build_phase_envelope(HEOS, "none")
            AbstractState_get_phase_envelope_data(HEOS, len, t, p, rhomolar_vap, rhomolar_liq, x, y)
            AbstractState_build_spinodal(HEOS)
            AbstractState_get_spinodal_data(HEOS, len, tau, delta, m1)
        catch err
            println("$x0  $err")
        end
    end
    t, p, rhomolar_vap, rhomolar_liq, x, y = AbstractState_get_phase_envelope_data(HEOS, len, 2)
    tau, delta, m1 = AbstractState_get_spinodal_data(HEOS, len)
    rhomolar=zeros(len); stable=zeros(Clong, len)
    t, p, rhomolar, stable = AbstractState_all_critical_points(HEOS, len)
    AbstractState_free(HEOS)
end
