---@type LazySpec
return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- latest release
  ft = "markdown",
  dependencies = { "folke/snacks.nvim" },
  ---@module "obsidian"
  ---@type obsidian.config
  opts = {
    legacy_commands = false,
    workspaces = {
      {
        name = "personal",
        path = "~/repos/leo-personal",
      },
    },
    picker = { name = "snacks.picker" },
    -- Existing notes are kebab-case filenames, not random zettel ids.
    note_id_func = function(title, dir) return require("obsidian.builtin").title_id(title, dir) end,
    -- Saving a note must not inject the plugin's id/aliases/tags schema.
    frontmatter = { enabled = false },
  },
}
