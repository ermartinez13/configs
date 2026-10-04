#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
NIX_PROFILE=/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
if command -v nix >/dev/null || [[ -e "$NIX_PROFILE" ]]; then
  echo "Nix is already installed. Nothing to do; use ./rebuild-nix.sh to apply changes."
  exit 0
fi
PKG="$(mktemp -d)/determinate.pkg"
trap 'rm -rf "$(dirname "$PKG")"' EXIT
curl -fsSL -o "$PKG" https://install.determinate.systems/determinate-pkg/stable/Universal
sudo installer -pkg "$PKG" -target /
# Load Nix into this shell instead of opening a new one.
# shellcheck disable=SC1090
source "$NIX_PROFILE"
"$DIR/rebuild-nix.sh"
