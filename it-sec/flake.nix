/* Great inspiration for this flake was taken from https://github.com/the-nix-way/dev-templates/blob/main/python/flake.nix */
{
  description = "it-sec dev flake";

  inputs = {
    nixpkgs_unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs_stable.url = "github:nixos/nixpkgs?ref=nixos-24.11";    

    flake-utils.url =  "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs_stable, nixpkgs_unstable, flake-utils, ... } @ inputs:
    flake-utils.lib.eachDefaultSystem (system: 
      let
        unstable = import nixpkgs_unstable { inherit system; config.allowUnfree = true; };
        stable = import nixpkgs_stable { inherit system; config.allowUnfree = true; };

        python = unstable.python3;
      in
      {
        devShells.default = unstable.mkShellNoCC {
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
            pip # in case you need to install other dependencies
            # debugpy
            requests
            flask
          ];
        };
      })
    ;
}
