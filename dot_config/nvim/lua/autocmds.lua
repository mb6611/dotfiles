-- Autocommands (converted from autocmds.vim)

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Jump to previous position when opening a file
augroup("RestoreCursor", { clear = true })
autocmd("BufReadPost", {
  group = "RestoreCursor",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})


-- Auto-reload file when it changes externally
augroup("AutoReload", { clear = true })
autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = "AutoReload",
  command = "checktime",
})

-- Toggle relative line numbers based on focus/mode
augroup("NumberToggle", { clear = true })
autocmd({ "BufEnter", "FocusGained", "InsertLeave" }, {
  group = "NumberToggle",
  callback = function()
    if vim.wo.number then
      vim.wo.relativenumber = true
    end
  end,
})
autocmd({ "BufLeave", "FocusLost", "InsertEnter" }, {
  group = "NumberToggle",
  callback = function()
    vim.wo.relativenumber = false
  end,
})

-- Persistent folds
augroup("AutoSaveFolds", { clear = true })
autocmd("BufWinLeave", {
  group = "AutoSaveFolds",
  pattern = "*",
  command = "silent! mkview",
})
autocmd("BufWinEnter", {
  group = "AutoSaveFolds",
  pattern = "*",
  command = "silent! loadview",
})


-- Format Prisma files on save
augroup("PrismaFormat", { clear = true })
autocmd("BufWritePre", {
  group = "PrismaFormat",
  pattern = "*.prisma",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- Restore cursor on VimLeave
autocmd("VimLeave", {
  callback = function()
    vim.opt.guicursor = "a:ver25-blinkwait700-blinkon400-blinkoff250-Cursor/lCursor"
  end,
})

-- Clear search highlights on startup
vim.cmd("nohlsearch")

-- Detect Helm templates (YAML files with Go template syntax)
vim.filetype.add({
  pattern = {
    [".*/templates/.*%.yaml"] = "helm",
    [".*/templates/.*%.tpl"] = "helm",
    ["helmfile.*%.yaml"] = "helm",
  },
})

-- Open PDFs in Sioyek instead of loading them as a garbage binary buffer.
-- BufReadCmd intercepts the read itself, so nvim never slurps the binary; we launch
-- Sioyek (detached, on PATH at /opt/homebrew/bin/sioyek) and then either:
--   * quit nvim, if it was started purely to open this pdf (`nvim file.pdf`), or
--   * drop the pdf buffer and return to the previous one, if opened mid-session
--     (:e, telescope, nvim-tree) — so no empty [No Name] is left behind.
augroup("PdfToSioyek", { clear = true })
autocmd("BufReadCmd", {
  group = "PdfToSioyek",
  pattern = { "*.pdf", "*.PDF" },
  callback = function(ev)
    local path = vim.fn.fnamemodify(ev.file, ":p")
    -- Capture now, before VimEnter flips vim_did_enter to 1.
    local launched_for_pdf = vim.v.vim_did_enter == 0 and vim.fn.argc() <= 1
    vim.fn.jobstart({ "sioyek", path }, { detach = true })
    vim.schedule(function()
      if launched_for_pdf then
        vim.cmd("qa!") -- shell `nvim file.pdf`: hand off to Sioyek, don't linger
      else
        if vim.api.nvim_buf_is_valid(ev.buf) then
          pcall(vim.api.nvim_buf_delete, ev.buf, { force = true })
        end
        vim.notify("Opened in Sioyek: " .. vim.fn.fnamemodify(path, ":t"))
      end
    end)
  end,
})

-- Highlight on yank
augroup("HighlightYank", { clear = true })
autocmd("TextYankPost", {
  group = "HighlightYank",
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})
