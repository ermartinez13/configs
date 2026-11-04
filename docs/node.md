# Node.js

Both machines get Node.js 24 (including npm) and fnm through Nix. After rebuilding, open a new terminal or SSH session to pick up the shell environment.

Use fnm for additional versions:

```sh
fnm install 22
fnm use 22
fnm use system  # return to the Nix baseline
```

Zsh initializes fnm with `--use-on-cd`, so project `.node-version` and `.nvmrc` files select installed versions when entering a directory. Use an exact project version when repeatability matters. Additional fnm downloads are local runtime state, outside `flake.lock`.

The package declaration and shell integration live in `shared/home.nix`. The shell function rehashes zsh's command cache after fnm changes a version, so cached Nix node/npm paths do not mask the switch.
