vim.g.mapleader = " "
-- Customize highlight for Git conflict markers
vim.cmd [[
  highlight DiffAdd    ctermfg=Green  ctermbg=NONE guifg=#00FF00 guibg=NONE
  highlight DiffChange ctermfg=Yellow ctermbg=NONE guifg=#FFFF00 guibg=NONE
  highlight DiffDelete ctermfg=Red    ctermbg=NONE guifg=#FF0000 guibg=NONE
  highlight DiffText   ctermfg=White  ctermbg=DarkRed guifg=#FFFFFF guibg=#5C0000
]]

--vim.opt.runtimepath:append("~/.config/nvim/plugged") deps:
require('img-clip').setup ({
  -- use recommended settings from above
  {
    -- support for image pasting
    embed_image_as_base64 = false,
    prompt_for_file_name = false,
    drag_and_drop = {
      insert_mode = true,
    },
    -- required for Windows users
    use_absolute_path = true,
  },
})
--require('copilot').setup ({
--  -- use recommended settings from above
--})
require('render-markdown').setup ({
  -- use recommended settings from above
  file_types = { "markdown", "Avante" },
})
--require('avante_lib').load()
--print(vim.inspect(package.loaded['avante_lib']))  -- Shows if avante_lib is loaded
require('avante_lib').load()
require('avante').setup ({
  ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
  providers = {
    openai = {
      model = "gpt-4o",
      --api_key_name = vim.fn.system("security find-generic-password -s 'avante.nvim' -a '' -w"),
      api_key_name = {"security", "find-generic-password", "-s", "avante.nvim", "-a", "", "-w"},
      --api_key_name = "OPENAI_API_KEY",
      --temperature = 0,
      max_tokens = 4096,
    },
  },
  auto_suggestions_provider = "copilot", -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
  rag_service = {
    enabled = false, -- Enables the RAG service
    host_mount = os.getenv("HOME"), -- Host mount path for the rag service
    provider = "openai", -- The provider to use for RAG service (e.g. openai or ollama)
    llm_model = "", -- The LLM model to use for RAG service
    embed_model = "", -- The embedding model to use for RAG service
    endpoint = "https://api.openai.com/v1", -- The API endpoint for RAG service
  },
  behaviour = {
    auto_suggestions = true, -- Experimental stage
    auto_set_highlight_group = true,
    auto_set_keymaps = true,
    auto_apply_diff_after_generation = false,
    support_paste_from_clipboard = false,
  },
  mappings = {
    --- @class AvanteConflictMappings
    diff = {
      ours = "co",
      theirs = "ct",
      all_theirs = "ca",
      both = "cb",
      cursor = "cc",
      next = "]x",
      prev = "[x",
    },
    suggestion = {
      accept = "<M-l>",
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
    jump = {
      next = "]]",
      prev = "[[",
    },
    submit = {
      normal = "<CR>",
      insert = "<C-s>",
    },
    sidebar = {
      apply_all = "A",
      apply_cursor = "a",
      switch_windows = "<Tab>",
      reverse_switch_windows = "<S-Tab>",
    },
  },
  hints = { enabled = true },
  windows = {
    ---@type "right" | "left" | "top" | "bottom"
    position = "right", -- the position of the sidebar
    wrap = true, -- similar to vim.o.wrap
    width = 30, -- default % based on available width
    sidebar_header = {
      enabled = true, -- true, false to enable/disable the header
      align = "center", -- left, center, right for title
      rounded = true,
    },
    input = {
      prefix = "> ",
    },
    edit = {
      border = "rounded",
      start_insert = true, -- Start insert mode when opening the edit window
    },
    ask = {
      floating = false, -- Open the 'AvanteAsk' prompt in a floating window
      start_insert = true, -- Start insert mode when opening the ask window, only effective if floating = true.
      border = "rounded",
      ---@type "ours" | "theirs"
      focus_on_apply = "ours", -- which diff to focus after applying
    },
  },
  highlights = {
    ---@type AvanteConflictHighlights
    diff = {
      current = "DiffText",
      incoming = "DiffAdd",
    },
  },
  --- @class AvanteConflictUserConfig
  diff = {
    autojump = true,
    ---@type string | fun(): any
    list_opener = "copen",
    --- Override the 'timeoutlen' setting while hovering over a diff (see :help timeoutlen).
    --- Helps to avoid entering operator-pending mode with diff mappings starting with `c`.
    --- Disable by setting to -1.
    override_timeoutlen = 500,
  },
})
