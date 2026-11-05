# SSH access from the Mac

SSH keys and host configuration are local machine state, not files to commit to this public repo. These steps restore access after a Mac reset; the Pi must already have an SSH server, a reachable address and an account.

## Before starting: use a dedicated WezTerm tab

Use a fresh local WezTerm tab **outside herdr** for `ssh-add`, `ssh-copy-id` and subsequent `ssh rpi` connections. Agent and connection errors occurred inside a Mac herdr session and were resolved by using a dedicated tab. A stale `SSH_AUTH_SOCK` may explain `ssh-add: Connection refused`; the separate SSH connection failure was not diagnosed. Retry outside herdr before generating another key.

## Restore or create a key

Restore `~/.ssh/id_ed25519_rpi` and its `.pub` file from your private backup. If you need a new key instead, create one without overwriting a restored key:

```sh
mkdir -p ~/.ssh
chmod 700 ~/.ssh
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_rpi
```

For a restored private key, ensure its permissions are restricted:

```sh
chmod 600 ~/.ssh/id_ed25519_rpi
```

## Configure the host

Add this entry to `~/.ssh/config`:

```sshconfig
Host rpi
    User main
    AddKeysToAgent yes
    IdentityFile ~/.ssh/id_ed25519_rpi
```

This assumes `rpi` resolves on your network. Otherwise add `HostName` with the Pi's actual hostname or address. Adjust `User` if the Pi account is different.

Load the key:

```sh
ssh-add ~/.ssh/id_ed25519_rpi
```

If the public key is not already authorized on the Pi, install it using an existing login method. With `ssh-copy-id` available:

```sh
ssh-copy-id -i ~/.ssh/id_ed25519_rpi.pub main@rpi
```

If that utility is unavailable, this sends only the public key using ordinary SSH:

```sh
cat ~/.ssh/id_ed25519_rpi.pub | ssh main@rpi 'umask 077; mkdir -p ~/.ssh; cat >> ~/.ssh/authorized_keys'
```

An existing password login may be needed for this first installation. Verify the host identity when connecting, then confirm key-based login with `ssh rpi`. After reimaging a Pi, verify its new host key rather than bypassing host-key checking. The repo does not configure or enforce key-only SSH on Ubuntu.
