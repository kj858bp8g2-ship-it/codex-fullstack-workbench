---
name: document-ingest
description: "将 PDF、Word、PowerPoint、Excel、HTML、图片或音频等资料转换为可检索文本，并定向提取证据。适用于 MarkItDown、文档阅读、资料对比、会议材料、表格摘要或减少二进制文件上下文占用。"
---

# Document Ingest

先把资料转成可检索文本，再围绕问题读取；保留来源、页码/工作表等定位信息，不把转换结果当作无损原文。

## 工作流

1. 确认文件来源、格式、敏感性和用户想回答的问题。
2. 优先使用本地工具；检测 MarkItDown 是否存在，不自动上传到云服务。
3. 运行 `scripts/convert-document.ps1` 或 `scripts/convert-document.sh` 生成单独的 Markdown 文件。
4. 搜索标题、关键词、表格或错误位置，只读取相关片段。
5. 对关键数字、公式、图表和扫描件回看原文件；OCR/布局转换可能出错。
6. 按 [references/ingest-guide.md](references/ingest-guide.md) 记录来源和限制。

## 安全边界

- 不覆盖原文件；默认拒绝输出路径与输入相同。
- 未经许可不把客户文档上传到第三方服务。
- 转换音频/视频前确认本机依赖；缺少 FFmpeg 时明确降级。
- 临时文本也可能包含秘密或个人信息，不应默认提交到 Git。

## 输出

说明输入、转换工具、输出位置、提取范围、来源定位、转换局限和需人工核对项。
