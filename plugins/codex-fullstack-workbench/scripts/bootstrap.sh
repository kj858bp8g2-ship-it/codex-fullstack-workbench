#!/usr/bin/env bash
set -euo pipefail

usage() {
  printf '%s\n' 'Usage: bootstrap.sh --project PATH [--install-skills] [--apply] [--force]'
}

project=''
install_skills=false
apply=false
force=false

while (($#)); do
  case "$1" in
    --project)
      [[ $# -ge 2 ]] || { usage >&2; exit 2; }
      project=$2
      shift 2
      ;;
    --install-skills) install_skills=true; shift ;;
    --apply) apply=true; shift ;;
    --force) force=true; shift ;;
    -h|--help) usage; exit 0 ;;
    *) printf 'Unknown option: %s\n' "$1" >&2; usage >&2; exit 2 ;;
  esac
done

[[ -n "$project" ]] || { usage >&2; exit 2; }
[[ -d "$project" ]] || { printf 'Project path is not a directory: %s\n' "$project" >&2; exit 1; }

script_dir=$(CDPATH= cd -- "$(dirname "$0")" && pwd -P)
plugin_root=$(CDPATH= cd -- "$script_dir/.." && pwd -P)
project_root=$(CDPATH= cd -- "$project" && pwd -P)
agents_template="$plugin_root/assets/AGENTS.template.md"
assets_source="$plugin_root/assets"
skills_source="$plugin_root/skills"
timestamp=$(date '+%Y%m%d-%H%M%S')
backup_root="$project_root/.codex-workbench-backups/$timestamp"
backup_suffix=0
while [[ -e "$backup_root" ]]; do
  backup_suffix=$((backup_suffix + 1))
  backup_root="$project_root/.codex-workbench-backups/$timestamp-$backup_suffix"
done

plan_item() {
  local kind=$1 source=$2 destination=$3 action
  if [[ ! -e "$destination" ]]; then
    action='CREATE'
  elif [[ "$force" == true ]]; then
    action='BACKUP_AND_REPLACE'
  else
    action='SKIP_EXISTS'
  fi
  printf '%s\t%s\t%s\t%s\n' "$action" "$kind" "$source" "$destination"
}

plan_file=$(mktemp "${TMPDIR:-/tmp}/codex-workbench-plan.XXXXXX")
trap 'rm -f "$plan_file"' EXIT
plan_item 'AGENTS' "$agents_template" "$project_root/AGENTS.md" >> "$plan_file"

if [[ "$install_skills" == true ]]; then
  for skill_dir in "$skills_source"/*; do
    [[ -d "$skill_dir" ]] || continue
    skill_name=${skill_dir##*/}
    plan_item 'SKILL' "$skill_dir" "$project_root/.agents/skills/$skill_name" >> "$plan_file"
  done
  for asset in "$assets_source"/*; do
    [[ -f "$asset" ]] || continue
    plan_item 'ASSET' "$asset" "$project_root/.agents/assets/${asset##*/}" >> "$plan_file"
  done
fi

if [[ "$apply" == true ]]; then mode='APPLY'; else mode='PREVIEW'; fi
printf 'Mode: %s\nProject: %s\n' "$mode" "$project_root"
printf 'ACTION\tKIND\tSOURCE\tDESTINATION\n'
cat "$plan_file"

if [[ "$apply" != true ]]; then
  printf '%s\n' 'No files were changed. Re-run with --apply after reviewing the plan.'
  exit 0
fi

while IFS=$'\t' read -r action kind source destination; do
  if [[ "$action" == 'SKIP_EXISTS' ]]; then
    printf 'Skipped existing path: %s\n' "$destination"
    continue
  fi

  mkdir -p "$(dirname "$destination")"
  if [[ "$action" == 'BACKUP_AND_REPLACE' ]]; then
    case "$kind" in
      AGENTS) backup_path="$backup_root/AGENTS.md" ;;
      SKILL) backup_path="$backup_root/skills/${destination##*/}" ;;
      ASSET) backup_path="$backup_root/assets/${destination##*/}" ;;
    esac
    mkdir -p "$(dirname "$backup_path")"
    mv "$destination" "$backup_path"
    printf 'Backed up: %s\n' "$backup_path"
  fi

  if [[ "$kind" == 'SKILL' ]]; then
    cp -R "$source" "$destination"
  else
    cp "$source" "$destination"
  fi
  printf 'Installed: %s\n' "$destination"
done < "$plan_file"

printf '%s\n' 'Workbench files installed. Start a new Codex task so skill discovery can refresh.'
