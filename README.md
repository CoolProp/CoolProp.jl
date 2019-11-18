[![Build Status](https://img.shields.io/travis/vimalaad/CoolProp.jl/master.svg?label=master%20build)](https://travis-ci.org/vimalaad/CoolProp.jl)
[![Build Status](https://img.shields.io/travis/vimalaad/CoolProp.jl/nightly.svg?label=nightly%20build)](https://travis-ci.org/vimalaad/CoolProp.jl)

[![Build status](https://ci.appveyor.com/api/projects/status/gljbe5rx71u86qum/branch/master?svg=true&passingText=master%20-%20OK&failingText=master%20-%20FAILED&pendingText=master%20-%20PENDING)](https://ci.appveyor.com/project/vimalaad/coolprop-jl/branch/master)
[![Build status](https://ci.appveyor.com/api/projects/status/gljbe5rx71u86qum/branch/nightly?svg=true&passingText=nightly%20-%20OK&failingText=nightly%20-%20FAILED&pendingText=nightly%20-%20PENDING)](https://ci.appveyor.com/project/vimalaad/coolprop-jl/branch/nightly)

[![Coverage Status](https://img.shields.io/coveralls/vimalaad/CoolProp.jl/master.svg?label=master%20coverage)](https://coveralls.io/github/vimalaad/CoolProp.jl?branch=master)
[![Coverage Status](https://img.shields.io/coveralls/vimalaad/CoolProp.jl/nightly.svg?label=nightly%20coverage)](https://coveralls.io/github/vimalaad/CoolProp.jl?branch=nightly)

# CoolProp.jl
A Julia wrapper for CoolProp (http://www.coolprop.org)

This is not my work, and all the credit goes to the cool [CoolProp contributors](https://github.com/CoolProp/CoolProp/graphs/contributors). I only put this together to make things easier for a friend of mine.  

## Installation
```julia
Pkg.clone("https://github.com/CoolProp/CoolProp.jl.git")
```
or for nightly (Julia <0.7)
```julia
Pkg.add(PackageSpec(url="https://github.com/CoolProp/CoolProp.jl.git", rev="nightly"))
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
