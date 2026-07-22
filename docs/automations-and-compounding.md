# 每周维护与知识复利

这套 Workbench 包含两个长期循环：自动发现更新，以及把日常经验沉淀成可复用资产。默认策略是“自动检查、自动验证、人工晋升”，不是无人值守地覆盖正在使用的配置。

## 为什么不直接静默更新

Skills 和插件不仅是文字提示，还可能新增脚本、网络访问、Hook、MCP、登录和写权限。一次普通版本更新可能改变触发范围或执行边界。因此每周任务可以自动拉取和验证候选，但进入当前项目、用户目录或插件环境前必须看 Diff。

机器可读默认值见 [maintenance-policy.json](../plugins/codex-fullstack-workbench/assets/maintenance-policy.json)。低风险候选也只生成报告；用户明确启用隔离暂存后，项目级更新才可以在 Git Worktree 中准备待审 Diff。全局 Skills、Marketplace、插件、认证和权限扩大始终保持人工确认。

## 初始化知识目录

Windows 先预览：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File `
  .\plugins\codex-fullstack-workbench\scripts\init-knowledge.ps1 `
  -ProjectPath D:\path\to\project
```

确认后加上 `-Apply`。macOS/Linux 使用：

```bash
bash ./plugins/codex-fullstack-workbench/scripts/init-knowledge.sh \
  --project /path/to/project

bash ./plugins/codex-fullstack-workbench/scripts/init-knowledge.sh \
  --project /path/to/project \
  --apply
```

脚本只创建缺失的 `.codex-workbench/knowledge/`、维护策略和 `source-registry.json`，不提供 Force，也不会覆盖已有知识。初始化后要把 Registry 中的占位符替换为实际安装来源和 Revision；第三方 Skill 或 Marketplace 没有可信来源时保持未追踪，不能猜。如果项目原本已有 `AGENTS.md`，bootstrap 会跳过它；应让 Codex 只提出知识复利规则的合并 Diff，由你审查后决定是否加入。

## 创建每周更新审计

先在普通 Codex 任务中手动运行一次下面的正文。输出符合预期后，再让 Codex 桌面应用把它创建为每周独立 Scheduled 任务；时间可以按你的作息调整。

```text
使用 $skill-lifecycle 对当前项目执行每周 Workbench、Skills 和插件更新审计。

读取 .codex-workbench/maintenance-policy.json、source-registry.json 和 skill-lifecycle 的 weekly-maintenance 参考。
只检查能够追踪到可信来源的条目；把候选下载到临时目录，比较版本说明、SKILL.md、脚本、Hook、MCP、网络、认证和权限变化，并运行可用验证。
默认只生成报告，不覆盖当前文件，不执行 Force，不更新全局 Skills 或插件，不登录、不提交、不推送。
如果项目已明确启用 stage-trusted-updates，且是 Git 仓库，只能在独立 Worktree 暂存低风险项目级更新；其他情况保持只读。
来源不明、验证失败或权限扩大的条目放入阻塞清单。
输出来源、版本、Diff 摘要、验证、风险、建议和回滚方式；没有变化时只报告“本周无可信更新”。
```

然后对 Codex 说：

```text
请把上面的更新审计创建为当前项目每周运行一次的独立 Scheduled 任务。先展示任务名称、运行目录、权限、是否使用 Worktree 和完整提示词，得到我确认后再创建。
```

本地 Scheduled 任务要求运行时电脑和 Codex 桌面应用保持开启，项目路径仍然存在。CLI 和 IDE 可以测试提示词与脚本，但不能管理 Scheduled。前几次运行应人工检查结果，并使用尽可能小的沙箱和网络范围。

## 创建每周知识复利任务

```text
使用 $skill-lifecycle 对当前项目执行每周知识复利审查。

读取 .codex-workbench/knowledge/README.md、inbox.md、playbook.md 和 retired.md，只处理新增或待验证条目。
合并重复候选，检查证据、适用范围、隐私、来源和过期风险。
单次且未验证的观察继续留在 Inbox；至少两次独立成功，或一次高风险问题且有强证据的条目，可以提出晋升建议。
分别判断应该进入项目上下文、AGENTS.md、Playbook、Skill、插件/MCP，还是淘汰。
默认只生成建议，不自动改写用户编辑过的 AGENTS.md、Playbook 或 Skills，不记录完整聊天、密钥、客户数据和个人路径。
输出本周新增、可晋升、待验证、冲突、已过期和建议下周验证的条目。
```

建议把它设为与更新审计分开的每周 Scheduled 任务，减少上下文互相污染。日常任务只负责捕获少量高信号候选；每周任务负责聚类和晋升建议。

## 知识应该晋升到哪里

| 内容 | 合适载体 |
| --- | --- |
| 当前项目事实、入口和约束 | 项目上下文文档 |
| 每次都必须遵守的短规则 | 最近的 `AGENTS.md` |
| 跨项目都适用的个人沟通与执行默认值 | 用户级指导文件，经确认后写入 |
| 经过验证但仍依赖人工判断的技巧 | `playbook.md` |
| 稳定、重复、跨任务的操作流程 | 项目级 Skill |
| 在多个项目独立验证的个人方法 | 用户级 Skill 或个人插件，单独确认全局写入 |
| 多个 Skills 加工具或连接器 | 插件 |
| 实时外部数据、账号或动作 | MCP/连接器 |
| 一次性聊天和未经验证猜测 | 不沉淀或只留在 Inbox |

完整循环是：**捕获 → 提炼 → 验证 → 晋升 → 复用 → 淘汰**。积累数量不是目标，后续任务的正确率、速度和可验证性是否改善才是目标。
