# Contributing

感谢参与改进。请保持改动小、可验证，并避免把个人配置直接复制到公共仓库。

## 开发流程

1. 创建 Issue，说明用户问题、适用范围和不包含的内容。
2. 修改前检查最近的 `AGENTS.md` 和相关 Skill。
3. 保持每个 `SKILL.md` 简短；详细内容放入一层 `references/`。
4. 脚本默认 dry-run，不得收集或回显 Secrets。
5. 运行 `python scripts/validate_repository.py`。
6. 在 Pull Request 中列出已验证与未验证内容。

## 不接受的改动

- 未说明来源或许可证的第三方 Skill 大段复制。
- 默认扩大权限、自动推送、自动部署或自动执行数据库迁移。
- 写死用户名、盘符、绝对路径、Token 或账号 ID。
- 仅增加数量、没有明确使用边界的 Skill 或插件清单。
