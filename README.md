# tum-shells

> [!WARNING]\
> Most shells are being either actively developed or have been repurposed from earlier semesters.
>
> If things are outdated or broken, please let me know.

## Purpose

This repo is meant to be a stepping stone to people at TUM interested in or already actively using Nix.

When using the recommended approach you will benefit in the following ways:
- all dependencies you need, installed with one command
- minimal setup or configuration required
- no polluting your user space with clutter
- directory-based dependency isolation
- learn some Nix along the way 

## Getting started
[Nix](https://github.com/NixOS/Nix?tab=readme-ov-file#Nix) itself is a package manager, which means you don't need to switch operating systems in order to use it. 

Nix is compatible with virtually all Linux distributions, as well as MacOS and WSL and can be installed alongside your regular package manager without conflict.

### 1. Installing Nix
  <details>
    <summary> Determinate Nix Installer (Recommended) </summary>

  #### Determinate Nix Installer
    
  The [Determinate Nix Installer](https://github.com/DeterminateSystems/Nix-installer?tab=readme-ov-file#determinate-Nix-installer) makes it easy to install and uninstall Nix and is compatible with Linux, MacOS and WSL. 
  
  It also enables Flakes and Nix-command by default, allowing you to skip step 2.
  
  - Installing determinate Nix
  
    ```bash
    curl -fsSL https://install.determinate.systems/Nix | sh -s -- install --determinate
    ```
    
  - You can also use it to install regular Nix (flakes and Nix-command not enabled)
  
    ```bash
    curl -fsSL https://install.determinate.systems/nix | sh -s -- install
    ```
    
  </details>
  
  <details>
    <summary> Nix installer </summary>
  
  #### Nix installer
    
  You may also opt for the regular Nix installer, in which case you will find the install instructions on the Nix homepage.

  - [Linux](https://Nixos.org/download/#Nix-install-linux)
  - [MacOS](https://Nixos.org/download/#Nix-install-macos)
  - [WSL](https://Nixos.org/download/#Nix-install-windows)

  Note that determinate Nix is supposedly more resilient to MacOS updates.
    
  </details>
  
  <details>
    <summary> NixOS </summary>
  
  #### NixOS
  
  NixOS is the declarative and reproducible operating system that comes with the Nix package manager pre-installed.

  I personally use NixOS and while I do recommend it highly, it is a much larger commitment than simply installing the package manager. Many things that work on generic Linux systems do not work on NixOS, many things need tinkering and the learning curve is steep.

  You can find an ISO [here](https://Nixos.org/download/#Nixos-iso)
  
  </details>

### 2. Enabling Flakes and Nix-command

As of writing, this repository requires experimental Nix features called Flakes and nix-command. You must enable these features in order to use this repository. See [here](https://Nixos.wiki/wiki/Flakes) how do that (or use determinate Nix). Don't forget to apply the changes.

### 3. Installing and enabling direnv and nix-direnv (Optional, but highly recommended)

  You can technically use direnv without nix-direnv (it may already be pre-installed on your distribution also), but I still recommend nix-direnv. See [here](https://github.com/Nix-community/nix-direnv/tree/master?tab=readme-ov-file#nix-direnv) for its benefits.

  <details>
    <summary> Nix profile (recommended, easiest) </summary>
    
  #### 3.1 Installation
  
  Despite not being declarative and therefore kind of antithetical to the whole point of Nix, I still recommend using Nix profile here because it is the most straight-forward way to install a package.
  
  ```bash
    nix profile add direnv nix-direnv
  ```

  #### 3.2 Enabling direnv

  Add the following to your .bashrc (default location is ~/.bashrc)
  ```bash
  eval "$(direnv hook bash)"
  ```

  For other shells, see [direnv.net](https://direnv.net/docs/hook.html)
  
  #### 3.3 Enabling nix-direnv (optional)

  Add the following to your 'direnvrc' file (default location is ~/.config/direnv/direnvrc), create it if necessary

  ```bash
  source $HOME/.nix-profile/share/nix-direnv/direnvrc
  ```
  
  </details>

  <details>
    <summary> Other options </summary>
    
  ### Other options

  If you prefer, you may also use another method of installing direnv and nix-direnv and activating each (ideally, you would use Nix for this). For more info see:
  - [direnv](https://direnv.net/)
  - [nix-direnv](https://github.com/Nix-community/nix-direnv/tree/master?tab=readme-ov-file#installation)

  </details>

## Usage

I highly recommend using these flakes with [nix-direnv](https://github.com/Nix-community/nix-direnv)

### Location

You can either clone this repository or point to it directly in the following commands.

#### Local copy (Recommended)

You can simply pull the repository to get a local copy.

This has the benefit of offering you both flexibility as well as the ability to update the repo by pulling changes.

\<repo> = <path_to_your_local_repo>

#### Remote (Fastest)

You can also use the flake directly from this remote repository. This is quick and easy, but since Nix does local caching, you may accidentally use an older version of the repository without realizing and you have to remember to update your reference.

\<repo> = github:DanielLagally/tum-shells

#### Name

\<name> specifies the course. See directory names for reference.

### Activation

#### As a template (best for project specific control)

Using a template creates a local copy of the flake you specified, meaning you can easily modify it in order to add packages, however, updating them from the repo is not possible.

```bash
nix flake init -t <repo>#<name>
```

You probably want to enable the direnv with
```bash
direnv allow
```

Or just run it manually with
```bash 
nix develop
```

#### As a devShell (best for impermanence or quick testing)

A devShell can feel more tidy if you know you will be using the flake exactly as is. It points directly at the repository.

##### With direnv

```bash
echo "use flake <repo>#<name>" > .envrc & direnv allow
```

##### Without direnv

```bash 
nix develop <repo>#<name>
```

## Problems
Nix keeps a local reference to the commit of this repo you last used. This means you need to do one of the following things to access the newest commit of this repository:

- run whichever command you're using with the `--refresh` flag
- ```bash
  nix flake prefetch github:DanielLagally/tum-shells
  ```
- ```bash
  nix flake update --flake github:DanielLagally/tum-shells
  ```

Otherwise you may get errors similar to this:
`error: path '«github:DanielLagally/tum-shells/<commit-hash>»/flake.Nix' does not exist`

### TODO
- Move flakes from previous semesters / other classes
- Remove flake.lock(?)
- Compatibility without experimental features(?)

### Other resources
- [Nixpkgs search](https://search.Nixos.org/packages)
- [Official Nix Templates](https://github.com/NixOS/templates/)
- [More templates](https://github.com/the-Nix-way/dev-templates/)
