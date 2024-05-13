vim.g.mapleader = " "
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")


vim.opt.background = "dark"
vim.cmd([[colorscheme palenight]])
vim.opt.showcmd = true
vim.opt.iskeyword:append("-")
vim.opt.showmatch = true
vim.opt.smartcase = true  -- Do smart case matching
vim.opt.incsearch = true  -- Incremental search
vim.opt.autowrite = true  -- Automatically save before commands like :next and :make
vim.opt.autoread = true   -- Automatically reload files when externally changed
vim.opt.spell = false     -- Spell checking per default
vim.opt.wrap = false      --  Disable line wrapping (with unimpaired use yow to toggle)
vim.opt.cursorline = true -- Highlight the current line
vim.opt.termguicolors = true
vim.opt.number = false
vim.opt.mouse = "nv"
vim.opt.clipboard = "unnamedplus"  -- Interact easily with system clipboard
vim.b.surround_indent = 0 -- surround
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
require("lsp-config")
require("keymap") -- key mappings
require("autocmd") -- auto commands


vim.g.python3_host_prog = "~/miniforge3/bin/python3"
