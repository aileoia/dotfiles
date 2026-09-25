---@type LazySpec
return {
  "folke/snacks.nvim",
  opts = {
    image = {
      doc = { enabled = true },
    },
    picker = {
      db = { sqlite3_path = "libsqlite3.so.0" },
    },
  },
}
