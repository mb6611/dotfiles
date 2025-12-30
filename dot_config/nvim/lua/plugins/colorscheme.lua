-- Colorschemes
return {
  -- Dark Purple (favorite)
  {
    "shapeoflambda/dark-purple.vim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("gruvbox-material")
      -- vim.cmd.colorscheme("dark_purple")
      -- Transparency
      vim.cmd("hi! Normal ctermbg=NONE guibg=NONE")
      vim.cmd("hi! NonText ctermbg=NONE guibg=NONE guifg=NONE ctermfg=NONE")
      vim.cmd("hi Comment gui=NONE")
    end,
  },

  -- Other themes (lazy loaded)
  { "dracula/vim", name = "dracula", lazy = true },
  { "wadackel/vim-dogrun", lazy = true },
  { "arzg/vim-colors-xcode", lazy = true },
  { "sonph/onehalf", rtp = "vim/", lazy = true },
  { "ayu-theme/ayu-vim", lazy = true },
  { "morhetz/gruvbox", lazy = true },
  { "lifepillar/vim-gruvbox8", lazy = true },
  { "sainnhe/gruvbox-material", lazy = true },
  { "catppuccin/vim", name = "catppuccin", lazy = true },
}
