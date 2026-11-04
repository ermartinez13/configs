# Philosophy

The repository is the source of truth for computer setup. The [README](../README.md) is the command guide; these documents explain the choices behind it. External notes should link here rather than duplicate installation instructions.

## One repo, a clear entry point for each machine

A fresh Mac starts with `./init-nix.sh`; subsequent changes use `./rebuild-nix.sh`. The Pi has equivalent scripts under `rpi/`. Init installs Determinate Nix and applies the configuration. Rebuild applies configuration when Nix is already present. Both init scripts exit without making changes if Nix is already installed.

The shared user environment lives in `shared/home.nix`. Mac and Pi modules add only their platform-specific pieces. This keeps everyday tools and shell behavior consistent without treating the two operating systems as interchangeable.

## Declare what we manage

Packages, apps, supported macOS preferences, dotfile links and agent instruction links belong in configuration. Homebrew uses `cleanup = "zap"`: unlisted Homebrew installations can be removed on rebuild, including cask cleanup actions. Declare additions instead of installing them ad hoc.

This does not manage every byte on the machine. App permissions, account sign-ins, licensed software and some in-app preferences still need manual setup. Ubuntu owns the Pi's kernel, boot, networking, SSH server and system services. Docker Sandboxes on the Pi is an explicit apt installation, documented separately.

## Live configuration, local runtime state

Authored files under `home/` are linked into place with `mkOutOfStoreSymlink`. Editing the checkout changes what the application reads without a Nix rebuild; an application may still need to reload its configuration.

Track authored configuration, not sessions, caches, credentials or authentication. Link an individual config file when a tool writes runtime state beside it. Karabiner needs a directory link for change detection; its directory has an allowlist-style `.gitignore` to exclude runtime files.

Credentials stay on each machine. Ignore rules reduce accidental commits but do not remove tracked files or guarantee that a secret cannot be committed.

## Pin what can be pinned

Commit `flake.lock` for Nix inputs and `lazy-lock.json` for Neovim plugins. The lock file covers separate Darwin and Linux package inputs; it does not promise identical versions across operating systems.

Homebrew installations and the Pi's vendor-installed Claude Code, Codex and herdr are not pinned by `flake.lock`. Pi rebuilds run the latest vendor installers, and Claude Code can self-update. Reproducibility here means a declared environment with explicit exceptions, not a frozen disk image.

## Shared agent policy and reviewed autonomy

`home/AGENTS.md` is linked to Claude's `~/.claude/CLAUDE.md` and Codex's `~/.codex/AGENTS.md` on both machines. Edit that source once. Installation and authentication remain machine-specific.

The shared shell provides `claude-auto` and `codex-auto` aliases for automatic review modes. The operating policy is to use reviewed autonomy rather than modes that skip permission checks. Those aliases do not enforce how every agent process is launched.

## Headless companions

The Pi runs user-level development tools without Mac GUI apps, fonts or terminal configuration. Rendering happens on the Mac. Use key-based SSH and keep project work committed and pushed so a machine can be reimaged without losing it. These are operating practices, not SSH-server or backup policies enforced by this repo.

Weekly Nix cleanup limits retained history on the Pi. No explicit parallel-build limit is currently configured. A VPS or other VM is a possible extension; the current flake exposes an ARM64 Linux Pi configuration, not a universal cloud-machine setup.
