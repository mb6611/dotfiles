-- Editor options (converted from settings.vim)

local opt = vim.opt

-- Backup settings
opt.backup = false
opt.writebackup = false
opt.swapfile = false

-- Performance
opt.ttyfast = true
opt.lazyredraw = true
opt.updatetime = 100

-- Scrolling and display
opt.scrolloff = 5
opt.matchpairs:append("<:>")

-- Auto-reload
opt.autoread = true

-- Line numbers
opt.number = true
opt.relativenumber = true
opt.ruler = true
opt.showmatch = true

-- Encoding
opt.encoding = "utf-8"

-- Invisibles
opt.list = false

-- Search
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Indentation
opt.shiftwidth = 4
opt.tabstop = 4
opt.smartindent = true
opt.expandtab = true

-- Line wrapping
opt.textwidth = 0
opt.wrap = true
opt.linebreak = true

-- Folding
opt.foldmethod = "manual"
opt.foldlevelstart = 5
opt.foldenable = false

-- Mouse
opt.mouse = "a"

-- UI
opt.cmdheight = 1
opt.signcolumn = "yes"
opt.showmode = false
opt.showcmd = false
opt.shortmess:append("F")
opt.laststatus = 0
opt.fillchars = { fold = " ", vert = "│", eob = " ", msgsep = "‾" }

-- Splits
opt.splitbelow = true
opt.splitright = true

-- Filetype
vim.cmd("filetype plugin indent on")

-- Conceal
opt.conceallevel = 0

-- Timeout
opt.timeoutlen = 500

-- True colors
opt.termguicolors = true

-- Background
opt.background = "dark"