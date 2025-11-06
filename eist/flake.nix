# I've retroactively added this flake, so it's not thoroughly or actively tested
{
  description = "eist flake";

  inputs = {
    nixpkgs_unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs_stable.url = "github:nixos/nixpkgs?ref=nixos-24.11";    
  };

  outputs = { self, nixpkgs_stable, nixpkgs_unstable, ... } @ inputs:
  let
    system = builtins.currentSystem or "x86_64-linux";
    unstable = import nixpkgs_unstable { inherit system; config.allowUnfree = true; };
    stable = import nixpkgs_stable { inherit system; config.allowUnfree = true; };
    python = unstable.python312;
  in
  {
    devShells.${system}.default = unstable.mkShell {
      nativeBuildInputs = [
        # java
        unstable.jetbrains.idea-ultimate
        (unstable.jdk17.override {enableJavaFX = true;})
        unstable.gradle
         
        # python
        python # I used IntelliJ to edit python, you may add another editor / tools as needed
        python.pip # use to install needed dependencies

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
  };
}
