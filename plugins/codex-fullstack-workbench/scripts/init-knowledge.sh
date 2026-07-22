#!/usr/bin/env bash
set -euo pipefail

usage() {
  printf '%s\n' 'Usage: init-knowledge.sh --project PATH [--apply]'
}

project=''
apply=false

while (($#)); do
  case "$1" in
    --project)
      [[ $# -ge 2 ]] || { usage >&2; exit 2; }
      project=$2
      shift 2
      ;;
    --apply) apply=true; shift ;;
    -h|--help) usage; exit 0 ;;
    *) printf 'Unknown option: %s\n' "$1" >&2; usage >&2; exit 2 ;;
  esac
done

[[ -n "$project" ]] || { usage >&2; exit 2; }
[[ -d "$project" ]] || { printf 'Project path is not a directory: %s\n' "$project" >&2; exit 1; }

script_dir=$(CDPATH= cd -- "$(dirname "$0")" && pwd -P)
plugin_root=$(CDPATH= cd -- "$script_dir/.." && pwd -P)
project_root=$(CDPATH= cd -- "$project" && pwd -P)
knowledge_source="$plugin_root/assets/knowledge"
knowledge_target="$project_root/.codex-workbench/knowledge"
policy_source="$plugin_root/assets/maintenance-policy.json"
policy_target="$project_root/.codex-workbench/maintenance-policy.json"
registry_source="$plugin_root/assets/source-registry.template.json"
registry_target="$project_root/.codex-workbench/source-registry.json"
plan_file=$(mktemp "${TMPDIR:-/tmp}/codex-knowledge-plan.XXXXXX")
trap 'rm -f "$plan_file"' EXIT

plan_item() {
  local source=$1 destination=$2 action
  if [[ -e "$destination" ]]; then action='SKIP_EXISTS'; else action='CREATE'; fi
  printf '%s\t%s\t%s\n' "$action" "$source" "$destination" >> "$plan_file"
}

for source in "$knowledge_source"/*; do
  [[ -f "$source" ]] || continue
  plan_item "$source" "$knowledge_target/${source##*/}"
done
plan_item "$policy_source" "$policy_target"
plan_item "$registry_source" "$registry_target"

if [[ "$apply" == true ]]; then mode='APPLY'; else mode='PREVIEW'; fi
printf 'Mode: %s\nProject: %s\n' "$mode" "$project_root"
printf 'ACTION\tSOURCE\tDESTINATION\n'
cat "$plan_file"

if [[ "$apply" != true ]]; then
  printf '%s\n' 'No files were changed. Re-run with --apply after reviewing the plan.'
  exit 0
fi

while IFS=$'\t' read -r action source destination; do
  if [[ "$action" == 'SKIP_EXISTS' ]]; then
    printf 'Skipped existing path: %s\n' "$destination"
    continue
  fi
  mkdir -p "$(dirname "$destination")"
  cp "$source" "$destination"
  printf 'Initialized: %s\n' "$destination"
done < "$plan_file"

printf '%s\n' 'Knowledge loop initialized. Existing files were never overwritten.'
