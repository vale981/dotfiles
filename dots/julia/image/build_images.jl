using Pkg
Pkg.add("PackageCompiler")
Pkg.add("OhMyREPL")
Pkg.add("LanguageServer")
Pkg.add("Revise")

using PackageCompiler

PackageCompiler.create_sysimage(
    :LanguageServer;
    precompile_statements_file = "languageserver.jl",
    sysimage_path = "sys_ls.so",
)

PackageCompiler.create_sysimage(
    [:OhMyREPL, :Revise];
    precompile_statements_file = "repl_precompile.jl",
    sysimage_path = "sys_repl.so",
)
