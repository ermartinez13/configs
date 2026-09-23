# CONFIGS

Personal configuration files, tracked here and symlinked into place on the host.

## Layout

- `home/` — mirrors the structure of the actual home directory (`~`). Everything under it is meant to be **symlinked** from this repo into the corresponding path in `~`, not copied.
  - `home/.zshrc` → `~/.zshrc`
  - `home/.config/nvim/` → `~/.config/nvim`
  - `home/.config/wezterm/` → `~/.config/wezterm`
  - `home/.config/herdr/` → `~/.config/herdr`
  - `home/.config/karabiner.edn` → `~/.config/karabiner.edn`
- `accessories/` — device configs that are imported through their own apps rather than symlinked (`keychron-keymap.json`, `keychron-macros.json`).

## Symlinking

Because these are symlinks, edits made in `~` and edits made in this repo are the same file — commit from here as usual.

```shell
ln -s ~/repos/configs/home/.zshrc ~/.zshrc
ln -s ~/repos/configs/home/.config/nvim ~/.config/nvim
ln -s ~/repos/configs/home/.config/wezterm ~/.config/wezterm
ln -s ~/repos/configs/home/.config/herdr ~/.config/herdr
ln -s ~/repos/configs/home/.config/karabiner.edn ~/.config/karabiner.edn
```

Use `ln -sfn` to replace an existing link, and move any real file out of the way first.

## Karabiner

Prerequisites:
> Make sure you have a profile named "Default" in Karabiner's GUI tool. --[goku](https://github.com/yqrashawn/GokuRakuJoudo)
