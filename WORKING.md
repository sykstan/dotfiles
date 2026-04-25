# Working Notes: dotfiles
**Session:** 2026-04-25

## Current task
Filling in AI context docs (AGENTS.md, CLAUDE.md, WORKING.md) and fixing LazyVim not installing
on fresh machines.

## Approach
- Added headless nvim bootstrap step to `install.sh` (after neovim binary install)
- Filled AGENTS.md with full context from code review of install.sh, setup.sh, and repo structure

## In progress
- [done] LazyVim headless bootstrap added to install.sh
- [done] AGENTS.md, CLAUDE.md, WORKING.md populated

## Blockers / questions
- None currently

## Session log

### 2026-04-25
- Fixed syntax error in gh install block (missing `\` on line 116)
- Created `bunnings/linux/clone_all_repos.sh` for cloning work repos idempotently
- Added LazyVim headless bootstrap to `install.sh`
- Populated AI context docs

### 2026-04-23
- Started
