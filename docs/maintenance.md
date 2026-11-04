# Maintenance

Use the [README](../README.md) for rebuild commands and [Philosophy](philosophy.md) for the rationale.

## Where things go

| Change | Source |
| --- | --- |
| Shared CLI tool from nixpkgs | `home.packages` in `shared/home.nix` |
| Mac-only user package | `home.packages` in `home.nix` |
| Pi-only package or user service | `rpi/home.nix` |
| Homebrew formula, cask or tap | `configuration.nix` |
| macOS preference | `system.defaults` in `configuration.nix` |
| Shared zsh, aliases or Starship prompt | `programs.*` in `shared/home.nix` |
| Authored dotfile | `home/`, with a link in `shared/home.nix` or `home.nix` |
| Claude/Codex instructions | `home/AGENTS.md` |
| Brave/Chrome extensions | `browserExtensions` in `home.nix` |
| Imported device configuration | `accessories/` (Keychron keymap and macros) |

## Day-to-day changes

- Add Homebrew software to the declaration and rebuild; do not soften `zap` to preserve ad-hoc installations.
- Rebuild after changing a `.nix` file. Linked dotfile edits need no Nix rebuild, though the application may require a reload.
- Commit `flake.lock` when an intentional dependency update changes it, and `home/.config/nvim/lazy-lock.json` after plugin updates. Review the resulting diff.
- Edit agent policy in `home/AGENTS.md`; the Claude and Codex destinations are links.
- Keep credentials, environment secrets and session exports outside the tracked configuration. `.env.example` is allowed for placeholders only.

## Linking rules

The Mac rebuild links the checkout at `~/configs`; the Pi uses `~/nix-configs`. Each script refuses to replace an existing ordinary file or directory at that path unless it is the checkout itself. Existing symlinks are refreshed.

Shared links resolve through the `configsLink` argument. Link only `~/.config/herdr/config.toml`, because herdr owns the surrounding session state. Karabiner is the directory-link exception: its `.gitignore` admits only `karabiner.json` and `.gitignore`.

## Machine identity

- `user = "main"` in `flake.nix` supplies the username to both machine configurations. Change it before setup if the account has another name.
- `macConfigsLink` / `piConfigsLink` in `flake.nix` must match `CONFIGS` in the respective rebuild scripts.
- `darwinConfigurations.mac` matches `#mac` in the Mac rebuild; `homeConfigurations.pi` matches `#pi` in the Pi rebuild.
- The Mac targets `aarch64-darwin`; the Pi targets `aarch64-linux`. Intel machines need configuration changes.
- Determinate manages the Nix daemon, so `nix.enable = false` stays in the Mac configuration.
- Git identity is not declared in Nix. Configure it per machine; use your GitHub private `noreply` address if you do not want a personal address published in commit metadata.

```sh
git config --global user.name "Your Name"
git config --global user.email "YOUR_GITHUB_NOREPLY_ADDRESS"
```
