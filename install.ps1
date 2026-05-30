# Image Recognition Skill — 一键安装脚本
# One-Click Installer for Codex Image Recognition Skill
# GitHub: https://github.com/ailiasdesu/image-recognition-skill

$ErrorActionPreference = "Stop"
$SkillName = "image-recognition"
$CodexSkills = "$env:USERPROFILE\.codex\skills\$SkillName"
$CodexVenv = "$env:USERPROFILE\.codex\venv"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Codex Image Recognition Skill 安装程序" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# ── Step 1: Python 虚拟环境 ──────────────────────────────────
Write-Host "[1/4] 检查 Python 虚拟环境..." -ForegroundColor Yellow

$python = Get-Command python -ErrorAction SilentlyContinue
if (-not $python) {
    Write-Host "  [错误] 未找到 Python，请先安装 Python 3.12+" -ForegroundColor Red
    Write-Host "  下载: https://www.python.org/downloads/" -ForegroundColor Red
    exit 1
}
Write-Host "  Python: $($python.Source)" -ForegroundColor Green

if (-not (Test-Path $CodexVenv)) {
    Write-Host "  创建虚拟环境: $CodexVenv" -ForegroundColor Gray
    & python -m venv $CodexVenv
}
$pip = "$CodexVenv\Scripts\pip.exe"
Write-Host "  虚拟环境就绪" -ForegroundColor Green

# ── Step 2: Python 依赖 ──────────────────────────────────────
Write-Host "[2/4] 安装 Python 依赖..." -ForegroundColor Yellow
& $pip install pillow requests -q
Write-Host "  pillow + requests 已安装" -ForegroundColor Green

# ── Step 3: Ollama & 模型 ────────────────────────────────────
Write-Host "[3/4] 检查 Ollama 和视觉模型..." -ForegroundColor Yellow

$ollama = Get-Command ollama -ErrorAction SilentlyContinue
if (-not $ollama) {
    Write-Host "  [警告] 未找到 ollama 命令" -ForegroundColor DarkYellow
    Write-Host "  请手动安装 Ollama: https://ollama.com" -ForegroundColor DarkYellow
    Write-Host "  然后运行: ollama pull gemma3:4b" -ForegroundColor DarkYellow
} else {
    Write-Host "  Ollama: $($ollama.Source)" -ForegroundColor Green

    # Check if gemma3:4b is pulled
    $models = & ollama list 2>$null | Out-String
    if ($models -match "gemma3:4b") {
        Write-Host "  gemma3:4b 已就绪" -ForegroundColor Green
    } else {
        Write-Host "  正在下载 gemma3:4b (~3.3 GB，请耐心等待)..." -ForegroundColor Gray
        & ollama pull gemma3:4b
        Write-Host "  gemma3:4b 下载完成" -ForegroundColor Green
    }
}

# ── Step 4: 安装 Skill 文件 ──────────────────────────────────
Write-Host "[4/4] 安装 Skill 文件..." -ForegroundColor Yellow

# Copy from script directory (where this installer lives) to Codex skills
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not (Test-Path "$ScriptDir\SKILL.md")) {
    Write-Host "  [错误] 找不到 SKILL.md，请从项目根目录运行此脚本" -ForegroundColor Red
    exit 1
}

# Create skill directory
New-Item -ItemType Directory -Force -Path $CodexSkills | Out-Null
New-Item -ItemType Directory -Force -Path "$CodexSkills\scripts" | Out-Null
New-Item -ItemType Directory -Force -Path "$CodexSkills\agents" | Out-Null

Copy-Item "$ScriptDir\SKILL.md" $CodexSkills -Force
Copy-Item "$ScriptDir\README.md" $CodexSkills -Force
Copy-Item "$ScriptDir\.gitignore" $CodexSkills -Force
Copy-Item "$ScriptDir\agents\openai.yaml" "$CodexSkills\agents" -Force
Copy-Item "$ScriptDir\scripts\recognize_image.py" "$CodexSkills\scripts" -Force

Write-Host "  Skill 已安装到: $CodexSkills" -ForegroundColor Green

# ── Done ─────────────────────────────────────────────────────
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  安装完成！" -ForegroundColor Green
Write-Host "  请重启 Codex 以加载 Skill" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "使用方法:" -ForegroundColor White
Write-Host "  在 Codex 中输入图片路径即可自动识别" -ForegroundColor Gray
Write-Host "  例: 识别 C:\Users\xxx\Pictures\photo.jpg" -ForegroundColor Gray
Write-Host ""
