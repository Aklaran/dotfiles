-- Core Neovim Options
-- Focused on readability and comfortable editing

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs & Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Line wrapping
opt.wrap = false

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Behavior
opt.splitright = true
opt.splitbelow = true
opt.hidden = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"

-- Use OSC 52 for clipboard over SSH (terminal handles local clipboard)
vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
    ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
  },
}
opt.undofile = true
opt.updatetime = 250
opt.timeoutlen = 300

-- Reduce noise
opt.swapfile = false
opt.backup = false
opt.showmode = false

-- Better completion
opt.completeopt = "menuone,noselect"

-- Leader key (space)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Filetype-specific settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true       -- Wrap at word boundaries, not mid-word
    vim.opt_local.breakindent = true     -- Indent wrapped lines to match
    vim.opt_local.conceallevel = 2       -- Hide markup syntax for rendered view
  end,
})
