-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Search Neovim's current working directory instead of the active buffer's
-- dynamically detected project root. Hidden files are first-class workspace
-- files here (for example, .source.yaml and .agents/*), so include them too.
vim.keymap.set(
  "n",
  "<leader><leader>",
  LazyVim.pick("files", { root = false, hidden = true }),
  { desc = "Find Files (cwd, including hidden)" }
)
