return {
  {
   "m4xshen/hardtime.nvim",
   dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
   opts = {
    restriction_mode="hint",
    disable_mouse=false,
   },
  },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    config = function ()
       require("dressing").setup({
       input = {
         enable = true
  	}})
    end
  },
  {
    "lambdalisue/suda.vim",
    config = function ()
      vim.g.suda_nopass = 1
    end,
  },
  "drewtempelmeyer/palenight.vim", -- Color scheme
  "ellisonleao/gruvbox.nvim",
  "junegunn/fzf",
  "mechatroner/rainbow_csv",       --
  "mfussenegger/nvim-dap",
  "mgedmin/python-imports.vim",    -- Auto import for Python
  "neovim/nvim-lspconfig",
  "rafamadriz/friendly-snippets",
  "tmhedberg/SimpylFold",         -- Python folding
  "tpope/vim-eunuch",             -- UNIX commands
  "tpope/vim-fugitive",           -- Git support
  "tpope/vim-repeat",             -- "." repeating maps from plugins
  "tpope/vim-sensible",           -- Sensible defaults
  "tpope/vim-unimpaired",         -- See the help
  "tree-sitter/tree-sitter-python",
  "tveskag/nvim-blame-line",      -- Git blamer
  "vim-airline/vim-airline",      -- Nice status line
  "williamboman/mason-lspconfig.nvim",
  "williamboman/mason.nvim",
  "wookayin/semshi",
  "zaldih/themery.nvim",
  "zhou13/vim-easyescape",        -- Map jk and kj to <ESC>
 }
