-- which-key.nvim — popup menu of keybindings under any prefix
return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern", -- rounded floating box with icons
      delay = 300, -- ms to wait before the popup appears
      -- Scroll the popup with arrow keys (j/k stay free for your other bindings)
      keys = {
        scroll_down = "<Down>",
        scroll_up = "<Up>",
      },
      -- Group labels so prefixes show a friendly name instead of raw keys
      spec = {
        { "<leader>o", group = "obsidian" },
        { "<leader>a", group = "claude" },
        { "<leader>f", group = "find / format / fold" },
        { "<leader>g", group = "git" },
        { "<leader>h", group = "git hunks" },
        { "<leader>b", group = "buffers" },
        { "<leader>r", group = "lsp" },
        { "<leader>t", group = "toggles" },
        { "<leader><leader>", group = "misc" },
      },
    },
    -- <leader>? is intentionally left free for the snacks keymap picker
    -- (plugins/snacks.lua); pausing after <leader> already shows which-key hints.
  },
}
