# AGENTS.md

- Read `README.md`, the nearest applicable `AGENTS.md`, and the target Skill before editing.
- Keep this repository provider-neutral: external plugins are optional profiles, not silent dependencies.
- Route capabilities by material outcome gain, not usage quotas. Prefer one primary Skill plus one supporting Skill; do not avoid a specialist when it clearly improves fidelity, verification, or risk control.
- Keep each `SKILL.md` focused on routing and workflow. Put detailed checklists in one-level `references/` files.
- Bootstrap scripts must remain preview-only by default. Writing requires an explicit apply flag; replacing files requires an explicit force flag and a backup.
- Scheduled maintenance must default to audit-only. Do not silently replace active or global Skills, update plugins, authenticate accounts, expand permissions, commit, push, or deploy.
- Knowledge-compounding templates must reject full-chat logging and sensitive data. Promotion into `AGENTS.md`, Playbooks, Skills, or plugins requires scope and validation evidence; existing user knowledge is never overwritten.
- Do not add credentials, customer data, personal absolute paths, account IDs, authenticated samples, or private logs.
- Do not add automatic login, remote publishing, production deployment, database migration, or destructive behavior.
- Run `python scripts/validate_repository.py` after changes. Validate affected Skills and smoke-test changed scripts on their supported platform.
- Distinguish local checks from authenticated, third-party, CI, and production verification.
- Do not commit, push, publish a release, or create external resources unless the user explicitly authorizes that action.
