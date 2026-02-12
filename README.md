# dotfiles

Personal configuration files, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## What's Inside

| Package | What | Key choices |
|---------|------|-------------|
| `nvim` | Neovim config | Lazy.nvim, Kanagawa theme, Telescope, LSP, Treesitter, Oil |
| `ghostty` | Ghostty terminal | Iosevka Nerd Font Mono |

## Install

1. Clone the repo:
   ```bash
   git clone https://github.com/Aklaran/dotfiles ~/.dotfiles
   cd ~/.dotfiles
   ```

2. Install [GNU Stow](https://www.gnu.org/software/stow/) if you don't have it.

3. Install a [Nerd Font](https://www.nerdfonts.com/) (I use Iosevka Nerd Font Mono).

4. Run the install script:
   ```bash
   ./install.sh
   ```

   Or stow individual packages:
   ```bash
   stow nvim        # just neovim
   stow ghostty     # just ghostty
   ```

## Neovim Plugins

Managed with [lazy.nvim](https://github.com/folke/lazy.nvim). Plugins install automatically on first launch.

**Navigation:** Telescope (fuzzy finder), Oil (file explorer), Which-Key (keymap hints)
**Editing:** LSP + completion, Treesitter (syntax), Autopairs, Surround, Comment
**Git:** Gitsigns (hunk nav, inline blame, staging)
**UI:** Kanagawa colorscheme, Lualine, indent guides, smooth scrolling, notifications
**Notes:** Obsidian.nvim (Sanctuary/wiki navigation), render-markdown.nvim

## Key Bindings

Leader is `<Space>`.

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>/` | Search in project (grep) |
| `<leader><leader>` | Find files (alt) |
| `<leader>e` | File explorer (Oil float) |
| `-` | Open parent directory (Oil) |
| `<leader>d` | Show diagnostic |
| `<leader>w` | Save |
| `<leader>q` | Quit |
| `gd` | Go to definition |
| `gr` | Find references |
| `K` | Hover docs |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `]h` / `[h` | Next/prev git hunk |
| `<leader>cl` | Copy chat reference |
