-- Keymaps: minimal personal bindings on top of LazyVim defaults
-- LazyVim defaults are good — only adding what's genuinely missing

local map = vim.keymap.set

-- Insert newline in normal mode without entering insert mode
map("n", "nl", "o<Esc>", { desc = "Insert line below" })
map("n", "NL", "O<Esc>", { desc = "Insert line above" })

-- enable block visual with leader
map("n", "<Leader>v", "<C-v>", { desc = "Enter visual block when <C-v> taken", noremap = true })
