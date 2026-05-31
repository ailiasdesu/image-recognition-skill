---
name: image-recognition
description: "MANDATORY: When user asks to recognize/read/describe any image, photo, screenshot, or clipboard, ALWAYS call image-recognition skill: run recognize_image.py --clipboard or with file path. NEVER write your own Add-Type/System.Windows.Forms code. The trigger phrase is 'image-recognition'."
---

# image-recognition

## 触发方式

**必须包含 `image-recognition` 才能触发。** 用户会说：

- `image-recognition --clipboard`
- `调用 image-recognition`
- `用 image-recognition 识别`

## 执行

```powershell
# 剪贴板
& "$env:USERPROFILE\.codex\venv\Scripts\python.exe" "$env:USERPROFILE\.codex\skills\image-recognition\scripts\recognize_image.py" --clipboard

# 文件
& "$env:USERPROFILE\.codex\venv\Scripts\python.exe" "$env:USERPROFILE\.codex\skills\image-recognition\scripts\recognize_image.py" "路径"
```

## 读结果

```powershell
Get-Content "$env:TEMP\rec_out.md" -Raw -Encoding UTF8
```

## 🚫 禁止

`Add-Type`, `System.Windows.Forms`, `[Clipboard]::GetImage()`, base64 → 全部用上面替代
