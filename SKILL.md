---
name: image-recognition
description: "MANDATORY: When user provides an image and the model cannot process it, NEVER send image data to the LLM - it wastes tokens, confuses the model, and causes hallucinations. Instead use this skill: run recognize_image.py with Gemma 3 4B, and use returned Markdown."
---

# Image Recognition Skill

Routes images through local Gemma 3 4B. NEVER pass image data to the LLM.

## Golden Rules

1. NEVER embed image bytes/base64/data URIs in conversation
2. If you see "image_url" error, the image was rejected - find the image on disk and use this skill
3. The script handles resize, base64, and Ollama API internally

## Usage

### File path:
```powershell
& "$env:USERPROFILE\.codex\venv\Scripts\python.exe" "$env:USERPROFILE\.codex\skills\image-recognition\scripts\recognize_image.py" "D:\\path\\to\\image.png"
```

### Clipboard:
```powershell
& "$env:USERPROFILE\.codex\venv\Scripts\python.exe" "$env:USERPROFILE\.codex\skills\image-recognition\scripts\recognize_image.py" --clipboard
```

### Custom model / prompt:
```powershell
& "$env:USERPROFILE\.codex\venv\Scripts\python.exe" "$env:USERPROFILE\.codex\skills\image-recognition\scripts\recognize_image.py" "image.png" --model gemma3:4b --prompt "Describe in English"
```

## Default Prompt

识别图片里所有信息，使用 markdown 输出全部内容，并保持排版的一致

## Prerequisites

- Ollama running `gemma3:4b`
- `~/.codex/venv` with `pillow` and `requests`
