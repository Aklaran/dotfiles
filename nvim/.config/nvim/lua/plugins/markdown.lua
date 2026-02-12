-- Markdown rendering in the terminal
-- Renders headings, code blocks, tables, lists, etc. inline
-- Toggle with <leader>mr

return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  ft = { "markdown" },
  opts = {
    -- Render in normal mode and command mode, clear in insert
    render_modes = { "n", "c" },
    -- Heading styles
    heading = {
      enabled = true,
      sign = false, -- Don't clutter the sign column
      icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " },
    },
    -- Code blocks
    code = {
      enabled = true,
      sign = false,
      style = "full", -- Show language label + background
      width = "block",
      min_width = 60,
    },
    -- Bullet points
    bullet = {
      enabled = true,
      icons = { "●", "○", "◆", "◇" },
    },
    -- Checkboxes
    checkbox = {
      enabled = true,
    },
    -- Tables
    pipe_table = {
      enabled = true,
      style = "full",
    },
    -- Horizontal rules
    dash = {
      enabled = true,
    },
  },
  keys = {
    {
      "<leader>mr",
      function()
        require("render-markdown").toggle()
      end,
      desc = "Toggle Markdown Render",
    },
  },
}
