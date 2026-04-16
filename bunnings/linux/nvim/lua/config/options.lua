-- Options: overrides LazyVim defaults
-- See :h vim.opt for full reference

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation (match old vimrc: 4 spaces)
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

-- Search
opt.ignorecase = true
opt.smartcase = true

-- Persistent undo (better than backup files)
opt.undofile = true

-- No annoying bells
opt.visualbell = true
opt.errorbells = false

-- Wrap long lines
opt.wrap = true

-- Keep more command history
opt.history = 200
