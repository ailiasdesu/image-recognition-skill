---
name: image-recognition
description: "MANDATORY: Triggered when user says 'image-recognition skill' or '调用 image-recognition skill'. When triggered: run recognize_image.py. NEVER write Add-Type/System.Windows.Forms. NEVER embed base64."
---

# image-recognition skill

## 触发方式

**必须包含 `image-recognition` + `skill` 两个关键词：**

- `调用 image-recognition skill`
- `用 image-recognition skill 识别`
- `image-recognition skill --clipboard`

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
