# CONFIGS

My Mac setup, managed with nix-darwin and Home Manager. One repo, one command: a fresh Mac ends up configured the same way every time.

## Apply

```shell
./rebuild-nix.sh
```

The script links this repo to `~/configs`, then runs `darwin-rebuild switch --flake .#mac`. On a fresh machine (Determinate Nix installed, nothing else) it bootstraps nix-darwin first. It refuses to run if `~/configs` already exists and isn't this repo.

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
| Device config imported via its own app | `accessories/` (Keychron keymap/macros) |

## Machine identity

- Username: the single `user = "main"` line in `flake.nix`. Everything else is threaded from it.
- Host label `mac`: must match in `flake.nix` (`darwinConfigurations."mac"`) and `rebuild-nix.sh` (`#mac`).
- CPU: `nixpkgs.hostPlatform` in `configuration.nix` (`aarch64-darwin`, or `x86_64-darwin` for Intel).
- Determinate Nix owns the Nix daemon, so `nix.enable = false` stays.
- Git identity is not declared. Set it with `git config --global` per machine.

## Reference

Based on [kunchenguid/dotfiles](https://github.com/kunchenguid/dotfiles).
