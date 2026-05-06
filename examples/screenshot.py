#!/usr/bin/env python3
"""
xhs-producer 截图脚本模板
自动检测 HTML 中实际存在的卡片数量，逐张截图为 1080x1350 PNG

使用方式：
  1. 替换 SLUG 变量为实际值
  2. python3 screenshot.py

前置依赖：
  pip3 install playwright
  python3 -m playwright install chromium
"""
from playwright.sync_api import sync_playwright

# ========== 配置 ==========
SLUG = "REPLACE_WITH_SLUG"  # 生成脚本时替换为实际 slug
HTML_PATH = f"/tmp/xhs-{SLUG}/cards.html"
OUTPUT_DIR = f"/tmp/xhs-{SLUG}"
# ==========================

def main():
    with sync_playwright() as p:
        browser = p.chromium.launch()
        page = browser.new_page(viewport={"width": 1080, "height": 1350})
        page.goto(f"file://{HTML_PATH}")
        page.wait_for_load_state("networkidle")

        # 自动探测实际卡片数（检查 #card1 ~ #card20）
        card_count = 0
        for i in range(1, 20):
            if page.locator(f"#card{i}").count() > 0:
                card_count = i
            else:
                break

        if card_count == 0:
            print("❌ 未检测到任何卡片（#card1 不存在），请检查 HTML")
            browser.close()
            return

        print(f"检测到 {card_count} 张卡片")

        for i in range(1, card_count + 1):
            card = page.locator(f"#card{i}")
            output_path = f"{OUTPUT_DIR}/card{i}.png"
            card.screenshot(path=output_path)
            print(f"  Card {i}/{card_count} ✅ → {output_path}")

        browser.close()
        print(f"\n全部完成，共 {card_count} 张 → {OUTPUT_DIR}/")


if __name__ == "__main__":
    main()
