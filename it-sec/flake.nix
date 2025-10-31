/* Great inspiration for this flake was taken from https://github.com/the-nix-way/dev-templates/blob/main/python/flake.nix */
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

    python = unstable.python3;
  in
  {
    devShells.${system}.default = unstable.mkShellNoCC {
      venvDir = ".venv";

      postShellHook = ''
        venvVersionWarn() {
        	local venvVersion
        	venvVersion="$("$venvDir/bin/python" -c 'import platform; print(platform.python_version())')"

        	[[ "$venvVersion" == "${python.version}" ]] && return

        	cat <<EOF
        Warning: Python version mismatch: [$venvVersion (venv)] != [${python.version}]
                 Delete '$venvDir' and reload to rebuild for version ${python.version}
        EOF
        }

        venvVersionWarn
      '';

      packages = with python.pkgs; [
        venvShellHook

        # linting and type checking
        unstable.basedpyright
        unstable.ruff

        # python packages
        pip
        requests
      ];
    };
    defaultTemplate = {
      path = ./.;
      description = "it-sec template";
    };
  };
}
