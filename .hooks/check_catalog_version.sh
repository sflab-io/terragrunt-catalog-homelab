#!/usr/bin/env bash
set -e

branch=$(git rev-parse --abbrev-ref HEAD)

if [ "$branch" = "main" ]; then
  file="examples/terragrunt/environment.hcl"
  if ! grep -qE 'catalog_version\s*=\s*"main"' "$file"; then
    echo "ERROR: Branch 'main' erfordert catalog_version = \"main\" in $file"
    echo ""
    echo "Aktueller Wert:"
    grep 'catalog_version' "$file" || echo "(nicht gefunden)"
    exit 1
  fi
fi
