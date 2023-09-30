-- functions for key mapping
function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true})
end

function nmap(shortcut, command)
  map('n', shortcut, command)
end

function nmapsilent(shortcut, command)
  vim.api.nvim_set_keymap('n', shortcut, command, {silent = true, noremap = true})
end

function imap(shortcut, command)
  map('i', shortcut, command)
end


-- Save and quit quickly
nmapsilent("<leader>w", ":wa<CR>")
nmapsilent("<leader>q", ":x<CR>")
nmapsilent("<leader>x", ":xa<CR>")
-- Navigation between windows
nmap("<C-h>", "<C-w><C-h>")
nmap("<C-j>", "<C-w><C-j>")
nmap("<C-k>", "<C-w><C-k>")
nmap("<C-l>", "<C-w><C-l>")
nmap("<C-j>", "<C-w><C-j>")
-- Navigation between tabs
nmap("<C-f>", ":tabnext<CR>")
nmap("<C-d>", ":tabprevious<CR>")
-- Fugitive
nmap("gs", ":wa<CR> :vertical Git<CR>")
nmap("<leader>gp", ":Git push<CR>")
nmap("<leader>gb", ":Git blame<CR>")

nmap("<leader>tc", ":tabclose<CR>")

nmap("<leader>db", ":DapToggleBreakpoint<CR>")
nmap("<leader>dc", ":DapContinue<CR>")
nmap("<leader>dt", ":DapTerminate<CR>")
