# tum-shells

## Everything is work in progress! Expect breakage!

## Usage

I highly recommend using these flakes with [nix-direnv](https://github.com/nix-community/nix-direnv)

#### As a template
`nix flake init -t github:DanielLagally/tum-shells#<name>`

You probably want to enable the direnv with:
`direnv allow`

#### As a devShell
With direnv:
`echo "use flake github:DanielLagally/tum-shells#<name>" > .envrc & direnv allow`

Without direnv:
`nix develop github:DanielLagally/tum-shells#<name>`

Alternatively, you may clone the repository and instead use the path to your local copy

### TODO
- Move flakes from previous semesters / other classes
- Remove flake.lock(?)
- Compatibility without experimental features(?)

### Other resources
- [Official Nix Templates](https://github.com/NixOS/templates/)
- [More templates](https://github.com/the-nix-way/dev-templates/)
