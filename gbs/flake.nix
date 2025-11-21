{
  description = "gbs dev flake";

  inputs = {
    nixpkgs_unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs_stable.url = "github:nixos/nixpkgs?ref=nixos-24.11";    

    flake-utils.url =  "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs_stable, nixpkgs_unstable, flake-utils, ... } @ inputs:
    flake-utils.lib.eachDefaultSystem (system: 
    let
      unstable = import nixpkgs_unstable {
        inherit system;
        config.allowUnfree = true;
      };
      filterBrokenPackages = builtins.filter (pkg: !pkg.meta.broken);
    in
      {
        devShells.default = unstable.mkShell {
         nativeBuildInputs = filterBrokenPackages [
          unstable.pkgsCross.riscv64.gcc
          unstable.pkgsCross.riscv64.gdb
          unstable.pkgsCross.riscv64.binutils

          unstable.gcc
          unstable.binutils
          unstable.gnumake
          unstable.gdb
          unstable.valgrind # does not exist on mac
          unstable.man-pages
          unstable.bash
          unstable.bash-completion
          unstable.qemu

          # helix / editor support
          unstable.clang-tools # clangd
          unstable.libllvm
          unstable.lldb
          unstable.bear # '$ bear -- make <target>' | generate compile_commands.json for clangd
        ];

          hardeningDisable = [ "all" ]; # allows compiling with -O0 flag for debugging
        };
      }
    );
}
