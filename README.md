# Image Recognition Skill for Codex · 图像识别技能

> Route images through a local Ollama vision model — never pollute your LLM context with base64 image data again.
> 通过本地 Ollama 视觉模型识别图片 — 再也不让 base64 图片数据污染 LLM 上下文。

[English](#english) | [中文](#中文)

---

## English

### What It Does

Models like DeepSeek-V4 cannot process images. If you drag or paste an image directly into Codex, the base64 data gets sent to the LLM, which causes:

- **Session corruption** — the model returns `"unknown variant image_url"` errors
- **Irrecoverable context** — once corrupted, the entire conversation thread is broken
- **Hallucinations** — the model may fabricate content from the garbled binary data

This skill solves the problem by routing images through a **local Ollama Gemma 3 4B** vision model. It returns clean Markdown text that any LLM can safely consume.

### ⚠️ Critical Usage Rule

**ALWAYS paste the image FILE PATH — NEVER drag/drop or paste the image directly into Codex.**

| ✅ Correct | ❌ Wrong |
|-----------|----------|
| `"C:\Users\xxx\Pictures\photo.jpg"` | Dragging image into chat |
| `"D:\images\screenshot.png"` | Pasting from clipboard directly |
| `$image-recognition "path\to\img.jpg"` | Embedding base64 data URI |

Dragging or pasting an image directly embeds the base64 data into the conversation, which will **permanently corrupt the session** with DeepSeek-V4 and other non-vision models.

### How It Works

```
Image file path → resize (max 1280px) → base64 → Ollama Gemma 3 4B → Markdown → Codex
```

### Prerequisites

| Requirement | Details |
|-------------|---------|
| **Ollama** | [Download](https://ollama.com) Windows/Linux/macOS |
| **gemma3:4b** | `ollama pull gemma3:4b` (~3.3 GB) |
| **Python 3.12+** | With `pillow` and `requests` |
| **GPU** | RTX 3060 6GB tested (~30s/image, vision encoder on CPU) |

### Quick Install

```powershell
# One-click install
powershell -ExecutionPolicy Bypass -File install.ps1
```

Or manually:

```powershell
# 1. Create Python venv
python -m venv ~/.codex/venv

# 2. Install dependencies
~/.codex/venv/Scripts/pip.exe install pillow requests

# 3. Install skill files
Copy-Item -Recurse "image-recognition" "$env:USERPROFILE\.codex\skills\image-recognition"

# 4. Start Ollama & pull model
ollama serve
ollama pull gemma3:4b
```

### Usage

```powershell
# File path (REQUIRED — paste path, not the image itself)
& ~/.codex/venv/Scripts/python.exe ~/.codex/skills/image-recognition/scripts/recognize_image.py "C:\path\to\image.jpg"

# Clipboard screenshot
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

### Output

- **stdout** — Markdown text (terminal use)
- **`%TEMP%\rec_out.md`** — UTF-8 file (Codex agent reads this)

### Supported Models

| Model | Size | Speed | Quality |
|-------|------|-------|---------|
| `gemma3:4b` ⭐ | 3.3 GB | ~30s | Excellent (Chinese + English) |
| `qwen2.5vl:3b` | 3.2 GB | ~25s | Poor detail |

### Troubleshooting

| Problem | Fix |
|---------|-----|
| "Cannot connect to Ollama" | Run `ollama serve` |
| Model not found | `ollama pull gemma3:4b` |
| Garbled Chinese in terminal | Read `%TEMP%\rec_out.md` instead |
| Session corrupted (image_url error) | Create new thread — DO NOT paste images directly |
| Timeout | Vision encoder on CPU takes ~30s, be patient |

---

## 中文

### 功能说明

DeepSeek-V4 等模型不支持图像识别。如果你直接把图片拖入 Codex，base64 数据会被发送给 LLM，导致：

- **会话损坏** — 模型返回 `"unknown variant image_url"` 错误
- **无法恢复** — 一旦污染，整个对话线程永久损坏
- **产生幻觉** — 模型可能从乱码二进制数据中编造内容

本技能通过**本地 Ollama Gemma 3 4B** 视觉模型处理图片，返回干净的 Markdown 文本，任何 LLM 都可安全使用。

### ⚠️ 重要使用规则

**必须粘贴图片文件路径 — 绝对不能拖拽或直接粘贴图片到 Codex。**

| ✅ 正确做法 | ❌ 错误做法 |
|-----------|----------|
| `"C:\Users\xxx\Pictures\photo.jpg"` | 拖拽图片到对话框 |
| `"D:\images\screenshot.png"` | 直接从剪贴板粘贴图片 |
| `$image-recognition "path\to\img.jpg"` | 嵌入 base64 数据 URI |

直接拖拽或粘贴图片会将 base64 数据嵌入对话，这会**永久损坏** DeepSeek-V4 等非视觉模型的会话。

### 工作流程

```
图片文件路径 → 缩放 (最长边 ≤1280px) → base64 → Ollama Gemma 3 4B → Markdown → Codex
```

### 环境要求

| 组件 | 说明 |
|------|------|
| **Ollama** | [下载](https://ollama.com) Windows/Linux/macOS |
| **gemma3:4b** | `ollama pull gemma3:4b` (~3.3 GB) |
| **Python 3.12+** | 需 `pillow` 和 `requests` |
| **GPU** | RTX 3060 6GB 已测试 (~30秒/张，视觉编码在 CPU 运行) |

### 一键安装

```powershell
powershell -ExecutionPolicy Bypass -File install.ps1
```

或手动安装：

```powershell
# 1. 创建 Python 虚拟环境
python -m venv ~/.codex/venv

# 2. 安装依赖
~/.codex/venv/Scripts/pip.exe install pillow requests

# 3. 安装技能文件
Copy-Item -Recurse "image-recognition" "$env:USERPROFILE\.codex\skills\image-recognition"

# 4. 启动 Ollama 并下载模型
ollama serve
ollama pull gemma3:4b
```

### 使用方法

```powershell
# 文件路径（必须 — 粘贴路径，不是图片本身）
& ~/.codex/venv/Scripts/python.exe ~/.codex/skills/image-recognition/scripts/recognize_image.py "C:\path\to\image.jpg"

# 剪贴板截图
& ~/.codex/venv/Scripts/python.exe ~/.codex/skills/image-recognition/scripts/recognize_image.py --clipboard

# 自定义模型和提示词
& ~/.codex/venv/Scripts/python.exe ~/.codex/skills/image-recognition/scripts/recognize_image.py "image.png" `
    --model gemma3:4b `
    --prompt "用中文详细描述这张图片"
```

### 输出

- **stdout** — Markdown 文本
- **`%TEMP%\rec_out.md`** — UTF-8 文件（Codex agent 读取此文件）

### 支持的模型

| 模型 | 大小 | 速度 | 质量 |
|------|------|------|------|
| `gemma3:4b` ⭐ | 3.3 GB | ~30s | 优秀（中英文均可） |
| `qwen2.5vl:3b` | 3.2 GB | ~25s | 细节不足 |

### 常见问题

| 问题 | 解决方法 |
|------|----------|
| "Cannot connect to Ollama" | 运行 `ollama serve` |
| 模型未找到 | `ollama pull gemma3:4b` |
| 终端中文乱码 | 读 `%TEMP%\rec_out.md` 文件 |
| 会话损坏 (image_url 错误) | 新建对话线程 — 不要直接粘贴图片 |
| 超时 | 视觉编码在 CPU 运行需 ~30s，请耐心等待 |

---

## Development Issues Summary / 开发问题总结

以下是开发过程中遇到并解决的关键问题：

### 1. 会话污染 / Session Corruption ⚠️
**问题:** 直接拖拽图片到 Codex 时，base64 数据被发送给 DeepSeek-V4，模型不支持 `image_url` 类型，返回 `"unknown variant image_url"` 错误，且**整个会话永久损坏**，只能新建对话。
**解决:** 强制使用文件路径，SKILL.md 中加入 GOLDEN RULES 禁止 agent 将图片数据传入 LLM 上下文。

### 2. 沙盒超时 / Sandbox Timeout
**问题:** Codex 沙盒对 shell 命令有 ~14s 硬超时。Gemma 3 4B 的视觉编码在 CPU 上运行需 ~29s，直接调用会被杀进程。
**解决:** 授予完全权限后超时限制消失；之前的 workaround 是 `cmd /c start /b` 后台进程 + 轮询 `%TEMP%/rec_out.md`。

### 3. UTF-8 双重编码乱码 / Double Encoding
**问题:** 使用 `stream: True` 时，Ollama 返回的 SSE 流经过 Python `iter_lines()` → PowerShell 管道，产生 UTF-8 → CP1252 → UTF-8 双重编码，中文完全乱码。
**解决:** 改用 `stream: False`，从 JSON 一次性获取 `choices[0].message.content`，写文件时指定 `encoding="utf-8"`。

### 4. PowerShell 终端编码
**问题:** 即使脚本内部 UTF-8 正确，PowerShell 终端 stdout 中文仍然乱码（Windows 控制台默认 CP936）。
**解决:** Agent 不读 stdout，改为读取 `%TEMP%/rec_out.md` 文件（UTF-8 编码正确）。

### 5. GPU 显存不足 / VRAM Constraints
**问题:** RTX 3060 6GB 显存，Ollama 初次启动时 CUDA compute capability 8.6 不在编译架构列表中，跳过 GPU。后续找到兼容的 CUDA v12 库，但视觉编码仍因显存不足(5GB 可用)运行在 CPU。
**结果:** 每张图片处理约 29s，仍在可接受范围。

### 6. 模型选择 / Model Selection
**问题:** 最初测试 `qwen2.5vl:3b`（3.2GB），速度略快但输出质量低、细节丢失严重。
**解决:** 换用 `gemma3:4b`（3.3GB），质量显著提升，中英文识别效果都好。

### 7. Gemma 中途截断 / Truncation
**问题:** 一次运行中 gemma3:4b 在生成 752 tokens 后停止（stop processing: n_tokens = 752）。
**解决:** 未复现，可能为偶发 Ollama 调度问题；`max_tokens` 默认值足够应对大多数图片。

### 8. Ollama 端口冲突 / Port Conflict
**问题:** 尝试重启 Ollama 时，`listen tcp 127.0.0.1:11434: bind: Only one usage of each socket address`。
**解决:** Ollama 已经在后台运行，不需要重复启动。

### 9. 持久化触发 / Persistent Skill Trigger
**问题:** 用户希望 Skill 始终自动加载，而非每次手动触发。但如果在持久化指令触发前图片已被发送，会话仍然会损坏。
**结论:** 妥协方案 — 依靠 SKILL.md 的 MANDATORY 描述 + agent 训练来识别图片路径模式并自动路由。

### 10. 一键安装与分发
**问题:** 用户需要简单方式安装到自己的 Codex。
**解决:** 创建 `install.ps1` 脚本，自动检测 Python/Ollama/模型，一键安装所有依赖和技能文件。

---

## License

MIT
