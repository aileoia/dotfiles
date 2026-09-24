-- Customize Mason

---@type LazySpec
return {
  -- Debian python3 has no ensurepip; Mason PyPI packages (basedpyright, ruff extras, black, isort, debugpy)
  -- need a venv-capable interpreter. miniforge is already used for node/npm in this machine's PATH setup.
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      local conda_bin = vim.fn.expand "~/miniforge3/bin"
      if vim.fn.isdirectory(conda_bin) == 1 then
        vim.env.PATH = conda_bin .. ":" .. vim.env.PATH
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
