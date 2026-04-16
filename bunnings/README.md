# Bunnings Linux Dotfiles

## Quick Start

On a fresh machine, run these in order:

```bash
# 1. Clone the repo (git must be installed)
git clone https://github.com/sykstan/dotfiles.git ~/localfiles/dotfiles

# 2. Create your machine-specific config (not tracked in repo)
cat > ~/.bashrc.local <<'EOF'
export http_proxy="http://proxy.example.com:80"
export https_proxy="http://proxy.example.com:80"
conda activate azureml_py38   # or whatever env is relevant
EOF

# 3. Install tools (takes a few minutes)
bash ~/localfiles/dotfiles/bunnings/install.sh

# 4. Symlink dotfiles
bash ~/localfiles/dotfiles/bunnings/setup.sh

# 5. Start zsh
exec zsh
```

After `exec zsh`, if the prompt looks broken (missing icons), your terminal font likely doesn't support Nerd Fonts. Run `p10k configure` to re-run the prompt wizard.

---

## What's Included

| File | Purpose |
|---|---|
| `linux/.zshrc` | zsh config — oh-my-zsh, powerlevel10k, plugins, aliases |
| `linux/.bashrc` | bash config — history, completions, sources `.bashrc.local` |
| `linux/.bash_aliases` | shared aliases (sourced by both bash and zsh) |
| `linux/.gitconfig` | git config — delta pager, user identity |
| `linux/.tmux.conf` | tmux — 256-colour terminal support |
| `linux/.p10k.zsh` | powerlevel10k prompt config |
| `linux/nvim/` | neovim config — LazyVim distro + customisations (symlinked to `~/.config/nvim`) |
| `../vimrc.vim` | legacy vim config — symlinked to `~/.vimrc` |

**Not tracked (machine-specific):**
- `~/.bashrc.local` — proxy settings, conda env activation, anything machine-specific
- `~/.ssh/` — never in version control

---

## Keeping Things in Sync

**Making a change:**
```bash
# Edit the file in the repo (symlinks mean your live config IS the repo file)
vim ~/localfiles/dotfiles/bunnings/linux/.zshrc
# Then commit and push
cd ~/localfiles/dotfiles && git add -A && git commit -m "..." && git push
```

**On another machine:**
```bash
cd ~/localfiles/dotfiles && git pull
# Symlinks already point to the updated files — no re-running setup.sh needed
```

---

## Tools Reference

### Shell
- **zsh** — better interactive shell; tab completion, history, plugin ecosystem
- **oh-my-zsh** — zsh plugin/theme manager
- **powerlevel10k** — fast, informative prompt (git status, python env, execution time)
- **zsh-autosuggestions** — fish-style command suggestions from history
- **zsh-syntax-highlighting** — highlights valid/invalid commands as you type

### Navigation & File Management
- **zoxide** (`z`) — smarter `cd`; learns your most-visited dirs, jump with `z partial-name`
- **fzf** — fuzzy finder; `Ctrl+R` for history search, `Ctrl+T` for file search
- **yazi** (`y`) — terminal file manager; press `q` to quit and drop into the browsed directory
- **fd** (`fdfind`) — faster, friendlier `find`
- **tree** — directory tree view

### Viewing & Searching
- **bat** (`batcat`) — `cat` with syntax highlighting and line numbers
- **ripgrep** (`rg`) — faster `grep`, respects `.gitignore` by default
- **tldr** — practical command examples (instead of reading full man pages)

### Git
- **lazygit** — terminal UI for git; stage hunks, resolve conflicts, view history
- **delta** — side-by-side diff pager for git; replaces the default diff output

### Monitoring
- **btop** — interactive process/resource monitor (better `htop`)
- **htop** — classic process monitor
- **duf** — disk usage summary (better `df`)

### Multiplexing
- **tmux** — terminal multiplexer; multiple panes/windows in one SSH session, sessions survive disconnects

### Python
- **uv** — fast Python package and virtual environment manager
  - Preferred over conda for new projects: `uv venv && uv pip install ...`
  - conda is present on Azure ML instances but mostly unused; activate with `conda activate <env>` in `.bashrc.local` if needed

### Neovim
Config lives in `linux/nvim/`. Built on [LazyVim](https://www.lazyvim.org/) — a pre-configured distro that auto-installs all plugins on first run.

**Resources:**
- [LazyVim docs](https://www.lazyvim.org/) — official docs, keymaps, plugin list
- [LazyVim keymaps cheatsheet](https://www.lazyvim.org/keymaps) — full default keymap reference
- [Neovim beginner guide](https://github.com/nvim-lua/kickstart.nvim/blob/master/README.md) — good conceptual intro even if not using kickstart

**Essential keymaps to remember** (`<Space>` is leader):

| Key | Action |
|---|---|
| `<Space><Space>` | Find files (telescope) |
| `<Space>ff` | Find files |
| `<Space>fg` | Live grep across project |
| `<Space>fb` | Switch open buffers |
| `<Space>e` | Toggle file explorer (neo-tree) |
| `<Space>gg` | Open lazygit |
| `<Space>?` | Show all keymaps (which-key) |
| `<Space>l` | Open lazy.nvim plugin manager |
| `<Space>cm` | Open mason (LSP/tool installer) |
| `gd` | Go to definition |
| `gr` | Go to references |
| `K` | Hover docs |
| `]d` / `[d` | Next/prev diagnostic |

**Included plugins worth exploring:**

| Plugin | What it does |
|---|---|
| **telescope.nvim** | Fuzzy finder for files, text, buffers, git, LSP symbols |
| **neo-tree.nvim** | File explorer sidebar (`<Space>e`) |
| **gitsigns.nvim** | Inline git blame, diff in gutter, stage hunks |
| **blink.cmp** | Autocomplete with LSP, snippets, buffer words |
| **nvim-lspconfig + mason** | LSP support for Python, SQL, etc. Install servers via `:MasonInstall pyright` |
| **nvim-treesitter** | Accurate syntax highlighting (parses code, not regex) |
| **flash.nvim** | Jump anywhere on screen with 2 keystrokes (`s` then letters) |
| **mini.surround** | Add/change/delete surrounding brackets/quotes (`gsa`, `gsd`, `gsr`) |
| **noice.nvim** | Better UI for command line and notifications |
| **snacks.nvim** | Dashboard, file picker, terminal, notifications — LazyVim's utility layer |
| **lualine.nvim** | Status bar with git branch, LSP status, file info |
| **todo-comments.nvim** | Highlights `TODO`, `FIXME`, `NOTE` in code; `<Space>st` to search all |

**Themes** (change active theme in `lua/plugins/custom.lua`):

| Theme | Vibe |
|---|---|
| `catppuccin` (default) | Soft pastels, purple/blue — try variants: latte, frappe, macchiato, mocha |
| `tokyonight` | Cool blues and purples — variants: night, storm, moon |
| `gruvbox-material` | Warm ambers and greens — variants: hard, medium, soft |
| `rose-pine` | Elegant muted tones — variants: main, moon, dawn |
| `kanagawa` | Japanese woodblock art inspired — variants: wave, dragon, lotus |

To preview any theme without changing config: `:colorscheme <name><Tab>`

### Notes
- R projects may run on dedicated VMs with their own provisioning — no setup scripts provided here
- `~/.config/` stores per-tool config for btop, htop, lazygit, uv — not tracked here as defaults are fine
