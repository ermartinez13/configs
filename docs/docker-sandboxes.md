# Docker Sandboxes

Docker Sandboxes uses the standalone `sbx` command. Installation differs between the Mac and Pi; authentication stays local to each machine.

## Mac

The `docker/tap/sbx` Homebrew cask (including its trust setting) and Docker Desktop are declared in `configuration.nix`. Apply them with the normal Mac rebuild, then sign in:

```sh
./rebuild-nix.sh
sbx login
```

## Pi

Run the installer from the checkout on the Pi:

```sh
./rpi/install-sbx.sh
```

This adds Docker's signed Ubuntu apt source if missing, installs `docker-sbx` without recommends, checks for `/dev/kvm`, and adds the user to `kvm` if needed. Re-run it to upgrade. If group membership changed, reconnect over SSH and start a new herdr/tmux server before using sbx.

Then sign in and smoke-test:

```sh
sbx login
sbx create --name pi-smoke --cpus 2 --memory 4g shell
sbx exec pi-smoke -- uname -m
sbx stop pi-smoke
sbx rm pi-smoke
```

A missing `/dev/kvm` prevents sandboxes from starting on that kernel even if package installation succeeded.

## Copying from an sbx pane in herdr

With WezTerm → herdr → sbx, ordinary drag-to-copy can stop working while copying from a regular shell pane still works. Mouse reporting from an application inside the pane can cause herdr to forward drags to that application instead of selecting text.

Two workarounds were verified with herdr 0.9.5, WezTerm 20240203-110809-5046fc22, and sbx v0.51.0:

- **WezTerm selection:** hold **Shift** while dragging over the text, then press **Cmd+C**. This uses WezTerm's selection and can span herdr pane boundaries.
- **Herdr copy mode:** focus the sbx pane, press **Ctrl+B**, then **[**. Move with the arrow keys, press **Space** to start selecting, move to extend the selection, then press **y** to copy.

Neither workaround requires a configuration change. A `Broken pipe (os error 32)` was also observed; its cause has not been confirmed.
