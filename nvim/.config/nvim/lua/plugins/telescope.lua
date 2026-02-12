-- Telescope: Fuzzy finder for files, text, and more
-- The Swiss Army knife of navigation

return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        prompt_prefix = "   ",
        selection_caret = "  ",
        path_display = { "smart" },
        file_ignore_patterns = { ".git/", "node_modules/", "%.lock" },
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<Esc>"] = actions.close,
          },
          n = {
            ["q"] = actions.close,
          },
        },
        layout_config = {
          horizontal = {
            preview_width = 0.55,
            results_width = 0.8,
          },
          vertical = {
            mirror = false,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
        live_grep = {
          additional_args = function()
            return { "--hidden" }
          end,
        },
      },
    })

    -- Load fzf extension for better performance
    pcall(telescope.load_extension, "fzf")

    -- Keymaps
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Find text (grep)" })
    vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find help" })
    vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Find recent files" })
    vim.keymap.set("n", "<leader>fc", builtin.current_buffer_fuzzy_find, { desc = "Find in current buffer" })
    vim.keymap.set("n", "<leader>fs", builtin.grep_string, { desc = "Find string under cursor" })
    vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Find keymaps" })
    vim.keymap.set("n", "<leader><leader>", builtin.find_files, { desc = "Find files" })
    vim.keymap.set("n", "<leader>/", builtin.live_grep, { desc = "Search in project" })
  end,
}
