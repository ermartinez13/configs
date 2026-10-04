#!/usr/bin/env bash
set -euo pipefail
# Pinned on purpose: don't upgrade past 15.0.0 (see README).
VERSION=15.0.0
SHA256=c560ac6e43fd7159c38d61538169792ab47bc04a5c41833831df7da5323f975e
URL="https://github.com/pqrs-org/Karabiner-Elements/releases/download/v$VERSION/Karabiner-Elements-$VERSION.dmg"
TMP="$(mktemp -d)"
trap 'hdiutil detach -quiet "$TMP/mnt" 2>/dev/null || true; rm -rf "$TMP"' EXIT
if ! curl -fsSL -o "$TMP/karabiner.dmg" "$URL"; then
  printf 'Could not download Karabiner-Elements %s from:\n  %s\n' "$VERSION" "$URL" >&2
  exit 1
fi
if ! echo "$SHA256  $TMP/karabiner.dmg" | shasum -a 256 -c --status; then
  echo "Downloaded file doesn't match the expected Karabiner-Elements $VERSION checksum. Not installing." >&2
  exit 1
fi
hdiutil attach -quiet -nobrowse -readonly -mountpoint "$TMP/mnt" "$TMP/karabiner.dmg"
sudo installer -pkg "$TMP/mnt/Karabiner-Elements.pkg" -target /
cat <<MSG

Karabiner-Elements $VERSION installed. Next:
  1. Open Karabiner-Elements and grant the permissions it asks for
     (driver extension, Input Monitoring).
  2. Rename its profile to "Default" so goku can write to it.
  3. Run: goku
MSG
