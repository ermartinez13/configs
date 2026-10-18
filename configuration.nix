{ lib, user, ... }:

let
  mouseSpeed = 1.5;  # 75% toward fast on the System Settings slider
  # The live mouse driver takes speed as a whole number where 65536 means 1.0,
  # so a speed of 1.5 is sent as 1.5 * 65536 = 98304.
  mouseSpeedForDriver = builtins.floor (mouseSpeed * 65536);
in
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
      "com.apple.mouse.tapBehavior" = 1; # tap to click, alongside trackpad.Clicking
    };
    dock.autohide = true;
    dock.persistent-apps = [];             # no pinned apps (Finder and Trash always stay)
    dock.show-recents = false;             # no "recent apps" section
    WindowManager.StandardHideWidgets = true;      # no widgets on desktop
    WindowManager.StageManagerHideWidgets = true;  # ...or in Stage Manager
    finder.FXPreferredViewStyle = "Nlsv";  # list view by default
    finder.CreateDesktop = false;          # clean desktop
    trackpad.Clicking = true;              # tap to click
    ".GlobalPreferences"."com.apple.mouse.scaling" = mouseSpeed;
  };
  system.activationScripts.postActivation.text = ''
    # nix-darwin writes user defaults; also set the host-specific tap preference.
    /bin/launchctl asuser "$(/usr/bin/id -u -- ${lib.escapeShellArg user})" \
      /usr/bin/sudo --user=${lib.escapeShellArg user} -- \
      /usr/bin/defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    # The mouse speed preference is read at login; also update the live driver.
    /usr/bin/hidutil property --set '{"HIDMouseAcceleration":${toString mouseSpeedForDriver}}' >/dev/null
  '';
  environment.variables.HOMEBREW_NO_ANALYTICS = "1";  # brew in your shells
  nix-homebrew = {
    enable = true;
    inherit user;
  };
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";  # remove anything not listed here
    onActivation.autoUpdate = true;
    onActivation.extraFlags = [ "--force" ];
    # Activation runs brew under sudo, so it doesn't see environment.variables.
    onActivation.extraEnv.HOMEBREW_NO_ANALYTICS = "1";
    taps = [
      "anomalyco/tap"
      "can1357/tap"
      "docker/tap"
    ];
    brews = [
      "herdr"
      "can1357/tap/omp"
      "anomalyco/tap/opencode"
    ];
    casks = [
      "wezterm"
      "claude-code"
      "claude"
      "chatgpt"
      "codex"
      "brave-browser"
      "google-chrome"
      "notion"
      "visual-studio-code"
      "betterdisplay"
      "nordvpn"
      "docker-desktop"
      { name = "docker/tap/sbx"; trusted = true; } # standalone Docker Sandboxes
      "spokenly"
      "obsidian"
    ];
  };
}
