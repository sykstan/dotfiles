# Architecture: dotfiles
**Last updated:** 2026-04-25

## Repo structure

```
dotfiles/
├── bunnings/              # Work machine setup (Bunnings)
│   ├── install.sh         # Install all tools — run first on a fresh machine
│   ├── setup.sh           # Symlink dotfiles to ~ — run after install.sh
│   ├── install-nerd-fonts.ps1  # Windows: install fonts for terminal
│   └── linux/             # Dotfiles symlinked by setup.sh
│       ├── .zshrc, .bashrc, .bash_aliases, .gitconfig, .tmux.conf, .p10k.zsh
│       ├── .Renviron
│       ├── lazygit/config.yml
│       ├── nvim/          # Neovim config (LazyVim-based)
│       └── clone_all_repos.sh  # Clone work repos idempotently
├── autohotkey/            # Windows AutoHotkey scripts
├── work/                  # Legacy bash configs (reference only)
├── vimrc.vim              # Vim config (symlinked to ~/.vimrc)
└── docs/                  # This folder
```

## Bootstrap sequence (fresh machine)

1. Clone this repo
2. `bash bunnings/install.sh` — installs all binaries and packages
3. `bash bunnings/setup.sh` — symlinks dotfiles to `~`
4. `exec zsh` — switch to configured shell
5. Open `nvim` — LazyVim plugins install on first launch (or headless step in install.sh handles it if setup.sh was run first)

## Neovim / LazyVim

Config lives in `bunnings/linux/nvim/`. `setup.sh` symlinks this to `~/.config/nvim`.
`lazy.nvim` bootstraps itself from `lua/config/lazy.lua` on first launch.
`install.sh` runs `nvim --headless "+Lazy! sync" +qa` to pre-install plugins.

## Two-context design

Work and personal configs are kept separate. `bunnings/` is the work subtree.
The repo root contains personal-only files (`vimrc.vim`, `autohotkey/`).
Don't merge work tooling into the root level.
