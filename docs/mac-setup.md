# Manual Mac setup

Start with the [fresh Mac commands](../README.md#fresh-mac). `init-nix.sh` installs Determinate Nix and invokes the rebuild in the same shell; a separate Nix installation or new shell is unnecessary for that first run.

## After the automated setup

1. Open installed apps and complete their permissions and account sign-ins. Claude Desktop, ChatGPT Desktop, Claude Code and Codex are declared in `configuration.nix`; their authentication is not stored in the repo.
2. Connect the keyboard and mouse. Complete the [Karabiner permissions and device checks](karabiner.md). Karabiner is installed through Homebrew and reads native JSON directly.
3. Configure Spokenly in the app: **Option+Space**, **Distil-Whisper Large 3.5 (English only)**, and offline mode. The application is installed automatically; these in-app settings are manual.
4. Clear ChatGPT's floating Mini/Pets **Option+Space** binding so it does not conflict with Spokenly. In ChatGPT settings, check **Keyboard shortcuts → Show pet**; labels may change between app versions. See the [Pets documentation](https://learn.chatgpt.com/docs/pets).
5. If tapping the trackpad still does not click after rebuilding, log out and back in. Tap-to-click is declared, but the running driver can retain the previous setting.
6. Restore [SSH access to the Pi](ssh.md) and configure [Git identity](maintenance.md#machine-identity).
7. If using Docker Sandboxes, complete its [sign-in step](docker-sandboxes.md).
8. Open Proton Drive, sign in to your Proton account, complete any requested macOS permissions, and choose which files to keep available offline. Homebrew installs the app; authentication and sync preferences stay local to the Mac.
9. Open BetterDisplay and complete its first-launch setup. Leave CLI integration enabled and run `./rebuild-nix.sh` again to apply the built-in display scaling described below.

## Built-in display scaling

The Mac rebuild uses the installed BetterDisplay app to select **1496 × 967 HiDPI with ProMotion** on **Built-in Display**. This is the effective "looks like" size, not the panel's physical resolution. The preferred size is set by `builtInDisplayResolution` in `configuration.nix`; external displays are not targeted.

BetterDisplay must already be running in the user's graphical session. If it is not running, the rebuild skips this step with a message. An unsupported mode or failed CLI request produces a warning without failing the rebuild. On a different Mac, check the available modes before changing the preference:

```sh
/Applications/BetterDisplay.app/Contents/MacOS/BetterDisplay \
  get -name="Built-in Display" -displayModeList
```

The activation command also requests ProMotion, so adjust that argument for displays without it. See the [BetterDisplay CLI reference](https://betterdisplay.pro/guide/integration/cli-reference/).

## Software with manual setup

Spokenly's model and offline mode are configured in the app. Contexts is licensed software installed separately from [contexts.co](https://contexts.co/); it is not declared in the current Homebrew list. The previous Homebrew installation attempt encountered a vendor certificate error; this is historical context, not a check of the vendor's current certificate.

Keychron exports in `accessories/` are imported through the keyboard's configuration app when needed. They are not applied by a Nix rebuild.
