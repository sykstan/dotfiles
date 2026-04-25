# Claude Instructions: dotfiles

Primary context is in AGENTS.md — read that first.

## Style preferences
- Australian English spelling (colour, organisation, etc.)
- Commit messages: imperative mood, explain *why* not just *what*
- Always include the Co-authored-by Copilot trailer in commits

## Approach
- Favour simple, readable bash over clever one-liners
- When adding a new tool to `install.sh`, follow the existing pattern: echo header,
  idempotency check, install, `[skip]` / `[ok]` output
- Don't refactor unrelated sections when fixing a specific tool's install block
