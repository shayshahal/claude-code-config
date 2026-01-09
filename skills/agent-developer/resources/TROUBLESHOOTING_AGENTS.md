# Troubleshooting Agents

Debug and resolve common issues with Claude Code agents.

## Table of Contents

1. [Agent Not Completing Task](#agent-not-completing-task)
2. [Agent Getting Stuck](#agent-getting-stuck)
3. [Agent Returning Poor Results](#agent-returning-poor-results)
4. [Agent Asking Questions Mid-Execution](#agent-asking-questions-mid-execution)
5. [Agent Timing Out](#agent-timing-out)
6. [Agent Can't Access Tools](#agent-cant-access-tools)
7. [Performance Optimization](#performance-optimization)

---

## Agent Not Completing Task

### Symptoms
- Agent starts but never returns final report
- Agent stops mid-execution without explanation
- Task appears to hang indefinitely

### Diagnosis Steps

**1. Check agent instructions:**
```bash
# View the agent file
cat .claude/agents/{agent-name}.md
```

Look for:
- Missing "Final Report" section in instructions
- No clear completion criteria
- Ambiguous ending conditions

**2. Review invocation prompt:**
- Was the task clearly defined?
- Did it include all necessary context?
- Were there conflicting instructions?

**3. Check for infinite loops:**
- Does agent have circular logic?
- Are there exit conditions for all loops?
- Could agent be stuck in analysis paralysis?

### Solutions

**Add clear completion criteria:**
```markdown
## Instructions

### Final Step: Report Results

You MUST end by returning a final report in this format:

# Task Complete: [Task Name]

## Summary
[What was accomplished]

## Status
[COMPLETE / BLOCKED / PARTIAL]

If BLOCKED or PARTIAL, explain what prevented completion.
```

**Add timeout guidance:**
```markdown
## Important Notes

- If you cannot complete the task within reasonable time (~10 minutes), report your progress and blockers
- Don't get stuck in analysis - make a decision and proceed
- If information is missing, state assumptions and proceed
```

**Simplify the task:**
- Break complex agents into smaller, focused agents
- Reduce scope of what agent is responsible for
- Remove optional steps that could cause confusion

---

## Agent Getting Stuck

### Symptoms
- Agent repeats same action multiple times
- Agent searches endlessly without progressing
- Agent can't make a decision

### Common Causes

**1. Insufficient guidance on decision-making:**
```markdown
❌ BAD:
"Analyze the code and determine the best approach"

✅ GOOD:
"Analyze the code:
- If error is TypeScript type mismatch → Fix type definitions
- If error is missing import → Add import statement
- If error is logic bug → Fix the logic
- If unclear → Check similar working code for pattern"
```

**2. No fallback behavior:**
```markdown
❌ BAD:
"Find the configuration file"

✅ GOOD:
"Find the configuration file:
1. Check for config.ts in src/
2. Check for config.ts in root
3. Check for .env file
4. If not found: Create default config based on template"
```

**3. Too many options without prioritization:**
```markdown
❌ BAD:
"Check all possible causes"

✅ GOOD:
"Check causes in order of likelihood:
1. First check for common issue X (80% of cases)
2. Then check for issue Y (15% of cases)
3. Finally check for edge case Z (5% of cases)"
```

### Solutions

**Add decision trees:**
```markdown
## Instructions

### Decision Logic

**Step 1: Classify Error**
- Read error message
- Match against patterns:
  - Pattern A (type error) → Go to Section 3.1
  - Pattern B (runtime error) → Go to Section 3.2
  - Pattern C (build error) → Go to Section 3.3
  - Unknown → Go to Section 3.4

### Section 3.1: Handle Type Errors
[Specific steps...]

### Section 3.4: Handle Unknown Errors
[Fallback steps with clear exit]
```

**Add progress checkpoints:**
```markdown
After each major step, verify progress:
- [ ] Step 1 complete - Found X files
- [ ] Step 2 complete - Identified Y pattern
- [ ] Step 3 complete - Applied Z fix

If any step fails after 3 attempts, report blocker and move to next step or exit.
```

**Set iteration limits:**
```markdown
## Important Notes

- Maximum 3 search attempts per file pattern
- Maximum 5 files to analyze
- If solution not found after checking top 3 likely causes, report findings and suggest next steps rather than continuing indefinitely
```

---

## Agent Returning Poor Results

### Symptoms
- Agent completes but results are not useful
- Report is too vague or generic
- Missing critical information
- Incorrect analysis or recommendations

### Diagnosis

**1. Review agent output format requirements:**
- Is the expected format clearly specified?
- Are all required sections listed?
- Are examples provided?

**2. Check instruction specificity:**
- Are instructions concrete or vague?
- Do they specify what to include?
- Do they provide examples of good output?

**3. Verify agent has necessary context:**
- Was invocation prompt comprehensive?
- Does agent have access to needed files?
- Are there missing dependencies?

### Solutions

**Specify exact output format:**
```markdown
## Final Report

Return your findings in EXACTLY this format:

# Error Resolution Report

## Error Details
- **File**: [exact file path]
- **Line**: [line number]
- **Message**: [exact error message]
- **Type**: [TypeScript/Runtime/Build/Other]

## Root Cause
[One paragraph explaining the underlying issue]

## Fix Applied

### File: [path]
**Lines Modified**: [X-Y]

**Before**:
```typescript
[Exact code before]
```

**After**:
```typescript
[Exact code after]
```

**Reason**: [Why this change fixes the issue]

## Verification
- [ ] Command run: [exact command]
- [ ] Result: [PASS/FAIL]
- [ ] Output: [relevant output]

## Impact
- Files changed: [count]
- Related areas affected: [list]
- Breaking changes: [YES/NO - if yes, explain]

DO NOT deviate from this format.
```

**Provide good/bad examples:**
```markdown
## Examples of Good Reports

### Example 1:
```
# Error Resolution Report

## Error Details
- **File**: src/components/Dashboard.tsx
- **Line**: 45
- **Message**: Property 'userId' does not exist on type 'User'
- **Type**: TypeScript

[...full example...]
```

### Example of Bad Report (DON'T DO THIS):
```
I fixed the error. Everything works now.
```

This is bad because it:
- Doesn't specify what was fixed
- Doesn't show code changes
- Doesn't include verification
- Provides no context for future reference
```

**Add quality checklist:**
```markdown
## Before Submitting Report

Verify your report includes:
- [ ] Specific file paths with line numbers
- [ ] Exact error messages (not paraphrased)
- [ ] Code snippets showing before/after
- [ ] Verification command output
- [ ] Impact analysis
- [ ] All sections from template completed

If any checkbox is unchecked, your report is incomplete.
```

---

## Agent Asking Questions Mid-Execution

### Symptoms
- Agent tries to use AskUserQuestion tool
- Agent says "I need more information"
- Agent requests clarification mid-task

### Root Cause
Agent instructions don't provide enough guidance for autonomous operation.

### Solutions

**Make instructions self-sufficient:**
```markdown
❌ BAD:
"Review the code and identify issues"

✅ GOOD:
"Review the code against these specific criteria:
1. Security: Check for SQL injection, XSS, CSRF
2. Error handling: All async operations in try-catch
3. Types: All functions have return type annotations
4. Naming: camelCase for variables, PascalCase for types

For each issue found, categorize as:
- CRITICAL: Security vulnerability or data loss risk
- HIGH: Violates best practice, causes bugs
- MEDIUM: Code smell, maintainability issue
- LOW: Style preference, minor optimization

If uncertain about severity, default to MEDIUM and note uncertainty in report."
```

**Provide decision-making criteria:**
```markdown
When you encounter ambiguity:

**Scenario**: Multiple possible causes for error
**Action**: Test each cause in order of likelihood, report findings for all

**Scenario**: Unclear which pattern to follow
**Action**: Use the pattern found in similar existing code

**Scenario**: Missing information about user preference
**Action**: Use project defaults or industry standard practice, note assumption in report

**Scenario**: Cannot determine correct approach
**Action**: Report the options found, recommend the safest/simplest, proceed with that
```

**Include all necessary context in invocation:**

Main Claude should provide comprehensive prompt:
```typescript
Task({
  subagent_type: "my-agent",
  prompt: `
  [Task description]

  Context:
  - Project uses React with TypeScript
  - State management: Redux Toolkit
  - Styling: Material-UI v7
  - Code style: Prettier with 2-space indent
  - Testing: Vitest
  - All errors must be reported to Sentry

  Constraints:
  - Maintain backward compatibility
  - Keep bundle size impact < 50KB
  - Follow existing component patterns

  [Rest of detailed instructions]
  `
})
```

---

## Agent Timing Out

### Symptoms
- Agent doesn't complete within reasonable time
- Task takes > 10 minutes
- Agent performs too many operations

### Common Causes

**1. Scope too broad:**
Agent trying to do too much in one execution

**2. Inefficient operations:**
- Reading too many large files
- Running expensive searches repeatedly
- Not using targeted tools

**3. No prioritization:**
Agent exploring every possibility instead of likely causes

### Solutions

**Narrow agent scope:**
```markdown
❌ BAD: "Review and refactor the entire codebase"

✅ GOOD: "Review the authentication module (src/auth/) for security issues"
```

**Add time budgets:**
```markdown
## Time Budget Guidelines

This task should complete in ~5 minutes:
- Step 1 (Analysis): ~2 minutes
- Step 2 (Implementation): ~2 minutes
- Step 3 (Verification): ~1 minute

If any step is taking longer:
- Stop and report progress
- Note what's causing delay
- Suggest next steps
```

**Optimize tool usage:**
```markdown
## Efficient Searching

DON'T:
```bash
# Read every file
for file in src/**/*.ts; do
  Read($file)
done
```

DO:
```bash
# Search first, read only relevant files
Grep("pattern", "src/**/*.ts", output_mode: "files_with_matches")
# Then Read only the matched files
```

**Prioritize likely causes:**
```markdown
Check in order (stop when found):
1. ✅ Most likely: Type definition mismatch (70% of cases)
2. ⏭️ If not #1: Missing import (20% of cases)
3. ⏭️ If not #1 or #2: Logic error (10% of cases)

Don't check all causes if you find the issue.
```

**Use appropriate granularity:**
```markdown
For large files:
- Use Grep to find relevant sections
- Read with offset/limit for specific parts
- Don't read entire 5000-line files if you need one function
```

---

## Agent Can't Access Tools

### Symptoms
- Error: "Tool X not available"
- Agent can't complete task due to missing tool
- Permission denied errors

### Diagnosis

**Check frontmatter:**
```markdown
---
name: my-agent
description: My agent description
tools: Read, Write, Grep  # ← Limited tools
---
```

**Check if tool needed:**
- Does agent need to modify files? → Needs Write/Edit
- Does agent need to run commands? → Needs Bash
- Does agent need to search? → Needs Grep/Glob

### Solutions

**Use "All tools" for most agents:**
```markdown
---
name: my-agent
description: My agent description
tools: All tools  # ← Gives access to everything
---
```

**Or grant specific tools needed:**
```markdown
---
name: code-reviewer
description: Review code (read-only)
tools: Read, Glob, Grep, Bash  # ← Read and search only
---
```

**Update agent if tool requirements changed:**
```markdown
# Agent initially only read files
tools: Read, Glob, Grep

# Now needs to fix files too
tools: Read, Write, Edit, Glob, Grep, Bash
```

---

## Performance Optimization

### Making Agents Faster and More Efficient

**1. Limit file reads:**
```markdown
❌ SLOW:
"Read all TypeScript files in src/ and analyze"

✅ FAST:
"Use Grep to find files with 'useState' in src/, then read only those files"
```

**2. Use targeted searches:**
```markdown
❌ SLOW:
```bash
Grep("error", "**/*.*")  # Search everything
```

✅ FAST:
```bash
Grep("error", "src/**/*.ts", type: "ts")  # Search only TypeScript in src
```

**3. Batch operations:**
```markdown
❌ SLOW:
"For each file, read it, analyze it, report findings"

✅ FAST:
"Read all relevant files, analyze together, report all findings"
```

**4. Cache results:**
```markdown
In agent instructions:
"Store intermediate results to avoid re-computing:
- After finding files, note the list
- After reading files, note key patterns
- Refer back to notes instead of re-searching"
```

**5. Early exit:**
```markdown
"If you find a critical error:
- Fix it immediately
- Verify the fix
- Report and exit

Don't continue searching for other issues if critical issue found."
```

**6. Parallelize when possible:**
```markdown
"When testing multiple routes:
- Note all routes to test
- Test them in a batch if possible
- Report results together"
```

---

## Debugging Checklist

When an agent isn't working correctly:

### Agent Definition
- [ ] Frontmatter has name, description, tools
- [ ] Description is clear and specific (2-3 sentences)
- [ ] Tools field includes all needed tools
- [ ] Instructions are sequential and numbered
- [ ] Each step has clear completion criteria
- [ ] Final report format is specified
- [ ] Edge cases are handled
- [ ] Examples are provided

### Invocation
- [ ] Prompt includes specific task description
- [ ] All necessary context provided
- [ ] File paths specified if relevant
- [ ] Error messages included if applicable
- [ ] Expected outcomes listed
- [ ] Verification criteria defined
- [ ] Output format requested

### Instructions Quality
- [ ] Each step is concrete and actionable
- [ ] Decision logic is explicit
- [ ] Fallback behaviors defined
- [ ] No ambiguous requirements
- [ ] Time/iteration limits set
- [ ] Progress checkpoints included
- [ ] No circular dependencies

### Expected Output
- [ ] Report format template provided
- [ ] All required sections listed
- [ ] Good/bad examples shown
- [ ] Quality checklist included
- [ ] Specific file:line reference requirements
- [ ] Verification output requirements

---

## Getting Help

If you've tried everything and agent still not working:

**1. Simplify the agent:**
- Remove optional steps
- Narrow the scope
- Test with simplest possible task
- Add more explicit instructions

**2. Test manually:**
- Try following agent instructions yourself
- See where you get confused or stuck
- That's where agent likely struggles too

**3. Review similar working agents:**
- Look at agents that work well
- Compare structure and instructions
- Adopt successful patterns

**4. Iterate incrementally:**
- Start with minimal agent
- Test it works
- Add one feature at a time
- Test after each addition

**5. Check invocation:**
- Problem might not be agent definition
- Could be how it's being invoked
- Try invoking with more context
- Specify exactly what you want
