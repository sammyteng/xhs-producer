# 小红书内容生产器 (`xhs-producer`)

> 🔴 **Agent Skill** — Claude Code · Codex · Gemini CLI · Antigravity 通用

从任意来源（Obsidian 笔记 / URL / YouTube / 话题关键词 / 直接文本）**一键生成完整的小红书发布包**：标题、6-9 张竖版配图（1080×1350px）、文案，最终投递到飞书文档。

## 效果

- 📐 **1080×1350px 竖版配图**，6-9 张，HTML 单文件 → Playwright 自动截图
- 🎨 **54 个品牌设计系统**内置（NVIDIA/Apple/Notion/Linear...），话题匹配品牌时自动套用
- 📝 **爆款文案公式**，基于小红书算法研究（收藏 > 点赞 > 评论），800-1200 字最优区间
- 📄 **飞书文档一键交付**，Bot 创建 + 图片上传 + 文案插入 + 权限授予

## 触发方式

在对话中提到以下关键词时自动触发：

- 「帮我做一套小红书图文」
- 「把这篇内容做成小红书」
- 「生成小红书配图 + 文案」
- `/xhs-producer [来源]`

## 支持的输入类型

| 输入类型 | 示例 |
|---------|------|
| Obsidian 笔记 | `07_Sources/网页/xxx.md` |
| URL | `https://...` |
| YouTube | `youtube.com/watch?v=...` |
| 话题关键词 | "黄仁勋 NVIDIA 护城河" |
| 直接文本 | 用户粘贴的正文 |

## 工作流程

```
Step 1: 内容提炼 → 提取核心观点/金句/数据，规划卡片数量与类型
Step 2: HTML 生成 → 品牌匹配/领域映射/风格决策 → CSS 变量化 → 组件拼装
Step 3: 截图      → Playwright Python API 自动截图（非 CLI），自动探测卡片数
Step 4: 文案撰写  → 鱼骨法（钩子→骨架→肉→尾→标签），标题公式 + emoji 规范
Step 5: 飞书交付  → lark-cli docs 创建 + 图片上传 + 文案追加 + 权限授予
```

## 目录结构

```
xhs-producer/
├── SKILL.md                              ← 主文件（27KB）：完整工作流 + 6 大步骤
├── README.md                             ← 本文件
├── LICENSE                               ← MIT 协议
├── references/
│   ├── dark-amber-caution.md             ← 已验证主题：深色科技风 + 琥珀金（AI 警示类）
│   ├── feishu-permission-flow.md         ← Bot 创建文档后的用户授权流程
│   └── checklist.md                      ← 发布前质量检查清单（P0-P3 分级）
└── examples/
    └── screenshot.py                     ← Playwright 截图脚本模板
```

## 设计风格决策

三级优先级：

1. **品牌匹配**（最高）：话题涉及已知品牌 → 读取 `popular-web-designs/templates/` 对应设计系统
2. **领域映射**：按内容领域（科技/产品/管理/成长/财经/消费/健康/游戏）自动选配色方案
3. **探索模式**：用户需求模糊时，出 3 个方向的封面样品供选择

## 安装

### 一行命令安装

```bash
git clone https://github.com/sammyteng/xhs-producer.git ~/shared-skills/xhs-producer
```

然后运行检查脚本，确认依赖环境：

```bash
bash ~/shared-skills/xhs-producer/setup.sh
```

### 触发方式

安装后，在 Claude Code / Codex / Gemini CLI / Antigravity 中直接说：

- 「帮我做一套小红书图文」
- 「把这篇内容做成小红书」
- `/xhs-producer [话题]`

---

## 依赖

### 运行环境（必须）

```bash
pip3 install playwright
python3 -m playwright install chromium
```

### 关联 Skill

| Skill | 关系 | 说明 |
|-------|------|------|
| `popular-web-designs` | **推荐** | 54 个品牌设计系统（NVIDIA/Apple/Notion...），话题匹配品牌时自动读取。未安装时自动降级到 Level 2 领域映射，不影响核心功能 |
| `huashu-design` | 可选 | HTML 视觉设计通用规范，设计逻辑已内置于 SKILL.md |
| `feishu-doc-writer` | 可选 | 飞书 Docx Block API 细节，lark-cli 不可用时参考 |

> `popular-web-designs` 是 Hermes 社区 skill，**不是本仓库的一部分**。如果你的 `~/shared-skills/` 已有该目录（Hermes 套件用户）则无需额外操作。

### lark-cli（飞书交付，可选）

```bash
npm install -g @anthropic-ai/lark-cli
```

---

## 注意事项

- HTML 注释中**禁止出现连续 `--`**（`═══` `──` 都不行），会破坏 DOM
- 截图脚本**必须通过 terminal 执行**，不能用沙箱 `execute_code`
- 飞书 `--file` 参数**只接受相对路径**，先 `cd` 到图片目录
- 所有颜色/圆角/间距通过 CSS `:root` 变量控制，切换风格只改变量

## License

MIT © 2026
