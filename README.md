# Dotfiles

Automated Mac setup for Dennis's machines. One script to go from a fresh macOS install to a fully configured development environment.

## Setting up a fresh Mac

These steps happen **at the new Mac** (the only hands-on part):

### 1. Enable SSH

System Settings → General → Sharing → toggle **Remote Login** on.

### 2. Allow SSH access from the Mac Mini

Open Terminal on the new Mac and run:

```bash
mkdir -p ~/.ssh
```

Then get the Mac Mini's public key added. From the **Mac Mini**, run:

```bash
ssh-copy-id dennis@<new-mac-ip>
```

Or if that fails (no password auth), on the **new Mac** run:

```bash
curl http://192.168.68.101:9999/key.txt >> ~/.ssh/authorized_keys
```

(Only works if the Mac Mini is serving the key — see below.)

### 3. Install Xcode CLI tools

On the new Mac, run:

```bash
xcode-select --install
```

A **GUI dialog will appear** — click "Install" and wait for it to finish. This cannot be automated (Apple requires GUI confirmation). Takes a few minutes.

### 4. Clone and run bootstrap

Still on the new Mac (Homebrew install requires sudo/TTY — can't run over SSH):

```bash
git clone https://github.com/dennisroethig/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles
git checkout main
./bootstrap.sh --laptop    # or --mini, or --headless
```

**Note:** The repo has an old `master` branch. Always use `main`.

### 5. Everything else is remote

After bootstrap completes, the rest can be done from any machine via SSH.

## What bootstrap does

1. Installs Homebrew (skip if present)
2. Installs packages from `Brewfile` (skips GUI apps with `--headless`)
3. Installs Oh My Zsh (robbyrussell theme, git plugin)
4. Symlinks config files (shell, git, SSH, Ghostty, Zed)
5. Copies wallpapers and sets the desktop wallpaper
6. Creates `~/.secrets` template for API keys
7. Generates an SSH key (ed25519)
8. Applies macOS system preferences (Dock, Finder, keyboard, screenshots)
9. Prints a post-setup checklist

## After bootstrap

### Privacy permissions (System Settings → Privacy & Security)

macOS blocks programmatic permission grants — these must be done manually:

- **Accessibility** → enable **Raycast** (required for Hyper Key and window management)
- **Files & Folders** → allow **Raycast**, **Ghostty**, **Zed** (or approve when prompted on first use)
- **Bluetooth** → allow **iStat Menus** (if installed)

### Other manual steps

- Add SSH public key to GitHub (or run `gh ssh-key add ~/.ssh/id_ed25519.pub` from a machine with `gh` auth)
- Install Tailscale from the App Store (not Homebrew — better macOS integration)
- Open Zed → install Snazzy extension (`Cmd+Shift+X`)
- Install Claude Code: `npm install -g @anthropic-ai/claude-code`
- Fill in `~/.secrets` with API keys (only if needed on this machine)
- Run `./setup-ssh-access.sh` to push SSH key to all other machines

## Profiles

| Flag | Use case | GUI apps? |
|------|----------|-----------|
| `--laptop` | MacBook Pro / laptop | Yes |
| `--mini` | Mac Mini Pro / desktop | Yes |
| `--headless` | Server (LLM host, etc.) | No |

## Repo structure

```
configs/
  ghostty/config        # Terminal (Dracula-style bg, padding)
  zed/settings.json     # Editor (Menlo, Snazzy theme)
  git/gitconfig         # Aliases, user info
  ssh/config            # Host aliases (mini, mbp, old-mini)
  shell/
    zshrc               # Oh My Zsh, aliases, PATH
    zprofile            # Homebrew PATH, OrbStack
    devrc               # NVM loader
macos/
  defaults.sh           # macOS system preferences
wallpapers/             # Desktop wallpapers
docs/
  llm-server-setup.md   # Ollama / LLM server guide
Brewfile                # Homebrew packages and casks
bootstrap.sh            # Main setup script
setup-ssh-access.sh     # Push SSH key to all other machines
```

## Secrets

API keys and tokens live in `~/.secrets` (not in this repo). Bootstrap creates a template. Currently tracked:

- `INTERVALS_API_KEY` — Intervals.icu API
- `INTERVALS_ATHLETE_ID` — Intervals.icu athlete ID
- `UP_BANK_API_TOKEN` — Up Bank API

## LLM server

See `docs/llm-server-setup.md` for setting up the MacBook Pro as a local LLM inference server (Ollama, model list, network config).
