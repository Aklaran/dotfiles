#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installing dotfiles with GNU Stow..."

# Check for stow
if ! command -v stow &>/dev/null; then
  echo "Error: GNU Stow is required. Install it first:"
  echo "  macOS: brew install stow"
  echo "  Ubuntu: sudo apt install stow"
  echo "  Arch: sudo pacman -S stow"
  exit 1
fi

cd "$DOTFILES_DIR"

# Stow each package (--restow to handle re-runs cleanly)
for pkg in nvim ghostty; do
  echo "  Stowing $pkg..."
  stow --restow --target="$HOME" "$pkg"
done

# Merge zsh snippets into existing .zshrc (append if not already present)
MARKER="# --- dotfiles/zsh ---"
if ! grep -qF "$MARKER" "$HOME/.zshrc" 2>/dev/null; then
  echo "  Appending zsh snippets to ~/.zshrc..."
  printf '\n%s\n' "$MARKER" >> "$HOME/.zshrc"
  cat "$DOTFILES_DIR/zsh/zshrc.snippet" >> "$HOME/.zshrc"
else
  echo "  zsh snippets already in ~/.zshrc, skipping."
fi

echo ""
echo "Done! Restart your terminal/editor to pick up changes."
