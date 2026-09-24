-- Customize Mason

---@type LazySpec
return {
  -- Debian python3 has no ensurepip; Mason PyPI packages need a venv-capable
  -- interpreter. Prefer the uv-managed CPython from install-runtimes.sh.
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      if vim.fn.executable "uv" == 1 then
        local python = vim.fn.systemlist("uv python find")[1]
        if python and python ~= "" and vim.fn.filereadable(python) == 1 then
          local bin = vim.fn.fnamemodify(python, ":h")
          vim.env.PATH = bin .. ":" .. vim.env.PATH
        end
      end
      return opts
    end,
  },
  -- use mason-tool-installer for automatically installing Mason packages
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- overrides `require("mason-tool-installer").setup(...)`
    opts = {
      -- Make sure to use the names found in `:Mason`
      ensure_installed = {
        "lua-language-server",
        "basedpyright",
        "ruff",
        "debugpy",
        "black",
        "isort",
        "docker-language-server",
        "hadolint",
        "json-lsp",
        "marksman",
        "taplo",
        "yaml-language-server",
        "helm-ls",
        "stylua",
        "selene",
      },
    },
  },
}
