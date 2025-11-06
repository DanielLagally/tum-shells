{
  description = "main system config";

  inputs = {
    nixpkgs_unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs_stable.url = "github:nixos/nixpkgs?ref=nixos-24.11";    
  };

  outputs = { self, nixpkgs_stable, nixpkgs_unstable, ... } @ inputs:
  let
    system = builtins.currentSystem or "x86_64-linux";
    unstable = import nixpkgs_unstable { inherit system; config.allowUnfree = true; };
    unstableWithCuda = import nixpkgs_unstable { inherit system; config.allowUnfree = true; config.cudaSupport = true; };
    stable = import nixpkgs_stable { inherit system; config.allowUnfree = true; };
    stdenv = unstable.gccStdenv;
    llvm_env = unstable.llvmPackages_20.stdenv;
  in
  {
    devShells.${system}.default = unstable.mkShell.override { inherit stdenv ; } {
      nativeBuildInputs = [
        unstable.ocamlPackages.ocaml-lsp
        unstable.ocaml
        unstable.ocamlformat_0_26_1
        unstable.dune_3
        unstable.ocamlPackages.earlybird
        unstable.ocamlPackages.utop
      ];
    };
  };
}
