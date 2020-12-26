
[![Coverage Status](https://img.shields.io/coveralls/vimalaad/CoolProp.jl/master.svg?label=master%20coverage)](https://coveralls.io/github/vimalaad/CoolProp.jl?branch=master)
[![Coverage Status](https://img.shields.io/coveralls/vimalaad/CoolProp.jl/nightly.svg?label=nightly%20coverage)](https://coveralls.io/github/vimalaad/CoolProp.jl?branch=nightly)

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
## Development
For development, it is possible to include a custom wrapper from `ENV["TestingPath"]`, then:  
```julia
ENV["includelocalwrapper"]="on";
using CoolProp;
```
if `!haskey(ENV, "TestingPath")` the default `\test\CoolProp.jl` will be used.
