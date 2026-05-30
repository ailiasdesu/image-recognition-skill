# Image Recognition Skill for Codex

> Route images through a local Ollama vision model — never pollute your LLM context with base64 image data again.

## What It Does

When you paste or drag an image into Codex, models like DeepSeek-V4 cannot process it, which wastes tokens and causes hallucinations. This skill intercepts images and routes them through a **local Ollama Gemma 3 4B** vision model instead, returning clean Markdown text that any LLM can use.

## How It Works

```
Image → resize (max 1280px) → base64 → Ollama Gemma 3 4B → Markdown → Codex
```

## Prerequisites

| Requirement | Details |
|-------------|---------|
| **Ollama** | [Download](https://ollama.com) Windows/Linux/macOS |
| **gemma3:4b** | `ollama pull gemma3:4b` (~3.3 GB) |
| **Python 3.12+** | With `pillow` and `requests` |
| **GPU** | RTX 3060 6GB tested (vision encoder on CPU, ~30s/image) |

### Quick Setup

```powershell
# 1. Create Python venv
python -m venv ~/.codex/venv

# 2. Install dependencies
~/.codex/venv/Scripts/pip.exe install pillow requests

# 3. Start Ollama & pull model
ollama serve
ollama pull gemma3:4b
```

## Installation

```powershell
# Via skill-installer (after publishing to GitHub)
# Will be: codex skill install <github-user>/image-recognition-skill
```

Or manually:

```powershell
Copy-Item -Recurse "image-recognition" "$env:USERPROFILE\.codex\skills\image-recognition"
```

Restart Codex to pick up the new skill.

## Usage

### From Codex

Just drag an image into Codex or paste a file path — the skill detects image data automatically and routes to Ollama.

### From Terminal

```powershell
# File path
& ~/.codex/venv/Scripts/python.exe ~/.codex/skills/image-recognition/scripts/recognize_image.py "C:\path\to\image.jpg"

# Clipboard
& ~/.codex/venv/Scripts/python.exe ~/.codex/skills/image-recognition/scripts/recognize_image.py --clipboard

# Custom model & prompt
& ~/.codex/venv/Scripts/python.exe ~/.codex/skills/image-recognition/scripts/recognize_image.py "image.png" `
    --model gemma3:4b `
    --prompt "Describe this image in English"
```

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `IMAGE_API_BASE` | `http://localhost:11434` | Ollama API endpoint |

## Output

Results are written to:
- **stdout** — Markdown text (for terminal use)
- **`%TEMP%\rec_out.md`** — UTF-8 file (for Codex agent consumption)

## Supported Models

Any Ollama model with vision support. Tested:

| Model | Size | Speed | Quality |
|-------|------|-------|---------|
| `gemma3:4b` ⭐ | 3.3 GB | ~30s | Good (Chinese + English) |
| `qwen2.5vl:3b` | 3.2 GB | ~25s | Lower detail |

## Troubleshooting

| Problem | Fix |
|---------|-----|
| "Cannot connect to Ollama" | Run `ollama serve` in another terminal |
| Model not found | `ollama pull gemma3:4b` |
| Garbled Chinese output | Read `%TEMP%\rec_out.md` instead of terminal stdout |
| Timeout | GPU with <6GB VRAM runs vision encoder on CPU, be patient |
| "image_url" error in Codex | Image was sent to LLM instead of skill — restart Codex |

## License

MIT
