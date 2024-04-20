# CONFIGS

This repo contains the following configuration files:

- `.zshrc`
- `karabiner.edn`

## Symlink

A symlink was created from `~/configs/.zshrc` to `~/.zshrc`.

## Karabiner

To apply changes made to `karabiner.edn`, must specify the file location using an env var: 

```shell
GOKU_EDN_CONFIG_FILE=~/configs/karabiner.edn goku
```