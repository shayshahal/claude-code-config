---
name: project-setup
description: Initialize .claude/ directory in new projects. Detects tech stack, creates appropriate skills, hooks, and CLAUDE.md. Use when starting work on a new project.
---

# Project Setup Agent

You help initialize proper `.claude/` configuration in new projects based on their tech stack.

## When to Use

- Starting work on a new project without `.claude/` setup
- User asks to "set up Claude Code for this project"
- Project has code but no Claude Code configuration

## Detection Process

1. **Identify project root** - Look for package.json, requirements.txt, Cargo.toml, go.mod, etc.

2. **Detect tech stack:**

   | File | Stack |
   |------|-------|
   | `package.json` with `svelte` | SvelteKit/Svelte |
   | `package.json` with `next` | Next.js/React |
   | `package.json` with `react` | React |
   | `package.json` with `vue` | Vue |
   | `requirements.txt` or `pyproject.toml` | Python |
   | `requirements.txt` with `fastapi` | FastAPI |
   | `Cargo.toml` | Rust |
   | `go.mod` | Go |

3. **Detect database:**
   - MongoDB: `pymongo`, `beanie`, `mongoose`
   - PostgreSQL: `psycopg`, `pg`, `prisma`
   - SQLite: `sqlite3`, `better-sqlite3`

4. **Detect testing:**
   - JavaScript: `vitest`, `jest`, `playwright`
   - Python: `pytest`, `unittest`

## Setup Actions

### 1. Create Directory Structure

```bash
mkdir -p .claude/{skills,agents,commands,hooks}
```

### 2. Create Project CLAUDE.md

Based on detected stack, create `.claude/CLAUDE.md` with:
- Project architecture overview
- Key coding standards
- Tech stack patterns
- Verification commands

### 3. Create settings.json with Verification Hooks

```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Edit|Write|MultiEdit",
      "hooks": [{
        "type": "command",
        "command": "[DETECTED_LINT_COMMAND] && [DETECTED_TYPECHECK_COMMAND]"
      }]
    }],
    "Stop": [{
      "hooks": [{
        "type": "command",
        "command": "[DETECTED_BUILD_COMMAND]"
      }]
    }]
  }
}
```

**Common commands:**
- TypeScript: `npm run lint:fix && npx tsc --noEmit`
- Python: `ruff check --fix . && mypy .`
- Rust: `cargo clippy && cargo check`

### 4. Copy Relevant Skills from Archive

If the project matches archived skills, offer to copy them:

| Stack | Skills to Copy |
|-------|---------------|
| SvelteKit | `sveltekit-svelte5-patterns`, `tailwind-shadcn-patterns` |
| FastAPI | `backend-dev-guidelines`, `api-security-patterns` |
| MongoDB | `mongodb-beanie-patterns` |
| Auth | `authentication-patterns`, `api-security-patterns` |
| Testing | `testing-patterns` |

Archive location: `~/.claude/archive/skills/`

### 5. Suggest Project-Specific Agents

If the project has specific patterns, suggest creating:
- `error-fixer.md` - Project-specific error patterns
- `code-reviewer.md` - Project-specific standards

## Output

After setup, summarize:
1. What was detected
2. What was created
3. How to use the new configuration
4. Suggestions for additional customization

## Example Interaction

**User:** "Set up Claude Code for this project"

**Agent:**
1. Scans project files
2. Detects: SvelteKit + FastAPI + MongoDB
3. Creates:
   - `.claude/CLAUDE.md` with full-stack patterns
   - `.claude/settings.json` with hooks for both frontend and backend
   - Copies relevant skills from archive
4. Reports what was created and how to customize

## Important Notes

- Always ask before copying large skill files
- Recommend installing browser MCPs for verification: `claude mcp add playwright -s user -- npx @playwright/mcp@latest`
- Suggest the planning-with-files pattern for complex projects
- Keep CLAUDE.md concise (<500 lines)
