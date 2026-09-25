-- Wrap prose at `textwidth` while typing, but leave code blocks, tables,
-- mermaid diagrams, headings and frontmatter alone.

-- The bundled markdown queries capture `(inline) @spell` and mark code spans,
-- link urls and entity references `@nospell`, so only prose is checked.
vim.opt_local.spell = true
vim.opt_local.spelllang = "en"

local width = 88
local reflow_paragraphs = false -- `a`: reformat the whole paragraph on every edit

vim.opt_local.textwidth = width
vim.opt_local.formatoptions:remove "l" -- break lines that were already long
vim.opt_local.formatoptions:remove "t" -- the autocommand below owns this flag

-- Markdown blocks where breaking a line changes the meaning of the document.
local no_wrap = {
  atx_heading = true,
  fenced_code_block = true,
  html_block = true,
  indented_code_block = true,
  link_reference_definition = true,
  minus_metadata = true, -- yaml frontmatter
  pipe_table = true,
  plus_metadata = true, -- toml frontmatter
  setext_heading = true,
}

-- Ask the markdown layer directly instead of `vim.treesitter.get_node`, which
-- descends into injected trees and would report mermaid/lua/python nodes inside
-- a fenced block rather than the fence itself.
local function in_prose(buf)
  local ok, parser = pcall(vim.treesitter.get_parser, buf, "markdown")
  if not ok or not parser then return false end

  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row, col = row - 1, math.max(0, col - 1)

  local trees = parser:parse { row, row + 1 }
  if not trees or not trees[1] then return false end

  local node = trees[1]:root():named_descendant_for_range(row, col, row, col)
  local prose = false
  while node do
    local kind = node:type()
    if no_wrap[kind] then return false end
    if kind == "paragraph" then prose = true end
    node = node:parent()
  end
  return prose
end

local group = vim.api.nvim_create_augroup("markdown_prose_wrap", { clear = false })
vim.api.nvim_clear_autocmds { group = group, buffer = 0 }

vim.api.nvim_create_autocmd({ "InsertEnter", "TextChangedI", "CursorMovedI" }, {
  group = group,
  buffer = 0,
  desc = "Auto-wrap markdown prose only",
  callback = function(args)
    local formatoptions = vim.opt_local.formatoptions
    if in_prose(args.buf) then
      formatoptions:append "t"
      if reflow_paragraphs then formatoptions:append "a" end
    else
      formatoptions:remove { "t", "a" }
    end
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  group = group,
  buffer = 0,
  desc = "Leave formatoptions clean for gq",
  callback = function() vim.opt_local.formatoptions:remove { "t", "a" } end,
})
