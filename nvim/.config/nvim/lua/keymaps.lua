-- Core Keymaps
-- Plugin-specific keymaps are defined with their plugins

local map = vim.keymap.set

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Resize windows with arrows
map("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Buffer navigation
map("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })

-- Clear search highlight
map("n", "<Esc>", ":nohlsearch<CR>", { desc = "Clear search highlight" })

-- Better indenting (stay in visual mode)
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Move lines up/down
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep cursor centered when scrolling
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })

-- Keep cursor centered when searching
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

-- Quick save
map("n", "<leader>w", ":w<CR>", { desc = "Save file" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit" })
map("n", "<leader>Q", ":qa!<CR>", { desc = "Force quit all" })

-- Chat Reference Helper
-- Copies current file:line + content to clipboard for pasting into Annapurna chat
-- Single line in normal mode, selection in visual mode
--
-- Writes to + register (system clipboard) AND ~/.chat_ref as fallback.
-- On headless/SSH, your terminal emulator handles clipboard via OSC 52.

local function copy_to_clipboard(text)
  vim.fn.setreg("+", text)
  -- Fallback: write to file so it's always retrievable
  local f = io.open(os.getenv("HOME") .. "/.chat_ref", "w")
  if f then
    f:write(text)
    f:close()
  end
end

local function chat_ref()
  local file = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
  local line = vim.fn.line(".")
  local content = vim.fn.getline(".")
  local ref = string.format("// %s:%d\n%s", file, line, content)
  copy_to_clipboard(ref)
  vim.notify(string.format("Copied ref: %s:%d", file, line), vim.log.levels.INFO)
end

local function chat_ref_visual()
  local file = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
  -- Need to escape visual mode first to set '< and '> marks
  vim.cmd("normal! \\<Esc>")
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  local lines = vim.fn.getline(start_line, end_line)
  local content = table.concat(lines, "\n")
  local ref = string.format("// %s:%d-%d\n%s", file, start_line, end_line, content)
  copy_to_clipboard(ref)
  vim.notify(string.format("Copied ref: %s:%d-%d", file, start_line, end_line), vim.log.levels.INFO)
end

map("n", "<leader>cl", chat_ref, { desc = "Copy chat reference (line)" })
map("v", "<leader>cl", chat_ref_visual, { desc = "Copy chat reference (selection)" })
