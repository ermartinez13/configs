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
exec sudo darwin-rebuild switch --flake "$DIR#mac"
