using Compat
import LibGit2
import JSON
const OS_ARCH_CoolProp = (Sys.WORD_SIZE == 64) ? "64bit" : (Sys.iswindows() ? "32bit__cdecl" : "32bit");
const destpathbase = abspath(@__FILE__, "..", "lib");

# const branchname = LibGit2.branch(LibGit2.GitRepo(abspath(@__FILE__, "..", "..")));
const branchname = "master"
@info "On $branchname";
latestVersion_CoolProp = "";
_download(s, d) = isfile(d) ? throw("file exists ...") : begin
    @info "Downloading $s => $d ."
    download(s, d);
    @info "Done.";
end
if isdir(destpathbase)
    @warn "$destpathbase exists make sure to remove old library files.";
else
    mkdir(destpathbase);
end
try
    latestVersion_CoolProp = JSON.parse(read(download("https://sourceforge.net/projects/coolprop/best_release.json"), String))["release"]["filename"][11:15];  
catch err
    latestVersion_CoolProp = "6.1.0";
    @warn "unable to download may be a windows machine firewall.. , set latestVersion_CoolProp = $latestVersion_CoolProp";
end
latestVersion_CoolProp = JSON.parse(read(download("https://sourceforge.net/projects/coolprop/best_release.json"), String))["release"]["filename"][11:15]; 
coolpropurlbase = "http://netix.dl.sourceforge.net/project/coolprop/CoolProp/$latestVersion_CoolProp/";

(branchname == "nightly") && (global coolpropurlbase = "http://www.coolprop.dreamhosters.com/binaries/");
(branchname == "master") && (global coolpropurlbase = "http://netix.dl.sourceforge.net/project/coolprop/CoolProp/$latestVersion_CoolProp/");
try
    println("CoolProp latestVersion = $latestVersion_CoolProp ...")
    # _download(coolpropurlbase * "Julia/CoolProp.jl", joinpath(destpathbase,"CoolProp.jl")); 
    @info "I'm Getting CoolProp Binaries...";
    @static if  Sys.iswindows()
        urlbase = coolpropurlbase * "shared_library/Windows/$OS_ARCH_CoolProp/";
        _download(joinpath(urlbase,"CoolProp.dll"), joinpath(destpathbase,"CoolProp.dll"));
        _download(joinpath(urlbase,"CoolProp.lib"), joinpath(destpathbase,"CoolProp.lib"));
        _download(joinpath(urlbase,"exports.txt"), joinpath(destpathbase,"exports.txt"));
    end
    @static if  Sys.islinux()
        (branchname == "nightly") && (global coolpropurlbase = "http://netix.dl.sourceforge.net/project/coolprop/CoolProp/nightly/");
        urlbase = coolpropurlbase * "shared_library/Linux/$OS_ARCH_CoolProp/libCoolProp.so.$latestVersion_CoolProp";
        _download(urlbase, joinpath(destpathbase,"CoolProp.so"));
    end
    @static if  Sys.isapple()
        urlbase = coolpropurlbase * "shared_library/Darwin/$OS_ARCH_CoolProp/libCoolProp.dylib";
        _download(urlbase, joinpath(destpathbase,"CoolProp.dylib"));
    end
    (branchname == "nightly") && begin
        @info "Building help tables..."
        touch(joinpath(destpathbase, "fluids.table"))
        touch(joinpath(destpathbase, "parameters.table"))
        import CoolProp: buildfluids , buildparameters
        buildfluids();
        buildparameters();
    end
catch err
    println("Build error: $err")
end