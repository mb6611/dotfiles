-- Editor plugins
return {
  -- Surround
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- Better escape
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    opts = {
      timeout = 300,
      mappings = {
        i = { j = { c = "<Esc>", f = "<Esc>:w<CR>", j = "<Esc>:w<CR>", k = "<Esc>:w<CR>" } },
      },
    },
  },

  -- Sleuth (auto-detect indent)
  { "tpope/vim-sleuth" },

  -- Easy motion (hop.nvim - closer to classic EasyMotion)
  {
    "smoka7/hop.nvim",
    version = "*",
    event = "VeryLazy",
    opts = { keys = "etovxqpdygfblzhckisuran" },
    keys = {
      { "<leader><leader>w", "<cmd>HopWordAC<cr>", mode = { "n", "x", "o" }, desc = "Hop word forward" },
      { "<leader><leader>b", "<cmd>HopWordBC<cr>", mode = { "n", "x", "o" }, desc = "Hop word backward" },
    },
  },

  -- Tmux integration
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
    },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>" },
    },
  },

  -- FZF
  {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf", build = ":call fzf#install()" },
    keys = {
      { "<C-f>", "<cmd>Lines<cr>", mode = "n" },
    },
  },

  -- Zoxide
  { "nanotee/zoxide.vim" },

  -- Table mode
  { "dhruvasagar/vim-table-mode", ft = { "markdown", "org" } },

  -- Zen mode
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {},
  },

  -- Twilight (dimming)
  {
    "folke/twilight.nvim",
    cmd = "Twilight",
    opts = {},
  },

  -- File explorer
  -- INSTRUCTIONS (macOS):
  -- https://formulae.brew.sh/cask/font-caskaydia-mono-nerd-font
  -- brew install --cask font-caskaydia-mono-nerd-font
  -- set NERDTreeFontFamily="Caskaydia Mono Nerd Font Mono"
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>n", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file explorer" },
    },
    config = function()
      local api = require("nvim-tree.api")
      local function on_attach(bufnr)
        local function opts(desc)
          return { desc = desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end
        -- Default mappings
        api.config.mappings.default_on_attach(bufnr)
        -- NERDTree-style mappings
        vim.keymap.set("n", "s", api.node.open.vertical, opts("Open: Vertical Split"))
        vim.keymap.set("n", "i", api.node.open.horizontal, opts("Open: Horizontal Split"))
        vim.keymap.set("n", "go", api.node.open.preview, opts("Open Preview"))
        vim.keymap.set("n", "t", api.node.open.tab, opts("Open: New Tab"))
      end
      require("nvim-tree").setup({
        on_attach = on_attach,
        view = { width = 30 },
        renderer = {
          indent_markers = { enable = true },
          icons = {
            show = { git = true, folder = true, file = true },
            git_placement = "signcolumn",
            glyphs = {
              folder = {
                arrow_closed = "",
                arrow_open = "",
              },
              git = {
                unstaged = "●",
                staged = "✓",
                unmerged = "",
                renamed = "➜",
                untracked = "★",
                deleted = "",
                ignored = "",
              },
            },
          },
        },
        git = { ignore = false },
      })
    end,
  },

  -- Copilot
  {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
      vim.g.copilot_filetypes = { markdown = true, yaml = true }
    end,
  },

  -- Instant collaborative editing
  {
    "jbyuki/instant.nvim",
    cmd = { "InstantStartServer", "InstantJoinSession" },
    config = function()
      vim.g.instant_username = "matt"
    end,
  },

  -- Emoji completion
  { "junegunn/vim-emoji", event = "VeryLazy" },

  -- Tmux.nvim (additional tmux integration)
  -- Note: This plugin provides functions, no setup needed
  { "nathom/tmux.nvim", lazy = true },

  -- Goyo (distraction-free writing)
  {
    "junegunn/goyo.vim",
    cmd = "Goyo",
  },

  -- Codi (interactive scratchpad)
  {
    "metakirby5/codi.vim",
    cmd = { "Codi", "CodiNew", "CodiSelect" },
    init = function()
      vim.g.codi_interpreters = {
        python = {
          bin = "python3",
          prompt = "^\\(>>>\\|\\.\\.\\.\\) ",
        },
      }
    end,
  },

  -- Semantic highlight
  {
    "jaxbot/semantic-highlight.vim",
    cmd = { "SemanticHighlight", "SemanticHighlightToggle" },
  },

  -- JSX pretty (syntax)
  { "maxmellon/vim-jsx-pretty", ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" } },
}
