#!/usr/bin/env bash
# hub-drift-check.sh
# Compares the plugin NAMES in this repo's marketplace against the ClaudePluginHub
# collection. REPORT ONLY - it never edits marketplace.json. Use it to notice when
# the hub catalog has gained/lost a plugin so you can add/remove it here (with a
# VERIFIED native source, not a blind copy of the hub entry).
set -euo pipefail

HUB_URL="https://www.claudepluginhub.com/api/collections/dP1jafLSpQiFj3fI345Bzt0YpCvoezlK/taboo-grow-public-plugins-for-team/marketplace.json"
REPO_MARKETPLACE="$(cd "$(dirname "$0")/.." && pwd)/.claude-plugin/marketplace.json"

echo "Fetching hub collection..."
export HUB_JSON="$(curl -fsSL "$HUB_URL")"

python3 - "$REPO_MARKETPLACE" <<'PY'
import json, os, sys

repo = json.load(open(sys.argv[1]))
hub = json.loads(os.environ["HUB_JSON"])

hub_names = {p.get("name") for p in hub.get("plugins", [])}
repo_names = {p.get("name") for p in repo.get("plugins", [])}

def norm(n): return (n or "").lower()

# The hub prefixes some names (e.g. "anthropics-...-skill-creator"); match loosely.
only_hub = sorted(n for n in hub_names
                  if not any(norm(r) in norm(n) or norm(n).endswith(norm(r)) for r in repo_names))
only_repo = sorted(n for n in repo_names
                   if not any(norm(n) in norm(h) or norm(h).endswith(norm(n)) for h in hub_names))

print(f"\nRepo marketplace : {sorted(repo_names)}")
print(f"Hub collection   : {sorted(hub_names)}\n")

if not only_hub and not only_repo:
    print("OK - no drift. Repo and hub cover the same plugins.")
else:
    if only_hub:
        print("IN HUB but NOT in repo (consider adding, with a VERIFIED source):")
        for n in only_hub:
            print(f"  + {n}")
    if only_repo:
        print("IN REPO but NOT in hub (consider removing from repo, or add to hub):")
        for n in only_repo:
            print(f"  - {n}")
    print("\nReminder: never blind-copy hub 'source' fields. Verify the real repo+path first.")
PY
