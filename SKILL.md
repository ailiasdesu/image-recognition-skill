---
name: image-recognition
description: "MANDATORY: When user provides an image and the model cannot process it, NEVER send image data to the LLM - it wastes tokens, confuses the model, and causes hallucinations. Instead use this skill: run recognize_image.py with Gemma 3 4B, and use returned Markdown."
---

# Image Recognition Skill · 图像识别技能

Routes images through local Gemma 3 4B. NEVER pass image data to the LLM.

## ⚠️ GOLDEN RULES · 铁律

1. **NEVER** embed image bytes, base64, or data URIs in the conversation — this will **permanently corrupt the session** with non-vision models like DeepSeek-V4
2. If user provides an image, look for a **file path** on disk. If no path exists, ask user to save the image and provide the path. Do NOT attempt to read the image bytes yourself
3. If you see `"image_url"` or `"unknown variant"` error in the JSON response, the session is corrupted — inform user to start a new thread
4. This script handles resize, base64, and Ollama API internally — you only need to pass the file path

## Usage · 使用方式

### File path (REQUIRED):
```powershell
& "$env:USERPROFILE\.codex\venv\Scripts\python.exe" "$env:USERPROFILE\.codex\skills\image-recognition\scripts\recognize_image.py" "D:\\path\\to\\image.png"
```

### Clipboard:
```powershell
& "$env:USERPROFILE\.codex\venv\Scripts\python.exe" "$env:USERPROFILE\.codex\skills\image-recognition\scripts\recognize_image.py" --clipboard
```

### Custom model / prompt:
```powershell
& "$env:USERPROFILE\.codex\venv\Scripts\python.exe" "$env:USERPROFILE\.codex\skills\image-recognition\scripts\recognize_image.py" "image.png" --model gemma3:4b --prompt "用中文描述"
```

## Default Prompt · 默认提示词

识别图片里所有信息，使用 markdown 输出全部内容，并保持排版的一致

## Output · 输出

- **stdout** — Markdown (may be garbled in PowerShell terminal)
- **`%TEMP%\rec_out.md`** — UTF-8 file (READ THIS for correct Chinese text)

After running the script, read the output from `%TEMP%\rec_out.md`:
```powershell
Get-Content "$env:TEMP\rec_out.md" -Raw -Encoding UTF8
```

## Prerequisites · 环境要求

- Ollama running `gemma3:4b`
- `~/.codex/venv` with `pillow` and `requests`
