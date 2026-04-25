-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- add yazi to path
vim.env.PATH = vim.env.PATH .. ":" .. vim.fn.expand("/snap/bin")
