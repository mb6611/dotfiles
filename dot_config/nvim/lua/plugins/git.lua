-- Git plugins
return {
  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "┃" },
          change = { text = "┃" },
          delete = { text = "╏" },
          topdelete = { text = "╏" },
          changedelete = { text = "┃" },
        },
        signcolumn = true,
        numhl = false,
        linehl = true,
        watch_gitdir = {
          enable = true,
          interval = 1000,
          follow_files = true,
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local map = function(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
          end

          -- Navigation
          map("n", "<leader>hn", gs.next_hunk, "Next hunk")
          map("n", "<leader>hN", gs.prev_hunk, "Previous hunk")

          -- Actions
          map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
          map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
          map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage hunk")
          map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Reset hunk")
          map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
          map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
          map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
          map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
          map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
          map("n", "<leader>hd", gs.diffthis, "Diff this")
        end,
      })
    end,
  },

  -- Fugitive
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gstatus", "Gblame", "Gpush", "Gpull" },
  },

  -- Unified inline diffs (shows diffs directly in buffer)
  {
    "axkirillov/unified.nvim",
    lazy = false,
    keys = {
      { "<leader>dv", "<cmd>Unified<cr>", desc = "Toggle unified diff view" },
      { "<leader>du", "<cmd>Unified<cr>", desc = "Toggle unified diff view" },
    },
    config = function()
      require("unified").setup({
        -- Display settings
        default_keymaps = true,

        -- Sign configuration
        signs = {
          add = "▎",
          change = "▎",
          delete = "▎",
        },

        -- Highlight configuration
        highlights = {
          add = "UnifiedAdded",
          change = "UnifiedChanged",
          delete = "UnifiedDeleted",
        },
      })

      -- Hunk navigation keybindings
      local nav = require("unified.navigation")
      vim.keymap.set("n", "<leader>hn", nav.next_hunk, { desc = "Next hunk" })
      vim.keymap.set("n", "<leader>hN", nav.previous_hunk, { desc = "Previous hunk" })

      -- Setup highlighting for added/deleted lines
      local set_hl = vim.api.nvim_set_hl
      set_hl(0, "UnifiedAdded", { bg = "#1a3a1a", fg = "#90ee90" })
      set_hl(0, "UnifiedDeleted", { bg = "#3a1a1a", fg = "#ff6b6b" })
      set_hl(0, "UnifiedChanged", { bg = "#2a2a1a", fg = "#ffeb3b" })
    end,
  },

  -- Inline deleted lines (shows deleted git lines as virtual text)
  {
    -- dir = "~/Desktop/code/inline-deleted.nvim",
    "mb6611/inline-deleted.nvim",
    dependencies = { "lewis6991/gitsigns.nvim" },
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
    keys = {
      { "<leader>gi", function() require("inline-deleted").toggle() end, desc = "Toggle inline deleted" },
      { "<leader>ge", function() require("inline-deleted").expand() end, desc = "Expand deleted hunk" },
    },
  },
}
