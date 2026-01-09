---
name: agent-developer
description: Comprehensive guide for creating and managing custom agents in Claude Code. Use when creating agents, developing Task tool subagents, building specialized agents, writing agent prompts, configuring agent types, defining agent tools, agent best practices, autonomous task handlers, multi-step agent workflows, agent naming conventions, agent descriptions, testing agents, debugging agents, or working with files in agents/ directory.
---

# Agent Developer Guide

## Purpose

Guide for creating custom agents in Claude Code - autonomous Claude instances that handle complex, multi-step tasks independently and return comprehensive reports.

## When to Use This Skill

Automatically activates when:
- Creating or modifying agents
- Working with Task tool and subagent patterns
- Developing autonomous task handlers
- Writing agent prompt files
- Configuring agent capabilities
- Testing or debugging agents
- Working with files in `agents/` directory

---

## What Are Agents?

**Agents** are specialized Claude instances launched via the Task tool to autonomously handle complex tasks. Each agent:

- Runs in its own isolated context
- Has access to specific tools (configurable)
- Executes multi-step workflows independently
- Returns a final report when complete
- Cannot be interrupted or receive additional messages mid-execution

**Key Difference from Main Session:**
- Main Claude: Interactive, conversational, can ask questions
- Agent: Autonomous, must complete task independently with initial instructions only

---

## Agent File Structure

### Location
```
.claude/agents/{agent-name}.md
```

### Basic Template

```markdown
---
name: my-specialized-agent
description: Brief 1-2 sentence description that appears in Task tool listings. Include the agent's primary purpose and when to use it.
tools: All tools
---

# Agent Name

## Purpose
Clear statement of what this agent does and why it exists.

## When to Use
Specific scenarios when main Claude should invoke this agent:
- Scenario 1 with example
- Scenario 2 with example
- Scenario 3 with example

## Capabilities
What the agent can do:
- Capability 1
- Capability 2
- Capability 3

## Instructions

### Step 1: Initial Analysis
Detailed instructions for what the agent should do first...

### Step 2: Core Task
Detailed instructions for the main work...

### Step 3: Verification
How to verify the work is complete and correct...

### Step 4: Final Report
What to include in the final report back to main Claude...

## Important Notes
- Critical constraint 1
- Critical constraint 2
- Edge cases to handle

## Examples

### Example 1: [Scenario Name]
**Input:** What the agent receives
**Process:** How it should handle it
**Output:** What it should return

### Example 2: [Scenario Name]
**Input:** What the agent receives
**Process:** How it should handle it
**Output:** What it should return
```

---

## Agent Naming Conventions

### Name Format
- Lowercase with hyphens: `error-resolver`, `code-reviewer`
- Descriptive and specific: NOT `helper`, YES `frontend-error-fixer`
- Action-oriented: `refactor-planner`, `route-tester`, `plan-reviewer`

### Good Names
✅ `frontend-error-fixer` - Clear scope and action
✅ `auth-route-tester` - Specific domain and purpose
✅ `documentation-architect` - Clear role and responsibility
✅ `code-architecture-reviewer` - Precise and descriptive

### Bad Names
❌ `helper` - Too vague
❌ `agent` - Not descriptive
❌ `fixer` - What does it fix?
❌ `test` - What kind of test?

---

## Agent Descriptions

The description field appears in Task tool documentation and helps main Claude decide when to invoke the agent.

### Description Best Practices

**Length:** 1-3 sentences (aim for 2)

**Structure:**
1. What the agent does (primary purpose)
2. When to use it (triggering scenarios)
3. Optional: Key capabilities or constraints

**Good Examples:**

```yaml
description: Use this agent when you encounter frontend errors, whether they appear during the build process (TypeScript, bundling, linting errors) or at runtime in the browser console (JavaScript errors, React errors, network issues). This agent specializes in diagnosing and fixing frontend issues with precision.
```

```yaml
description: Use this agent when you need to test routes after implementing or modifying them. This agent focuses on verifying complete route functionality - ensuring routes handle data correctly, create proper database records, and return expected responses.
```

```yaml
description: Use this agent when you have a development plan that needs thorough review before implementation to identify potential issues, missing considerations, or better alternatives.
```

**Bad Examples:**

❌ `description: Helps with code` - Too vague
❌ `description: Testing agent` - What kind of testing?
❌ `description: Use this for everything` - Not specific enough

---

## Tool Access Configuration

### Tools Field Options

**All tools** (most common):
```yaml
tools: All tools
```

**Specific tools** (restricted agents):
```yaml
tools: Read, Write, Edit, MultiEdit, Bash
```

**No write access** (read-only agents):
```yaml
tools: Read, Glob, Grep, Bash
```

### When to Restrict Tools

**Use "All tools"** when:
- Agent needs to modify code
- Agent may need any tool to complete task
- Agent should have full autonomy
- Most agents fall into this category

**Restrict tools** when:
- Agent is exploratory only (Explore agents)
- Agent should not modify files (research agents)
- Agent has a very specific, narrow scope
- Security or safety concerns

### Common Tool Combinations

**Full autonomy:**
```yaml
tools: All tools
```

**Read and analyze:**
```yaml
tools: Read, Glob, Grep
```

**Code modification:**
```yaml
tools: Read, Write, Edit, MultiEdit, Glob, Grep
```

**Testing and validation:**
```yaml
tools: Read, Bash, Glob, Grep
```

---

## Agent Types and Patterns

### 1. Error Resolution Agents

**Purpose:** Diagnose and fix specific types of errors

**Characteristics:**
- Focused on error detection and fixing
- Often have access to build/test tools
- Return detailed error analysis and fixes

**Example:** `frontend-error-fixer`, `auto-error-resolver`

**Template Pattern:**
```markdown
## Instructions

1. **Detect Errors**: Check build output, runtime logs, test results
2. **Analyze Root Cause**: Trace error to source
3. **Implement Fix**: Make necessary code changes
4. **Verify Fix**: Confirm error is resolved
5. **Report**: Summarize error, fix, and verification
```

### 2. Review Agents

**Purpose:** Analyze code, plans, or architecture for quality/correctness

**Characteristics:**
- Critical analysis focus
- May or may not modify code
- Return detailed review reports with suggestions

**Example:** `code-reviewer`, `plan-reviewer`, `code-architecture-reviewer`

**Template Pattern:**
```markdown
## Instructions

1. **Gather Context**: Read relevant files, understand scope
2. **Analyze Against Standards**: Check against best practices/requirements
3. **Identify Issues**: Note problems, anti-patterns, missing pieces
4. **Suggest Improvements**: Provide actionable recommendations
5. **Report**: Detailed findings with specific file/line references
```

### 3. Planning Agents

**Purpose:** Create strategic plans or refactoring strategies

**Characteristics:**
- High-level thinking and organization
- Break down complex tasks
- Minimal or no code modification

**Example:** `refactor-planner`

**Template Pattern:**
```markdown
## Instructions

1. **Understand Current State**: Analyze existing code/architecture
2. **Identify Goals**: What needs to be achieved
3. **Assess Risks**: What could go wrong
4. **Create Step-by-Step Plan**: Detailed, actionable steps
5. **Report**: Complete plan with timeline and dependencies
```

### 4. Testing Agents

**Purpose:** Execute tests and validate functionality

**Characteristics:**
- Focus on verification and validation
- Execute actual tests/requests
- Return pass/fail results with details

**Example:** `auth-route-tester`

**Template Pattern:**
```markdown
## Instructions

1. **Setup Test Environment**: Prepare necessary context/data
2. **Execute Tests**: Run actual test cases
3. **Capture Results**: Record outputs, errors, status codes
4. **Analyze Results**: Determine pass/fail and why
5. **Report**: Test results with recommendations
```

### 5. Documentation Agents

**Purpose:** Create comprehensive documentation

**Characteristics:**
- Gather context from multiple sources
- Organize information clearly
- Create markdown documentation

**Example:** `documentation-architect`

**Template Pattern:**
```markdown
## Instructions

1. **Gather Context**: Read code, existing docs, related files
2. **Identify Gaps**: What's missing or unclear
3. **Structure Content**: Organize information logically
4. **Write Documentation**: Clear, comprehensive, with examples
5. **Report**: Location of created docs, summary of coverage
```

### 6. Research Agents

**Purpose:** Investigate codebases or external resources

**Characteristics:**
- Exploratory and analytical
- May use web search or codebase search
- Return findings and insights

**Example:** `web-research-specialist`, `Explore` agent

**Template Pattern:**
```markdown
## Instructions

1. **Define Research Scope**: What are we looking for
2. **Execute Search Strategy**: Search code, web, docs
3. **Analyze Findings**: What did we learn
4. **Synthesize Information**: Organize insights
5. **Report**: Clear summary with references
```

---

## Writing Effective Agent Instructions

### Instruction Best Practices

**Be Explicit:**
- State assumptions clearly
- Define success criteria
- Specify what to return

**Be Sequential:**
- Use numbered steps
- Each step builds on previous
- Clear progression from start to finish

**Be Comprehensive:**
- Handle edge cases
- Define error handling
- Specify what to do if stuck

**Be Specific:**
- Concrete actions, not vague guidance
- File paths, tool usage, commands
- Expected outputs

### Example: Good vs Bad Instructions

**Bad (Vague):**
```markdown
## Instructions
1. Look at the code
2. Find problems
3. Fix them
4. Report back
```

**Good (Specific):**
```markdown
## Instructions

### 1. Analyze Error Context
- Read the error message provided in the prompt
- Identify the file path and line number
- Use Read tool to examine the problematic file
- Use Grep to search for related code patterns

### 2. Diagnose Root Cause
- Check for common issues:
  - TypeScript type mismatches
  - Missing imports
  - Undefined variables
  - Syntax errors
- Cross-reference with similar working code in the codebase
- Determine if this is a local issue or system-wide pattern

### 3. Implement Fix
- Use Edit tool to make targeted changes
- Preserve existing code style and patterns
- Add comments if the fix is non-obvious
- Do NOT make unrelated changes

### 4. Verify Fix
- If TypeScript error: Run `npm run type-check`
- If build error: Run `npm run build`
- Check that error no longer appears
- Verify no new errors were introduced

### 5. Final Report
Return a structured report containing:
- **Error**: Original error message
- **Root Cause**: What caused the issue
- **Fix Applied**: Specific changes made (file:line references)
- **Verification**: Build/check results
- **Additional Notes**: Any concerns or follow-up needed
```

---

## Agent Communication Patterns

### What Agents Receive

Agents receive a single prompt from main Claude containing:
- Task description
- Relevant context
- Any specific requirements
- Expected output format

**Example invocation:**
```typescript
Task tool called with:
{
  subagent_type: "frontend-error-fixer",
  prompt: "Fix the TypeScript error in src/components/Dashboard.tsx:45 - Property 'userId' does not exist on type 'User'",
  description: "Fix TypeScript error"
}
```

### What Agents Return

Agents return ONE final message when complete:
- Cannot send multiple messages
- Cannot ask questions mid-execution
- Must be comprehensive and self-contained

**Good Return Format:**
```markdown
# Task Complete: Frontend Error Fixed

## Error Analysis
- **File**: src/components/Dashboard.tsx:45
- **Error**: Property 'userId' does not exist on type 'User'
- **Root Cause**: User type definition missing userId field

## Fix Applied
Updated `src/types/User.ts:12` to include userId:
```typescript
interface User {
  id: string;
  name: string;
  email: string;
  userId: string; // Added this field
}
```

## Verification
✅ TypeScript check passed
✅ Build successful
✅ No new errors introduced

## Additional Notes
The userId field is used in 3 other components - all now type-safe.
```

### Main Claude's Responsibility

After agent completes:
- Main Claude receives the agent's report
- Main Claude should summarize for user
- Main Claude may launch additional agents if needed
- Main Claude maintains conversation with user

**Example:**
```markdown
The frontend-error-fixer agent has successfully resolved the TypeScript error.

The issue was a missing `userId` field in the User type definition. The agent:
1. Added the field to the User interface
2. Verified the build passes
3. Confirmed all 3 components using userId are now type-safe

Your code should now compile without errors.
```

---

## Testing Agents

### Manual Testing

**1. Create test scenario:**
```bash
# In Claude Code session, invoke agent manually
/task frontend-error-fixer "Test with sample TypeScript error"
```

**2. Verify agent behavior:**
- Does it understand the task?
- Does it use appropriate tools?
- Does it return useful results?
- Does it handle edge cases?

**3. Iterate on instructions:**
- Refine based on observed behavior
- Add missing guidance
- Clarify ambiguous instructions

### Testing Checklist

When testing a new agent:

- [ ] Agent activates for intended use cases
- [ ] Agent description is clear and helpful
- [ ] Agent has necessary tool access
- [ ] Instructions are comprehensive and clear
- [ ] Agent handles happy path correctly
- [ ] Agent handles error cases gracefully
- [ ] Agent returns useful, structured output
- [ ] Agent doesn't ask questions (works autonomously)
- [ ] Agent doesn't get stuck or timeout
- [ ] Main Claude can use agent's output effectively

---

## Common Pitfalls

### 1. Agent Asks Questions Mid-Execution

**Problem:** Agent tries to use AskUserQuestion or communicate mid-task

**Solution:** Make instructions comprehensive enough that agent doesn't need to ask. Include:
- All necessary context in initial prompt
- Clear decision-making criteria
- Fallback behaviors for uncertainty

### 2. Agent Instructions Too Vague

**Problem:** Agent doesn't know what to do or does wrong thing

**Solution:** Be extremely specific:
- Exact tools to use
- Step-by-step process
- Concrete success criteria
- Example outputs

### 3. Agent Scope Too Broad

**Problem:** Agent tries to do too much, gets lost, or times out

**Solution:**
- Narrow agent focus to specific task type
- Create multiple specialized agents instead of one general one
- Set clear boundaries in instructions

### 4. Agent Can't Access Needed Tools

**Problem:** Agent errors because it needs a tool not granted

**Solution:**
- Review tools field in frontmatter
- Generally safer to use "All tools" unless specific reason to restrict
- Test agent with realistic scenarios

### 5. Poor Return Format

**Problem:** Agent returns unstructured text that's hard to use

**Solution:** In instructions, specify exact format for return:
```markdown
## Final Report Format
Return your findings in this structure:

# [Task Name]

## Summary
[One paragraph overview]

## Detailed Findings
- Finding 1 with file:line reference
- Finding 2 with file:line reference

## Recommendations
1. Recommendation with specific action
2. Recommendation with specific action

## Status
[Complete/Blocked/Needs-Follow-up]
```

---

## Advanced Patterns

### Multi-Stage Agents

Some tasks require multiple distinct phases:

```markdown
## Instructions

### Phase 1: Discovery (Estimate: 2 minutes)
1. Search codebase for relevant files
2. Read and analyze current implementation
3. Identify all affected areas

### Phase 2: Analysis (Estimate: 3 minutes)
1. Determine root cause or requirements
2. Check against best practices
3. Identify potential solutions

### Phase 3: Implementation (Estimate: 5 minutes)
1. Make necessary code changes
2. Update tests if needed
3. Verify changes work

### Phase 4: Validation (Estimate: 2 minutes)
1. Run build/tests
2. Check for regressions
3. Verify success criteria met

### Phase 5: Report
[Structured output as specified above]
```

### Conditional Logic

Guide agents through decision trees:

```markdown
## Instructions

1. **Check Error Type**
   - If TypeScript error → Follow TypeScript fix process
   - If Runtime error → Follow Runtime debug process
   - If Build error → Follow Build fix process

2. **TypeScript Fix Process**
   a. Read type definitions
   b. Identify type mismatch
   c. Update types or usage
   d. Verify with tsc

3. **Runtime Debug Process**
   a. Check browser console
   b. Trace error to source
   c. Fix logic bug
   d. Test in browser

4. **Build Fix Process**
   a. Check build logs
   b. Identify failing step
   c. Fix configuration or imports
   d. Re-run build
```

### Context-Rich Prompts

Main Claude should provide comprehensive context when invoking:

```markdown
**Good Invocation:**
Task tool with prompt:
"Review the new authentication system in src/auth/.

Context:
- We migrated from JWT to session cookies
- Previous implementation was in src/legacy-auth/
- New system should follow patterns in backend-dev-guidelines skill
- Key files: src/auth/middleware.ts, src/auth/service.ts, src/auth/routes.ts

Requirements:
- Check for security vulnerabilities
- Verify error handling with Sentry
- Ensure cookie settings are secure
- Validate session cleanup logic

Return detailed review with specific file:line references for any issues."
```

---

## Reference Files

For implementation examples and advanced patterns, see:

### [AGENT_EXAMPLES.md](resources/AGENT_EXAMPLES.md)
Real-world agent examples:
- Complete agent file examples
- Different agent type templates
- Successful agent patterns
- Before/after refactoring examples

### [AGENT_INVOCATION_PATTERNS.md](resources/AGENT_INVOCATION_PATTERNS.md)
How main Claude should invoke agents:
- Good vs bad invocation examples
- Context preparation strategies
- When to use which agent type
- Parallel agent invocations

### [TROUBLESHOOTING_AGENTS.md](resources/TROUBLESHOOTING_AGENTS.md)
Debugging agent issues:
- Agent not completing task
- Agent getting stuck
- Agent returning poor results
- Performance optimization

---

## Quick Reference

### Create New Agent (4 Steps)

1. **Create file**: `.claude/agents/{name}.md`
2. **Add frontmatter**: name, description, tools
3. **Write instructions**: Step-by-step, comprehensive
4. **Test**: Invoke manually and iterate

### Agent Template Checklist

- [ ] Frontmatter with name, description, tools
- [ ] Clear purpose statement
- [ ] "When to Use" scenarios
- [ ] Capabilities list
- [ ] Step-by-step instructions
- [ ] Expected output format
- [ ] Edge case handling
- [ ] Examples with inputs/outputs

### Tool Access Quick Reference

- **Full autonomy**: `tools: All tools`
- **Read-only**: `tools: Read, Glob, Grep, Bash`
- **Code changes**: `tools: Read, Write, Edit, MultiEdit, Glob, Grep`

### Best Practices Summary

✅ Action-oriented names (`error-fixer`, not `error-helper`)
✅ 2-sentence descriptions with clear use cases
✅ Comprehensive, sequential instructions
✅ Specify exact return format
✅ Handle edge cases explicitly
✅ Test with realistic scenarios
✅ Start with "All tools" unless reason to restrict

---

## Related Files

**Agent Files:**
- `.claude/agents/*.md` - All agent definitions

**Configuration:**
- `.claude/settings.json` - Claude Code configuration

**Documentation:**
- `CLAUDE.md` - Repository overview including agent system
- `.claude/skills/skill-developer/SKILL.md` - Skill development guide

---

**Skill Status**: READY FOR USE ✅
**Line Count**: ~490 (within 500-line limit) ✅
**Progressive Disclosure**: Reference files created ✅
