-- Keymaps (converted from keymaps.vim)

local map = vim.keymap.set
local opts = { noremap = true, silent = true }
-- opts + a which-key label (so bindings show friendly names in the menu)
local function d(desc)
  return { noremap = true, silent = true, desc = desc }
end

-- Disable ex mode
map("n", "q:", "<Nop>", d("Disable ex mode"))

-- Delete to black hole register (non-buffer overwrite)
map({ "n", "v" }, "<leader>d", '"_d', d("Blackhole delete"))
map({ "n", "v" }, "<leader>D", '"_D', d("Blackhole delete to EOL"))
map({ "n", "v" }, "<leader>c", '"_c', d("Blackhole change"))
map({ "n", "v" }, "<leader>C", '"_C', d("Blackhole change to EOL"))
map({ "n", "v" }, "<leader>x", '"_x', d("Blackhole delete char"))
map({ "n", "v" }, "<leader>X", '"_X', d("Blackhole delete char before"))

-- Insert mode escape alternatives
map("i", "jc", "<Esc>", d("Escape"))
map("i", "jf", "<Esc>:w<CR>", d("Escape + save"))
map("i", "jj", "<Esc>:w<CR>", d("Escape + save"))
map("i", "kk", "<Esc>:w<CR>", d("Escape + save"))
map("i", "jk", "<Esc>:w<CR>", d("Escape + save"))
map("i", "<C-c>", "<Esc>:w<CR>", d("Escape + save"))

-- Switch to alternate buffer
map("n", "<C-e>", "<C-^>", d("Alternate buffer"))

-- Visual line
map("n", "<leader>v", "V", d("Select line (visual)"))

-- Folding
map("n", "<leader>f", "za", d("Toggle fold"))
map("v", "<leader>z", "zf", d("Create fold"))

-- Insert newline without entering insert mode (moved to <leader><leader>o to free <leader>o for Obsidian)
map("n", "<leader><leader>o", "o<Esc>k", d("Insert blank line below"))
map("n", "<leader><leader>O", "O<Esc>j", d("Insert blank line above"))

-- Bracket jumping
map({ "n", "v" }, "<leader>w", "%", d("Jump to matching bracket"))

-- Fast vertical movement (Shift-j/k)
map({ "n", "v" }, "J", "10j", d("Down 10 lines"))
map({ "n", "v" }, "K", "10k", d("Up 10 lines"))

-- Line moving (Alt+j/k)
map("n", "<A-j>", ":m .+1<CR>==", d("Move line down"))
map("n", "<A-k>", ":m .-2<CR>==", d("Move line up"))
map("i", "<A-j>", "<Esc>:m .+1<CR>==gi", d("Move line down"))
map("i", "<A-k>", "<Esc>:m .-2<CR>==gi", d("Move line up"))
map("v", "<A-j>", ":m '>+1<CR>gv=gv", d("Move selection down"))
map("v", "<A-k>", ":m '<-2<CR>gv=gv", d("Move selection up"))

-- Line moving (Meta+j/k alternative)
map("n", "<M-j>", ":m .+1<CR>==", d("Move line down"))
map("n", "<M-k>", ":m .-2<CR>==", d("Move line up"))
map("i", "<M-j>", "<Esc>:m .+1<CR>==gi", d("Move line down"))
map("i", "<M-k>", "<Esc>:m .-2<CR>==gi", d("Move line up"))
map("v", "<M-j>", ":m '>+1<CR>gv=gv", d("Move selection down"))
map("v", "<M-k>", ":m '<-2<CR>gv=gv", d("Move selection up"))

-- Clipboard (macOS)
map({ "n", "x" }, "<leader>y", ":w !pbcopy<CR><CR>", d("Copy selection to clipboard"))
map("n", "<leader>yy", ":%w !pbcopy<CR><CR>", d("Copy whole file to clipboard"))

-- Telescope mappings defined in lua/plugins/telescope.lua

-- LaTeX shortcuts moved to lua/plugins/latex.lua (colocated with VimTeX)

-- Twilight toggle
map("n", "<leader>z", "<cmd>Twilight<CR>", d("Toggle Twilight"))

-- Commands
vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("PWF", function() print(vim.fn.expand("%")) end, {})
vim.api.nvim_create_user_command("S", "source ~/.config/nvim/init.lua", {})

-- DiffWithSaved command
vim.api.nvim_create_user_command("DiffSaved", function()
  local filetype = vim.bo.filetype
  vim.cmd("diffthis")
  vim.cmd("vnew | r # | normal! 1Gdd")
  vim.cmd("diffthis")
  vim.cmd("setlocal bt=nofile bh=wipe nobl noswf ro ft=" .. filetype)
end, {})

-- Note mode command
vim.api.nvim_create_user_command("Note", function()
  vim.opt_local.spell = true
  vim.opt_local.syntax = "markdown"
  vim.opt_local.number = false
  vim.opt_local.relativenumber = false
end, {})

-- Terminal commands
-- Open horizontal terminal split
vim.keymap.set("n", "<leader>ts", function()
  vim.cmd("split | terminal")
  vim.cmd("startinsert")
end, { desc = "Terminal (horizontal split)" })

-- Open vertical terminal split
vim.keymap.set("n", "<leader>ti", function()
  vim.cmd("vsplit | terminal")
  vim.cmd("startinsert")
end, { desc = "Terminal (vertical split)" })

-- Exit terminal mode
-- terminal escape
vim.keymap.set("t", "xx", [[<C-\><C-n>]], { noremap = true, desc = "Terminal: exit to normal mode" })


-- Diagnostic popup on demand
vim.keymap.set("n", "<leader>d", function()
  vim.diagnostic.open_float(nil, {
    focus = false,
    border = "rounded",
    source = "always",
  })
end, { desc = "Show diagnostic popup" })

-- Global diagnostic keymaps
vim.keymap.set("n", "]g", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "[g", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })

vim.keymap.set("n", "]G", function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Next error" })

vim.keymap.set("n", "[G", function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Prev error" })
