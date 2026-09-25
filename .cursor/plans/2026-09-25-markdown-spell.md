# Markdown spell checking

## Goal

Turn spell checking on automatically in markdown buffers, and keep the words
added with `zg` in this repo so they follow the user across machines.

## Approach

`spell` and `spelllang=en` are set in `config/nvim/after/ftplugin/markdown.lua`,
next to the prose wrapping logic. `spell` is globally off via astrocore, so the
buffer-local setting only affects markdown.

No `spellfile` option is set. Neovim resolves the `zg` target itself and dotbot
links that path into the repo, so the config stays free of machine paths.

## Key decisions

Code blocks need no special handling. The bundled markdown queries capture only
`(inline) @spell`, and markdown_inline marks `code_span`, link urls and
`entity_reference` as `@nospell`, so fenced blocks are never checked.

The link target is `~/.local/share/nvim/site/spell/en.utf-8.add`. Neovim ignores
the classic vim rule of "first writable directory in runtimepath" here: with a
writable `~/.config/nvim` at the front of the runtimepath it still chose the
data directory.

The existing `config/nvim/*` glob additionally links `config/nvim/spell` to
`~/.config/nvim/spell`. That link is inert, since only compiled `.spl` files are
loaded from the runtimepath, and it was present during verification.

The compiled `en.utf-8.add.spl` is written beside the symlink in the data
directory, so it stays machine-local and out of git.

## Steps

- [x] Set `spell` and `spelllang` in `config/nvim/after/ftplugin/markdown.lua`
- [x] Add empty `config/nvim/spell/en.utf-8.add`
- [x] Link it from `install.conf.yaml`
- [x] Verify `zg` writes through the symlink and preserves it
- [x] Run `./install`
- [ ] Reload open markdown buffers with `:edit`
