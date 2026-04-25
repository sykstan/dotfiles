# Project: dotfiles
**Last updated:** 2026-04-25

## What this is
Personal developer environment dotfiles for Ubuntu/Debian machines — primarily WSL and Azure ML
compute instances. Covers shell config (zsh + oh-my-zsh), editor (neovim + LazyVim), git tooling
(lazygit, delta, gh), terminal utilities, and work-specific (Bunnings) scripts. Goal is to be able
to bootstrap a usable dev environment on a fresh machine in a single session.

There are two contexts:
- **Root-level / personal**: `vimrc.vim`, `work/` (old bash configs, kept for reference)
- **`bunnings/`**: work machine setup — `install.sh`, `setup.sh`, `linux/` dotfiles, `clone_all_repos.sh`

## Current objective
Ongoing maintenance — keeping `install.sh` idempotent and complete, adding new tools as adopted,
and improving the AI context files in this repo.

## Tech stack
- **Shell**: bash (scripts), zsh (interactive shell via oh-my-zsh + powerlevel10k)
- **Editor**: neovim (binary install, version-pinned) + LazyVim + lazy.nvim
- **Git tooling**: lazygit, git-delta, gh CLI, gh-dash extension
- **Utilities**: tmux, fzf, zoxide, fd, bat, ripgrep, yazi, btop, tldr
- **Python**: uv (package/env manager)
- **Data**: Snowflake ODBC driver (for R)
- **Windows**: AutoHotkey scripts in `autohotkey/`
- **Package managers in use**: apt, snap, curl-to-binary, npm (only for Copilot CLI fallback)

## Constraints & preferences
- Always: scripts must be idempotent — safe to re-run without side effects
- Always: check before installing (skip if already present), print `[skip]` / `[ok]` status
- Always: target Ubuntu/Debian (apt-based); don't assume snap works everywhere
- Never: add tools to `install.sh` without an idempotency guard
- Avoid: pinning versions unless there's a concrete reason (note the reason in a comment)
- Avoid: installing things globally with pip — use uv

## Key decisions (don't relitigate)
- **neovim installed via binary tarball**, not snap or apt: allows version pinning and easy
  upgrades by changing `NVIM_VERSION`. Extracted to `~/.local/nvim-<version>/`, symlinked
  to `~/.local/bin/nvim`.
- **neovim pinned to 0.11.x**: 0.12 introduced the kitty keyboard protocol which broke
  shift+number key input. Re-evaluate when LazyVim handles this cleanly.
- **LazyVim config tracked in repo** at `bunnings/linux/nvim/`; `setup.sh` symlinks the
  whole directory to `~/.config/nvim`. Plugin bootstrapping happens headlessly in `install.sh`.
- **fd and bat aliased to canonical names** (`fd` → `fdfind`, `bat` → `batcat`) via symlinks
  in `~/.local/bin/` because Ubuntu ships them under different names.
- **`bunnings/` subtree is work-specific**: keep work and personal config cleanly separated.
  Don't merge work tooling into the root level.
- **gh CLI installed via official apt repo** (not snap): GitHub's recommended method.
  Requires adding their GPG key and apt source first.

## Known gotchas
- **Proxy must be set before running `install.sh`**: create `~/.bashrc.local` with
  `http_proxy`/`https_proxy` and source it first. The script warns but continues.
- **`setup.sh` must run before `install.sh` for LazyVim bootstrap to work**: `install.sh`
  checks for `~/.config/nvim/init.lua` (created by `setup.sh`'s symlink) before running
  headless nvim. If skipped, LazyVim plugins won't install; open nvim manually to trigger it.
- **gh-dash install (`gh extension install`) fails if not authenticated**: run `gh auth login`
  before re-running `install.sh` if this section fails.
- **Azure ML compute has no login shell change**: `CHSH=no` is set when installing oh-my-zsh.
  Use `exec zsh` to switch; don't rely on login shell being set.
- **`~/.local/bin` must be on PATH**: the binary installs (nvim, lazygit, delta) land there.
  Ensured by `.bashrc` / `.zshrc` in `bunnings/linux/`.

## Current state
`install.sh` is functional. LazyVim headless bootstrap step added (2026-04-25).
AI context docs being filled in this session.
