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

echo ""
echo "Done! Restart your terminal/editor to pick up changes."
