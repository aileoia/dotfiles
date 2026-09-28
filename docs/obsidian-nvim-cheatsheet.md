# Obsidian.nvim mini cheat sheet

These shortcuts work in Markdown notes under `~/repos/leo-personal`.
Legacy commands are disabled, so use the `:Obsidian <command>` form.

## Keyboard shortcuts

- `Enter`: follow the link under the cursor; on a tag, checkbox, or heading,
  perform the corresponding smart action
- `]o` / `[o`: jump to the next / previous link in the note
- `gf`: follow the wiki or Markdown link under the cursor
- `grr`: list references to the current note
- `grn`: rename the note and update backlinks
- `gra`: show available Obsidian code actions

While inserting text:

- `[[`: complete note links
- `#`: complete tags
- `[^`: complete footnotes

## Everyday commands

- `:Obsidian quick_switch`: find and open a note
- `:Obsidian search [query]`: search note contents
- `:Obsidian backlinks`: show notes linking to the current note
- `:Obsidian links`: list links in the current note
- `:Obsidian tags [tag]`: find notes containing a tag
- `:Obsidian new [title]`: create a note
- `:Obsidian rename [name]`: rename the current note and update backlinks
- `:Obsidian toc`: open the current note's table of contents
- `:Obsidian open`: open the current note in the Obsidian application

## Daily notes and templates

- `:Obsidian today [offset-or-date]`
- `:Obsidian yesterday` / `:Obsidian tomorrow`
- `:Obsidian dailies [offset ...]`: browse daily notes
- `:Obsidian new_from_template [title] [template]`
- `:Obsidian template [name]`: insert a template

Template commands require a `templates.folder` setting.

## Visual selection commands

Select text first, then run:

- `:Obsidian link [note]`: link the selection to an existing note
- `:Obsidian link_new [title]`: create a note and link the selection
- `:Obsidian extract_note [title]`: move the selection into a linked note

## Help

- `:Obsidian check`: check the vault and plugin configuration
- `:checkhealth obsidian`: run Neovim health checks
- `:Obsidian help`: browse the installed plugin documentation
