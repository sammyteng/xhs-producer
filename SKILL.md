---
name: xhs-producer
description: 小红书内容生产器。从任意来源（Obsidian笔记/URL/话题/已有内容）一键生成「标题 + 多图 + 文案」，并通过飞书文档交付。
---

# 小红书内容生产器

> **一句话定义**：给我一个话题或来源，我给你一套完整的小红书发布包：标题、6-9张竖版配图（1080×1350）、图文文案，最终投递到飞书文档。

---

## 触发条件

以下任一情况激活本技能：

- 「帮我做一套小红书图文」
- 「把这篇内容做成小红书」
- 「生成小红书配图 + 文案」
- `/xhs-producer [来源]`

---

## 支持的输入类型

| 输入类型 | 示例 | 处理方式 |
|---------|------|---------|
| Obsidian 笔记路径 | `07_Sources/网页/xxx.md` | 直接 Read |
| URL（网页/博客） | `https://...` | WebFetch / Firecrawl |
| YouTube | `youtube.com/watch?v=...` | yt_long_summary.sh |
| 话题关键词 | "黄仁勋 NVIDIA 护城河" | WebSearch 综合 |
| 直接内容文本 | 用户粘贴的正文 | 直接分析 |
| 已有长图 HTML | `/tmp/xxx/index.html` | 重新解析内容 |

---

## 交付规格

| 产出物 | 规格 | 路径 |
|-------|------|------|
| 封面图 | 1080×1350px PNG | `/tmp/xhs-{slug}/card1.png` |
| 内容图 ×N | 1080×1350px PNG | `/tmp/xhs-{slug}/card2~N.png` |
| 总结图 | 1080×1350px PNG | `/tmp/xhs-{slug}/cardN.png`（末张）|
| 文案 | Markdown | `/tmp/xhs-{slug}/文案.md` |
| 飞书文档 | 含标题+图片+文案 | 返回 URL |

> **张数规则**：6-9 张，根据内容量决定（见下方卡片规划表）

---

## 完整工作流程

### Step 1：内容提炼与规划

**1.1 读取来源内容**

根据输入类型选择对应抓取路径（参见知识库 CLAUDE.md 抓取决策树）。

**1.2 提炼核心观点**

从内容中提取：

```
话题标题：[吸引人的角度，非原标题]
核心钩子：[第一句话，引发好奇/共鸣]
核心观点：[3-5个，每个一句话]
金句：[最有冲击力的原话或改写]
数据支撑：[具体数字/事实]
结论：[一句话总结，可作分享动机]
```

**1.3 规划卡片结构**

张数根据内容量决定，规则如下：

| 内容体量 | 推荐张数 | 判断标准 |
|---------|---------|---------|
| 话题聚焦、观点≤3个 | **6 张** | 单篇文章、短演讲、一个产品 |
| 内容丰富、观点4-5个 | **7-8 张** | 长访谈摘要、多维度分析 |
| 体系庞大、观点≥6个 | **9 张** | 书籍精华、系列内容、全方位拆解 |

**各位置职责（固定首尾，中间弹性）**：

| 位置 | 类型 | 核心内容 | 是否固定 |
|-----|------|---------|---------|
| Card 1 | **封面** | 话题标题 + 副标题 + 最强金句 | ✅ 必有 |
| Card 2 | **钩子/背景** | 为什么这件事值得关注 | ✅ 必有 |
| Card 3~N-2 | **核心观点** | 每张一个观点，带数据/案例/对比图 | 🔄 弹性（1-6张）|
| Card N-1 | **深层逻辑** | 底层原因 / 延伸思考 / 反直觉结论 | ✅ 必有 |
| Card N | **总结** | 一句话结论 + Takeaway 列表 + 来源 | ✅ 必有 |

**扩展卡片类型库**（中间弹性位置可选）：

| 类型 | 适用场景 | 推荐组件 |
|-----|---------|---------|
| 观点卡 | 单个论点展开 | 步骤流程 / 引用框 / 数据行 |
| 对比卡 | 两种方案/时代对比 | 对比表格 / 左右分栏 |
| 数据卡 | 核心数字冲击 | 大号数字 + 说明文字 |
| 案例卡 | 真实事件/案例 | 时间线 / 事件卡 |
| 框架卡 | 方法论/模型 | 2×2 格 / 矩阵图 / 金字塔 |
| 问答卡 | 反驳常见误解 | Q&A 格式 |

---

### Step 2：HTML 卡片生成

**2.1 设计原则**

- **尺寸**：每张 `1080px × 1350px`，独立 `<div class="card">`
- **字体**：`"PingFang SC", "Noto Sans SC", "Microsoft YaHei", sans-serif`（中文首选）+ 设计系统英文字体
- **排版**：标题大字（56-96px）+ 正文中字（24-32px）+ 来源小字（18-20px）
- **层次**：eyebrow 标签 → 主标题 → 副标题 → 内容区 → 底部页码
- **CSS 变量化**：所有颜色/圆角/间距写入 `:root`，方便主题切换

---

**2.2 风格决策流程（三级优先级）**

> 集成 `popular-web-designs` + `huashu-design` + `stitch-ui-design-spec-generator` 的设计决策逻辑

**Level 1 — 品牌匹配（最高优先级）**

若话题涉及已知品牌/产品，直接读取对应设计系统：

```
READ ~/shared-skills/popular-web-designs/templates/<brand>.md
提取：色值 / 字体 / 圆角 / 阴影 / 组件风格
```

可用品牌（54个）：nvidia · apple · notion · linear · stripe · vercel · spotify · cursor · elevenlabs · mistral · claude · figma · framer · raycast · warp · x.ai · spacex · revolut · wise · coinbase · ...

> 💡 `popular-web-designs` 是 Hermes 社区 skill，安装方式见 README.md。若未安装，跳过 Level 1 直接走 Level 2 领域映射。

示例：话题是「NVIDIA / 黄仁勋」→ 加载 `nvidia.md`：
- bg: `#000000`，accent: `#76b900`，字体: Inter，圆角: 1-2px（极小，工程感）
- 装饰元素: 绿色细线边框，非大面积填充

**Level 2 — 领域自动映射（无品牌时）**

根据内容领域自动选择风格（参考 `stitch-ui-design-spec-generator` 的 Domain→Tone 逻辑）：

| 内容领域 | 氛围关键词 | 背景 | 强调色 | 圆角 | 字重风格 |
|---------|----------|------|-------|------|---------|
| 科技 / AI / 芯片 | 工程感、精密 | `#080808` | `#76b900` 或 `#0084ff` | 4-8px | 超粗 900 标题 |
| 产品 / 创业 / SaaS | 专注、现代 | `#0d1117` | `#7c3aed` 或 `#2563eb` | 12-16px | 700-800 |
| 管理 / 职场 | 专业、清晰 | `#0f172a` | `#38bdf8` | 8-12px | 700 |
| 个人成长 / 读书 | 温暖、沉浸 | `#1a1208` | `#f59e0b` 或 `#e07b39` | 16-20px | 700 |
| 财经 / 投资 | 信任、数据 | `#0a100a` | `#22c55e` 金 `#eab308` | 8px | 800 |
| 消费 / 时尚 / 生活 | 轻盈、鲜活 | `#ffffff` 或 `#f8f4f0` | 品牌色 / `#e74c3c` | 20-28px | 600-700 |
| 健康 / 情感 | 平静、治愈 | `#f0f7f4` | `#10b981` | 24px | 500-600 |
| 游戏 / 二次元 | 沉浸、高饱和 | `#0d0015` | `#00ff88` 或 `#ff006e` | 0-4px | 900 斜体 |

**Level 3 — 设计方向探索（用户模糊需求时）**

若用户表达模糊（「做个好看的」「随便」「试试看」），启用 `huashu-design` advisor 模式：

1. 从 20 种设计哲学中选 3 个差异化方向（如：极简主义 × 工程感 × 温暖叙事）
2. 为每个方向生成 1 张 card1（封面）作为视觉样品
3. 展示 3 张给用户选择后，再继续生成全套

> 触发词：「你来决定」「随便」「你觉得什么风格好看」「给我推荐」

---

**2.3 设计系统 CSS 变量模板**

所有风格统一通过 `:root` 变量控制，生成时按上方决策填入：

```css
:root {
  /* 从 Level 1/2/3 决策填入 */
  --bg-primary: #080808;        /* 主背景 */
  --bg-card: #0f0f0f;           /* 卡片背景 */
  --bg-subtle: rgba(255,255,255,0.04); /* 次级背景 */
  --accent: #76b900;            /* 品牌强调色 */
  --accent-dim: rgba(118,185,0,0.15); /* 强调色淡化 */
  --accent-border: rgba(118,185,0,0.4); /* 边框色 */
  --text-primary: #ffffff;      /* 主文字 */
  --text-secondary: rgba(255,255,255,0.55); /* 次文字 */
  --text-accent: #d0f0a0;       /* 强调文字（近accent的亮色） */
  --radius-sm: 8px;             /* 小圆角（标签、徽章） */
  --radius-md: 16px;            /* 中圆角（卡片内组件） */
  --radius-lg: 24px;            /* 大圆角（主卡片内容块） */
  --font-en: 'Inter', system-ui, sans-serif; /* 英文/数字字体 */
}
```

引用时统一使用变量：
```css
.card { background: var(--bg-primary); }
.card-tag { background: var(--accent-dim); border-color: var(--accent-border); color: var(--accent); }
.fw-circle { background: var(--accent); }
```

---

**2.4 HTML 文件结构**

> ⚠️ **HTML 注释杀手**：HTML 注释中**绝对不能出现两个连续连字符 `--`**（注释开始/结束标记之外）。如 `<!-- ═══ Card 3 ──>` 会因 `──` 被解析为注释结束而破坏后续 DOM。如需分隔注释，用单字符如 `<!-- Card 3 -->`。

所有卡片写在单个 HTML 文件，每张 card 一个 div：

```html
<!DOCTYPE html>
<html lang="zh">
<head>
<meta charset="UTF-8">
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  body { font-family: "PingFang SC", "Noto Sans SC", sans-serif; background: #f0f0f0; }

  .card {
    width: 1080px;
    height: 1350px;
    display: flex;
    flex-direction: column;
    position: relative;
    overflow: hidden;
    margin-bottom: 40px;  /* 卡片间距，方便调试 */
  }
  /* 各卡片样式... */
</style>
</head>
<body>
  <div class="card card-1" id="card1">...</div>
  <div class="card card-2" id="card2">...</div>
  <!-- ... -->
  <div class="card card-6" id="card6">...</div>
</body>
</html>
```

**2.5 常用组件代码片段（全部使用 CSS 变量）**

> 所有颜色引用 `:root` 变量，切换风格只需改变量值，无需逐一修改组件。

**封面 Hero 区（Card 1）**
```css
.card-cover { background: var(--bg-primary); justify-content: center; align-items: center; }

.bg-grid {  /* 网格背景装饰 — 颜色跟随强调色 */
  position: absolute; inset: 0;
  background-image:
    linear-gradient(color-mix(in srgb, var(--accent) 8%, transparent) 1px, transparent 1px),
    linear-gradient(90deg, color-mix(in srgb, var(--accent) 8%, transparent) 1px, transparent 1px);
  background-size: 60px 60px;
}
.glow {  /* 中心光晕 */
  position: absolute; width: 600px; height: 600px; border-radius: 50%;
  background: radial-gradient(circle, color-mix(in srgb, var(--accent) 18%, transparent) 0%, transparent 70%);
  top: 50%; left: 50%; transform: translate(-50%, -50%);
}
```

**标签徽章**
```html
<div class="card-tag">🛡️ 观点一</div>
```
```css
.card-tag {
  display: inline-block;
  background: var(--accent-dim); border: 1px solid var(--accent-border); color: var(--accent);
  font-size: 22px; padding: 8px 24px;
  border-radius: var(--radius-sm); font-weight: 600; margin-bottom: 36px;
  letter-spacing: 1px;
}
```

**流程步骤（带连接线）**
```html
<div class="fw-item">
  <div class="fw-left">
    <div class="fw-circle">1</div>
    <div class="fw-line"></div>  <!-- 最后一项不加 -->
  </div>
  <div class="fw-body">
    <div class="fw-label">步骤标题</div>
    <div class="fw-desc">步骤说明</div>
  </div>
</div>
```
```css
.fw-circle { width:48px; height:48px; border-radius:50%; background:var(--accent);
  display:flex; align-items:center; justify-content:center;
  font-size:22px; font-weight:700; color:var(--bg-primary); flex-shrink:0; }
.fw-line { width:2px; flex:1; min-height:36px;
  background:linear-gradient(to bottom, var(--accent), var(--accent-dim)); }
.fw-label { font-size:30px; font-weight:700; color:var(--text-primary); margin-bottom:8px; }
.fw-desc { font-size:24px; color:var(--text-secondary); line-height:1.5; }
```

**2×2 卡片格**
```html
<div class="grid-2x2">
  <div class="grid-card known">...</div>
  <div class="grid-card known">...</div>
  <div class="grid-card known">...</div>
  <div class="grid-card hot">...</div>  <!-- 高亮卡（最后一个或关键卡）-->
</div>
```
```css
.grid-2x2 { display:grid; grid-template-columns:1fr 1fr; gap:24px; }
.grid-card { border-radius:var(--radius-md); padding:36px 32px; position:relative; overflow:hidden; }
.grid-card.known { background:var(--bg-subtle); border:1px solid rgba(255,255,255,0.1); }
.grid-card.hot { background:linear-gradient(135deg,var(--accent-dim),transparent);
  border:1.5px solid var(--accent-border); }
```

**对比表格**
```html
<table class="compare-table">
  <tr><th>传统方式</th><th>新方式</th></tr>
  <tr><td>...</td><td>...</td></tr>
</table>
```
```css
.compare-table { width:100%; border-collapse:separate; border-radius:var(--radius-md); overflow:hidden; }
.compare-table th { padding:24px 32px; font-size:24px; font-weight:700; text-align:left; }
.compare-table th:first-child { background:var(--bg-subtle); color:var(--text-secondary); }
.compare-table th:last-child { background:var(--accent-dim); color:var(--accent); }
.compare-table td { padding:22px 32px; font-size:26px; border-top:1px solid rgba(255,255,255,0.05); }
.compare-table td:first-child { background:rgba(255,255,255,0.02); color:var(--text-secondary); }
.compare-table td:last-child { background:rgba(255,255,255,0.02); color:var(--text-accent); font-weight:600; }
```

**金句引用块**
```html
<div class="quote-box">
  <div class="quote-label">核心原话</div>
  <div class="quote-text">"引用原文..."</div>
</div>
```
```css
.quote-box { background:linear-gradient(135deg,var(--accent-dim),transparent);
  border:1px solid var(--accent-border); border-radius:var(--radius-md); padding:36px 44px; }
.quote-label { font-size:20px; color:var(--accent); margin-bottom:14px; font-weight:600; letter-spacing:1px; }
.quote-text { font-size:28px; color:var(--text-accent); line-height:1.65; font-style:italic; }
```

**数据统计行**
```html
<div class="stat-row highlight">  <!-- highlight 可选，加强调背景 -->
  <div class="stat-num">×10</div>
  <div class="stat-info">
    <div class="stat-title">每年能源效率提升</div>
    <div class="stat-desc">每瓦特/秒Token处理能力年提升10倍</div>
  </div>
</div>
```
```css
.stat-row { display:flex; align-items:center; background:var(--bg-subtle);
  border:1px solid rgba(255,255,255,0.08); border-radius:var(--radius-md); padding:36px 44px; gap:40px; }
.stat-row.highlight { background:var(--accent-dim); border-color:var(--accent-border); }
.stat-num { font-size:72px; font-weight:900; color:var(--accent); min-width:180px; line-height:1; }
.stat-title { font-size:30px; font-weight:700; color:var(--text-primary); margin-bottom:8px; }
.stat-desc { font-size:24px; color:var(--text-secondary); line-height:1.5; }
```

**底部页码导航**
```html
<div class="card-footer">
  <span>系列标题</span>
  <div class="prog">
    <div class="prog-dot active"></div>
    <div class="prog-dot"></div> <!-- 按实际卡片数重复 -->
  </div>
</div>
```
```css
.card-footer { position:absolute; bottom:52px; left:72px; right:72px;
  display:flex; justify-content:space-between; align-items:center;
  color:var(--text-secondary); font-size:20px; opacity:0.5; }
.prog { display:flex; gap:8px; align-items:center; }
.prog-dot { width:8px; height:8px; border-radius:50%; background:rgba(255,255,255,0.15); }
.prog-dot.active { background:var(--accent); }
```

**大号背景序号**
```html
<div class="card-section-num">02</div>
```
```css
.card-section-num { font-size:120px; font-weight:900;
  color:color-mix(in srgb, var(--accent) 12%, transparent);
  line-height:1; position:absolute; top:60px; right:60px; font-variant-numeric:tabular-nums; }
```

---

### Step 3：Playwright 截图

**3.0 前置依赖检查**

```bash
# 检查 playwright 是否已安装
python3 -c "from playwright.sync_api import sync_playwright" 2>/dev/null || {
  echo "Installing playwright..."
  pip3 install playwright
  python3 -m playwright install chromium
}
```

**3.1 输出目录**

```bash
SLUG=$(echo "$TOPIC" | sed 's/ /-/g' | head -c 20)
mkdir -p /tmp/xhs-${SLUG}
# HTML 路径：/tmp/xhs-${SLUG}/cards.html
# 截图路径：/tmp/xhs-${SLUG}/card1.png 到 card6.png
```

**3.2 截图脚本（必须使用 Python playwright API，不用 CLI）**

> ⚠️ **执行环境**：截图脚本**必须通过 `terminal` 运行**，不能通过 `execute_code`（沙箱环境通常不含 Playwright）。先 `write_file` 写出脚本，再用 `terminal` 执行 `python3 screenshot.py`。

脚本自动检测 HTML 中实际存在的卡片数量（无需硬编码）：

```python
# /tmp/xhs-{slug}/screenshot.py
from playwright.sync_api import sync_playwright

SLUG = "REPLACE_WITH_SLUG"  # 生成脚本时替换

with sync_playwright() as p:
    browser = p.chromium.launch()
    page = browser.new_page(viewport={"width": 1080, "height": 1350})
    page.goto(f"file:///tmp/xhs-{SLUG}/cards.html")
    page.wait_for_load_state("networkidle")

    # 自动探测实际卡片数（检查 #card1 ~ #card9）
    card_count = 0
    for i in range(1, 10):
        if page.locator(f"#card{i}").count() > 0:
            card_count = i
        else:
            break

    print(f"检测到 {card_count} 张卡片")

    for i in range(1, card_count + 1):
        card = page.locator(f"#card{i}")
        card.screenshot(path=f"/tmp/xhs-{SLUG}/card{i}.png")
        print(f"Card {i}/{card_count} ✅")

    browser.close()
    print(f"全部完成，共 {card_count} 张")
```

执行：

```bash
python3 /tmp/xhs-${SLUG}/screenshot.py
```

**3.3 截图质量检查**

> 用 `vision_analyze` 验证首末两张截图。注意：部分模型（如 deepseek）不支持 vision，此时可跳过视觉验证，通过 Playwright 的卡片探测数量（应等于预期张数）和文件大小验证 DOM 完整性。

截图完成后，用 Read 工具读取 card1.png 和最后一张（cardN.png）验证：
- 文字是否完整显示（无截断）
- 色彩是否正确（背景色/强调色）
- 内容是否超出边界
- 底部导航是否清晰

如发现问题，修改 HTML → 重新截图。

> ⚠️ **DeepSeek 模型限制**：DeepSeek 不支持 vision/图片分析。使用该模型时，跳过 `vision_analyze` 验证，依赖 Playwright DOM 探测 + 文件大小检查作为替代验证手段。
>
> **DeepSeek 文件大小验证命令**：
> ```bash
> ls -lh /tmp/xhs-${SLUG}/card*.png | awk '{print $5, $NF}'
> ```
> 健康范围：纯文本卡片 60-90KB，含渐变/光晕的卡片 140-200KB。全部文件 ≥50KB 且无 0B 文件即为通过。

---

### Step 4：文案撰写

> 基于小红书算法研究与爆款案例提炼。核心逻辑：**算法看收藏 > 点赞 > 评论**，收藏驱动分发。

---

**4.1 标题公式（决定流量入口）**

标题是第一道门槛，前 10 个字决定点击率。规则：

**硬规则**：默认标题控制在 **20 字以内**。标题必须先让人看懂「谁的痛点 / 什么冲突 / 为什么和我有关」，不要写成工具发布说明。

自检标准：

- 有重点：能看出本文核心对象或场景，而不是泛泛说“深度解析”。
- 有冲突：包含痛点、反差、误解、成本、失败、终于解决等张力。
- 有人味：像一个真实用户/打工人/创始人的感受，不像 PR 稿或论文标题。
- 不绕弯：不要用“全面解读、深度解析、重磅升级、效率革命”这类空话。

优先标题模板：

| 模板 | 示例 | 适用场景 |
|-----|------|---------|
| 工具 + 戳中痛点 | 「Claude Code戳中打工人痛点」 | AI 工具/产品更新 |
| 旧流程 + 新结果 | 「AI干完活，我还在写汇报」 | 工作流/效率 |
| 人群 + 别再低效做法 | 「产品经理别再手搓周报了」 | 职场/工具 |
| 终于 + 具体变化 | 「终端成果终于能给人看了」 | 技术能力可视化 |
| 不是 X，而是 Y | 「不是更强，是更好交付了」 | 反常识判断 |

| 公式 | 示例 | 适用场景 |
|-----|------|---------|
| 数字 + 颠覆认知 | 「3个观点彻底颠覆我对NVIDIA的认知」 | 知识/科技 |
| 痛点 + 解决方案 | 「一直搞不懂AI护城河？看这一篇就够了」 | 教程/工具 |
| 身份共鸣 + 事件 | 「做销售运营3年，这本书改变了我的打法」 | 职场/成长 |
| 名人/品牌 + 反常细节 | 「黄仁勋这个管理方式让我觉得他很不一样」 | 人物/品牌 |
| 时间 + 结果 + 经验 | 「花2.5小时，整理了5个真判断」 | 内容精华 |
| 悬念 + 结论 | 「大家都说买GPU，但NVIDIA真正卖的不是这个」 | 反常识 |

**加分项**：标题带具体人群、真实痛点、反常识转折；总长 12-20 字最优。

**禁忌**：纯描述性标题（「关于XXX的分享」）、默认超过 20 字、无冲突、像官方公告。

---

**4.2 正文结构：鱼骨法**

```
🪝 鱼头（开篇钩子）— 前3行是生死线
   ↓
🦴 鱼骨（每张图的段落标题）— 结构感让人愿意读完
   ↓
🥩 鱼肉（每个观点的展开）— 数据/故事/原话支撑
   ↓
🎯 鱼尾（结论 + CTA）— 引导收藏/评论/关注
   ↓
🏷️ 标签（5-10个）— 流量分发的钥匙
```

**完整文案模板**：

```
[标题]

🪝 开篇（图1）
[场景共鸣/反问/数据冲击，≤20字一句]
[交代来源可信度：「看了X小时访谈/读了这本书...」]
[预告收获：「整理了X个颠覆认知的观点👇」]

· · ·

💡 [观点1小标题]（图2）
[核心论点1句，口语化]
[支撑证据：数据 or 原话 or 案例，1-2句]
[个人感受/延伸，拉近距离，1句]

💡 [观点2小标题]（图3）
[同上结构...]

💡 [观点3小标题]（图4）
[同上结构...]

[如有图5/6/7，按卡片类型延续...]

· · ·

🎯 结论（图N）
[一句话总结，可引用金句]
[点明分享价值：「如果你也在研究X，建议收藏」]
[轻量CTA：「你怎么看？评论区聊聊」]

---
[话题标签行]
📌 来源：[来源信息]
```

---

**4.3 段落排版规则**

| 规则 | 标准 | 原因 |
|-----|------|------|
| 总字数 | **800-1200字** | 低于300字收藏率↓78%；超过1500字阅读完成率骤降 |
| 每段行数 | **3-5行** | 手机单屏可见，避免视觉疲劳 |
| 段间节奏 | 空行 + 分隔符（`· · ·`或`—`） | 视觉呼吸感，章节感 |
| 句子长度 | **≤20字/句** | 手机阅读，短句更易扫读 |
| 连词使用 | 去掉「然而」「因此」「综上所述」 | 口语化，不像论文 |

---

**4.4 Emoji 使用规范**

- **段落开头**：用于标记段落类型（💡观点 / 🎯结论 / ⚡数据 / 📌来源）
- **段落结尾**：用于情绪收尾（👇 / ✅ / 🔥）
- **每段1-2个**：不超过2个，超量显得廉价
- **高效能 emoji 清单**：💡❗⭐👉📌🎯⚡✅👀🔥💪
- **禁止**：每句都有emoji、纯装饰性连续emoji（👏👏👏）

---

**4.5 话题标签策略（5-10个）**

```
结构：2-3个大流量词 + 3-4个垂直词 + 1-2个话题词

大流量（曝光）：#AI #科技 #职场干货 #个人成长
垂直精准（转化）：#黄仁勋 #NVIDIA #AI芯片 #大模型
话题关联（借势）：#Lex访谈 #科技人物
```

**规则**：
- 大词 + 小词 = 既要流量也要精准受众
- **不超过10个**：超量被算法判定为堆砌
- 放在正文最后，单独一行
- 垂直词权重高于泛化词，优先确保3-4个垂直词

---

**4.6 文案保存**

```bash
cat > /tmp/xhs-${SLUG}/文案.md << 'EOF'
# [标题]（≤20字，有重点、有冲突、有人味）

> 配图：card1.png ~ cardN.png（共N张）| 目标字数：800-1200字

---

[完整正文，按4.2模板结构填写]

---

#话题1 #话题2 #话题3 #话题4 #话题5 #话题6

📌 来源：[来源信息]
EOF
```

---

### Step 5：飞书文档交付（lark-cli docs 快捷方式，推荐）

> **前提**：`lark-cli config show` 可见 appId。
> **关键原则**：全程用 `--as bot` + `lark-cli docs` 子命令，比原始 API 调用更可靠。
> **无需用户登录**：`--as bot` 模式下 docs +create/+update/+media-insert 均可用。

**5.1 创建文档（一步搞定）**

> ⚠️ **JSON 解析陷阱**：`lark-cli` stdout 可能夹杂 warning/deprecated 行（如 `[lark-cli] [WARN] proxy detected`），`python3 -c "json.load(sys.stdin)"` 会失败。详见 `feishu-lark-cli-workflows` Skill 的 Workflow 5 附节。

```bash
# 方法一：手动提取（推荐，最快）
RESULT=$(lark-cli docs +create \
  --title "小红书 | ${TOPIC} | $(date +%Y-%m-%d)" \
  --markdown "由 Hermes Agent 创建 | 来源页头文字" \
  --as bot 2>&1)
echo "$RESULT"
# 从输出中直接读取 doc_id 和 doc_url，手动赋值：
# DOC_ID="XpPPd..."
# DOC_URL="https://www.feishu.cn/docx/..."

# 方法二：brace-matching 解析（稳健）
DOC_ID=$(echo "$RESULT" | python3 -c "
import sys, json
raw = sys.stdin.read()
start = raw.find('{\"ok\"')
if start < 0: sys.exit(1)
depth = 0; end = start
for i, ch in enumerate(raw[start:], start):
    if ch == '{': depth += 1
    elif ch == '}':
        depth -= 1
        if depth == 0: end = i + 1; break
print(json.loads(raw[start:end])['data']['doc_id'])
")
DOC_URL=$(echo "$RESULT" | python3 -c "
import sys, json
raw = sys.stdin.read()
start = raw.find('{\"ok\"')
if start < 0: sys.exit(1)
depth = 0; end = start
for i, ch in enumerate(raw[start:], start):
    if ch == '{': depth += 1
    elif ch == '}':
        depth -= 1
        if depth == 0: end = i + 1; break
print(json.loads(raw[start:end])['data']['doc_url'])
")
```

**5.2 逐张插入图片（⚠️ 必须用相对路径）**

```bash
cd /tmp/xhs-${SLUG}  # 必须 cd 到图片目录！--file 只接受相对路径

for i in $(seq 1 $CARD_COUNT); do
  echo "上传 card${i}.png ..."
  lark-cli docs +media-insert \
    --doc "$DOC_ID" \
    --file "./card${i}.png" \
    --as bot
done
```

> ⚠️ **绝对路径陷阱**：`--file` 参数**只接受相对路径**（如 `./card1.png`），传绝对路径会报 `unsafe file path`。

**5.3 追加文案内容**

```bash
lark-cli docs +update \
  --doc "$DOC_ID" \
  --mode append \
  --markdown "$(cat /tmp/xhs-${SLUG}/文案.md)" \
  --as bot
```

> ⚠️ 如果文案中包含反引号或特殊字符，用 `--markdown @/tmp/xhs-${SLUG}/文案.md` 从文件读取更安全。

**5.4 授权用户访问（Bot 创建文档后必须操作）**

Bot 创建的文档默认只有 Bot 自己能访问。需要为当前用户授权 `full_access`。

详见 [`references/feishu-permission-flow.md`](references/feishu-permission-flow.md)。

快速流程（用上述 reference 的完整脚本）：

```bash
# 1. 获取用户 open_id
USER_OPEN_ID=$(lark-cli api GET "/open-apis/contact/v3/users?page_size=20" --as bot \
  | python3 -c "import sys,json; items=json.load(sys.stdin)['data']['items'];
     [print(u['open_id']) for u in items if '滕' in u.get('name','') or '思琪' in u.get('name','')]")

# 2. 授权
lark-cli api POST "/open-apis/drive/v1/permissions/${DOC_ID}/members" \
  --data "{\"member_type\":\"openid\",\"member_id\":\"${USER_OPEN_ID}\",\"perm\":\"full_access\",\"type\":\"user\"}" \
  --params '{"type":"docx"}' \
  --as bot
```

**5.5 返回链接**

```bash
echo "✅ 飞书文档已创建：${DOC_URL}"
echo "本地文件：/tmp/xhs-${SLUG}/"
```

---

### Step 6：（备选）Chrome 手动模式

> 当 lark-cli 图片上传失败时使用。

1. 用 `claude-in-chrome` 打开 `https://www.feishu.cn/docs`
2. 创建新文档，填入标题
3. 用 `/` 插入菜单逐张上传本地图片
4. 粘贴文案
5. 获取并返回文档链接

---

## ⚠️ 平台审查差异（与公众号对比）

| 平台 | 审查严格度 | 政治/时政内容 | 建议 |
|------|----------|-------------|------|
| 小红书 | 🟡 较宽松 | 图文信息流不触发关键词审查，轻度时政可发 | 适合信息图传播，数据可视化类时政内容 |
| 公众号 | 🔴 严格 | 严禁政治叙事、中美博弈、「卡脖子」等框架 | 只发纯商业/技术选题 |

> 💡 **分工策略**：同一批新闻素材，硬核时政/博弈类走小红书信息图，安全商业分析走公众号。两篇定位互补：小红书打传播，公众号打深度。

| 问题 | 处理方式 |
|-----|---------|
| Playwright 未安装 (`ModuleNotFoundError`) | `pip3 install playwright && python3 -m playwright install chromium`（3.0 节已内置检查） |
| 图片截图不完整 | 检查 HTML 高度是否恰好 1350px，card div 是否有 `overflow:hidden` |
| 中文字体显示异常 | 确认字体栈包含 `"Noto Sans SC"` 作为备用 |
| Playwright 找不到元素 | 确认 `id="card1"` 存在，用 `page.wait_for_load_state("networkidle")` |
| 飞书 `unsafe file path` | **`--file` 必须用相对路径**（`./card1.png`），先 `cd` 到图片目录 |
| 飞书 bot 创建后文档打不开 | 用 5.4 节流程为用户授权 `full_access`（见 references/feishu-permission-flow.md） |
| 飞书权限 API 返回 99992402 | `type` 字段应为 `"user"`（不是 `"docx"`），详见 references/feishu-permission-flow.md |
| 飞书上传失败 | 检查文件路径和大小，PNG 单张通常 60-200KB（纯 CSS 卡片），含位图素材的卡片可能达 500KB-2MB |
| chrome-in-chrome 登录态失效 | 提示用户重新登录飞书后再操作 |
| Playwright 只检测到部分卡片 | HTML 注释中可能包含 `--` 序列破坏了 DOM。修复：`sed -i '' '/<!-- ═══/d' cards.html` 删除所有含特殊字符的注释行，然后重跑截图 |

---

## 快速检查清单

执行完毕前，逐项确认：

- [ ] 内容提炼：核心观点≥3个，有金句有数据
- [ ] 张数决策：根据观点数量确定 6/7/8/9 张（见卡片规划表）
- [ ] 卡片规划：首尾固定（封面+总结），中间弹性，每张主题明确
- [ ] HTML 生成：所有卡片 `id` 连续正确（`card1` ~ `cardN`，N=6~9）
- [ ] 截图脚本：自动探测卡片数，无硬编码 `range(1,7)`
- [ ] 截图质量：Read 工具查看首张和末张，无截断/溢出
- [ ] 文案完整：标题 + 每张图配文（图1~图N）+ 话题标签 + 来源
- [ ] 飞书上传：图片数量与文案图号一致，**所有 --file 参数均为相对路径**
- [ ] 飞书权限：Bot 创建后已为用户授权 full_access（5.4 节）
- [ ] 返回给用户：飞书文档 URL + 本地文件路径 + 共 N 张图

---

## 与公众号的双平台互补策略

小红书审核尺度比公众号宽松。当选题涉及中美科技/芯片/地缘时：

| 平台 | 策略 | 说明 |
|------|------|------|
| 小红书 | 可发信息图/行业对比 | 图文信息流不触发关键词审查 |
| 公众号 | 必须转写为纯商业/纯技术角度 | 见 `wechat-article-writer` 安全红线 |

> 💡 **核心原则**：高热度但微敏感选题 → 小红书信息图打传播，公众号转安全角度打深度。两篇互补，不浪费任何选题。

---

## 示例调用

```
用户：把这篇 Karpathy 的 Sequoia 演讲笔记做成小红书图文，发到飞书

Claude：
1. Read 07_Sources/网页/2026-04-29_Karpathy_...md
2. 提炼 4 个核心观点 + 金句
3. 生成 6 张暗色系 HTML 卡片（蓝色强调）
4. Python Playwright 截图
5. 撰写文案（标题：「Karpathy 这句话让我重新理解了 AI 工程师的边界」）
6. chrome-in-chrome 创建飞书文档，上传图片，填入文案
7. 返回：✅ 飞书文档已创建：https://xxx.feishu.cn/docs/xxx
```

---

## 相关技能

- `huashu-design` — HTML 视觉设计通用规范
- `feishu-doc-writer` — 飞书 Docx Block API 详细文档
- `feishu-rich-document-generator` — 飞书富文本文档模板
- `qiaomu-anything-to-notebooklm` — 内容 → NotebookLM 播客

---

*创建：2026-05-06 | 首次使用：黄仁勋×NVIDIA系列*
