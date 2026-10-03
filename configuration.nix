{ user, ... }:

{
  # Determinate already manages the Nix daemon, so nix-darwin shouldn't.
  nix.enable = false;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin"; # use x86_64-darwin for Intel CPU

  system.primaryUser = user;
  users.users.${user} = {
    home = "/Users/${user}";
  };
  system.stateVersion = 6;
  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 2;          # fast key repeat
      InitialKeyRepeat = 15;  # short delay before repeat
      _HIHideMenuBar = true;  # auto-hide the menu bar
      AppleShowAllExtensions = true;
    };
    dock.autohide = true;
    dock.persistent-apps = [];             # no pinned apps (Finder and Trash always stay)
    dock.show-recents = false;             # no "recent apps" section
    WindowManager.StandardHideWidgets = true;      # no widgets on desktop
    WindowManager.StageManagerHideWidgets = true;  # ...or in Stage Manager
    finder.FXPreferredViewStyle = "Nlsv";  # list view by default
    finder.CreateDesktop = false;          # clean desktop
    trackpad.Clicking = true;              # tap to click
  };
  nix-homebrew = {
    enable = true;
    inherit user;
  };
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";  # remove anything not listed here
    onActivation.autoUpdate = true;
    onActivation.extraFlags = [ "--force" ];
    taps = [
      "anomalyco/tap"
      "can1357/tap"
    ];
    brews = [
      "herdr"
      "can1357/tap/omp"
      "anomalyco/tap/opencode"
    ];
    casks = [
      "wezterm"
      "claude-code"
      "codex"
      "brave-browser"
      "google-chrome"
      "notion"
      "visual-studio-code"
      "betterdisplay"
      "nordvpn"
      "docker-desktop"
      "spokenly"
      "obsidian"
    ];
  };
}
