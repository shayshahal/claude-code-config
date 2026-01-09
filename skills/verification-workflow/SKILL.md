---
name: verification-workflow
description: General task verification patterns. Ensures Claude provides evidence of task completion before marking done. Applies to ALL tasks (research, writing, configuration, etc.). For coding-specific verification, see /home/shay/coding/.claude/.
triggers:
  - pattern: "done|complete|finished|ready"
    type: intent
  - pattern: "verify|check|confirm"
    type: intent
---

# Task Verification Workflow

## Core Principle

**Never mark a task complete without concrete evidence of success.**

```
UNDERSTAND → EXECUTE → VERIFY → REPORT
```

---

## General Task Verification

### Research Tasks

**Before marking complete:**
- [ ] Sources cited and accessible
- [ ] Information cross-referenced
- [ ] Key findings summarized
- [ ] Gaps/limitations noted

**Evidence format:**
```
Sources consulted: [list URLs/references]
Key findings: [summary]
Confidence: [high/medium/low]
```

### Writing Tasks

**Before marking complete:**
- [ ] Addresses the request fully
- [ ] Accurate information
- [ ] Clear and well-structured
- [ ] No obvious errors

### Configuration Tasks

**Before marking complete:**
- [ ] Changes applied
- [ ] Services restarted if needed
- [ ] Functionality verified
- [ ] No errors in logs

**Evidence format:**
```
Changed: [what was modified]
Verified: [how it was tested]
Status: [working/issues found]
```

### Analysis Tasks

**Before marking complete:**
- [ ] Data examined thoroughly
- [ ] Patterns/insights identified
- [ ] Conclusions supported by evidence
- [ ] Limitations acknowledged

---

## Coding Tasks

For coding verification, defer to the coding tier:
- **Location:** `/home/shay/coding/.claude/`
- **Skill:** `code-verification`
- **Agent:** `app-verifier`

Coding verification includes:
- Type checking
- Build verification
- Test execution
- Browser verification
- Debugging (when verification fails)

---

## When Verification Fails

If you cannot verify task completion:

1. **State what was attempted**
2. **Explain what blocked verification**
3. **Propose next steps**
4. **Ask user how to proceed**

Do NOT mark a task complete if verification failed.

---

## Evidence Format

When completing ANY task, include:

```markdown
## Task Complete

**What was done:** [brief description]
**Verification:** [how you confirmed it works]
**Evidence:** [concrete proof - output, screenshot, test result]
```

---

**Remember:** If you can't verify it, you can't claim it's done.
