# 项目 Profiles：把全面覆盖变成可执行选择

13 个核心 Skill 会随 Workbench 一起部署，它们是路由层，不代表一个任务要把 13 个都加载。这里的 Profile 把常见项目类型映射为“通常会经过哪些路由、哪些能力按需加、哪些不应为了完整而安装、最终如何验收”。机器可读版本是 [project-profiles.json](../plugins/codex-fullstack-workbench/assets/project-profiles.json)。

## 小白怎么用

安装后，不必手动挑 Skill。把下面提示词发给 Codex：

```text
先读取当前项目的 AGENTS.md、README、Git 状态和 .agents/assets/project-profiles.json。

判断它最接近哪个项目 Profile，并说明：
1. 当前任务应选的一个主 Skill 和最多一个辅助 Skill；
2. 哪些外部能力能带来明确增益，哪些不该为了“全套”而安装；
3. 哪些操作需要我确认；
4. 本次完成的验收标准。

先不要安装插件、登录账号、写入密钥、创建远程资源、提交、推送或部署。
```

## 覆盖清单

| Profile | 覆盖的交付 | 核心质量重点 | 常见按需能力 |
| --- | --- | --- | --- |
| Web 全栈产品 | 前端、API、数据库、测试和交付 | 契约、鉴权、浏览器路径与发布门槛 | Browser、GitHub、React、一个数据库和真实部署平台 |
| 后端服务与集成 | API、Webhook、队列和第三方集成 | 输入、错误、重试、幂等、权限 | Auth、Cron、邮件、支付、可观测性 |
| 前端产品界面 | 应用页面、组件、状态和响应式 | 可用性、状态完整性、真实浏览器验收 | React、Shadcn、Figma、一个既有设计系统 |
| 品牌、官网与营销页面 | 品牌识别、叙事、转化与动效 | 明确审美方向、真素材、性能与减少动效 | 一个审美专家、ImageGen、按需 GSAP、Figma |
| 移动端与原生应用 | Expo、React Native、SwiftUI、iOS | 平台导航、权限、设备生命周期 | Expo 或 Build iOS Apps、模拟器/真机 |
| AI、Agent 与 ChatGPT 应用 | 模型、工具、MCP 和 AI 工作流 | 数据/工具边界、降级、成本与可观测性 | OpenAI Docs、Agents SDK、MCP Builder |
| 文档、数据与知识 | PDF、Office、表格、知识库 | 来源保留、转换损失和抽样核验 | MarkItDown、Documents、PDF、Spreadsheets |
| 生产可靠性 | 安全、发布、事故和回滚 | 风险分层、真实环境边界、可恢复性 | Security、Sentry、Datadog、PostHog、CI 修复 |
| 日常研发与维护 | 读代码、排错、研究、知识复利 | 定向读取、证据、低上下文和维护边界 | `rg`、CodeGraph/Codebase Memory 二选一、GitHub、find-skills |
| 图像、视频与内容 | 素材、视频、口播、品牌内容 | 实际渲染、版权、音画与输出规格 | ImageGen、Remotion/Hyperframes、FFmpeg |

## 前端审美放在哪里

它不是一个“装了就高级”的独立插件，而是两层结构：

1. `frontend-quality` 是所有视觉改动的底线，负责层级、状态、响应式、可访问性与真实浏览器验收。
2. 只有官网、营销页、作品集、品牌重塑或关键转化页面确实需要时，才额外选择一个审美专家。设计系统和 Figma 有明确来源时优先忠实复用，不能让风格 Skill 覆盖业务 UI 的可用性。

完整选择规则见 [前端审美路由与验收](../plugins/codex-fullstack-workbench/skills/frontend-quality/references/aesthetic-routing.md)。

## 覆盖，不等于乱装

每个 Profile 都说明“何时不用”。原因很简单：多个数据库、部署平台、分析平台、审美专家或工作流框架同时接管项目，通常只会增加上下文、权限和维护成本。全栈覆盖来自可发现、可选择、可验证的路径，而不是把本机变成插件仓库。
