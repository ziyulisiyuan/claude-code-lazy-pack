# Claude Code 懒人配置包 - Windows 一键安装脚本
# 右键 → "使用 PowerShell 运行"，或者在终端里输入：.\install.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Claude Code 懒人配置包 - 一键安装" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. 检查 Claude Code 是否安装
Write-Host "[1/4] 检查 Claude Code..." -ForegroundColor Yellow
$claudeInstalled = Get-Command claude -ErrorAction SilentlyContinue
if (-not $claudeInstalled) {
    Write-Host "  未检测到 Claude Code，请先安装：https://claude.ai/code" -ForegroundColor Red
    Write-Host "  安装完成后重新运行此脚本。" -ForegroundColor Red
    pause
    exit 1
}
Write-Host "  Claude Code 已安装 ✓" -ForegroundColor Green

# 2. 配置 settings.json
Write-Host "[2/4] 配置 settings.json..." -ForegroundColor Yellow
$claudeDir = "$env:USERPROFILE\.claude"
$settingsFile = "$claudeDir\settings.json"

# 确保目录存在
if (-not (Test-Path $claudeDir)) {
    New-Item -ItemType Directory -Force -Path $claudeDir | Out-Null
}

# 读取现有配置（如果有的话）
$existingSettings = @{}
if (Test-Path $settingsFile) {
    try {
        $existingSettings = Get-Content $settingsFile -Raw -Encoding UTF8 | ConvertFrom-Json
        Write-Host "  检测到已有配置，将合并（不覆盖你的设置）" -ForegroundColor Gray
    } catch {
        Write-Host "  已有配置文件格式有误，将备份后覆盖" -ForegroundColor Gray
        Copy-Item $settingsFile "$settingsFile.backup" -Force
    }
}

# 合并新配置
$newSettings = Get-Content "$PSScriptRoot\settings.json" -Raw -Encoding UTF8 | ConvertFrom-Json
$mergedSettings = $existingSettings

# 只添加缺失的配置项，不覆盖已有项
foreach ($prop in $newSettings.PSObject.Properties) {
    $existingValue = $mergedSettings.PSObject.Properties | Where-Object { $_.Name -eq $prop.Name }
    if (-not $existingValue) {
        $mergedSettings | Add-Member -MemberType NoteProperty -Name $prop.Name -Value $prop.Value -Force
        Write-Host "  添加: $($prop.Name)" -ForegroundColor Gray
    } else {
        Write-Host "  保留: $($prop.Name)（你已有配置，不覆盖）" -ForegroundColor Gray
    }
}

# 特殊处理 env 合并
if ($newSettings.env) {
    if (-not $mergedSettings.env) {
        $mergedSettings | Add-Member -MemberType NoteProperty -Name "env" -Value @{} -Force
    }
    foreach ($envProp in $newSettings.env.PSObject.Properties) {
        $existingEnv = $mergedSettings.env.PSObject.Properties | Where-Object { $_.Name -eq $envProp.Name }
        if (-not $existingEnv) {
            $mergedSettings.env | Add-Member -MemberType NoteProperty -Name $envProp.Name -Value $envProp.Value -Force
            Write-Host "  添加环境变量: $($envProp.Name) = $($envProp.Value)" -ForegroundColor Gray
        }
    }
}

$mergedSettings | ConvertTo-Json -Depth 10 | Set-Content $settingsFile -Encoding UTF8
Write-Host "  settings.json 配置完成 ✓" -ForegroundColor Green

# 3. 复制项目文件
Write-Host "[3/4] 复制项目配置文件..." -ForegroundColor Yellow
$targetDir = Read-Host "  请输入项目目录路径（直接按回车则用当前目录）"
if ([string]::IsNullOrWhiteSpace($targetDir)) {
    $targetDir = (Get-Location).Path
}

# 确保目标目录存在
if (-not (Test-Path $targetDir)) {
    Write-Host "  目录不存在，创建: $targetDir" -ForegroundColor Gray
    New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
}

# 复制 CLAUDE.md
$claudeMdSource = "$PSScriptRoot\CLAUDE.md"
$claudeMdTarget = "$targetDir\CLAUDE.md"
if (Test-Path $claudeMdTarget) {
    $backup = "$claudeMdTarget.backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
    Copy-Item $claudeMdTarget $backup -Force
    Write-Host "  已有 CLAUDE.md，备份到: $backup" -ForegroundColor Gray
}
Copy-Item $claudeMdSource $claudeMdTarget -Force
Write-Host "  CLAUDE.md → $claudeMdTarget ✓" -ForegroundColor Green

# 复制 .claudeignore
$claudeignoreSource = "$PSScriptRoot\.claudeignore"
$claudeignoreTarget = "$targetDir\.claudeignore"
Copy-Item $claudeignoreSource $claudeignoreTarget -Force
Write-Host "  .claudeignore → $claudeignoreTarget ✓" -ForegroundColor Green

# 4. 可选：安装进阶工具
Write-Host "[4/4] 进阶工具（可选）..." -ForegroundColor Yellow
Write-Host ""
Write-Host "  推荐安装以下两个免费开源工具，进一步省 50-65% Token：" -ForegroundColor White
Write-Host "  - Caveman (75K+ GitHub Stars)：让我说话变简洁"
Write-Host "  - Pith：自动压缩文件读取和命令输出"
Write-Host ""

$installCaveman = Read-Host "  是否安装 Caveman？(y/n，默认 y)"
if ($installCaveman -ne "n") {
    Write-Host "  正在安装 Caveman..." -ForegroundColor Gray
    try {
        $script = Invoke-WebRequest -Uri "https://raw.githubusercontent.com/JuliusBrussee/caveman/main/install.ps1" -UseBasicParsing
        $script.Content | Out-File -FilePath "$env:TEMP\caveman-install.ps1" -Encoding utf8
        & "$env:TEMP\caveman-install.ps1"
        Write-Host "  Caveman 安装完成 ✓" -ForegroundColor Green
    } catch {
        Write-Host "  Caveman 安装失败，可稍后手动安装" -ForegroundColor Yellow
    }
}

$installPith = Read-Host "  是否安装 Pith？(y/n，默认 y)"
if ($installPith -ne "n") {
    Write-Host "  正在安装 Pith（需要 Git Bash）..." -ForegroundColor Gray
    try {
        bash -c "bash <(curl -s https://raw.githubusercontent.com/abhisekjha/pith/main/install.sh)"
        Write-Host "  Pith 安装完成 ✓" -ForegroundColor Green
    } catch {
        Write-Host "  Pith 安装失败（可能需要安装 Git Bash），可稍后手动安装" -ForegroundColor Yellow
    }
}

# 完成
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  全部配置完成！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  下次打开 Claude Code 时自动生效。" -ForegroundColor White
Write-Host "  在终端输入 claude 试试看吧！" -ForegroundColor White
Write-Host ""
Write-Host "  已配置的优化项：" -ForegroundColor White
Write-Host "  ✓ 默认使用 Sonnet 模型（省钱 60%，够用）" -ForegroundColor Gray
Write-Host "  ✓ 限制思考 Token（省 70% 思考费）" -ForegroundColor Gray
Write-Host "  ✓ 小助手用 Haiku（省 80% 子任务费）" -ForegroundColor Gray
Write-Host "  ✓ 缓存延长到 1 小时（减少重复扣费）" -ForegroundColor Gray
Write-Host "  ✓ 自动压缩触发线 60%（保持上下文清爽）" -ForegroundColor Gray
Write-Host "  ✓ 智能模型切换提醒（复杂任务自动建议切 Opus）" -ForegroundColor Gray
Write-Host ""

pause
