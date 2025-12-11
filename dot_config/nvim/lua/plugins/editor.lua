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
    lazy = false,
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

      -- Open NvimTree on startup (IDE style)
      vim.api.nvim_create_autocmd("UIEnter", {
        once = true,
        callback = function()
          local api = require("nvim-tree.api")

          if vim.fn.argc() == 0 then
            -- No file was given: open tree and focus it
            vim.cmd("enew")
            api.tree.open()
          else
            -- File was given: open tree but keep cursor in the file
            api.tree.open()
            vim.cmd("wincmd p") -- go back to previous window (the file)
          end
        end,
      })

      -- Smart toggle for NvimTree
      vim.keymap.set('n', '<leader>e', function()
        local view = require('nvim-tree.view')
        local api = require('nvim-tree.api')

        if view.is_visible() and vim.api.nvim_get_current_win() == view.get_winnr() then
          -- You are in nvim-tree → go back to previous window (your file)
          vim.cmd("wincmd p")
        else
          -- You are in a file → focus nvim-tree (open it if needed)
          api.tree.open()
          api.tree.focus()
        end
      end, { silent = true })


      -- Auto-close NvimTree if it's the last window
      vim.api.nvim_create_autocmd("BufEnter", {
        nested = true,
        callback = function()
          local tree = require("nvim-tree.api").tree
          -- If NvimTree is the last window open, close it
          if #vim.api.nvim_list_wins() == 1 and tree.is_tree_buf() then
            vim.cmd("quit")
          end
        end,
      })


      require("nvim-tree").setup({
        on_attach = on_attach,
        view = { width = 25 },
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

  -- Bufferline
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      vim.opt.termguicolors = true
      -- Get Normal colors from your theme (works with transparency too)
      local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
      local selected = vim.api.nvim_get_hl(0, { name = "Type" })
      require("bufferline").setup{
        highlights = {
          buffer_selected = {
            fg = selected.fg,
            bg = selected.bg,
            bold = true,
            italic = false,
          },
          buffer_visible = {
            fg = normal.fg, -- active window but not focused
            bg = normal.bg,
          },
          buffer = {
            fg = normal.fg, -- inactive text (make readable)
            bg = normal.bg,
          },
          background = {
            fg = normal.fg,
            bg = normal.bg,
          },
          fill = {
            bg = normal.bg,
          },
        },
        options = {
          max_name_length = 30,
          tab_size = 25,
          show_tab_indicators = true,
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              highlight = "Directory",
              text_align = "left",
              separator = true, -- adds a nice vertical line
            }
          },
          custom_filter = function(bufnr)
            -- Hide Claude Code terminal buffers
            local bt = vim.bo[bufnr].buftype
            local ft = vim.bo[bufnr].filetype
            local name = vim.api.nvim_buf_get_name(bufnr)

            -- Hide based on filetype (best)
            if ft == "claude-code" then
              return false
            end

            -- Hide terminal buffers whose names contain "claude"
            if bt == "terminal" and name:match("claude") then
              return false
            end

            return true
          end,
        }
      }

      -- cycle tabs
      vim.keymap.set('n', '<Tab>', '<Cmd>BufferLineCycleNext<CR>')
      vim.keymap.set('n', '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>')

      -- reorder buffers
      vim.keymap.set('n', '<leader>bn', '<Cmd>BufferLineMoveNext<CR>')
      vim.keymap.set('n', '<leader>bp', '<Cmd>BufferLineMovePrev<CR>')

      -- pick tab
      vim.keymap.set('n', '<leader>p', '<Cmd>BufferLinePick<CR>')

      -- open and close tabs
      vim.keymap.set('n', '<leader>bc', '<Cmd>bdelete<CR>')
      vim.keymap.set('n', '<leader>bx', '<Cmd>BufferLinePickClose<CR>')


      vim.keymap.set('n', '<leader>T', function()
        require('telescope.builtin').find_files()
      end)

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
