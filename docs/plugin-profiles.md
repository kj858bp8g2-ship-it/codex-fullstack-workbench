# 插件 Profiles

完整配置包含所有 Profile，但不代表默认安装全部插件。选择顺序是：真实需求、现有平台、授权范围、能力增量、验证成本。

下列 ID 按 2026-07-22 的本地插件目录核对；插件库会更新，发布后应定期复查。安装、当前任务可调用、账号认证和写权限必须分别验证。

本页负责插件和账号连接器；完整 Skill 能力域见 [完整能力地图](full-capability-map.md)。

## Core Development

| 插件 | 用途 | 边界 |
| --- | --- | --- |
| Superpowers | 规划、TDD、系统调试、验证和审查 | 高级多代理与 Worktree 流程按需使用 |
| Build Web Apps | React、前端测试、Shadcn、Stripe/Supabase 最佳实践 | 主要面向 Web 技术栈 |
| Browser | 页面检查、截图、控制台和交互验证 | 不复用用户私人 Chrome 登录态 |
| GitHub | Issue、PR、CI 和代码托管 | 需要用户授权，写操作前确认 |

## Skill Management

| 能力 | 用途 | 边界 |
| --- | --- | --- |
| `skill-lifecycle` | 本仓库自带的发现、评估、安装、每周维护、创建与知识复利入口 | 默认使用，负责治理而不是堆数量 |
| `find-skills` | 搜索开放 Skill 生态中的现成能力 | 搜索结果必须继续审查，不能按排名直接安装 |
| `skill-creator` | 将重复流程、领域规则和脚本沉淀成 Skill | 优先项目级；创建后必须验证和真实试用 |
| `plugin-creator` | 把多个 Skills、连接器或 MCP 打包成插件 | 只有确实需要组合分发时使用 |

这里采用的判断不是“我是否已经用过”，而是“遇到能力缺口时是否能可靠发现、评估和补齐”。低频的恢复、迁移、安全或创建工具仍可能很有价值，但不需要在每次任务中加载。

插件市场刷新、插件版本更新、账号认证和写权限是不同状态。每周自动化默认只审计可信来源与权限变化；不要假设所有插件都有统一的静默更新命令。具体策略见 [每周维护与知识复利](automations-and-compounding.md)。

## Data and Deployment

| 选择 | 建议 |
| --- | --- |
| Supabase / Neon | 二选一；需要 Auth、Storage、RLS 时优先 Supabase，纯 Postgres 时考虑 Neon |
| Vercel / Cloudflare / Netlify / Render | 按真实部署平台选择一个主要入口 |
| Convex | 仅在项目明确采用 Convex 时使用，不与 Supabase/Neon 无目的叠加 |

## Production Loop

| 插件 | 用途 |
| --- | --- |
| Codex Security | 授权代码库的安全扫描与调查 |
| Sentry | 线上错误与事件调查 |
| PostHog | 产品分析、漏斗和实验 |
| Jam / Replay.io | UI 问题复现；简单反馈选 Jam，复杂会话分析选 Replay.io |

## Product and Design

| 插件 | 用途 |
| --- | --- |
| Figma | 已存在设计源时读取与实现 |
| Product Design / Impeccable | 产品设计与 UI 质量审查 |
| Build Web Data Visualization | 图表、地图、仪表盘、Gantt、UML 和数据叙事 |

## Payments, Communication, AI

| 插件 | 用途 |
| --- | --- |
| Stripe | 支付和订阅 |
| Twilio Developer Kit | 短信、语音、Verify、SendGrid 等通信能力 |
| OpenAI Developers | OpenAI API 应用 |
| Hugging Face | 模型、数据集、Spaces 和研究资料 |

## 最容易漏掉但值得关注

| 优先级 | 插件 ID | 适用条件 |
| --- | --- | --- |
| 高 | `codex-security` | 需要授权范围内的代码安全扫描和调查 |
| 高 | `sentry` | 产品已接入 Sentry，需要从线上错误回到代码 |
| 高 | `posthog` | 产品已接入 PostHog，需要漏斗、事件与实验闭环 |
| 高 | `build-web-data-visualization` | 仪表盘、图表、地图、Gantt、UML 或数据叙事 |
| 中 | `jam` / `replayio` | 二选一，用于带上下文的 UI Bug 复现 |
| 中 | `cloudflare` | Workers、Wrangler 或 Agents SDK 项目 |
| 中 | `temporal` | 长事务、重试、补偿和耐久工作流确实存在 |
| 中 | `stripe` / `twilio-developer-kit` | 项目真实使用支付或通信平台 |
| 中 | `zotero` / `readwise` | 研究、引用和长期阅读工作流 |
| 条件式 | `airtable` / `hugging-face` | 已有对应数据或 AI 资产工作流 |

## Mobile and Media

| 插件/工具 | 用途 |
| --- | --- |
| Expo | React Native/Expo 项目 |
| Build iOS Apps | 原生 iOS 项目 |
| Remotion / Hyperframes | 程序化视频与动效内容 |
| FFmpeg / OpenMontage | 本地音视频处理和自动化工作流 |

## Knowledge and Operations

| 插件 | 用途 |
| --- | --- |
| Zotero / Readwise | 研究资料、引用和长期阅读知识 |
| Airtable | 结构化记录和轻量运营数据库 |
| Linear | Issue 与研发任务；未使用 Linear 时不安装 |
| Documents / PDF / Spreadsheets / Presentations | 专业文件输出和编辑 |

## 协作连接器不是开发必装项

`atlassian-rovo`、`box`、`gmail`、`google-calendar`、`google-drive`、`notion`、`outlook-calendar`、`outlook-email`、`sharepoint`、`slack` 和 `teams` 的价值在于读取或操作真实办公系统。只有资料或动作就在对应平台，且用户接受授权范围与数据流向时才安装；它们不会提升本地编码本身的质量。

## 默认不建议

- 同时安装多个同类分析平台：PostHog、Amplitude、Mixpanel、Statsig 选实际在用的。
- 同时安装多个部署平台：已有 Vercel 时不要为了“完整”再装所有替代品。
- 同时安装多个数据库平台：Supabase、Neon、Convex 按项目选择。
- 安装多个会议记录、CRM 或营销插件，但没有对应账号和日常流程。
- 用 CodeRabbit 等重复审查工具替代本地测试与人工审查。
