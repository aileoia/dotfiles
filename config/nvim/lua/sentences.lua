-- Join a line range and place each sentence on its own line.

local M = {}

local split_pattern = "^(.-[.!?][\"')}%]]*)%s+(.*)$"

---@param text string
---@return string[]
local function split_paragraph(text)
  local sentences = {}
  local remainder = text
  while remainder ~= "" do
    local sentence, rest = remainder:match(split_pattern)
    if not sentence then
      table.insert(sentences, remainder)
      break
    end
    table.insert(sentences, sentence)
    remainder = rest
  end
  return sentences
end

---@param line string
---@return boolean
local function is_blank(line) return line:find "%S" == nil end

---Join wrapped lines, then put each sentence on its own line.
---Blank lines stay in place and are not joined across.
---@param lines string[]
---@return string[]
function M.lines(lines)
  local output = {}
  local paragraph = {}

  local function flush()
    if #paragraph == 0 then return end
    local joined = table.concat(paragraph, " ")
    for _, sentence in ipairs(split_paragraph(joined)) do
      table.insert(output, sentence)
    end
    paragraph = {}
  end

  for _, line in ipairs(lines) do
    if is_blank(line) then
      flush()
      table.insert(output, "")
    else
      table.insert(paragraph, vim.trim(line))
    end
  end
  flush()
  return output
end

---@param buffer integer
---@param start_line integer
---@param end_line integer
function M.replace(buffer, start_line, end_line)
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end
  if start_line < 1 then return end

  local original = vim.api.nvim_buf_get_lines(buffer, start_line - 1, end_line, true)
  local replacement = M.lines(original)
  if vim.deep_equal(original, replacement) then return end
  vim.api.nvim_buf_set_lines(buffer, start_line - 1, end_line, true, replacement)
end

---Operator entry. Charwise, linewise, and block motions all split whole lines.
---@param _ string
function M.operator(_)
  local start_mark = vim.api.nvim_buf_get_mark(0, "[")
  local end_mark = vim.api.nvim_buf_get_mark(0, "]")
  local start_line = start_mark[1]
  local end_line = end_mark[1]
  if start_line < 1 or end_line < 1 then return end

  M.replace(0, start_line, end_line)
  local cursor_line = math.min(math.min(start_line, end_line), vim.api.nvim_buf_line_count(0))
  vim.api.nvim_win_set_cursor(0, { cursor_line, 0 })
end

_G.sentence_split_operator = M.operator

return M
