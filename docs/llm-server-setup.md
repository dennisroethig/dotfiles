# LLM Server Setup (MacBook Pro)

Guide for setting up the MacBook Pro (M1 Max, 64GB) as a local LLM inference server.

## Machine

- **Model:** MacBook Pro (MacBookPro18,4) — Apple M1 Max, 10-core, 64 GB RAM
- **Hostname:** MacBook-Pro
- **IP:** 192.168.68.102 (LAN), 100.71.60.121 (Tailscale)
- **SSH:** `ssh mbp` (alias in dotfiles ssh config)

## Ollama

### Install

```bash
# Option A: Homebrew (if available)
brew install ollama

# Option B: Direct download
# Download from https://ollama.com/download/mac
```

### Configure LAN access

Ollama needs to listen on all interfaces to be accessible from other machines on the network.

Create a LaunchAgent to set the environment variable:

```bash
mkdir -p ~/Library/LaunchAgents
```

The Ollama.app LaunchAgent (installed by the app) auto-starts Ollama. To make it listen on all interfaces, set `OLLAMA_HOST`:

```bash
launchctl setenv OLLAMA_HOST "0.0.0.0"
```

Or add to `~/.zshrc` / `~/.secrets`:

```bash
export OLLAMA_HOST="0.0.0.0"
```

Then restart Ollama. The API will be available at `http://192.168.68.102:11434` from any machine on the LAN.

### Models

Pull the models (sizes are approximate):

```bash
ollama pull qwen3.5:35b-16k           # 20 GB
ollama pull frob/qwen3.5:35b-a3b-instruct-ud-q4_K_XL  # 20 GB
ollama pull qwen3-coder-next:16k       # 51 GB
```

The 64 GB unified memory can comfortably run the 20 GB models. The 51 GB model uses most of available memory.

### Verify

```bash
# Check service is running
curl http://localhost:11434

# From another machine on the LAN
curl http://192.168.68.102:11434

# List loaded models
ollama list
```

## llama.cpp (reference)

Built from source at `~/llama.cpp` for experimentation. Not required for the standard LLM server setup.

```bash
git clone https://github.com/ggerganov/llama.cpp.git ~/llama.cpp
cd ~/llama.cpp
make -j
```

Models for llama.cpp use GGUF format and can be downloaded from Hugging Face.

## SSH access

After the MacBook Pro is reset, set up key-based SSH access from the Mac Mini:

```bash
# From Mac Mini
ssh-copy-id mbp
```

Enable Remote Login in System Settings > General > Sharing on the MacBook Pro.

## Notes

- Ollama is managed via its macOS app (LaunchAgent auto-start)
- No Homebrew was installed on the MacBook Pro previously — consider installing it for easier package management
- The MacBook Pro runs headless most of the time — SSH access is the primary interface
