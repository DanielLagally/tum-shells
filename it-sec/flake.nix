{
  description = "it-sec dev flake";

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
    riscv_env = unstable.pkgsCross.riscv64;
    llvm_env = unstable.llvmPackages_20.stdenv;
  in
  {
    devShells.${system}.default = riscv_env.mkShell {
      nativeBuildInputs = [
        (unstable.python3.withPackages (py-pkgs: with py-pkgs; [
          pip
          requests
        ]))
        unstable.basedpyright
        unstable.ruff
      ];
      shellHook = ''
                  if [ ! -d venv ]; then
                    python -m venv --system-site-packages venv
                  fi
                  source venv/bin/activate
                '';
    };
    defaultTemplate = {
      path = ./.;
      description = "it-sec template";
    };
  };
}
