---@type LazySpec
return {
  "folke/snacks.nvim",
  keys = {
    { "<Leader>Mp", function() Snacks.image.hover() end, desc = "Preview image at cursor" },
  },
  opts = {
    image = {
      doc = { enabled = true },
    },
    picker = {
      db = { sqlite3_path = "libsqlite3.so.0" },
    },
  },
}
