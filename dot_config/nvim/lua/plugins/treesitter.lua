-- Treesitter
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    -- Treesitter should NOT be lazy-loaded on events
    -- so it's loaded immediately at startup for correct highlighting.
    event = "VeryLazy",

    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },

    opts = {
      -- Parsers to install
      ensure_installed = {
        "c",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "python",
        "javascript",
        "typescript",
        "tsx",
        "html",
        "css",
        "json",
        "markdown",
        "markdown_inline",
        "bash",
        "latex",
        "dockerfile",
      },

      sync_install = false,

      -- Auto-install missing parsers (safe without tree-sitter CLI)
      auto_install = true,

      -- Advanced: ignore certain parsers
      ignore_install = {},

      highlight = {
        enable = true,

        -- Disable highlight dynamically for large files only
        disable = function(lang, buf)
          local max_filesize = 150 * 1024 -- 150 KB (safer default)
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,

        additional_vim_regex_highlighting = false,
      },

      indent = { enable = true },
    },

    config = function(_, opts)
      -- OPTIONAL: Better Dockerfile parser (uncomment to fix Dockerfile crashes)
      -- local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      -- parser_config.dockerfile = {
      --   install_info = {
      --     url = "https://github.com/camdencheek/tree-sitter-dockerfile",
      --     files = { "src/parser.c" },
      --     branch = "main",
      --   },
      --   filetype = "dockerfile",
      -- }
      --
      -- require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- JSX/TSX commenting support
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    opts = { enable_autocmd = false },
  },
}
