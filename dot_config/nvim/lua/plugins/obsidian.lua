-- Obsidian.nvim
return {
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    -- Commands also lazy-load the plugin if typed manually outside a note
    cmd = {
      "ObsidianNew",
      "ObsidianQuickSwitch",
      "ObsidianSearch",
      "ObsidianToday",
      "ObsidianYesterday",
      "ObsidianDailies",
      "ObsidianFollowLink",
      "ObsidianBacklinks",
      "ObsidianLinks",
      "ObsidianTags",
      "ObsidianRename",
      "ObsidianOpen",
      "ObsidianExtractNote",
      "ObsidianPasteImg",
    },
    -- <leader>o namespace (loads the plugin on first keypress, works from anywhere)
    keys = {
      { "<leader>oo", "<cmd>ObsidianQuickSwitch<cr>", desc = "Obsidian: quick switch" },
      { "<leader>of", "<cmd>ObsidianFollowLink<cr>", desc = "Obsidian: follow link under cursor" },
      { "<leader>on", ":ObsidianNew ", desc = "Obsidian: new note", silent = false },
      { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Obsidian: search note contents" },
      { "<leader>ot", "<cmd>ObsidianToday<cr>", desc = "Obsidian: today's daily" },
      { "<leader>oy", "<cmd>ObsidianYesterday<cr>", desc = "Obsidian: yesterday's daily" },
      { "<leader>od", "<cmd>ObsidianDailies<cr>", desc = "Obsidian: daily notes picker" },
      { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Obsidian: backlinks" },
      { "<leader>ol", "<cmd>ObsidianLinks<cr>", desc = "Obsidian: links in note" },
      { "<leader>oT", "<cmd>ObsidianTags<cr>", desc = "Obsidian: tags" },
      { "<leader>or", "<cmd>ObsidianRename<cr>", desc = "Obsidian: rename + update links" },
      { "<leader>og", "<cmd>ObsidianOpen<cr>", desc = "Obsidian: open in app" },
      { "<leader>ox", "<cmd>ObsidianExtractNote<cr>", mode = "v", desc = "Obsidian: extract selection to note" },
      { "<leader>op", "<cmd>ObsidianPasteImg<cr>", desc = "Obsidian: paste image" },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      workspaces = {
        {
          name = "notes",
          path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/matt-vault",
        },
      },
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },
      mappings = {
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        -- <CR>: follow link if on one, else toggle the checkbox (Obsidian-app-like)
        ["<cr>"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        },
        ["<leader>ch"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
      },
      -- Disabled: render-markdown.nvim owns in-buffer rendering.
      -- Running both obsidian's UI and render-markdown conflicts (both conceal/decorate).
      ui = { enable = false },
    },
  },
}
