-- Custom plugins: additions and overrides on top of LazyVim defaults
-- LazyVim already includes: telescope, treesitter, LSP, neo-tree, gitsigns,
-- mini.surround, mini.comment, blink.cmp (autocomplete), lazygit

return {
  -- ── Themes ──────────────────────────────────────────────────────────────────
  -- Switch theme: update the colorscheme value in the LazyVim opts block below.
  -- To preview any theme: :colorscheme <name><Tab>

  -- Catppuccin: soft pastels, purple/blue tones. Variants: latte, frappe, macchiato, mocha
  { "catppuccin/nvim", name = "catppuccin", priority = 1000, opts = { flavour = "mocha" } },

  -- Tokyo Night: cool blues and purples. Variants: night, storm, day, moon
  { "folke/tokyonight.nvim", priority = 1000, opts = { style = "night" } },

  -- Gruvbox Material: warm ambers and greens. Variants: hard, medium, soft
  { "sainnhe/gruvbox-material", priority = 1000 },

  -- Rose Pine: elegant muted tones. Variants: main, moon, dawn
  { "rose-pine/neovim", name = "rose-pine", priority = 1000 },

  -- Kanagawa: inspired by Japanese woodblock art. Variants: wave, dragon, lotus
  { "rebelot/kanagawa.nvim", priority = 1000, opts = { theme = "wave" } },

  -- ── Active theme ────────────────────────────────────────────────────────────
  -- Change "catppuccin" to any of: tokyonight, gruvbox-material, rose-pine, kanagawa
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "catppuccin" },
  },
}
