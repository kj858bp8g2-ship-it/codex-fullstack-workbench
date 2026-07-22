# 完整能力地图

“全面覆盖”不等于把所有 Skill 同时安装和加载，而是做到三件事：常见任务有默认入口，专业任务有明确路由，未知能力有发现与创建机制。

本机 2026-07-22 的盘点快照包含 517 份 Skill 文件、439 个唯一名称和 75 组重名。这说明只按名字堆配置不可行，也说明“我没用过”不能作为删除依据。完整配置采用两层结构：

1. 13 个核心路由随 Workbench 提供，负责理解任务、选择流程、执行与验证。
2. 专业能力按 Profile 条件式启用，覆盖技术栈、角色、文件类型、外部平台和垂直领域。

机器可读配置见 [skill-profiles.json](../plugins/codex-fullstack-workbench/assets/skill-profiles.json)。插件和账号连接器另见 [插件 Profiles](plugin-profiles.md)。

能力被收录不代表每次都调用。具体激活由 [Skill 与插件调用权重](capability-routing-policy.md) 决定。

## 能力矩阵

| 能力域 | 典型任务 | 核心入口 | 专业能力举例 | 选择原则 |
| --- | --- | --- | --- | --- |
| 工作台与环境 | 首次安装、项目检测、权限边界 | `setup-workbench` | `bootstrap`、`setup`、`env-vars` | 默认启用 |
| 需求、产品与架构 | PRD、成功标准、系统设计、方案权衡 | `requirements-architecture` | `feature-spec`、`brief`、`architecture`、`create-plan` | 按任务触发 |
| 长任务与执行框架 | TDD、阶段计划、自治执行、Worktree | 核心工作循环 | Superpowers、`gsd:*`、`ops:*` | 选一个主框架，避免三套同时接管流程 |
| Skill、插件与 MCP | 查找、安装、每周更新审计、创建、分享、卸载 | `skill-lifecycle` | `find-skills`、`skill-creator`、`plugin-creator`、`mcp-builder`、Scheduled | 自动检查与验证，覆盖、全局更新和认证前确认 |
| 代码库理解与记忆 | 仓库地图、迁移、长期知识、复利、交接 | `project-onboard` / `skill-lifecycle` | `codebase-migrate`、`llm-wiki`、`index`、`capture`、`recall`、`distill`、`debrief`、`handoff` | 只沉淀高信号且已验证内容，定期淘汰 |
| Web 前端工程 | React、Next.js、路由、组件和性能 | `frontend-quality` | `frontend-app-builder`、`react-best-practices`、`shadcn`、`nextjs`、`turborepo` | 按真实栈选择 |
| UI、设计与动效 | 视觉方向、设计系统、Figma、动画 | `frontend-quality` | `frontend-design`、Taste Skill、Impeccable、`apple-hig`、`gsap`、`figma:*` | 主审美能力选一个，平台规范条件式叠加 |
| 后端与 API | 服务、Webhook、队列、缓存、邮件 | `backend-api` | `auth-patterns`、`cron-jobs`、`email`、`cms`、`payments` | 由架构和依赖触发 |
| 数据库、认证与支付 | Schema、迁移、RLS、会话、支付 | `database-auth` | Supabase、Neon、`stripe-best-practices` | 数据库和支付平台按项目选择 |
| 测试、调试与代码审查 | 复现、TDD、E2E、PR Review | `testing-debugging` | `test-driven-development`、`systematic-debugging`、Playwright、`pr-review-ci-fix` | 基础验证默认，浏览器/E2E 条件式 |
| 安全与合规 | Secrets、权限、供应链、漏洞、行业规则 | `security-review` | `security-audit`、`security-guardrails`、Codex Security、`exploits`、行业合规 Skill | 低频但高影响，不能因使用少而删除 |
| 可观测性与事故 | 线上错误、日志、产品事件、支持工单 | `testing-debugging` / `security-review` | Sentry、Datadog、PostHog、`observability`、`issue-triage` | 只接入项目真实使用的平台 |
| Git、CI 与发布 | Diff、PR、CI、版本、回滚 | `delivery-deploy` | GitHub、`gh-fix-ci`、`release-check`、`deployments-cicd` | 本地审查默认，远程写操作确认 |
| 云与部署平台 | Vercel、Cloudflare、Netlify、Render | `delivery-deploy` | 对应平台插件、`vercel-*` | 选真实平台，不全装 |
| 移动端与原生 | Expo、React Native、SwiftUI、模拟器 | 需求与交付入口 | `expo:*`、`build-ios-apps:*`、`swiftui-*` | 按项目技术栈安装完整 Profile |
| AI、Agent 与 ChatGPT Apps | OpenAI API、Agents SDK、MCP、模型调试 | `requirements-architecture` / `backend-api` | `openai-docs`、`agents-sdk`、`ai-sdk`、`mcp-builder`、`langsmith-fetch` | API 和框架版本需当前官方资料 |
| 浏览器与电脑自动化 | 网页操作、登录态、截图、重复流程 | `daily-toolbox` | Browser、Chrome、Computer Use、Playwright、Agent Browser | 普通网页、私人登录态和可重复测试分开选 |
| 文档、表格与知识库 | PDF、Office、Excel、Obsidian、Notion | `document-ingest` | Documents、PDF、Spreadsheets、Presentations、Obsidian、Notion | 按文件类型和保真要求选择 |
| 研究、会议与协作 | 网页研究、会议纪要、Issue、邮件 | `daily-toolbox` | `research`、`content-research-writer`、Meeting、Linear、Notion、邮箱/日历/Slack/Teams | 连接器只在数据真实存在于平台时启用 |
| 图像、视频、品牌与内容 | 图片、程序化视频、品牌、口播和复盘 | `daily-toolbox` | ImageGen、Canvas、Remotion、Hyperframes、Canva、`humanizer-zh`、Cheat on Content | 按输出类型启用，媒体运行时单独验证 |
| 产品、商业与财务 | 市场规模、财务模型、Deck、增长、销售 | 需求与文档入口 | `market-size`、`financial-model`、`analyze-pitch-deck`、`lead-research-assistant` | 开发者日常不默认加载，角色需要时启用 |
| 垂直领域 | 按揭、基金、特定合规和公司知识 | `skill-lifecycle` | Mortgage、Fund、Compliance 等领域 Skills | 只为真实业务域安装和维护 |

## 怎么判断一个低频 Skill 是否有价值

不要只看使用次数，至少看六个维度：

- 杠杆：能否显著减少重复工作或学习成本？
- 风险：能否阻止高代价错误，例如权限扩大、迁移失败和错误发布？
- 稀缺性：是否包含通用模型不知道的组织规则、Schema 或工具流程？
- 恢复价值：平时少用，但事故、迁移或交接时是否不可替代？
- 可迁移性：能否跨项目复用，还是只服务一次任务？
- 可验证性：能否证明它比通用能力更稳定，而不是只写了更多提示词？

因此，`find-skills`、`skill-creator`、安全、迁移和恢复类能力可以低频但高价值。相反，一个每天触发但只重复常识、没有真实增量的 Skill 仍然可能不值得保留。

## 四级启用模型

### 1. 默认核心

13 个路由 Skill、项目 `AGENTS.md`、Git 状态和基本验证。每个项目都可使用。

### 2. 技术栈 Profile

Web、移动端、AI、数据、媒体等按项目技术栈选择。一个项目只启用实际相关的 Profile。

### 3. 账号与平台连接器

GitHub、Sentry、Figma、Notion、Slack、邮箱、日历、数据库和部署平台。安装、认证、只读和写权限分别确认。

### 4. 垂直领域

公司规则、行业合规、金融、按揭、销售运营等。默认不进入通用开发上下文，但必须能被 `skill-lifecycle` 发现。

## 重叠能力处理

- Superpowers、GSD、OPS：选一个主要执行框架。
- Taste Skill、Impeccable、Frontend Design、UI/UX Pro：选一个主要审美入口，平台规范按需叠加。
- Browser、Chrome、Computer Use、Playwright：分别对应普通网页、用户登录态、通用电脑操作和可重复测试。
- Supabase、Neon、Convex：按数据模型和现有平台选择。
- Jam、Replay.io：按反馈采集和会话复现深度二选一。
- Notion、Obsidian、Readwise、Zotero：按知识实际存放位置选择。

“完整”的最终标准是：用户提出任意合理任务时，系统能判断直接做、调用现有能力、安装专业能力、连接外部平台或创建新 Skill，并能说明权限与验证边界。调用率不是目标，结果增益才是。
