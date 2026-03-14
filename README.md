# Dotfiles

Automated Mac setup for Dennis's machines. One script to go from a fresh macOS install to a fully configured development environment.

## Quick start

```bash
# 1. Install Xcode CLI tools (needed for git)
xcode-select --install

# 2. Clone this repo
git clone https://github.com/dennisroethig/dotfiles.git ~/Projects/dotfiles

# 3. Run bootstrap
cd ~/Projects/dotfiles
./bootstrap.sh --laptop    # MacBook Pro / laptop
./bootstrap.sh --mini      # Mac Mini Pro / desktop
./bootstrap.sh --headless  # Headless server (no GUI apps)
```

## What it does

1. Installs Xcode CLI tools
2. Installs Homebrew
3. Installs packages from `Brewfile` (skips GUI apps with `--headless`)
4. Installs Oh My Zsh (robbyrussell theme, git plugin)
5. Symlinks config files (shell, git, SSH, Ghostty, Zed)
6. Creates `~/.secrets` template for API keys
7. Generates an SSH key (ed25519)
8. Applies macOS system preferences
9. Prints a post-setup checklist

## Manual steps after bootstrap

- Add SSH public key to GitHub
- Fill in `~/.secrets` with API keys
- Open Zed and install the Snazzy extension (`Cmd+Shift+X`)
- Install Claude Code: `npm install -g @anthropic-ai/claude-code`

## Repo structure

```
configs/
  ghostty/config        # Terminal (Dracula-style bg, padding)
  zed/settings.json     # Editor (Menlo, Snazzy theme)
  git/gitconfig         # Aliases, user info
  ssh/config            # Host aliases (mbp, old-mini)
  shell/
    zshrc               # Oh My Zsh, aliases, PATH
    zprofile            # Homebrew PATH, OrbStack
    devrc               # NVM loader
macos/
  defaults.sh           # macOS system preferences
docs/
  llm-server-setup.md   # Ollama / LLM server guide
Brewfile                # Homebrew packages and casks
bootstrap.sh            # Main setup script
```

## Secrets

API keys and tokens live in `~/.secrets` (not in this repo). The bootstrap script creates a template. Currently tracked secrets:

- `INTERVALS_API_KEY` — Intervals.icu API
- `INTERVALS_ATHLETE_ID` — Intervals.icu athlete ID
- `UP_BANK_API_TOKEN` — Up Bank API

## LLM server

See `docs/llm-server-setup.md` for setting up the MacBook Pro as a local LLM inference server (Ollama, model list, network config).
