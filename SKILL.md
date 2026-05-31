---
name: image-recognition
description: "Triggers when user says: 启动识图, 识图模式, image-recognition, 识图skill, 调用识图, 看图, 图片, 照片, 截图, 剪贴板, 读图. When triggered: run recognize_image.py. NEVER write System.Windows.Forms. NEVER embed base64."
---

# 🟢 识图模式

用户说以下任意一句激活：
- **调用识图** / **启动识图** / **识图模式**
- **image-recognition** / 识图skill
- 看图 / 读图 / 识别 / 图片 / 照片 / 截图 / 剪贴板

## 激活后执行

```powershell
# 剪贴板
& "$env:USERPROFILE\.codex\venv\Scripts\python.exe" "$env:USERPROFILE\.codex\skills\image-recognition\scripts\recognize_image.py" --clipboard

# 文件
& "$env:USERPROFILE\.codex\venv\Scripts\python.exe" "$env:USERPROFILE\.codex\skills\image-recognition\scripts\recognize_image.py" "图片路径"
```

读结果：
```powershell
Get-Content "$env:TEMP\rec_out.md" -Raw -Encoding UTF8
```

## 🚫 禁止
`Add-Type`, `System.Windows.Forms`, `[Clipboard]::GetImage()`, base64 嵌入 → 全部用上面命令替代
