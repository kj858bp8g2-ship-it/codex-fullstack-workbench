# Security Policy

## Supported versions

Only the latest released version is supported with security fixes.

## Reporting a vulnerability

Before a public GitHub repository exists, report issues directly to the repository owner through a private channel. After publication, enable GitHub Private Vulnerability Reporting and use a private security advisory instead of a public issue.

Do not include production credentials, customer data, private repository content, or exploitable secrets in a report.

## Trust boundaries

- This repository contains instructions and local scripts. Review them before use.
- Bootstrap scripts default to preview mode and require an explicit apply flag.
- Knowledge initialization creates missing files only and never overwrites existing project knowledge.
- External plugins and connectors are not bundled or authenticated automatically.
- Scheduled maintenance defaults to audit-only. It must not silently replace active or global Skills, update plugins, authenticate accounts, expand permissions, commit, push, or deploy.
- Update candidates are untrusted input until their source, license, instructions, scripts, network access, hooks, MCP configuration and permission changes have been reviewed.
- Plugin capability labels are not a replacement for provider-side permissions.
- Generated code still requires tests, review, and environment-specific security controls.
