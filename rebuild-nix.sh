#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
CONFIGS="$HOME/configs"
if [[ ! -L "$CONFIGS" && -e "$CONFIGS" ]]; then
  if [[ ! "$CONFIGS" -ef "$DIR" ]]; then
    printf 'Cannot link %s: it already exists and is not this repository.\n' "$CONFIGS" >&2
    exit 1
  fi
else
  ln -sfn "$DIR" "$CONFIGS"
fi
if REBUILD="$(command -v darwin-rebuild)"; then
  exec sudo "$REBUILD" switch --flake "$DIR#mac"
elif [[ -x /run/current-system/sw/bin/darwin-rebuild ]]; then
  exec sudo /run/current-system/sw/bin/darwin-rebuild switch --flake "$DIR#mac"
else
  # Bootstrap nix-darwin on the first rebuild, matching flake.nix's release.
  NIX="$(command -v nix)"
  exec sudo "$NIX" run github:nix-darwin/nix-darwin/nix-darwin-26.05#darwin-rebuild -- switch --flake "$DIR#mac"
fi
