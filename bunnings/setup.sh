#!/usr/bin/env bash
# setup.sh — symlink dotfiles to ~, backing up any real files first
# Usage: bash setup.sh
# Idempotent: safe to re-run. Only backs up real files (not existing symlinks).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR/linux"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
HOME_CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%dT%H%M%S)"

backup_and_link() {
    local src="$1"
    local dst="$2"

    # If dst is already a symlink pointing to src, nothing to do
    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
        echo "  [skip] $dst already linked"
        return
    fi

    # If a real file or directory exists (not a symlink), back it up
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        mkdir -p "$BACKUP_DIR"
        echo "  [backup] $dst → $BACKUP_DIR/$(basename "$dst")"
        mv "$dst" "$BACKUP_DIR/$(basename "$dst")"
    fi

    # Remove any stale symlink
    [ -L "$dst" ] && rm "$dst"

    ln -s "$src" "$dst"
    echo "  [linked] $dst → $src"
}

echo "==> Symlinking dotfiles from $DOTFILES_DIR"
backup_and_link "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
backup_and_link "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
backup_and_link "$DOTFILES_DIR/.bash_aliases" "$HOME/.bash_aliases"
backup_and_link "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
backup_and_link "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
backup_and_link "$DOTFILES_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
backup_and_link "$DOTFILES_DIR/lazygit/config.yml" "$HOME_CONFIG_DIR/lazygit/config.yml"
backup_and_link "$DOTFILES_DIR/.Renviron" "$HOME/.Renviron"
backup_and_link "$REPO_ROOT/vimrc.vim" "$HOME/.vimrc"

# neovim config — symlink the whole directory
mkdir -p "$HOME/.config"
backup_and_link "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

# Remind about .bashrc.local (machine-specific, not tracked)
if [ ! -f "$HOME/.bashrc.local" ]; then
    echo ""
    echo "  [reminder] ~/.bashrc.local does not exist."
    echo "             Create it with machine-specific env vars, e.g.:"
    echo "             export http_proxy='http://proxy.example.com:80'"
    echo "             export https_proxy='http://proxy.example.com:80'"
    echo "             conda activate azureml_py38"
fi

echo ""
echo "==> Done. $([ -d "$BACKUP_DIR" ] && echo "Backups saved to $BACKUP_DIR" || echo "No files needed backing up.")"
