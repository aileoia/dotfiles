return {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
    init = function()
      vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { silent = true })
    end,
    config = function()
      require("nvim-tree").setup({
        filters = {
          dotfiles = true,
          custom = { "__pycache__" },
        },
        renderer = {
          icons = {
            show = {
              folder_arrow = false,
            },
            glyphs = {
              default = "",
              folder = {
                default = "▶",
                open = "▼",
                empty = "▷",
                empty_open = "▽",
              },
            },
          },
        },
        on_attach = function(bufnr)
          local api = require("nvim-tree.api")

          -- Default mappings
          api.config.mappings.default_on_attach(bufnr)

          -- Custom mappings
          local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, silent = true, nowait = true }
          end
          vim.keymap.set("n", "<cr>", api.node.open.no_window_picker, opts("Open: No Window Picker"))
          vim.keymap.set("n", "<2-LeftMouse>", api.node.open.no_window_picker, opts("Open: No Window Picker"))
          vim.keymap.set("n", "s", api.node.open.vertical, opts('Open: Vertical Split'))
        end,
      })
    end,
  }
