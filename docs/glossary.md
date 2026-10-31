# Glossary

## Starting vocabulary

- [**Nix**](https://nixos.org/) is a package manager and build system, configured using the Nix language, that creates reproducible packages and development environments. It can be added to existing macOS or Linux installations without replacing the operating system.
- [**Determinate Nix**](https://determinate.systems/products/nix/) is Determinate Systems' distribution of Nix, with additional features and defaults such as enabled flakes.
- [**nix-darwin**](https://github.com/nix-darwin/nix-darwin) applies declarative configuration to macOS, including supported system preferences, packages, and services.
- [**NixOS**](https://nixos.org/) is a Linux distribution that uses Nix to configure the operating system, including its kernel, services, and installed software. Using Nix on Ubuntu does not require it.

In this repo, Determinate provides Nix on both machines, nix-darwin manages the Mac, and Ubuntu remains the Pi's operating system. Neither machine runs NixOS.

## Configuration and reproducibility

The following entries extend the original glossary, including its outstanding Home Manager item. Their roles are grounded in [flake.nix](../flake.nix), [configuration.nix](../configuration.nix), [shared/home.nix](../shared/home.nix) and [rpi/home.nix](../rpi/home.nix).

| Term | Meaning and role here |
| --- | --- |
| Home Manager | Nix modules that declare a user's packages, shell and managed files. It runs inside nix-darwin on the Mac and as a standalone configuration on Ubuntu. This is the shared layer between the two machines. |
| nixpkgs | The Nix package collection and module library. This flake uses separate Darwin and Linux inputs for the two platforms. |
| Flake | A Nix project interface declaring inputs and outputs. This repo's `flake.nix` exposes `darwinConfigurations.mac` and `homeConfigurations.pi`. |
| Lock file | A record of resolved dependencies. `flake.lock` pins Nix inputs; `lazy-lock.json` records Neovim plugin revisions. Each covers its own dependency system. |
| Declarative configuration | A description of the desired setup: installed packages, shell settings and managed files. A rebuild applies that description. |
| Activation / switch | Applying the built configuration to the machine or user account. Activation can also run imperative steps, such as the Pi's vendor installers. |
| Nix store | The `/nix/store` paths containing Nix-managed packages and build outputs. These are treated as immutable; mutable application data belongs elsewhere. |
| Generation | A saved Nix profile/configuration version that can support rollback while retained. It does not snapshot the whole machine or the contents of live dotfiles. |
| Garbage collection | Removing unreferenced Nix store objects. The Pi schedules weekly cleanup with `--delete-older-than 30d`, trading retained history for disk space. Referenced paths remain protected. |
| Out-of-store symlink | A managed link to a file outside the Nix store. Here it points into the checkout, so authored configuration stays editable without rebuilding. |
| Runtime state | Data produced while a tool runs: sessions, caches, downloaded runtimes and authentication. It stays local rather than becoming authored configuration in Git. |
| Homebrew | The Mac package manager used here for GUI apps and selected tools distributed through taps. A formula usually supplies a CLI/library; a cask commonly supplies an application; a tap adds a package catalog. |
| nix-homebrew | The integration that provisions Homebrew. nix-darwin's separate `homebrew` options declare formulae, casks, taps and activation behavior. |
| `cleanup = "zap"` | The chosen Homebrew activation cleanup policy: unlisted Homebrew installations can be removed, including cask cleanup actions. It makes the declared list consequential; it is not a general cleanup of all software on the OS. |
| Development shell | A project-specific environment containing that project's tools. The Pi enables direnv with nix-direnv to load approved project environments when entering their directories. This repo itself does not define a project `devShell`. |
| `aarch64-darwin` / `aarch64-linux` | Platform identifiers for ARM64 macOS and ARM64 Linux. Matching CPU architecture does not make their executables interchangeable. |

## Everyday tools and workflow

| Term | Role in this environment |
| --- | --- |
| zsh | The interactive shell, with autosuggestions, syntax highlighting, aliases and fnm initialization managed by Home Manager. |
| Starship | The shell prompt. This config shows the directory, Git state, command duration and prompt character. |
| WezTerm | The Mac terminal emulator: it renders local terminals and SSH sessions and forwards selected Command shortcuts to herdr. |
| herdr | The primary terminal/session multiplexer in this setup, with panes, workspaces and an agent panel. The Pi also installs tmux as a backup. |
| Neovim | The default terminal editor (`EDITOR=nvim`), with Lua configuration and plugins managed through lazy.nvim. |
| Karabiner-Elements / goku | Karabiner applies Mac keyboard remappings. goku compiles the repo's `karabiner.edn` into Karabiner configuration. The Karabiner installer is separately pinned to 15.0.0. |
| Hyper key | The combined Control/Option/Command/Shift modifier produced by holding Caps Lock here. It gives navigation shortcuts a common prefix. |
| Node.js / npm | The JavaScript runtime and package manager provided by the Nix Node package. Node 24 is the baseline for fresh installs. |
| fnm | The Node version manager used to install and select additional Node versions without rebuilding Nix. See [Node workflow](node.md). |
| `.node-version` / `.nvmrc` | Project files declaring a desired Node version that fnm can read. An exact version is more repeatable than a moving major or LTS alias. |
| Agent harness | A tool used to run a coding agent, such as the Claude Code, Codex and omp installations declared here. Their local sessions and authentication are separate from shared agent instructions. |

Tool roles above are visible in the [shared configuration](../shared/home.nix), [Mac configuration](../home.nix), [Pi configuration](../rpi/home.nix) and authored files under [home/](../home/).
