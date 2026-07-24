---
name: setup-workbench
description: "为现有或新项目建立安全、渐进式的 Codex 工作台。适用于首次接入仓库、生成或审查 AGENTS.md、选择插件 Profile、检查本机依赖，以及用户要求配置 Skills、插件或开发环境时。"
---

# Setup Workbench

先检测，后建议；先预览，后写入。不要自动登录外部服务、安装第三方插件、写入密钥或覆盖用户文件。

## 工作流

1. 读取最近的 `AGENTS.md`、README、包管理文件与 Git 状态。
2. 读取 [references/setup-checklist.md](references/setup-checklist.md)，识别操作系统、技术栈、可用命令和权限边界。
3. 读取插件根目录 `assets/capability-routing-policy.json`、`assets/skill-profiles.json`、`assets/plugin-profiles.json`、`assets/project-profiles.json` 与 `assets/maintenance-policy.json`；项目级安装时读取 `.agents/assets/` 和 `.codex-workbench/maintenance-policy.json` 中的对应文件。先从项目 Profiles 判断当前项目的完整覆盖路径，再按任务净收益选择最小激活集合；不要因“以后可能用到”安装全部能力，也不要在明显有专业增益时回避使用。
4. 当现有能力确实不足时，转到 `skill-lifecycle` 搜索、评估或创建 Skill。
5. 如需项目级配置，先执行插件根目录 `scripts/bootstrap.ps1` 或 `scripts/bootstrap.sh` 的预览模式。
6. 展示将创建、跳过或备份的文件，得到用户确认后才使用 `-Apply` 或 `--apply`。
7. 完成后验证生成文件可读、Skill 名称唯一，并说明仍需人工完成的认证或平台配置。
8. 用户需要长期维护时，先预览 `scripts/init-knowledge.ps1` 或 `scripts/init-knowledge.sh`，只创建缺失的知识复利文件；再由 `skill-lifecycle` 提供每周更新审计和知识提炼的 Scheduled 任务方案。
9. 创建定时任务、启用隔离暂存或修改用户级 Skills/插件前必须单独确认；安装 Workbench 不等于授权后台更新。

## 选择规则

- 纯本地开发：先使用本插件，不要求外部连接器。
- Web 项目：按需增加浏览器、GitHub、部署平台和一个数据库提供方。
- 前端产品 UI：`frontend-quality` 是质量门槛；只有营销、品牌或作品集等需要明确艺术方向的页面，才在它之外选择一个审美专家。
- AI、移动端、文档数据、生产可靠性、日常研发和媒体内容：先匹配 `project-profiles.json` 中的 Profile，再按实际技术栈与授权范围选择条件能力。
- 生产闭环：只有在项目确实使用相应服务时，才选择安全、错误监控与产品分析插件。
- 重叠能力二选一，例如 Supabase/Neon、Jam/Replay.io、Zotero/Readwise。
- “已安装”不等于“当前任务可调用”；分别验证安装、认证和权限。
- 自动维护默认只审计并报告；全局 Skills、Marketplace、插件和外部认证不得静默更新。

## 输出

给出：检测结果、建议 Profile、预览差异、需要用户确认的动作、已验证项与未验证项。
