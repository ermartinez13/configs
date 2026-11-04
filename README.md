# CONFIGS

My Mac and Raspberry Pi environment, managed with Nix and Home Manager. Run these commands from the repository directory.

## Fresh Mac

Use an Apple Silicon Mac with the account name `main` (or change `user` in `flake.nix`). Install Apple's Command Line Tools if Git is unavailable, then clone this repo:

```sh
xcode-select --install  # if the Command Line Tools are not already installed
```

After the installation finishes:

```sh
git clone https://github.com/ermartinez13/configs.git
cd configs
./init-nix.sh
```

**No manual Determinate Nix installation is needed.** The script installs it and runs the Mac rebuild. If Nix is already installed, the init script does nothing; run the rebuild below instead.

Finish the [manual Mac setup](docs/mac-setup.md) for app permissions, sign-ins and peripherals.

## Mac rebuild

After changing a `.nix` file:

```sh
./rebuild-nix.sh
```

This also bootstraps nix-darwin if Nix is installed but nix-darwin is not. Editing linked dotfiles under `home/` needs no Nix rebuild.

## Fresh Pi

Start with Ubuntu Server on an ARM64 Pi, an account named `main` (or adjust `flake.nix`), Git, curl, sudo access and a working SSH connection. On the Pi:

```sh
git clone https://github.com/ermartinez13/configs.git
cd configs
./rpi/init-nix.sh
```

This installs Determinate Nix, applies Home Manager, sets zsh as the login shell and enables lingering for user services. Reconnect over SSH afterwards. If Nix is already installed, the init script does nothing; use the Pi rebuild below. See [Pi setup](docs/pi-setup.md) for existing-Nix setup, sign-ins and cleanup, and [SSH access](docs/ssh.md) for restoring Mac access.

## Pi rebuild

On the Pi, from the repo directory:

```sh
./rpi/rebuild.sh
```

For Docker Sandboxes, follow the separate [Mac/Pi installation and copying guide](docs/docker-sandboxes.md).

## Documentation

- [Philosophy](docs/philosophy.md): what belongs in the repo and the limits of reproducibility.
- [Maintenance](docs/maintenance.md): where changes go, linking rules and machine identity.
- [Mac setup](docs/mac-setup.md): manual steps after installation.
- [Pi setup](docs/pi-setup.md): headless operation, authentication and garbage collection.
- [SSH access](docs/ssh.md): keys and connecting from the Mac.
- [Karabiner](docs/karabiner.md): permissions, device setup and shortcuts.
- [Node.js](docs/node.md): the baseline runtime and per-project versions.
- [Docker Sandboxes](docs/docker-sandboxes.md): installation and clipboard workarounds.
- [Glossary](docs/glossary.md): the tools and terminology used here.

Based on [kunchenguid/dotfiles](https://github.com/kunchenguid/dotfiles).
