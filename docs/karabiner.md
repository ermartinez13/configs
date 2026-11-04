# Karabiner setup and shortcuts

Karabiner-Elements is installed through the unversioned `karabiner-elements` Homebrew cask. Each Mac rebuild explicitly upgrades it to the available stable release. To update between rebuilds:

```sh
brew update
brew upgrade --cask karabiner-elements
```

The source is [`home/.config/karabiner/karabiner.json`](../home/.config/karabiner/karabiner.json). There is no separate compiler step or pinned v15 installer.

## First launch

Open Karabiner-Elements and complete the permissions and background/driver approvals requested by the installed version. The tracked profile is named **Default**, is selected, and uses the ANSI keyboard type.

Connect the Keychron V1 Max and check the Devices tab. Enable **Modify events** for the keyboard if needed. The tracked device override sets `ignore = false` for vendor `13364`, product `2323` (keyboard and pointing-device flags); a different device identifier may need its own setting.

## Current shortcuts

| Input | Action |
| --- | --- |
| Hold Caps Lock | Hyper: Control + Option + Command + Shift |
| Caps Lock alone | Caps Lock |
| Hyper + H / J / K / L | Left / Down / Up / Right |
| Hyper + I | Command+Tab |
| Hyper + U | Command+Shift+Tab |
| Hyper + [ / ] | Control+Shift+Tab / Control+Tab |
| Hyper + F | Command+Control+F (fullscreen) |

Edit the JSON directly or use Karabiner's settings and review the Git diff. The whole config directory is linked for change detection, but its `.gitignore` excludes runtime state and admits only the JSON and ignore file.
