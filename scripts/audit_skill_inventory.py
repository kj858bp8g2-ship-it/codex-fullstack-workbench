#!/usr/bin/env python3
"""Inventory Codex Skills without exposing local paths by default."""

from __future__ import annotations

import argparse
import json
import os
import re
import sys
from collections import defaultdict
from pathlib import Path


NAME_PATTERN = re.compile(r"^name:\s*[\"']?([^\"'\r\n]+)", re.MULTILINE)


def default_roots() -> list[Path]:
    codex_home = Path(os.environ.get("CODEX_HOME", Path.home() / ".codex"))
    return [codex_home / "skills", codex_home / "plugins" / "cache"]


def read_skill_name(path: Path) -> str | None:
    try:
        head = path.read_text(encoding="utf-8-sig")[:8192]
    except (OSError, UnicodeError):
        return None
    match = NAME_PATTERN.search(head)
    return match.group(1).strip() if match else None


def collect(roots: list[Path]) -> tuple[list[dict[str, str]], list[str]]:
    records: list[dict[str, str]] = []
    missing: list[str] = []
    for index, root in enumerate(roots, start=1):
        expanded = root.expanduser()
        if not expanded.is_dir():
            missing.append(str(root))
            continue
        label = f"root-{index}"
        for skill_file in expanded.rglob("SKILL.md"):
            name = read_skill_name(skill_file)
            if not name:
                continue
            records.append(
                {
                    "name": name,
                    "source": label,
                    "path": str(skill_file),
                }
            )
    return records, missing


def build_report(records: list[dict[str, str]], missing: list[str], include_paths: bool) -> dict[str, object]:
    by_name: dict[str, list[dict[str, str]]] = defaultdict(list)
    for record in records:
        by_name[record["name"]].append(record)

    duplicates = {
        name: entries
        for name, entries in sorted(by_name.items())
        if len(entries) > 1
    }
    skills = []
    for name, entries in sorted(by_name.items()):
        item: dict[str, object] = {
            "name": name,
            "copies": len(entries),
            "sources": sorted({entry["source"] for entry in entries}),
        }
        if include_paths:
            item["paths"] = [entry["path"] for entry in entries]
        skills.append(item)

    report: dict[str, object] = {
        "skill_files": len(records),
        "unique_names": len(by_name),
        "duplicate_names": len(duplicates),
        "missing_roots": len(missing),
        "skills": skills,
    }
    if include_paths:
        report["missing_root_paths"] = missing
    return report


def render_markdown(report: dict[str, object]) -> str:
    lines = [
        "# Skill inventory",
        "",
        f"- Skill files: {report['skill_files']}",
        f"- Unique names: {report['unique_names']}",
        f"- Duplicate names: {report['duplicate_names']}",
    ]
    if report["missing_roots"]:
        lines.append(f"- Missing roots: {report['missing_roots']}")
    lines.extend(["", "| Skill | Copies | Sources |", "| --- | ---: | --- |"])
    for item in report["skills"]:
        if not isinstance(item, dict):
            continue
        sources = ", ".join(item["sources"])
        lines.append(f"| `{item['name']}` | {item['copies']} | {sources} |")
    return "\n".join(lines) + "\n"


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", action="append", type=Path, help="Skill search root; repeat as needed")
    parser.add_argument("--format", choices=("summary", "markdown", "json"), default="summary")
    parser.add_argument("--include-paths", action="store_true", help="Include absolute paths; off by default")
    parser.add_argument("--output", type=Path, help="Write the report to this file instead of stdout")
    args = parser.parse_args()

    roots = args.root or default_roots()
    records, missing = collect(roots)
    report = build_report(records, missing, args.include_paths)
    if not records:
        print("No readable SKILL.md files were found.", file=sys.stderr)
        return 1

    if args.format == "json":
        rendered = json.dumps(report, ensure_ascii=False, indent=2) + "\n"
    elif args.format == "markdown":
        rendered = render_markdown(report)
    else:
        rendered = (
            f"Skill files: {report['skill_files']}\n"
            f"Unique names: {report['unique_names']}\n"
            f"Duplicate names: {report['duplicate_names']}\n"
            f"Missing roots: {report['missing_roots']}\n"
        )

    if args.output:
        args.output.write_text(rendered, encoding="utf-8")
    else:
        sys.stdout.write(rendered)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
