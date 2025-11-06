# I've retroactively added this flake I used when I took fpv, so it's not thoroughly or actively tested
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
    stable = import nixpkgs_stable { inherit system; config.allowUnfree = true; };
    stdenv = unstable.gccStdenv;
  in
  {
    devShells.${system}.default = unstable.mkShell.override { inherit stdenv ; } {
      nativeBuildInputs = [
        unstable.ocaml
        unstable.dune_3
        unstable.ocamlPackages.utop # allows you simply run `utop` instead of `dune utop`, otherwise kind of redundant

        unstable.ocamlPackages.ocaml-lsp
        unstable.ocamlformat_0_26_1 # don't remember if I got this to run
        unstable.ocamlPackages.earlybird # don't remember if I got this to run
      ];
    };
  };
}
