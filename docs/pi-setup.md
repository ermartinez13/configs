# Pi setup and operation

The current target is an ARM64 Raspberry Pi running Ubuntu Server 24.04. Ubuntu manages the OS; standalone Home Manager manages the user environment. Begin with the [README commands](../README.md#fresh-pi).

## What initialization does

`rpi/init-nix.sh` installs Determinate Nix, applies `homeConfigurations.pi`, adds the Nix-managed zsh to `/etc/shells`, changes the user's login shell and enables lingering. Reconnect over SSH to use the new shell. Rebuilds link the checkout at `~/nix-configs`, leaving an unrelated `~/configs` directory alone.

If Nix is already installed, init exits before all of those steps. Run `./rpi/rebuild.sh` to apply Home Manager. If zsh and lingering were never configured, complete those steps explicitly:

```sh
ZSH_PATH="$HOME/.nix-profile/bin/zsh"
grep -qxF "$ZSH_PATH" /etc/shells || echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
sudo chsh -s "$ZSH_PATH" "$USER"
sudo loginctl enable-linger "$USER"
```

## Sign-ins and everyday operation

Authenticate Claude Code, Codex and `gh` on the Pi itself. Credentials are not shared from the Mac. Set [Git identity](maintenance.md#machine-identity) separately. Docker Sandboxes has an additional [apt installation and login](docker-sandboxes.md).

The shared CLI tools and dotfiles come from `shared/home.nix`; Pi additions live in `rpi/home.nix`. The prompt has a green/red `🍓 Pi ❯` marker to distinguish remote panes. Herdr is the primary multiplexer, with tmux available as a backup. Direnv with nix-direnv supports approved project environments.

Claude Code, Codex and herdr are installed with vendor installers during rebuilds. They are not pinned by the lock file. Installer failures produce a warning and can be retried on a later rebuild.

## Weekly Nix cleanup

`rpi/home.nix` enables weekly garbage collection with `--delete-older-than 30d`. Old eligible profile generations can be deleted, then store paths with no remaining references can be collected. The current generation and paths protected by GC roots remain protected.

This reduces rollback history; the 30-day threshold is not a guarantee of exactly 30 days of available rollbacks. Do not assume every previously used project development environment remains available: protection depends on live references and GC roots.

Cleanup concerns the Nix store and eligible profile history. It does not delete the checkout, project files or vendor-installed harnesses under `~/.local/bin`. Lingering allows the systemd user services to run without an open SSH session. A powered-off machine cannot run cleanup; no missed-run catch-up guarantee is asserted here.

Inspect the timer and recent runs on the Pi:

```sh
systemctl --user list-timers nix-gc.timer
systemctl --user status nix-gc.timer
journalctl --user -u nix-gc.service
```

Change the retention option in `rpi/home.nix` and rebuild to adjust it. No explicit build-concurrency cap is configured. Keep project work pushed to Git before reimaging; rebuilding the environment does not restore unpushed work.
