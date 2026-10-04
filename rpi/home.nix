# Raspberry Pi (Ubuntu Server, headless): the shared user environment plus
# what an SSH-only agent machine needs. Ubuntu keeps the OS; this is userland only.
{ lib, pkgs, ... }:

{
  imports = [ ../shared/home.nix ];

  targets.genericLinux.enable = true;  # Ubuntu, not NixOS
  programs.home-manager.enable = true; # provides the `home-manager` command

  # Per-project dev environments: a repo's flake/shell.nix loads on `cd`.
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Backup to herdr for keeping sessions alive across SSH disconnects.
  programs.tmux.enable = true;

  # Keep the Nix store from filling the SD card.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Agent harnesses aren't pinned: each rebuild runs the vendor installers,
  # which fetch the latest release. Claude Code and opencode also self-update.
  home.sessionPath = [ "$HOME/.local/bin" "$HOME/.opencode/bin" ];
  home.activation.installHarnesses = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export PATH="${lib.makeBinPath [ pkgs.curl pkgs.gnutar pkgs.gzip pkgs.unzip ]}:$HOME/.local/bin:$HOME/.opencode/bin:/usr/bin:/bin:$PATH"
    harness() {
      local name=$1 script=$2
      noteEcho "Installing latest $name"
      run bash -o pipefail -c "$script" \
        || warnEcho "Couldn't install $name (offline?). Continuing; the next rebuild retries."
    }
    harness claude   'curl -fsSL https://claude.ai/install.sh | bash'
    harness codex    'curl -fsSL https://chatgpt.com/codex/install.sh | CODEX_NON_INTERACTIVE=1 sh'
    harness opencode 'curl -fsSL https://opencode.ai/install | bash -s -- --no-modify-path'
    harness omp      'curl -fsSL https://omp.sh/install | sh'
    harness herdr    'curl -fsSL https://herdr.dev/install.sh | sh'
  '';
}
