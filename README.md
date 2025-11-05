# tum-shells

## Everything is work in progress! Expect breakage!

## Usage

I highly recommend using these flakes with [nix-direnv](https://github.com/nix-community/nix-direnv)

#### As a template
`nix flake init -t github:DanielLagally/tum-shells#<name>`

You probably want to enable the direnv with
`direnv allow`

Or just run it manually with
`nix develop`

#### As a devShell
With direnv:
`echo "use flake github:DanielLagally/tum-shells#<name>" > .envrc & direnv allow`

Without direnv:
`nix develop github:DanielLagally/tum-shells#<name>`

Alternatively, you may clone the repository and instead use the path to your local copy

### Problems
Nix may throw:
`error: path '«github:DanielLagally/tum-shells/<commit-hash>»/flake.nix' does not exist`

In this case simply run
`nix flake update --flake github:DanielLagally/tum-shells`

This may also help if nix is not detecting that there's a newer commit of the repository

### TODO
- Move flakes from previous semesters / other classes
- Remove flake.lock(?)
- Compatibility without experimental features(?)

### Other resources
- [Official Nix Templates](https://github.com/NixOS/templates/)
- [More templates](https://github.com/the-nix-way/dev-templates/)
