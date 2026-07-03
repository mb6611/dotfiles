-- ============================================================================
-- LaTeX  (VimTeX + concealment)
-- ============================================================================
-- All LaTeX editing lives here. Every command keymap is under <leader>l (tex only).
--
--   maplocalleader == mapleader == <space>, so VimTeX's native <localleader>l… maps
--   ARE <leader>l… — i.e. "\ll" in any VimTeX tutorial == <leader>ll here.
--   Core verbs (mnemonic: <leader>l + first letter of the verb; "ll" = compile):
--     <leader>ll compile (+auto-opens PDF)   <leader>lv view / forward-search
--     <leader>lk stop        <leader>le errors   <leader>lc clean   <leader>lt TOC
--     <leader>li info        <leader>lq log      <leader>ls toggle-main
--     <leader>lo build-log   <leader>la menu     <leader>lx reload
--
--   VimTeX motions:      %  ]] [[ ][ []   ]m [m (section)  ]n [n (env)  ]* [* (frame)
--   VimTeX text objects: ic/ac cmd  id/ad delim  ie/ae env  i$/a$ math  iP/aP section
--   VimTeX surround/toggle (normal): dse/cse env  dsc/csc cmd  dsd/csd delim
--                                    ds$/cs$ math  tse toggle-env  tss toggle-star
--                                    tsf toggle-frac  tsd toggle-delim-size
--   VimTeX F-keys: <F6> surround env  <F7> create cmd  <F8> add delim modifiers
--                  ]] (insert mode) close current environment
--   K = documentation lookup under cursor.
-- ============================================================================
return {
  -- VimTeX: compilation, Sioyek viewer, navigation, text objects.
  {
    "lervag/vimtex",
    ft = { "tex", "latex" },
    -- Also load on this command so the headless nvim that Sioyek spawns for inverse
    -- search (`nvim --headless -c "VimtexInverseSearch …"`) can actually run it.
    cmd = { "VimtexInverseSearch" },
    init = function()
      vim.g.vimtex_view_method = "sioyek"
      vim.g.vimtex_compiler_method = "latexmk"
      -- Continuous mode: <leader>ll starts `latexmk -pvc`, which then rebuilds on
      -- every save (:w) and auto-opens/reloads Sioyek. Off until you start it.
      vim.g.vimtex_compiler_latexmk = { continuous = 1 }
      vim.g.vimtex_quickfix_open_on_warning = 0
      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_quickfix_disable_warning_message = 1
      vim.g.vimtex_syntax_conceal_disable = 1

      -- tex-conceal renders \alpha->α, \frac->fraction, etc. It needs conceal on,
      -- but our global conceallevel is 0, so enable it for tex buffers only.
      -- a=accents b=bold/italic d=delimiters m=math-symbols g=greek
      vim.g.tex_conceal = "abdmg"
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("LatexSetup", { clear = true }),
        pattern = { "tex", "latex" },
        callback = function(ev)
          vim.opt_local.conceallevel = 2
          vim.opt_local.concealcursor = "" -- reveal raw source on the cursor line
          -- Label the <leader>l prefix as "+latex" in this buffer's which-key popup.
          pcall(function()
            require("which-key").add({ { "<leader>l", group = "latex", buffer = ev.buf } })
          end)
        end,
      })

      -- After an inverse search (right-click in Sioyek), surface Neovim: select its
      -- tmux pane, then bring iTerm2 to the foreground (macOS: iTerm2 -> tmux -> nvim).
      vim.api.nvim_create_autocmd("User", {
        group = vim.api.nvim_create_augroup("LatexInverseFocus", { clear = true }),
        pattern = "VimtexEventViewReverse",
        callback = function()
          local pane = vim.env.TMUX_PANE
          if vim.env.TMUX and pane then
            vim.fn.jobstart({ "tmux", "select-window", "-t", pane })
            vim.fn.jobstart({ "tmux", "select-pane", "-t", pane })
          end
          vim.fn.jobstart({ "osascript", "-e", 'tell application "iTerm" to activate' })
        end,
      })
    end,
  },

  -- Prettier in-buffer concealment of math symbols, \frac, sub/superscripts, etc.
  {
    "KeitaNakamura/tex-conceal.vim",
    ft = { "tex", "latex" },
  },

  -- Castel-style math autosnippets on LuaSnip: type x/y -> \frac{x}{y}, backslash-less
  -- greek (@a -> \alpha), auto-subscripts (x1 -> x_1), sq -> \sqrt, etc. They fire only
  -- inside math zones (via VimTeX's mathzone detection). Needs enable_autosnippets
  -- (set in completion.lua) + jsregexp (LuaSnip's build step).
  {
    "iurimateus/luasnip-latex-snippets.nvim",
    ft = { "tex", "latex" },
    dependencies = { "L3MON4D3/LuaSnip", "lervag/vimtex" },
    config = function()
      require("luasnip-latex-snippets").setup()
    end,
  },
}
