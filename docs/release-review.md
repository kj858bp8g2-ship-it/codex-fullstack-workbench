# 发布前审查

审查日期：2026-07-22
当前结论：**仓库所有者已授权公开发布；公共远程已创建，首个公开提交待推送。**

仓库主体、13 个核心路由 Skill、完整能力矩阵、Windows 安装脚本和文档转换链路已经可供公开审查。尚未完成 Bash 实机验证和本机 Codex CLI 权限验证；这些是环境验证边界，不阻塞首次公开仓库。

## 需要所有者确认

- [x] 仓库名称 `codex-fullstack-workbench` 保留。
- [x] MIT 许可证按现有项目文件发布。
- [x] 发布账号为 `kj858bp8g2-ship-it`；插件作者保留社区贡献者名称。
- [x] GitHub 仓库地址：`https://github.com/kj858bp8g2-ship-it/codex-fullstack-workbench`。
- [ ] 是否需要中英文双语 README；当前主 README 为中文，插件元数据为英文。
- [ ] 外部插件 Profile 的优先级是否符合你的公开观点。
- [ ] 发布后是否启用 GitHub Private Vulnerability Reporting。

## 技术检查结果

- [x] Plugin manifest 通过官方 `validate_plugin.py`。
- [x] 13 个 Skill 全部通过官方 `quick_validate.py`；Windows 运行时显式启用 UTF-8，绕过验证器默认 GBK 读取问题。
- [x] 仓库自带验证器通过，覆盖 JSON、Skill frontmatter、内部链接、预期文件、常见 Secrets 和个人绝对路径。
- [x] 14 个 YAML/YML 文件通过 `PyYAML safe_load`。
- [x] 13 个 Skill 的触发描述合计 1074 个字符，详细清单按需读取；Headroom 示例不覆盖用户配置。
- [x] 提供安装后 10 分钟上手指南，覆盖首次任务、提示词模板、Skill 触发、结果验收与常见故障。
- [x] 提供“把 GitHub 链接交给 Codex”的项目级安装提示词，包含临时下载、预览、无冲突 Apply、权限确认和安装后验证边界。
- [x] 完整能力地图覆盖 20 个 Profile，并提供带权重的 Skill/插件调用策略，避免强行使用和完全不用两个极端。
- [x] 提供每周更新审计、Scheduled 任务提示词和机器可读维护策略；默认自动检查、Diff 和验证，不静默覆盖当前或全局能力。
- [x] 提供知识复利目录、初始化脚本和“捕获、提炼、验证、晋升、复用、淘汰”门槛；不保存完整聊天或敏感数据。
- [x] Skill inventory 工具在当前本机识别 517 份文件、439 个唯一名称和 75 组重名；默认输出不泄露绝对路径。
- [x] 4 个 PowerShell 文件通过语法解析。
- [x] Windows bootstrap 的 preview、apply、重复运行跳过、force 前集中备份均通过临时目录 smoke test；项目级安装同时包含所需 `.agents/assets`。
- [x] 安装后 13 个核心 Skill 及其策略资产通过具名验证；备份集中在 `.codex-workbench-backups/`，不会产生重复 Skill。
- [x] Windows 知识目录初始化的 preview、apply 和重复运行跳过通过临时目录 smoke test，已有内容不会被覆盖。
- [ ] Bash 本机 smoke test：当前 Windows 无 Git Bash、WSL 发行版或其他 Bash；已配置 GitHub Actions 在 Ubuntu 执行语法与安装测试，尚未有远程 CI 结果。
- [x] MarkItDown 0.1.6 将仓库 README 转换为 Markdown 成功。
- [ ] FFmpeg 未找到；音频/视频链路未验证，文档已明确降级边界。
- [x] 未发现真实 Secret、用户名、客户数据或已写死的个人绝对路径。
- [ ] Codex 插件 CLI 实机安装未验证：命令与当前本地 OpenAI 手册一致，但当前 WindowsApps 中的 `codex.exe` 返回 Access denied。可使用项目级 bootstrap；正式发布前应在另一台可调用 CLI 的机器或桌面插件页复测。
- [ ] 链接驱动安装尚未做真实 GitHub 端到端验证：公开地址已确定；其底层调用的 Windows 项目级 preview、apply 和 verify 已分别通过本地 smoke test。
- [ ] 未创建真实 Scheduled 任务：公开仓库地址、运行项目和用户偏好的时间尚未确定；发布前应在 Codex 桌面应用中先手动运行提示词，再验证至少一次后台结果。
- [x] 已初始化 Git 并创建公共远程仓库；首个公开提交待推送。

## 范围审查

### 已纳入

- 项目接入、需求与架构、前端审美、后端 API、数据库与鉴权、测试调试、安全、交付部署。
- Context Headroom、MarkItDown 文档摄取和日常开发工具路由。
- 每周更新审计、隔离暂存策略、知识复利模板和晋升/淘汰门槛。
- 插件按 Profile 选择，包含常被遗漏的 Security、Sentry、PostHog、数据可视化、Jam/Replay.io、Temporal 等。
- 根 `AGENTS.md`、可复制项目模板、Windows/macOS/Linux bootstrap 和本地验证器。

### 有意不纳入

- 第三方插件静默安装或更新、账号登录、OAuth、API Key、生产部署和数据库迁移。
- 未经审查覆盖活动 Skills、用户级配置或自动改写用户维护的 `AGENTS.md` 与 Playbook。
- 用户个人 Skills 全量复制、客户项目内容、私有日志和机器路径。
- “所有插件一起启用”的重上下文方案。

## 已知环境问题

- 当前项目指令要求从本机 `~/.codex/templates/agent_memory/` 原样创建任务记忆文件，但该模板目录不存在。为避免伪造模板，本仓库没有创建 `agent_memory/`；这不影响公开插件运行，但需要仓库所有者确认公开仓库是否根本不纳入该内部目录。
- 当前目录已初始化 Git 并关联公共远程；首个公开提交和远程 CI 证据待推送后确认。

## 建议审查顺序

1. 先按 [10 分钟上手指南](getting-started.md) 模拟一个首次使用者，检查是否能独立完成第一个任务。
2. 再审 [README](../README.md) 的定位、安装承诺和受众语言。
3. 审查 [插件 Profiles](plugin-profiles.md) 是否代表你的公开推荐。
4. 抽查 `frontend-quality`、`context-headroom`、`document-ingest` 和根 `AGENTS.md`，确认方法论风格。
5. 最后确认名称、Publisher、许可证和 GitHub 地址；这些确认完成后再补元数据并做发布候选验收。

## 审查结论模板

- 结论：通过 / 有条件通过 / 不通过
- 阻塞项：
- 非阻塞改进：
- 允许修改的元数据：
- 是否允许初始化 Git：
- 是否允许创建远程仓库：
- 是否允许发布 `v0.1.0`：
