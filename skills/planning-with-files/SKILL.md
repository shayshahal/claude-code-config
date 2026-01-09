---
name: planning-with-files
description: Use persistent markdown files for planning complex tasks. Based on Manus AI's context engineering pattern. Use for multi-step tasks, research projects, or anything spanning many tool calls.
---

# Planning with Files

The Manus AI pattern for managing complex tasks using persistent files as "working memory on disk."

## When to Use

- Multi-step tasks (3+ steps)
- Research tasks
- Building/creating projects
- Tasks spanning many tool calls
- Anything requiring organization

## When NOT to Use

- Simple questions
- Single-file edits
- Quick lookups

## The 3-File Pattern

For every complex task, create three files:

```
task_plan.md      → Track phases and progress
notes.md          → Store research and findings
[deliverable].md  → Final output
```

## The Loop

```
1. Create task_plan.md with goal and phases
2. Research → save to notes.md → update task_plan.md
3. Read notes.md → create deliverable → update task_plan.md
4. Deliver final output
```

**Key insight:** By reading `task_plan.md` before each decision, goals stay in the attention window. This prevents drift across many tool calls.

## File Templates

### task_plan.md

```markdown
# Task Plan: [Task Name]

## Goal
[Clear, specific goal]

## Phases
- [x] Phase 1: Create plan
- [ ] Phase 2: Research (CURRENT)
- [ ] Phase 3: Implementation
- [ ] Phase 4: Verification
- [ ] Phase 5: Delivery

## Status
**Currently in Phase 2** - [What you're doing now]

## Progress Log
- [timestamp] Phase 1 complete - plan created
- [timestamp] Started Phase 2 - researching X

## Errors Encountered
- [List any failures to avoid repeating]

## Key Decisions
- [Important choices made and why]
```

### notes.md

```markdown
# Research Notes: [Task Name]

## Sources
- [Link/file]: Key finding

## Key Findings
1. [Finding 1]
2. [Finding 2]

## Code Snippets
[Relevant code discovered]

## Questions to Resolve
- [ ] Question 1
- [ ] Question 2
```

## Why This Works

| Problem | Solution |
|---------|----------|
| Volatile memory | Files survive context resets |
| Goal drift | Re-read plan before decisions |
| Hidden errors | Log failures in plan file |
| Context stuffing | Info in files, not prompts |

## Best Practices

1. **Re-read task_plan.md before major decisions** - keeps goals in attention
2. **Update progress immediately** - checkboxes show completion
3. **Log errors** - prevents repeating mistakes
4. **Keep notes separate** - don't bloat the plan
5. **Append, don't modify history** - maintain audit trail

## Directory Structure

For projects, consider:

```
.claude/
└── planning/
    ├── current-task/
    │   ├── task_plan.md
    │   ├── notes.md
    │   └── deliverable.md
    └── completed/
        └── [past task folders]
```

## Integration with Claude Code

This pattern complements:
- **TodoWrite** - for quick task tracking (volatile)
- **Planning mode** - for implementation planning
- **Browser MCPs** - for verification steps

Use planning-with-files when TodoWrite isn't enough (context resets, complex research, many phases).

## Attribution

Based on Manus AI's context engineering patterns. Manus achieved $100M+ revenue in 8 months using this approach.
