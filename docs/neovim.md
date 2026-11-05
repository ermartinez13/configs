# Neovim

Configuration lives in `home/.config/nvim/` and is linked on both the Mac and Pi. Plugins are managed by lazy.nvim; commit `lazy-lock.json` when intentionally updating their revisions.

## Markdown rendering

`render-markdown.nvim` loads only for Markdown files. It renders headings, lists, tables and code blocks in **Normal mode**. Enter **Insert mode** to see the raw Markdown while editing; rendering returns when you leave Insert mode. Visual mode also shows raw Markdown. The file contents are not changed by rendering.

Use `:RenderMarkdown buf_toggle` to toggle rendering for the current buffer.

Only the required `markdown` and `markdown_inline` Tree-sitter parsers and queries are installed through Nix. There is no extra icon plugin, browser preview, or LaTeX dependency; LaTeX rendering is disabled. The Mac already has a Nerd Font declared for terminal symbols.

After adding this setup, rebuild once (`./rebuild-nix.sh` on the Mac or `./rpi/rebuild.sh` on the Pi) to install the parsers, then restart Neovim. Lazy installs the rendering plugin on startup; open a Markdown file to use it. Run `:checkhealth render-markdown` if rendering does not work.
