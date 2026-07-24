# 日常工具层

## 输入与转换

### MarkItDown

将 PDF、Word、PowerPoint、Excel、网页和其他支持的输入转换为 Markdown，再使用标题和 `rg` 定向读取，减少重复上传二进制文件造成的上下文浪费。

安装：

```bash
pip install 'markitdown[all]'
```

使用：

```bash
markitdown document.pdf -o document.md
markitdown report.docx -o report.md
markitdown slides.pptx -o slides.md
markitdown data.xlsx -o data.md
```

本仓库还提供拒绝覆盖输出文件的安全包装：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File `
  .\plugins\codex-fullstack-workbench\skills\document-ingest\scripts\convert-document.ps1 `
  -InputPath .\report.pdf `
  -OutputPath .\report.converted.md
```

```bash
bash ./plugins/codex-fullstack-workbench/skills/document-ingest/scripts/convert-document.sh \
  --input ./report.pdf \
  --output ./report.converted.md
```

音频能力需要额外依赖；使用前检查 FFmpeg。不要默认把云端 Document Intelligence 或 Content Understanding Endpoint 写入公共配置。

## 搜索与代码库理解

- `rg`：文本、文件和配置定位的默认工具。
- Git/GitHub：状态、Diff、PR 和 CI。
- CodeGraph：需要快速追踪跨文件调用链、依赖关系或架构路径时按需使用；查询应从一个明确问题和目录开始。
- Codebase Memory：长期维护的大仓库按需建立本地索引，用于架构检索、图搜索、路径追踪和变更检测。
- 两者不是默认常驻组合：先用 `rg`；大型任务再选一个主索引，命中不足或索引陈旧时才切换。索引结果必须回到真实文件、测试和浏览器验证。

## 浏览器与验证

- Browser：普通网页和本地 Web 应用验证。
- Chrome：需要用户现有登录态时使用，操作前确认。
- Playwright：可重复的 E2E、截图和回归测试。
- Jam / Replay.io：面向人工反馈或复杂会话复现。

## 输出与媒体

- Documents、PDF、Spreadsheets、Presentations：正式交付物。
- FFmpeg：音视频运行时依赖。
- OpenMontage：多工具音视频自动化。
- Remotion、Hyperframes：程序化视频和动效。

## 选择原则

1. 优先使用已经安装且可验证的工具。
2. 只有工具带来新能力时才新增依赖。
3. 外部服务必须区分“插件已存在”和“账号已授权、权限足够”。
4. 本地工具必须执行真实 smoke test，不能只检查命令是否存在。

## Scheduled 与长期维护

Scheduled 适合每周更新审计、知识整理、依赖巡检和固定报告。先在普通任务中手动测试提示词；本地任务使用最小权限，Git 项目优先通过 Worktree 隔离候选改动。后台任务不应静默更新全局 Skills、插件、账号或权限。可复制方案见 [每周维护与知识复利](automations-and-compounding.md)。
