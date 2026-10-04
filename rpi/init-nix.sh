#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
NIX_PROFILE=/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
if command -v nix >/dev/null || [[ -e "$NIX_PROFILE" ]]; then
  echo "Nix is already installed. Nothing to do; use ./rpi/rebuild.sh to apply changes."
  exit 0
fi
curl -fsSL https://install.determinate.systems/nix | sh -s -- install --no-confirm
# Load Nix into this shell instead of opening a new one.
# shellcheck disable=SC1090
source "$NIX_PROFILE"
"$DIR/rebuild.sh"
# Make the Nix-managed zsh the login shell.
ZSH_PATH="$HOME/.nix-profile/bin/zsh"
grep -qxF "$ZSH_PATH" /etc/shells || echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
sudo chsh -s "$ZSH_PATH" "$USER"
# Let user services (the weekly Nix cleanup) run without an SSH session open.
sudo loginctl enable-linger "$USER"
echo "Done. Reconnect over SSH to start using zsh."
