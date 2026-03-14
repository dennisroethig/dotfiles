# LLM Server Setup (MacBook Pro)

Guide for setting up the MacBook Pro (M1 Max, 64GB) as a local LLM inference server.

## Machine

- **Model:** MacBook Pro (MacBookPro18,4) — Apple M1 Max, 10-core, 64 GB RAM
- **Hostname:** MacBook-Pro
- **IP:** 192.168.68.102 (LAN, ethernet) / may vary on WiFi
- **Tailscale:** 100.71.60.121
- **SSH:** `ssh mbp` (alias in dotfiles ssh config)

## Ollama

### Install

Ollama was installed via the macOS app (not Homebrew). Version as of last capture: **0.16.3**.

```bash
# Download from https://ollama.com/download/mac
# Or: brew install ollama
```

The app installs the binary at `/usr/local/bin/ollama`.

### LaunchAgent

The app creates `~/Library/LaunchAgents/com.ollama.serve.plist`. Here's the exact plist from the pre-reset capture, which includes `OLLAMA_HOST=0.0.0.0` for LAN access:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.ollama.serve</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/local/bin/ollama</string>
        <string>serve</string>
    </array>
    <key>EnvironmentVariables</key>
    <dict>
        <key>OLLAMA_HOST</key>
        <string>0.0.0.0</string>
    </dict>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/tmp/ollama.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/ollama.log</string>
</dict>
</plist>
```

If the Ollama app doesn't create this automatically with `OLLAMA_HOST`, create it manually:

```bash
mkdir -p ~/Library/LaunchAgents
# Copy the plist above to ~/Library/LaunchAgents/com.ollama.serve.plist
launchctl load ~/Library/LaunchAgents/com.ollama.serve.plist
```

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
curl http://<macbook-ip>:11434

# List loaded models
ollama list
```

## llama.cpp (reference)

Built from source at `~/llama.cpp` for experimentation. The repo includes build artifacts, cmake config, conversion scripts, and examples. Not required for the standard LLM server setup.

```bash
git clone https://github.com/ggerganov/llama.cpp.git ~/llama.cpp
cd ~/llama.cpp
cmake -B build && cmake --build build -j
```

Models for llama.cpp use GGUF format and can be downloaded from Hugging Face.

## Other software on the MBP (pre-reset)

Captured for reference — not all of this needs to be reinstalled.

- **Homebrew:** Not installed (Homebrew paths in .zshrc/.zprofile but `brew` not found)
- **Tailscale:** Running via LaunchAgent (`homebrew.mxcl.tailscale.plist`)
- **OrbStack:** Shell integration present in .zprofile
- **LM Studio:** CLI path in .zshrc (`~/.lmstudio/bin`)
- **Loopback:** Audio routing app (`com.rogueamoeba.loopbackd.plist`)
- **Google Chrome:** Updater LaunchAgents present

## SSH access

After the MacBook Pro is reset, set up key-based SSH access from the Mac Mini:

```bash
# From Mac Mini
ssh-copy-id mbp
```

Enable Remote Login in System Settings > General > Sharing on the MacBook Pro.

## Notes

- Ollama is managed via its macOS app (LaunchAgent auto-start with `KeepAlive`)
- `OLLAMA_HOST=0.0.0.0` is set in the LaunchAgent plist, not in shell env
- Logs go to `/tmp/ollama.log`
- The MacBook Pro can run headless — SSH is the primary interface
