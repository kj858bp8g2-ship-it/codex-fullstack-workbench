---
name: daily-toolbox
description: "为开发者日常任务选择最小可靠工具链。适用于网页与截图、GitHub 协作、文档与表格、代码库索引、文件整理、媒体处理、自动化、工具安装判断或用户询问该用什么工具时。"
---

# Daily Toolbox

先按任务选择能力，再检查本机或当前会话是否可用。工具的安装状态、可调用状态、认证状态和写权限是四件不同的事。

## 路由

- 网页资料：浏览器读取；需要稳定引用时转 Markdown 并保留 URL。
- UI 验证：真实浏览器、截图和视口检查；不以 HTML/CSS 静态阅读替代。
- GitHub：本地 Git 负责 Diff；远程 Issue/PR 操作需用户授权与认证。
- 文档：优先 `document-ingest` 与 MarkItDown；复杂文档、PDF、表格使用对应专用能力。
- 代码库理解：先用 `rg` 和语言工具；大型长期项目再按需在 CodeGraph 与 Codebase Memory 中选择一个主索引，不为“全覆盖”同时常驻两个索引。
- 媒体：先检查 FFmpeg；拼接、抽帧、字幕等重复流程再使用专用工具。
- 外部协作：Notion、Slack、邮箱、日历等连接器仅在真实工作流需要且用户同意时启用。

详细选择表见 [references/tool-routing.md](references/tool-routing.md)。
代码库索引的触发、选择、验证与维护边界见 [references/codebase-indexing.md](references/codebase-indexing.md)。

## 原则

1. 内置能力能完成时不增加依赖。
2. 优先本地、可逆、可检查的工具。
3. 同类工具选择一个主工具，避免重复安装。
4. 安装前说明来源、权限、数据去向、维护成本和卸载方法。
5. 外部写操作、消息发送、付费调用和公开发布必须单独确认。

## 输出

给出首选工具、替代方案、选择理由、前置条件、权限风险与最小验证命令。
