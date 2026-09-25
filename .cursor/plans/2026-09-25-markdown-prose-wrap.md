# Markdown prose wrapping

## Goal

Auto-wrap markdown prose at `textwidth` while typing in insert mode, without
breaking fenced code blocks, tables, mermaid diagrams, headings or frontmatter.

## Problem

`textwidth` was `0` in every buffer, so nothing wrapped while typing and `gq`
silently fell back to its default (screen width, capped at 79). The inherited
`formatoptions=tqnjcl` also carries `l`, which suppresses auto-format on lines
that were already longer than `textwidth` when insert mode started.

## Approach

Keep `textwidth=88` set for the whole markdown buffer so `gq` always works, and
toggle only the `t` flag per keystroke based on the Treesitter node under the
cursor.

The markdown tree is queried explicitly via `vim.treesitter.get_parser(buf,
"markdown")` rather than `vim.treesitter.get_node`. The latter resolves into
injected language trees, so a mermaid block would return mermaid nodes. Asking
the markdown layer directly keeps every fenced block a `fenced_code_block`
regardless of the injected language, and needs no extra parsers.

Wrapping is whitelisted, not blacklisted: enable `t` only when an ancestor is a
`paragraph` and no ancestor is a blocked block type. List items and blockquotes
come out right for free, since their text is a `paragraph` nested inside
`list_item` / `block_quote`.

Placed in `after/ftplugin/` so it runs last in the runtimepath and cannot be
overridden by the astrocommunity markdown pack.

## Key decisions

- `a` (continuous paragraph reflow) defaults to off behind a local toggle. Even
  scoped to paragraphs it rewrites the whole paragraph on every edit, which
  makes git diffs noisy.
- `l` is removed so existing long lines can be broken.
- Parse is range-limited to the cursor line to keep the per-keystroke cost down.
- `blink.cmp` strips `t`/`c`/`a` globally while its menu is open and restores
  them afterwards. It uses the global option, this uses the buffer-local one, so
  they can briefly disagree. The next keystroke corrects it.

## Steps

- [x] Add `config/nvim/after/ftplugin/markdown.lua`
- [x] Verify the node classification against a fixture covering prose, lists,
      blockquotes, tables, fenced code, mermaid, headings and frontmatter
- [x] Run `./install` to symlink `~/.config/nvim/after`
- [ ] Reload open markdown buffers with `:edit`
