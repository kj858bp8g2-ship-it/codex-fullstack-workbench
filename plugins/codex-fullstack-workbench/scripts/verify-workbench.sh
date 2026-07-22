#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 || "$1" != '--project' ]]; then
  printf '%s\n' 'Usage: verify-workbench.sh --project PATH' >&2
  exit 2
fi

project=$2
[[ -d "$project" ]] || { printf 'Project path is not a directory: %s\n' "$project" >&2; exit 1; }
project_root=$(CDPATH= cd -- "$project" && pwd -P)
failures=0
skills_root="$project_root/.agents/skills"
assets_root="$project_root/.agents/assets"
expected_skills=(
  setup-workbench project-onboard requirements-architecture frontend-quality
  backend-api database-auth testing-debugging security-review delivery-deploy
  context-headroom document-ingest daily-toolbox skill-lifecycle
)
required_assets=(
  capability-routing-policy.json config.headroom.example.toml maintenance-policy.json
  plugin-profiles.json source-registry.template.json skill-profiles.json
)

if [[ ! -f "$project_root/AGENTS.md" ]]; then
  printf 'Missing: %s\n' "$project_root/AGENTS.md" >&2
  failures=$((failures + 1))
fi

workbench_skill_count=0
for skill_name in "${expected_skills[@]}"; do
  skill_file="$skills_root/$skill_name/SKILL.md"
  if [[ -f "$skill_file" ]]; then
    workbench_skill_count=$((workbench_skill_count + 1))
  else
    printf 'Missing: %s\n' "$skill_file" >&2
    failures=$((failures + 1))
  fi
done

for asset_name in "${required_assets[@]}"; do
  asset_path="$assets_root/$asset_name"
  if [[ ! -f "$asset_path" ]]; then
    printf 'Missing: %s\n' "$asset_path" >&2
    failures=$((failures + 1))
  fi
done

printf 'Project: %s\nWorkbench skills present: %s/%s\n' "$project_root" "$workbench_skill_count" "${#expected_skills[@]}"
((failures == 0)) || exit 1
printf '%s\n' 'Workbench skills and project assets verified.'
