#!/usr/bin/env python3
"""Validate the public repository without third-party Python dependencies."""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
PLUGIN = ROOT / "plugins" / "codex-fullstack-workbench"
SKILLS_ROOT = PLUGIN / "skills"
EXPECTED_SKILLS = {
    "setup-workbench",
    "project-onboard",
    "requirements-architecture",
    "frontend-quality",
    "backend-api",
    "database-auth",
    "testing-debugging",
    "security-review",
    "delivery-deploy",
    "context-headroom",
    "document-ingest",
    "daily-toolbox",
    "skill-lifecycle",
}
REQUIRED_FILES = {
    ROOT / "AGENTS.md",
    ROOT / "CHANGELOG.md",
    ROOT / "scripts" / "audit_skill_inventory.py",
    ROOT / "docs" / "automations-and-compounding.md",
    ROOT / "README.md",
    ROOT / "LICENSE",
    ROOT / "SECURITY.md",
    ROOT / "CONTRIBUTING.md",
    ROOT / ".agents" / "plugins" / "marketplace.json",
    PLUGIN / ".codex-plugin" / "plugin.json",
    PLUGIN / "assets" / "AGENTS.template.md",
    PLUGIN / "assets" / "config.headroom.example.toml",
    PLUGIN / "assets" / "capability-routing-policy.json",
    PLUGIN / "assets" / "skill-profiles.json",
    PLUGIN / "assets" / "plugin-profiles.json",
    PLUGIN / "assets" / "maintenance-policy.json",
    PLUGIN / "assets" / "source-registry.template.json",
    PLUGIN / "assets" / "knowledge" / "README.md",
    PLUGIN / "assets" / "knowledge" / "inbox.md",
    PLUGIN / "assets" / "knowledge" / "playbook.md",
    PLUGIN / "assets" / "knowledge" / "retired.md",
    PLUGIN / "scripts" / "bootstrap.ps1",
    PLUGIN / "scripts" / "bootstrap.sh",
    PLUGIN / "scripts" / "verify-workbench.ps1",
    PLUGIN / "scripts" / "verify-workbench.sh",
    PLUGIN / "scripts" / "init-knowledge.ps1",
    PLUGIN / "scripts" / "init-knowledge.sh",
}
TEXT_SUFFIXES = {".md", ".json", ".yaml", ".yml", ".toml", ".py", ".ps1", ".sh"}
SECRET_PATTERNS = {
    "private key": re.compile(r"-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----"),
    "OpenAI-style key": re.compile(r"\bsk-[A-Za-z0-9_-]{20,}\b"),
    "GitHub token": re.compile(r"\bgh[opsu]_[A-Za-z0-9]{20,}\b"),
    "AWS access key": re.compile(r"\bAKIA[0-9A-Z]{16}\b"),
}
PRIVATE_PATH_PATTERNS = {
    "Windows user path": re.compile(r"[A-Za-z]:\\Users\\[^\\\s]+", re.IGNORECASE),
    "Unix user path": re.compile(r"/(?:Users|home)/[^/\s]+"),
}
MARKDOWN_LINK = re.compile(r"(?<!!)\[[^\]]+\]\(([^)]+)\)")


def load_json(path: Path, errors: list[str]) -> object | None:
    try:
        return json.loads(path.read_text(encoding="utf-8-sig"))
    except (OSError, json.JSONDecodeError) as exc:
        errors.append(f"Invalid JSON {path.relative_to(ROOT)}: {exc}")
        return None


def parse_frontmatter(path: Path, errors: list[str]) -> tuple[dict[str, str], str]:
    text = path.read_text(encoding="utf-8-sig")
    match = re.match(r"^---\r?\n(.*?)\r?\n---\r?\n", text, re.DOTALL)
    if not match:
        errors.append(f"Missing YAML frontmatter: {path.relative_to(ROOT)}")
        return {}, text

    fields: dict[str, str] = {}
    for line in match.group(1).splitlines():
        if not line.strip() or line.lstrip().startswith("#"):
            continue
        if ":" not in line:
            errors.append(f"Malformed frontmatter line in {path.relative_to(ROOT)}: {line}")
            continue
        key, value = line.split(":", 1)
        fields[key.strip()] = value.strip().strip('"').strip("'")
    return fields, text[match.end() :]


def validate_required_files(errors: list[str]) -> None:
    for path in sorted(REQUIRED_FILES):
        if not path.is_file():
            errors.append(f"Missing required file: {path.relative_to(ROOT)}")


def validate_manifest(errors: list[str]) -> None:
    manifest_path = PLUGIN / ".codex-plugin" / "plugin.json"
    marketplace_path = ROOT / ".agents" / "plugins" / "marketplace.json"
    manifest = load_json(manifest_path, errors)
    marketplace = load_json(marketplace_path, errors)
    load_json(PLUGIN / "assets" / "plugin-profiles.json", errors)
    if not isinstance(manifest, dict) or not isinstance(marketplace, dict):
        return

    if manifest.get("name") != "codex-fullstack-workbench":
        errors.append("plugin.json name must be codex-fullstack-workbench")
    if manifest.get("skills") != "./skills/":
        errors.append("plugin.json skills must point to ./skills/")
    interface = manifest.get("interface")
    if not isinstance(interface, dict) or not interface.get("defaultPrompt"):
        errors.append("plugin.json interface.defaultPrompt is required")

    entries = marketplace.get("plugins")
    if not isinstance(entries, list) or len(entries) != 1:
        errors.append("marketplace.json must contain exactly one plugin entry")
        return
    entry = entries[0]
    if not isinstance(entry, dict) or entry.get("name") != manifest.get("name"):
        errors.append("Marketplace plugin name must match plugin.json")
    source = entry.get("source") if isinstance(entry, dict) else None
    if not isinstance(source, dict) or source.get("path") != "./plugins/codex-fullstack-workbench":
        errors.append("Marketplace source path is invalid")


def validate_skills(errors: list[str]) -> None:
    if not SKILLS_ROOT.is_dir():
        errors.append("Skills directory is missing")
        return
    actual = {path.name for path in SKILLS_ROOT.iterdir() if path.is_dir()}
    if actual != EXPECTED_SKILLS:
        errors.append(f"Skill set mismatch. Missing={sorted(EXPECTED_SKILLS - actual)}, extra={sorted(actual - EXPECTED_SKILLS)}")

    for name in sorted(actual):
        skill_root = SKILLS_ROOT / name
        skill_path = skill_root / "SKILL.md"
        agent_path = skill_root / "agents" / "openai.yaml"
        if not skill_path.is_file():
            errors.append(f"Missing SKILL.md for {name}")
            continue
        fields, body = parse_frontmatter(skill_path, errors)
        if fields.get("name") != name:
            errors.append(f"Skill frontmatter name mismatch for {name}")
        description = fields.get("description", "")
        if len(description) < 30 or "TODO" in description:
            errors.append(f"Skill description is incomplete for {name}")
        if "TODO" in body:
            errors.append(f"TODO remains in {skill_path.relative_to(ROOT)}")
        if not agent_path.is_file():
            errors.append(f"Missing agents/openai.yaml for {name}")
        else:
            agent_text = agent_path.read_text(encoding="utf-8-sig")
            if f"${name}" not in agent_text:
                errors.append(f"openai.yaml default prompt must mention ${name}")


def iter_text_files() -> list[Path]:
    return [
        path
        for path in ROOT.rglob("*")
        if path.is_file()
        and path.suffix.lower() in TEXT_SUFFIXES
        and ".git" not in path.parts
        and "__pycache__" not in path.parts
    ]


def validate_public_content(errors: list[str]) -> None:
    for path in iter_text_files():
        text = path.read_text(encoding="utf-8-sig")
        relative = path.relative_to(ROOT)
        for label, pattern in SECRET_PATTERNS.items():
            if pattern.search(text):
                errors.append(f"Possible {label} in {relative}")
        for label, pattern in PRIVATE_PATH_PATTERNS.items():
            if pattern.search(text):
                errors.append(f"Possible {label} in {relative}")

        for raw_target in MARKDOWN_LINK.findall(text):
            target = raw_target.strip().split("#", 1)[0]
            if not target or target.startswith(("http://", "https://", "mailto:")):
                continue
            target = target.strip("<>")
            if not (path.parent / target).resolve().exists():
                errors.append(f"Broken local link in {relative}: {raw_target}")


def main() -> int:
    errors: list[str] = []
    validate_required_files(errors)
    validate_manifest(errors)
    validate_skills(errors)
    validate_public_content(errors)

    if errors:
        print(f"Repository validation failed with {len(errors)} error(s):", file=sys.stderr)
        for error in errors:
            print(f"- {error}", file=sys.stderr)
        return 1

    print(f"Repository validation passed: {len(EXPECTED_SKILLS)} skills, manifests, links, and public-content checks.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
