#!/usr/bin/env bash
set -euo pipefail
# Docker Sandboxes (sbx) from Docker's Ubuntu apt repo, plus KVM access for $USER.
# OS-level, so it lives here instead of rpi/home.nix (see docs/docker-sandboxes.md).
# Safe to re-run: it upgrades sbx to the repo's latest.
if ! grep -rqs download.docker.com/linux/ubuntu /etc/apt/sources.list /etc/apt/sources.list.d/; then
  # Docker's signed apt source, as in https://docs.docker.com/ai/sandboxes/install/#install-sbx-only
  sudo apt-get update
  sudo apt-get install -y ca-certificates curl
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc
  sudo tee /etc/apt/sources.list.d/docker.sources >/dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF
fi
sudo apt-get update
# Skipping recommends cuts the install from ~124 to ~78 packages.
sudo apt-get install -y --no-install-recommends docker-sbx
if [[ ! -e /dev/kvm ]]; then
  echo "sbx installed, but /dev/kvm is missing; sandboxes can't start on this kernel." >&2
  exit 1
fi
if id -nG "$USER" | grep -qw kvm; then
  RELOGIN=""
else
  sudo usermod -aG kvm "$USER"
  RELOGIN="  0. Reconnect over SSH (and start a new herdr/tmux server) so the kvm group applies.
"
fi
cat <<MSG

$(sbx version 2>/dev/null | head -1 || echo "docker-sbx") installed. Next:
$RELOGIN  1. Sign in: sbx login  (headless: pipe a Docker PAT to --password-stdin)
  2. Smoke test:
       sbx create --name pi-smoke --cpus 2 --memory 4g shell
       sbx exec pi-smoke -- uname -m
       sbx stop pi-smoke && sbx rm pi-smoke
MSG
