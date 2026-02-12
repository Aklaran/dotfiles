-- Indent Blankline: Shows indent guides
-- Makes code structure easier to follow visually

return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("ibl").setup({
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = {
        enabled = true,
        show_start = true,
        show_end = false,
        injected_languages = false,
        highlight = { "Function", "Label" },
        priority = 500,
      },
      exclude = {
        filetypes = {
          "help",
          "lazy",
          "mason",
          "notify",
          "oil",
          "toggleterm",
        },
      },
    })
  end,
}
