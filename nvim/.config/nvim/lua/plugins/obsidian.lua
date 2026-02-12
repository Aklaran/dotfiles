-- Obsidian.nvim: Wikilink navigation and note-taking for Sanctuary
-- Follow [[wikilinks]] with gf, find backlinks, autocomplete links

return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "sanctuary",
        path = "~/sanctuary",
      },
    },
    
    -- Disable UI features to keep markdown syntax visible
    ui = {
      enable = false,
    },
    
    -- Use Telescope for pickers
    picker = {
      name = "telescope.nvim",
    },
    
    -- Don't manage frontmatter
    disable_frontmatter = true,
    
    -- Note ID generation (if creating notes via obsidian.nvim)
    note_id_func = function(title)
      -- Just use the title as-is, preserving spaces
      return title
    end,
    
    -- Templates directory (if you want to use templates later)
    templates = {
      subdir = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
    },
  },
  
  config = function(_, opts)
    require("obsidian").setup(opts)
    
    -- Keymaps for Sanctuary navigation
    vim.keymap.set("n", "gf", function()
      if require("obsidian").util.cursor_on_markdown_link() then
        return "<cmd>ObsidianFollowLink<CR>"
      else
        return "gf"
      end
    end, { noremap = false, expr = true, desc = "Follow wikilink or file" })
    
    vim.keymap.set("n", "<leader>os", "<cmd>ObsidianSearch<CR>", { desc = "Search Sanctuary" })
    vim.keymap.set("n", "<leader>oq", "<cmd>ObsidianQuickSwitch<CR>", { desc = "Quick switch notes" })
    vim.keymap.set("n", "<leader>ob", "<cmd>ObsidianBacklinks<CR>", { desc = "Show backlinks" })
    vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<CR>", { desc = "New note" })
    vim.keymap.set("n", "<leader>ot", "<cmd>ObsidianToday<CR>", { desc = "Today's note" })
  end,
}
