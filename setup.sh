#!/bin/bash
# xhs-producer 一键安装脚本
# 安装本 skill 及所有关联依赖到 ~/shared-skills/
set -e

SKILLS_DIR="${HOME}/shared-skills"
echo "🔴 xhs-producer 安装器"
echo "========================"
echo "目标目录: ${SKILLS_DIR}"
echo ""

# 1. 安装 xhs-producer 本体
echo "📦 [1/4] 安装 xhs-producer ..."
if [ -d "${SKILLS_DIR}/xhs-producer" ]; then
  echo "  ↳ 已存在，拉取最新版本"
  cd "${SKILLS_DIR}/xhs-producer" && git pull origin main 2>/dev/null || true
else
  git clone https://github.com/sammyteng/xhs-producer.git "${SKILLS_DIR}/xhs-producer"
fi
echo "  ✅ xhs-producer 就绪"

# 2. 安装 popular-web-designs（54 个品牌设计系统）
echo ""
echo "🎨 [2/4] 安装 popular-web-designs（54 个品牌模板）..."
if [ -d "${SKILLS_DIR}/popular-web-designs" ]; then
  echo "  ✅ 已存在（$(ls ${SKILLS_DIR}/popular-web-designs/templates/ 2>/dev/null | wc -l | tr -d ' ') 个品牌）"
else
  echo "  ⚠️  popular-web-designs 是 Hermes 社区 skill，需手动安装："
  echo "     npx -y @anthropic-ai/hermes install popular-web-designs --dir ${SKILLS_DIR}"
  echo "     或从你的 Hermes skill 源手动复制到 ${SKILLS_DIR}/popular-web-designs/"
fi

# 3. 检查 Python 环境 + Playwright
echo ""
echo "🐍 [3/4] 检查 Python + Playwright ..."
if python3 -c "from playwright.sync_api import sync_playwright" 2>/dev/null; then
  echo "  ✅ Playwright 已安装"
else
  echo "  ⚠️  安装 Playwright: pip3 install playwright && python3 -m playwright install chromium"
fi

# 4. 检查 lark-cli（可选）
echo ""
echo "📄 [4/4] 检查 lark-cli（飞书交付，可选）..."
if command -v lark-cli &>/dev/null; then
  echo "  ✅ lark-cli 已安装"
else
  echo "  ℹ️  lark-cli 未安装（飞书交付功能不可用，可跳过）"
  echo "     安装: npm install -g @anthropic-ai/lark-cli"
fi

echo ""
echo "========================"
echo "🎉 安装完成！"
echo ""
echo "使用方式："
echo "  在 Claude Code / Gemini CLI / Antigravity 中说："
echo "  「帮我做一套小红书图文」"
echo "  「把这篇内容做成小红书」"
echo "  「/xhs-producer [话题]」"
