# CONFIGS

My Mac setup, managed with nix-darwin and Home Manager. One repo, one command: a fresh Mac ends up configured the same way every time.

## Apply

```shell
./rebuild-nix.sh
```

The script links this repo to `~/configs`, then runs `darwin-rebuild switch --flake .#mac`. On a fresh machine (Determinate Nix installed, nothing else) it bootstraps nix-darwin first. It refuses to run if `~/configs` already exists and isn't this repo.

On a fresh Mac, run `./init-nix.sh` instead: it installs Determinate Nix, then runs `./rebuild-nix.sh`. It does nothing if Nix is already installed.

## Rules

- **Declared or it doesn't exist.** Homebrew runs with `cleanup = "zap"`, so anything not listed in `configuration.nix` is uninstalled on rebuild. Never `brew install` ad-hoc, and don't soften `zap`.
- **Configs are live.** Files under `home/` are symlinked into `~` with `mkOutOfStoreSymlink`, so edits take effect without a rebuild. Rebuild only after changing a `.nix` file.
- **Track what I author, not runtime state.** If a tool writes state into its config dir, link only the config file (e.g. `herdr/config.toml`, not `~/.config/herdr`). No credentials, auth or session data in this repo.
- **Pin versions.** Commit `flake.lock` when a rebuild changes it, and `lazy-lock.json` after Neovim plugin updates.
- **Agent autonomy goes through a reviewer.** Use the `claude-auto` / `codex-auto` aliases, not modes that skip permission checks.

## Where things go

| Change | File |
| --- | --- |
| CLI tool from nixpkgs | `home.packages` in `home.nix` |
| GUI app, or tool only on Homebrew/a tap | `homebrew.casks` / `brews` / `taps` in `configuration.nix` |
| macOS preference | `system.defaults` in `configuration.nix` |
| Shell (zsh, aliases, prompt) | `programs.zsh` / `programs.starship` in `home.nix` |
| Authored dotfile | `home/<path in ~>`, plus a `home.file` link in `home.nix` |
| Agent instructions (Claude, Codex, opencode) | `home/AGENTS.md` (one file, linked to all three) |
| Browser extension (Brave/Chrome) | `programs.brave` / `programs.google-chrome` `extensions` in `home.nix` |
| Device config imported via its own app | `accessories/` (Keychron keymap/macros) |

## Installed manually (not in Nix)

- **Karabiner-Elements 15.0.0.** Do not upgrade past it. The Homebrew cask and nixpkgs both ship newer versions, so don't add it to either. Install it with `./install-karabiner.sh` (downloads and checksums 15.0.0, then runs its installer). Set up a profile named "Default" so goku can write to it.
- **Spokenly model** (Distil-Whisper Large 3.5, English only) and offline mode: set them up in the app.
- **Contexts** (licensed): download it from contexts.co. The Homebrew cask fails because the vendor's download server has an expired SSL certificate.

## Machine identity

- Username: the single `user = "main"` line in `flake.nix`. Everything else is threaded from it.
- Host label `mac`: must match in `flake.nix` (`darwinConfigurations."mac"`) and `rebuild-nix.sh` (`#mac`).
- CPU: `nixpkgs.hostPlatform` in `configuration.nix` (`aarch64-darwin`, or `x86_64-darwin` for Intel).
- Determinate Nix owns the Nix daemon, so `nix.enable = false` stays.
- Git identity is not declared. Set it with `git config --global` per machine.

## Reference

Based on [kunchenguid/dotfiles](https://github.com/kunchenguid/dotfiles).
