# 深色科技风 + 琥珀金强调 — 已验证模板

> 适用场景：AI 警示/戒律/方法论类内容，需要「科技感 + 警示感」双重氛围。
> 验证于：AI 三大逆定律 (Susam Pal) · 2026-05-06 · 7 张卡片

## CSS 变量

```css
:root {
  --bg-primary: #0a0a0a;
  --bg-card: #0f0f0f;
  --bg-subtle: rgba(255,255,255,0.04);
  --accent: #f59e0b;                 /* 琥珀金，带警示/戒律感 */
  --accent-dim: rgba(245,158,11,0.10);
  --accent-border: rgba(245,158,11,0.30);
  --text-primary: #f5f5f5;
  --text-secondary: rgba(255,255,255,0.46);
  --text-accent: #fcd34d;             /* 浅金色，用于引用/强调 */
  --radius-sm: 8px;
  --radius-md: 14px;
  --radius-lg: 22px;
  --font-zh: "PingFang SC", "Noto Sans SC", "Microsoft YaHei", sans-serif;
  --font-en: "Inter", system-ui, -apple-system, sans-serif;
}
```

## 卡片类型映射

| 卡片 | 类型 | CSS 类 | 组件 |
|------|------|--------|------|
| Card 1 | 封面 | `.card-cover` | 网格装饰 + 中心光晕 + 大标题 + 分隔线 + 钩子 + 来源 |
| Card 2 | 背景/钩子 | `.card-bg` | 标签徽章 + 大标题 + 时间线 (`.tl-item`/`.tl-year`/`.tl-text`/`.tl-line`) |
| Card 3-5 | 观点卡 | `.card-view` | 大背景序号 + 标签 + 英文副标题 + 观点列表 (`.view-point`/`.view-bullet`) + 引用块 (`.quote-box`) |
| Card 6 | 深层逻辑 | `.card-logic` | 标签 + 标题 + 对比表 (`.compare-table`) + 洞察块 (`.insight-block`) |
| Card 7 | 总结 | `.card-end` | 大金句 + Takeaway 列表 (`.end-take`/`.end-num`) + 来源 |

## 已验证的共享组件

- `.card-footer` + `.prog` / `.prog-dot.active` — 底部页码导航
- `.card-tag` — 标签徽章（统一风格）
- `.quote-box` / `.quote-label` / `.quote-text` — 引用块
- `.compare-table` — 两侧对比表（左侧暗色、右侧强调色）

## HTML 注释警告

**绝对禁止**：`<!-- ═══ XXX ═══ -->` 或 `<!-- XXX ──>` 格式。
`═══` 和 `──` 都包含连续 `--`，会提前结束注释，破坏 DOM。
正确格式：`<!-- Card 3：观点 -->`（无连续破折号/等号）。
