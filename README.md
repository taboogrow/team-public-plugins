# Taboo Grow - Team Public Plugins

A curated Claude Code **marketplace** of vetted, public third-party plugins the team should have. Add it once, install what you need, and everything comes from one place you control.

This repo is the **installable source of truth**. The matching catalog on [ClaudePluginHub](https://www.claudepluginhub.com/) ("Taboo Grow - Public Plugins For Team") is the human-facing tracker/organizer, but teammates install from *here* (see "Why this repo exists" below).

---

## For team members: how to install

1. Add this marketplace (run in any directory - it is global to your user):

   ```
   /plugin marketplace add taboogrow/team-public-plugins
   ```

2. Install the plugins you want. To grab everything:

   ```
   /plugin install skill-creator@team-public-plugins
   /plugin install superpowers@team-public-plugins
   /plugin install session-report@team-public-plugins
   /plugin install claude-code-setup@team-public-plugins
   ```

   (Or open `/plugin`, pick `team-public-plugins`, and install from the menu.)

3. Restart Claude Code (or run `/reload-plugins`) so they load.

> Installs are **user-scoped**, so the plugins are available in every project/session, not just the folder you ran the command in.

---

## What's included

| Plugin | What it does | Upstream source |
|--------|--------------|-----------------|
| **skill-creator** | Author, evaluate, and iteratively improve Claude Code skills. | `anthropics/claude-plugins-official` @ `plugins/skill-creator` |
| **superpowers** | TDD workflow, parallel task execution, git worktrees, systematic code review, collaboration patterns. | `obra/superpowers` (root plugin) |
| **session-report** | Explorable HTML report of a Claude Code session (tokens, cache, subagents, costs). | `anthropics/claude-plugins-official` @ `plugins/session-report` |
| **claude-code-setup** | Scans a codebase and recommends tailored automations (hooks, skills, MCP, subagents). | `anthropics/claude-plugins-official` @ `plugins/claude-code-setup` |

All four are maintained by **other people** (Anthropic, obra). Per team policy: **have Claude vet a plugin before installing**, and these are pinned to **no auto-update** so an upstream author cannot silently push changes into an install you already trust.

---

## Why this repo exists (instead of adding the ClaudePluginHub URL directly)

Two reasons the hub URL cannot be added natively today:

1. **Malformed marketplace `name`.** The hub emits `"name": "<collectionId>/<slug>"`. Claude Code rejects any marketplace `name` containing `/`, so `/plugin marketplace add <hub-url>` fails schema validation. (Reported upstream.)
2. **Wrong plugin sources.** The hub references some plugins by *whole repo* (e.g. skill-creator -> `anthropics/skills`), but that repo has **no standalone skill-creator plugin** - it lives in `anthropics/claude-plugins-official`. A blind copy of the hub's entries would not install.

This repo fixes both: a valid `name` and **verified native sources** (confirmed against working marketplaces). So the hub stays the nice catalog UI; this repo is what actually installs.

---

## Maintaining the list (for the admin)

Each plugin is one entry in [`.claude-plugin/marketplace.json`](.claude-plugin/marketplace.json). Supported `source` shapes (all proven working):

- Single-plugin repo: `{ "source": "github", "repo": "owner/repo" }`
- Plugin inside a monorepo/marketplace: `{ "source": "git-subdir", "url": "owner/repo", "path": "plugins/<name>" }`
- Pin to a commit: add `"ref": "main"` and/or `"sha": "<commit>"`

**To add a plugin:** find its real native source (which repo + path actually contains a `plugin.json`), add an entry, open a PR, merge. Do **not** just copy the hub's entry - verify the source first.

**Drift check vs. the hub:** run `scripts/hub-drift-check.sh` to see whether the ClaudePluginHub collection lists plugins that are not yet in this repo (or vice versa). It only *reports* differences; it never overwrites your verified sources.

---

## Repo facts

- Visibility: **public** (contains only references to already-public plugins; keeps `/plugin marketplace add` friction-free for teammates - no repo access needed).
- Owner: Taboo Grow Team
- Marketplace name: `team-public-plugins`
