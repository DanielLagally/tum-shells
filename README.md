# tum-shells

## Everything is work in progress! Expect breakage!

## Purpose

This repo is meant to be a stepping stone to people at TUM interested in or already actively using nix.

When using the recommended approach you will benefit in the following ways:
- all dependencies you need, installed with one command
- minimal setup or configuration required
- no polluting your user space with clutter
- directory-based dependency isolation
- learn some nix along the way 

### Installing Nix
You don't need to change your OS to try [Nix](https://github.com/NixOS/nix)! You can install [NixOS](https://nixos.org/download/#nixos-iso), but Nix also works on generic [Linux](https://nixos.org/download/#nix-install-linux "linux installation guide") and [MacOS](https://nixos.org/download/#nix-install-macos "macos installation guide") as well as [WSL](https://nixos.org/download/#nix-install-windows "wsl installation guide") and [Docker](https://nixos.org/download/#nix-install-docker "docker installation guide"). (This repo is not yet compatible with MacOS, though. soon)

As of writing, this repository uses experimental nix features called Flakes and nix-command. You must enable these features in order to use this repository. See [here](https://nixos.wiki/wiki/Flakes) how do that. Don't forget to apply the changes.

Alternatively, you can use [determinate nix installer](https://github.com/DeterminateSystems/nix-installer), which enables flakes by default and makes it very easy to uninstall nix later on. (Disclaimer: I've never tried determinate nix myself)

## Usage

I highly recommend using these flakes with [nix-direnv](https://github.com/nix-community/nix-direnv)

### As a template <span title="Copies the subdirectory to your local machine. Allows you to easily modify the flake"><ins>(?)</ins></span>
```bash
nix flake init -t github:DanielLagally/tum-shells#<name>
```

You probably want to enable the direnv with
```bash
direnv allow
```

Or just run it manually with
```bash 
nix develop
```

### As a devShell <span title="Allows you to easily keep up with changes made to this repo. See Problems section on how to update the reference to the repo."><ins>(?)</ins></span>
With direnv:
```bash
echo "use flake github:DanielLagally/tum-shells#<name>" > .envrc & direnv allow
```

Without direnv:
```bash 
nix develop github:DanielLagally/tum-shells#<name>
```

Alternatively, you may clone the repository and instead use the path to your local copy

## Problems
Nix keeps a local reference to the commit of this repo you last used. This means you need to do one of the following things to access the newest commit of this repo:

- run whichever command you're using with the `--refresh` flag, or run
- ```bash
  nix flake update --flake github:DanielLagally/tum-shells
  ```

Otherwise you may get errors similar to this:
`error: path '«github:DanielLagally/tum-shells/<commit-hash>»/flake.nix' does not exist`

### TODO
- Move flakes from previous semesters / other classes
- Remove flake.lock(?)
- Compatibility without experimental features(?)

### Other resources
- [Nixpkgs search](https://search.nixos.org/packages)
- [Official Nix Templates](https://github.com/NixOS/templates/)
- [More templates](https://github.com/the-nix-way/dev-templates/)
