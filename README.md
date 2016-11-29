[![Build Status](https://travis-ci.org/vimalaad/CoolProp.jl.svg?branch=master)](https://travis-ci.org/vimalaad/CoolProp.jl)<sub>master</sub>
[![Build Status](https://travis-ci.org/vimalaad/CoolProp.jl.svg?branch=nightly)](https://travis-ci.org/vimalaad/CoolProp.jl)<sub>nightly</sub>

[![Coverage Status](https://coveralls.io/repos/github/vimalaad/CoolProp.jl/badge.svg?branch=master)](https://coveralls.io/github/vimalaad/CoolProp.jl?branch=master)<sub>master</sub>
[![Coverage Status](https://coveralls.io/repos/github/vimalaad/CoolProp.jl/badge.svg?branch=nightly)](https://coveralls.io/github/vimalaad/CoolProp.jl?branch=nightly)<sub>nightly</sub>

[![codecov](https://codecov.io/gh/vimalaad/CoolProp.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/vimalaad/CoolProp.jl)<sub>master</sub>
[![codecov](https://codecov.io/gh/vimalaad/CoolProp.jl/branch/nightly/graph/badge.svg)](https://codecov.io/gh/vimalaad/CoolProp.jl)<sub>nightly</sub>
# CoolProp.jl
A Julia wrapper for CoolProp (http://www.coolprop.org)

This is not my work, and all the credit goes to the cool [CoolProp contributors](https://github.com/CoolProp/CoolProp/graphs/contributors). I only put this together to make things easier for a friend of mine.  

## Installation
```julia
Pkg.clone("https://github.com/vimalaad/CoolProp.jl.git")
Pkg.build("CoolProp") # to download the latest binaries
```
or
```julia
Pkg.clone("https://github.com/vimalaad/CoolProp.jl.git")
Pkg.checkout("CoolProp", "nightly")
Pkg.build("CoolProp") # to download the nightly binaries
```
## Note
The installer downloads related libraries respect to machine OS & wordsize. Please let me know if it does not work for you. As an alternative, you can download the binaries for your OS from [here](https://sourceforge.net/projects/coolprop/files/CoolProp/6.1.0/shared_library/)
