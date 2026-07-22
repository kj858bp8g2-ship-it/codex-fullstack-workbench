# AGENTS.md

- Before changing files, read the closest applicable `AGENTS.md`, project README, package scripts, and relevant source files.
- For multi-file, runtime, public API, database, permission, deployment, or complex debugging work, provide a short plan with success criteria and validation before editing.
- Make the smallest change that satisfies the request. Reuse existing code and patterns; do not perform unrelated refactors.
- Preserve user changes and dirty worktrees. Do not overwrite, reset, delete, move, commit, push, deploy, or migrate unless the request clearly authorizes it.
- Reproduce defects before fixing them. Record the observed failure and add the smallest useful regression check.
- Run validation proportional to the risk: types, lint, tests, build, browser checks, security checks, or post-deploy checks as applicable.
- Treat credentials, customer data, production systems, external messages, permissions, and destructive actions as explicit approval boundaries.
- Use targeted search and reads. Summarize noisy logs, load Skill references only when needed, and preserve context for implementation, verification, and review.
- Use a Skill or plugin when it provides material gains in task fit, quality, verification, deterministic tooling, or risk reduction. Do not invoke capabilities to meet a quota, and do not ignore a clear specialist advantage.
- Default to one primary Skill and at most one supporting Skill per implementation slice. External authentication, data access, writes, publishing, deployment, and migrations still require confirmation.
- When `.codex-workbench/knowledge/` exists, capture only high-signal reusable learnings with evidence and scope. Do not log full chats, secrets, customer data, or one-off paths. Propose repeated validated patterns for `AGENTS.md`, the Playbook, or a project Skill; do not promote a single unverified observation.
- Scheduled maintenance may inspect, diff, validate, and report updates. It must not silently overwrite active files, update global Skills or plugins, authenticate accounts, expand permissions, commit, push, or deploy.
- Report changed files, user-visible behavior, commands run, verified results, unverified areas, risks, and the next safe step.
- Do not present fixtures, simulations, local checks, or controlled samples as production or customer evidence.
