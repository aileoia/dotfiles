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
  "mechatroner/rainbow_csv",       --
  "junegunn/fzf",
  "mgedmin/python-imports.vim",    -- Auto import for Python
  "ellisonleao/gruvbox.nvim",
  "tmhedberg/SimpylFold",         -- Python folding
  "tpope/vim-eunuch",             -- UNIX commands
  "tpope/vim-fugitive",           -- Git support
  "tpope/vim-repeat",             -- "." repeating maps from plugins
  "tpope/vim-sensible",           -- Sensible defaults
  "tpope/vim-unimpaired",         -- See the help
  "tveskag/nvim-blame-line",      -- Git blamer
  "vim-airline/vim-airline",      -- Nice status line
  "zhou13/vim-easyescape",        -- Map jk and kj to <ESC>
  "zaldih/themery.nvim",
  "wookayin/semshi",
  "tree-sitter/tree-sitter-python",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",
  "rafamadriz/friendly-snippets",
  "mfussenegger/nvim-dap",
  "drewtempelmeyer/palenight.vim", -- Color scheme
 }
