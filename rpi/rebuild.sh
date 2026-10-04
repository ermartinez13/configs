#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
# Not ~/configs: the Pi may already have an unrelated folder there. Must match piConfigsLink in flake.nix.
CONFIGS="$HOME/nix-configs"
if [[ ! -L "$CONFIGS" && -e "$CONFIGS" ]]; then
  if [[ ! "$CONFIGS" -ef "$DIR" ]]; then
    printf 'Cannot link %s: it already exists and is not this repository.\n' "$CONFIGS" >&2
    exit 1
  fi
else
  ln -sfn "$DIR" "$CONFIGS"
fi
# -b: move aside existing dotfiles (e.g. Ubuntu's defaults) instead of failing.
if command -v home-manager >/dev/null; then
  exec home-manager switch -b backup --flake "$DIR#pi"
else
  # Bootstrap Home Manager on the first rebuild, matching flake.nix's release.
  exec nix run github:nix-community/home-manager/release-26.05 -- switch -b backup --flake "$DIR#pi"
fi
