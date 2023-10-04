return {
      "nvimtools/none-ls.nvim",
    dependencies="nvim-lua/plenary.nvim",
    ft = {
      "python"
    },
    config = function ()
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
      local sources = {
          require("null-ls").builtins.formatting.isort,
          require("null-ls").builtins.formatting.black,
          require("null-ls").builtins.diagnostics.mypy.with({
	    extra_args = function()
	    local virtual = os.getenv("CONDA_PREFIX") or os.getenv("CONDA_DEFAULT_ENV") or "/usr"
	    return { "--python-executable", virtual .. "/bin/python3", "--ignore-missing-imports", }
	    end,
	  }),
          require("null-ls").builtins.diagnostics.ruff,
          require("null-ls").builtins.diagnostics.pydocstyle,
      }
      require("null-ls").setup({
        debug=true,
        sources=sources,
        on_attach = function(client, bufnr)
              if client.supports_method("textDocument/formatting") then
                  vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                  vim.api.nvim_create_autocmd("BufWritePre", {
                      group = augroup,
                      buffer = bufnr,
                      callback = function()
                          -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
                          vim.lsp.buf.format({ async = false })
                      end,
                  })
              end
          end,})

    end
  }
