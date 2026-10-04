{ config, pkgs, ... }:

let
  configs = "${config.home.homeDirectory}/configs";
  browserExtensions = [
    "nngceckbapebfimnlniiiahkandclblb"  # Bitwarden
    "fmkadmapgofadopljbjfkapdkoienihi"  # React Developer Tools
  ];
in

{
  # CLI tools, shell, prompt and shared dotfiles live in shared/home.nix;
  # this file only adds what's Mac-specific.
  imports = [ ./shared/home.nix ];

  home.packages = with pkgs; [
    goku      # compiles karabiner.edn into Karabiner's config
    # the font everything renders in
    nerd-fonts.hack
  ];
  fonts.fontconfig.enable = true;

  # Browsers come from Homebrew (package = null); this only installs extensions
  # from the Chrome Web Store on next launch.
  programs.brave = {
    enable = true;
    package = null;
    extensions = browserExtensions;
  };
  programs.google-chrome = {
    enable = true;
    package = null;
    extensions = browserExtensions;
  };

  # Edit-in-place: the real file stays in my repo, ~/.config just points at it.
  home.file.".config/wezterm".source =
    config.lib.file.mkOutOfStoreSymlink "${configs}/home/.config/wezterm";
  home.file.".config/karabiner.edn".source =
    config.lib.file.mkOutOfStoreSymlink "${configs}/home/.config/karabiner.edn";
}
