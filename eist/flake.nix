# I've retroactively added this flake, so it's not thoroughly or actively tested
# NOT USING DIRENV BREAKS THE INTELLIJ INTERNAL SHELL, HIGHLY RECOMMEND USING DIRENV
{
  description = "eist flake";

  inputs = {
    nixpkgs_unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs_stable.url = "github:nixos/nixpkgs?ref=nixos-25.05";    

    flake-utils.url =  "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs_stable, nixpkgs_unstable, flake-utils, ... } @ inputs:
    flake-utils.lib.eachDefaultSystem (system: 
      let
        unstable = import nixpkgs_unstable { inherit system; config.allowUnfree = true; };
        stable = import nixpkgs_stable { inherit system; config.allowUnfree = true; };
        python = unstable.python312;

        filterBrokenPackages = builtins.filter (pkg: !pkg.meta.broken);
      in
      {
        devShells.default = unstable.mkShell {
          nativeBuildInputs = filterBrokenPackages [
            # java
            unstable.jetbrains.idea-ultimate
            unstable.jdk17
            # (unstable.jdk17.override {enableJavaFX = true;})
            # as of right now, JavaFX uses gradle_7 which has been marked as insecure. Patching this would probably be a larger undertaking, so if you really need JavaFX, you may uncomment the override and run the devShell in impure mode. Hopefully this will be fixed upstream soon
            unstable.gradle
         
            # python
            python # I used IntelliJ to edit python, you may add another editor / tools as needed
            python.pkgs.pip # use to install needed dependencies
            python.pkgs.venvShellHook

            # c
            unstable.gnumake
            unstable.man-pages
            unstable.man-pages-posix
            unstable.cmake
            unstable.valgrind
            # helix / editor support
            unstable.clang-tools # clangd
            unstable.libllvm
            unstable.lldb
            unstable.bear # '$ bear -- make <target>' | generate compile_commands.json for clangd

            # other tools
            unstable.bazel_7
            unstable.protobuf
            unstable.podman # daemon-less docker replacement, does have some quirks that make it not 100% compatible with some exercises, so you may opt for docker
            unstable.podman-compose
          ];

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
        };
      }
    );
}
