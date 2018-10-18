#Finding PROPERTIES WITH NUMERICAL VALUES in Trivial inputs
tpropwithnumval = Set();
@info "Finding trivials with numerical value"
for p in coolproptrivialparameters
  missed = Set();
  for fluid in coolpropfluids
    try
      res = ("$(PropsSI(p, Compat.String(fluid)))");
      push!(tpropwithnumval, p);
    catch err
      push!(missed, fluid);
    end
  end
  if (length(missed) == length(coolpropfluids))
    # if (findfirst(fails_any_props_trivals, p) == 0)
    if findfirst(x->x==p, fails_any_props_trivals) == nothing
       @warn "None of the defined fluids return a number for $p (expected to have numerical value.)";
    else
       println("$p is trivial without any numericalvalue");
    end
  else
    length(missed) > 0 && println("Only $(collect(setdiff(coolpropfluids, missed))) return number for $p");
  end
end
if ((tpropwithnumval == Set(trivalwithnumval)) && (Set(setdiff(coolproptrivialparameters, tpropwithnumval)) == Set(fails_any_props_trivals)))
  @info "Trivial inputs with numerical values are as expected.";
else
  @warn "Trivial inputs with numerical values are not as expected.";
end
