#!/usr/bin/env bash
# install.sh — install tools on a fresh Ubuntu/Debian machine
# Usage: bash install.sh
# Idempotent: checks before installing. Requires sudo for apt/snap.
# Run AFTER setting up ~/.bashrc.local with proxy env vars.

set -euo pipefail

# ── Proxy check ────────────────────────────────────────────────────────────────
if [ -z "${http_proxy:-}" ]; then
  echo "[warn] http_proxy is not set. Network installs may fail on corporate machines."
  echo "       Create ~/.bashrc.local with your proxy and re-source before running."
  echo "       Continuing anyway..."
  echo ""
fi

# ── Helpers ────────────────────────────────────────────────────────────────────
installed() { command -v "$1" &>/dev/null; }

apt_install() {
  for pkg in "$@"; do
    if dpkg -s "$pkg" &>/dev/null 2>&1; then
      echo "  [skip] $pkg already installed"
    else
      echo "  [apt] installing $pkg"
      sudo apt-get install -y "$pkg"
    fi
  done
}

# ── apt packages ───────────────────────────────────────────────────────────────
echo "==> Updating apt"
sudo apt-get update -q || echo "  [warn] apt-get update had errors (likely broken upstream repo — continuing)"

echo "==> Installing apt packages"
apt_install zsh
apt_install tmux
apt_install \
  zoxide \
  fzf \
  fd-find \
  bat \
  ripgrep \
  duf \
  tldr \
  tree
apt_install btop htop
apt_install delta — symlink to canonical names
# so tools like fzf previews and scripts can use 'fd' and 'bat'
if ! installed fd && installed fdfind; then
  ln -sf "$(which fdfind)" "$HOME/.local/bin/fd"
  echo "  [linked] fd → fdfind"
fi
if ! installed bat && installed batcat; then
  ln -sf "$(which batcat)" "$HOME/.local/bin/bat"
  echo "  [linked] bat → batcat"
fi

# ── snap packages ──────────────────────────────────────────────────────────────
echo "==> Installing snap packages"
if ! snap list yazi &>/dev/null 2>&1; then
  sudo snap install yazi --classic
else
  echo "  [skip] yazi already installed"
fi

# ── uv ────────────────────────────────────────────────────────────────────────
echo "==> Installing uv"
if installed uv; then
  echo "  [skip] uv already installed"
else
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# ── neovim ────────────────────────────────────────────────────────────────────
# snap gets a newer version than apt on Ubuntu 22.04
echo "==> Installing neovim"
if installed nvim; then
  echo "  [skip] nvim already installed"
else
  sudo snap install nvim --classic
fi

# ── delta (git pager) ─────────────────────────────────────────────────────────
# Not available via apt on Ubuntu 22.04 — install via .deb from GitHub releases
echo "==> Installing delta"
if installed delta; then
  echo "  [skip] delta already installed"
else
  DELTA_VERSION=$(curl -s "https://api.github.com/repos/dandavison/delta/releases/latest" \
    | grep -Po '"tag_name": "\K[^"]*')
  curl -Lo /tmp/delta.deb \
    "https://github.com/dandavison/delta/releases/latest/download/git-delta_${DELTA_VERSION}_amd64.deb"
  sudo dpkg -i /tmp/delta.deb
  rm /tmp/delta.deb
fi

# ── lazygit ───────────────────────────────────────────────────────────────────
echo "==> Installing lazygit"
if installed lazygit; then
  echo "  [skip] lazygit already installed"
else
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" \
    | grep -Po '"tag_name": "v\K[^"]*')
  curl -Lo /tmp/lazygit.tar.gz \
    "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar -xf /tmp/lazygit.tar.gz -C /tmp lazygit
  install /tmp/lazygit "$HOME/.local/bin/lazygit"
  rm /tmp/lazygit.tar.gz /tmp/lazygit
fi

# ── GitHub Copilot CLI ────────────────────────────────────────────────────────
echo "==> Installing GitHub Copilot CLI"
if installed copilot; then
  echo "  [skip] copilot already installed"
else
  if curl -fsSL https://gh.io/copilot-install | bash; then
    echo "  [ok] copilot installed"
  else
    echo "  [fallback] trying npm install..."
    npm install -g @github/copilot
  fi
fi

# ── oh-my-zsh + plugins ────────────────────────────────────────────────────────
echo "==> Installing oh-my-zsh"
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "  [skip] oh-my-zsh already installed"
else
  # CHSH=no: don't try to change login shell (fails on Azure ML)
  # RUNZSH=no: don't switch to zsh mid-script
  CHSH=no RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo "==> Installing zsh plugins and theme"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    "$ZSH_CUSTOM/themes/powerlevel10k"
else
  echo "  [skip] powerlevel10k already installed"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
  echo "  [skip] zsh-syntax-highlighting already installed"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
  echo "  [skip] zsh-autosuggestions already installed"
fi

echo ""
echo "==> Done."
echo ""
echo "Next steps:"
echo "  1. Run setup.sh to symlink dotfiles (if not done yet)"
echo "  2. Start zsh: exec zsh"
echo "  3. Run 'p10k configure' if you want to customise your prompt"
