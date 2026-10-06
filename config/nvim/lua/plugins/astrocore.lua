-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    treesitter = {
      ensure_installed = { "mermaid", "regex" },
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = false, -- sets vim.opt.relativenumber
        number = false, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
      },
      g = { -- vim.g.<key>
        loaded_perl_provider = 0,
        loaded_ruby_provider = 0,
        -- Prefer the dedicated pynvim environment from install-runtimes.sh.
        python3_host_prog = (function()
          local python = vim.fn.expand "~/.local/share/nvim/python/bin/python"
          if vim.fn.executable(python) == 1 then return python end
          if vim.fn.executable "uv" == 1 then
            python = vim.fn.systemlist("uv python find")[1]
            if python and python ~= "" then return python end
          end
        end)(),
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        ["<Leader>id"] = { 'a<C-R>=strftime("%F")<CR><Esc>', desc = "Insert date" },

        ["gs"] = {
          function()
            require "sentences"
            vim.go.operatorfunc = "v:lua.sentence_split_operator"
            return "g@"
          end,
          expr = true,
          desc = "Split sentences",
        },
        ["gss"] = {
          function()
            require "sentences"
            vim.go.operatorfunc = "v:lua.sentence_split_operator"
            -- The typed count is applied to this motion, as with `gqq`.
            return "g@_"
          end,
          expr = true,
          desc = "Split sentences",
        },

        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,
      },
      x = {
        ["gs"] = {
          function()
            require "sentences"
            vim.go.operatorfunc = "v:lua.sentence_split_operator"
            return "g@"
          end,
          expr = true,
          desc = "Split sentences",
        },
      },
    },
  },
}
