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
# apt_install git-delta  # symlink to canonical names, can skip, installing separately below
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
# Binary install from GitHub releases — allows version pinning and easy upgrades.
# choosing 0.11.7 due to 0.12's upgrade causing issues with shift+number characters
# when kitty protocol was introduced, otherwise would have used snap to manage nvim. 
# Extracted to ~/.local/nvim-<version>/ with ~/.local/bin/nvim symlinked to it.
# To upgrade: change NVIM_VERSION, re-run install.sh.
NVIM_VERSION="0.11.7"   
NVIM_INSTALL_DIR="$HOME/.local/nvim-${NVIM_VERSION}"
echo "==> Installing neovim ${NVIM_VERSION}"
if [ -x "$NVIM_INSTALL_DIR/bin/nvim" ]; then
    echo "  [skip] nvim ${NVIM_VERSION} already installed at $NVIM_INSTALL_DIR"
else
    curl -Lo /tmp/nvim.tar.gz \
        "https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim-linux-x86_64.tar.gz"
    mkdir -p "$NVIM_INSTALL_DIR"
    tar -xf /tmp/nvim.tar.gz -C "$NVIM_INSTALL_DIR" --strip-components=1
    rm /tmp/nvim.tar.gz
    echo "  [ok] nvim ${NVIM_VERSION} installed to $NVIM_INSTALL_DIR"
fi
mkdir -p "$HOME/.local/bin"
ln -sf "$NVIM_INSTALL_DIR/bin/nvim" "$HOME/.local/bin/nvim"
echo "  [linked] ~/.local/bin/nvim → $NVIM_INSTALL_DIR/bin/nvim"

# ── delta (git pager) ─────────────────────────────────────────────────────────
# Not available via apt on Ubuntu 22.04 — install via .deb from GitHub releases
echo "==> Installing delta"
if installed delta; then
    echo "  [skip] delta already installed"
else
    DELTA_VERSION=$(curl -s "https://api.github.com/repos/dandavison/delta/releases/latest" |
        grep -Po '"tag_name": "\K[^"]*')
    curl -Lo /tmp/delta.deb \
        "https://github.com/dandavison/delta/releases/latest/download/git-delta_${DELTA_VERSION}_amd64.deb"
    sudo dpkg -i /tmp/delta.deb
    rm /tmp/delta.deb
fi

# ── gh (Official Github CLI) ────────────────────────────────────────────────────
# can use snap but this is recommended by Github
# add gpg key
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && sudo apt update
apt_install gh

# ── gh-dash ───────────────────────────────────────────────────────────────────
# gh-dash to use gh above via terminal app
# https://www.gh-dash.dev/getting-started/usage/
gh extension install dlvhdr/gh-dash

# ── lazygit ───────────────────────────────────────────────────────────────────
echo "==> Installing lazygit"
if installed lazygit; then
    echo "  [skip] lazygit already installed"
else
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" |
        grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo /tmp/lazygit.tar.gz \
        "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar -xf /tmp/lazygit.tar.gz -C /tmp lazygit
    install /tmp/lazygit "$HOME/.local/bin/lazygit"
    rm /tmp/lazygit.tar.gz /tmp/lazygit
fi

# ── GitHub Copilot CLI ────────────────────────────────────────────────────────
echo "==> Installing GitHub Copilot CLI"
_copilot_path="$(command -v copilot 2>/dev/null)"
if [[ -n "$_copilot_path" && "$_copilot_path" != *".vscode-server"* ]]; then
    echo "  [skip] copilot already installed ($_copilot_path)"
else
    [[ "$_copilot_path" == *".vscode-server"* ]] && echo "  [info] ignoring VS Code extension copilot, installing CLI..."
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
