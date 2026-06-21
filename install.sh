#!/usr/bin/env bash
# Claude Code 懒人配置包 - Mac/Linux 一键安装脚本
# 用法：bash install.sh
set -e

echo "========================================"
echo "  Claude Code 懒人配置包 - 一键安装"
echo "========================================"
echo ""

# 1. 检查 Claude Code
echo "[1/4] 检查 Claude Code..."
if ! command -v claude &> /dev/null; then
    echo "  未检测到 Claude Code，请先安装：https://claude.ai/code"
    exit 1
fi
echo "  Claude Code 已安装 ✓"

# 2. 配置 settings.json
echo "[2/4] 配置 settings.json..."
CLAUDE_DIR="${HOME}/.claude"
SETTINGS_FILE="${CLAUDE_DIR}/settings.json"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "${CLAUDE_DIR}"

# 备份和合并逻辑用 node 处理 JSON
if command -v node &> /dev/null; then
    node -e "
const fs = require('fs');
const path = require('path');
const settingsFile = process.env.SETTINGS_FILE;
const newSettings = JSON.parse(fs.readFileSync(path.join(process.env.SCRIPT_DIR, 'settings.json'), 'utf8'));
let existing = {};
if (fs.existsSync(settingsFile)) {
    try { existing = JSON.parse(fs.readFileSync(settingsFile, 'utf8')); } catch(e) {}
}
// 合并：不覆盖已有配置
const merged = { ...newSettings, ...existing };
if (newSettings.env) {
    merged.env = { ...newSettings.env, ...(existing.env || {}) };
}
fs.writeFileSync(settingsFile, JSON.stringify(merged, null, 2));
console.log('  settings.json 配置完成 ✓');
" SETTINGS_FILE="$SETTINGS_FILE" SCRIPT_DIR="$SCRIPT_DIR"
else
    # 无 Node 时直接复制
    if [ -f "$SETTINGS_FILE" ]; then
        cp "$SETTINGS_FILE" "${SETTINGS_FILE}.backup.$(date +%Y%m%d%H%M%S)"
        echo "  已有配置已备份"
    fi
    cp "${SCRIPT_DIR}/settings.json" "$SETTINGS_FILE"
    echo "  settings.json 配置完成 ✓ (直接复制，建议安装 Node.js 以获得合并功能)"
fi

# 3. 复制项目文件
echo "[3/4] 复制项目配置文件..."
read -p "  请输入项目目录路径（直接按回车则用当前目录）: " TARGET_DIR
TARGET_DIR="${TARGET_DIR:-$(pwd)}"
mkdir -p "$TARGET_DIR"

# CLAUDE.md
if [ -f "${TARGET_DIR}/CLAUDE.md" ]; then
    cp "${TARGET_DIR}/CLAUDE.md" "${TARGET_DIR}/CLAUDE.md.backup.$(date +%Y%m%d%H%M%S)"
    echo "  已有 CLAUDE.md，已备份"
fi
cp "${SCRIPT_DIR}/CLAUDE.md" "${TARGET_DIR}/CLAUDE.md"
echo "  CLAUDE.md → ${TARGET_DIR}/CLAUDE.md ✓"

# .claudeignore
cp "${SCRIPT_DIR}/.claudeignore" "${TARGET_DIR}/.claudeignore"
echo "  .claudeignore → ${TARGET_DIR}/.claudeignore ✓"

# 4. 可选：安装进阶工具
echo "[4/4] 进阶工具（可选）..."
echo ""
echo "  推荐安装以下两个免费开源工具，进一步省 50-65% Token："
echo "  - Caveman (75K+ GitHub Stars)：让 Claude 说话变简洁"
echo "  - Pith：自动压缩文件读取和命令输出"
echo ""

read -p "  是否安装 Caveman？(y/n，默认 y): " INSTALL_CAVEMAN
INSTALL_CAVEMAN="${INSTALL_CAVEMAN:-y}"
if [ "$INSTALL_CAVEMAN" != "n" ]; then
    echo "  正在安装 Caveman..."
    curl -fsSL https://raw.githubusercontent.com/JuliusBrussee/caveman/main/install.sh | bash || echo "  Caveman 安装失败，可稍后手动安装"
fi

read -p "  是否安装 Pith？(y/n，默认 y): " INSTALL_PITH
INSTALL_PITH="${INSTALL_PITH:-y}"
if [ "$INSTALL_PITH" != "n" ]; then
    echo "  正在安装 Pith..."
    bash <(curl -s https://raw.githubusercontent.com/abhisekjha/pith/main/install.sh) || echo "  Pith 安装失败，可稍后手动安装"
fi

echo ""
echo "========================================"
echo "  全部配置完成！"
echo "========================================"
echo ""
echo "  下次打开 Claude Code 时自动生效。"
echo "  在终端输入 claude 试试看吧！"
echo ""
