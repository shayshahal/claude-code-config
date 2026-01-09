# Command Patterns

Common patterns and techniques for building effective slash commands.

## Table of Contents

1. [Parameter Handling](#parameter-handling)
2. [Conditional Logic](#conditional-logic)
3. [Multi-Phase Execution](#multi-phase-execution)
4. [Agent Integration](#agent-integration)
5. [File Creation Patterns](#file-creation-patterns)
6. [Context Gathering](#context-gathering)

---

## Parameter Handling

### Simple Single Parameter

**Pattern**: Command accepts one argument

```markdown
## Usage
/command-name [parameter]

## Prompt
You are processing: **{user_input}**

Task: Create documentation for {user_input}
```

**Example**:
```
User types: /document-api users-service
Claude receives: "You are processing: **users-service**..."
```

### Multiple Parameters

**Pattern**: Command accepts multiple space-separated arguments

```markdown
## Usage
/command-name [param1] [param2] [param3]

## Prompt
Parameters received:
- Target: {param1}
- Environment: {param2}
- Options: {param3}

Process deployment of {param1} to {param2} with options: {param3}
```

**Note**: Parameters are space-separated by default. For multi-word parameters, user must quote them.

### Optional Parameters

**Pattern**: Command works with or without parameters

```markdown
## Usage
/command-name [optional: specific scope]

## Prompt
Scope: {user_input or "entire project"}

If specific scope provided:
- Focus analysis on {user_input}

If no scope provided:
- Analyze entire project

Proceed with security analysis of: {scope}
```

### Parameter with Defaults

**Pattern**: Parameter has sensible default if not provided

```markdown
## Prompt
Target environment: {user_input or "development"}

Deploy to {target_environment}:

If target is "production":
- Run full test suite
- Require manual approval
- Create backup

Otherwise:
- Run smoke tests only
- Auto-deploy
```

---

## Conditional Logic

### Simple If-Then

**Pattern**: Different behavior based on condition

```markdown
## Prompt

Check if {feature_name} already exists:

If exists:
- Read existing implementation
- Create refactoring plan
- Preserve existing functionality

If does not exist:
- Create new feature from scratch
- Design architecture
- Implement fresh
```

### Multiple Conditions

**Pattern**: Handle several scenarios

```markdown
## Prompt

Analyze the file type:

**If TypeScript file** (.ts/.tsx):
- Run TypeScript compiler
- Check type definitions
- Verify imports

**If JavaScript file** (.js/.jsx):
- Run ESLint
- Check for common issues
- Suggest TypeScript migration

**If Test file** (*test.ts):
- Run test suite
- Check coverage
- Verify assertions

**Otherwise**:
- Skip analysis
- Inform user of unsupported type
```

### Conditional File Creation

**Pattern**: Create files based on analysis

```markdown
## Prompt

Analyze the project structure:

If monorepo:
- Create plans in `packages/{service}/dev/`
- Generate package-specific tasks

If single repo:
- Create plans in `dev/active/`
- Generate unified task list

Proceed with structure: {detected_structure}
```

---

## Multi-Phase Execution

### Sequential Phases

**Pattern**: Break command into distinct phases

```markdown
## Prompt

This command executes in 4 phases:

### Phase 1: Discovery (2-3 minutes)
1. Search codebase for related files
2. Read existing documentation
3. Identify dependencies

**Deliverable**: Context summary

### Phase 2: Analysis (3-5 minutes)
1. Analyze current implementation
2. Identify gaps and issues
3. Determine requirements

**Deliverable**: Analysis report

### Phase 3: Planning (5-10 minutes)
1. Design solution approach
2. Break into tasks
3. Estimate timeline

**Deliverable**: Implementation plan

### Phase 4: Documentation (2-3 minutes)
1. Create plan files
2. Generate task checklist
3. Summarize for user

**Deliverable**: Final documentation

**Total estimated time**: 12-21 minutes

Execute each phase sequentially. Do not skip phases.
```

### Phase with Gates

**Pattern**: Validate before proceeding

```markdown
## Prompt

### Phase 1: Validation

First, validate prerequisites:
- [ ] TypeScript configured
- [ ] Tests directory exists
- [ ] Package.json has test script

**Gate**: If validation fails, stop and inform user of missing prerequisites.

### Phase 2: Test Creation

Only proceed if Phase 1 passed:
- Create test files
- Generate test cases
- Add test utilities

### Phase 3: Execution

Run the created tests and report results.
```

### Parallel Execution Within Phase

**Pattern**: Do multiple things simultaneously

```markdown
## Prompt

### Phase 2: Parallel Analysis

Execute these analyses in parallel:

**Thread 1**: Code quality analysis
- Read source files
- Check patterns
- Identify anti-patterns

**Thread 2**: Security scan
- Check vulnerabilities
- Review dependencies
- Identify risks

**Thread 3**: Performance review
- Check for bottlenecks
- Review algorithms
- Suggest optimizations

After all threads complete, synthesize findings.
```

---

## Agent Integration

### Launch Single Agent

**Pattern**: Command delegates to specialized agent

```markdown
## Prompt

After analyzing the routes, launch the testing agent:

Use Task tool:
```typescript
Task({
  subagent_type: "auth-route-tester",
  prompt: `
Test route: POST /api/users

Details:
- Expected input: { email, password }
- Expected output: { user, token }
- Authentication: Required

Verify:
1. Successful user creation
2. Token generation
3. Database record created
4. Response format correct
  `,
  description: "Test user creation route"
})
```

Wait for agent to complete, then summarize results for user.
```

### Launch Multiple Agents in Parallel

**Pattern**: Test multiple things simultaneously

```markdown
## Prompt

Found {count} routes to test. Launching agents in parallel:

**IMPORTANT**: Create a single message with multiple Task tool calls:

```typescript
// Agent 1
Task({
  subagent_type: "auth-route-tester",
  prompt: "Test GET /api/users...",
  description: "Test users list route"
})

// Agent 2
Task({
  subagent_type: "auth-route-tester",
  prompt: "Test POST /api/users...",
  description: "Test user creation route"
})

// Agent 3
Task({
  subagent_type: "auth-route-tester",
  prompt: "Test DELETE /api/users/:id...",
  description: "Test user deletion route"
})
```

After all agents complete, compile results into summary report.
```

### Agent with Conditional Launch

**Pattern**: Launch agent only if needed

```markdown
## Prompt

Analyze the implementation:

If errors found:
- Launch frontend-error-fixer agent to resolve
- Wait for fixes
- Verify fixes applied

If no errors:
- Proceed with optimization suggestions
- No agent needed
```

### Agent Chain

**Pattern**: Launch agents sequentially

```markdown
## Prompt

### Step 1: Code Review

Launch code-architecture-reviewer agent:
```typescript
Task({
  subagent_type: "code-architecture-reviewer",
  prompt: "Review the authentication system...",
  description: "Review auth code"
})
```

### Step 2: Fix Issues (if found)

Based on review findings:

If critical issues found:
- Launch auto-error-resolver agent
- Address critical issues first

If medium issues found:
- Create task list for manual fixes

### Step 3: Test

After fixes applied:
- Launch auth-route-tester agent
- Verify all routes working

Report final status to user.
```

---

## File Creation Patterns

### Single File Creation

**Pattern**: Create one output file

```markdown
## Prompt

Create analysis report file:

**Location**: `dev/analysis/{feature}-{date}.md`

**Content**:
```markdown
# Analysis: {Feature Name}

## Summary
[Analysis summary]

## Findings
[Detailed findings]

## Recommendations
[Actionable recommendations]
```

After creating file, inform user:
- File location
- Summary of contents
- Next steps
```

### Multiple Related Files

**Pattern**: Create set of related files

```markdown
## Prompt

Create project documentation set:

### File 1: Plan
**Location**: `dev/active/{project}/plan.md`
**Content**: [Comprehensive plan]

### File 2: Tasks
**Location**: `dev/active/{project}/tasks.md`
**Content**: [Checklist of tasks]

### File 3: Notes
**Location**: `dev/active/{project}/notes.md`
**Content**: [Additional considerations]

### File 4: Timeline
**Location**: `dev/active/{project}/timeline.md`
**Content**: [Gantt-style timeline]

Create all files in sequence.
```

### Template-Based Creation

**Pattern**: Use templates for consistency

```markdown
## Prompt

Create component following template:

**Template Structure**:
```
src/components/{ComponentName}/
├── {ComponentName}.tsx        # Main component
├── {ComponentName}.module.css # Styles
├── {ComponentName}.test.tsx   # Tests
├── {ComponentName}.stories.tsx # Storybook
└── index.ts                   # Exports
```

For each file, use the standard template from frontend-dev-guidelines skill.

Ensure:
- Consistent naming
- Proper TypeScript types
- Test coverage
- Storybook stories
```

### Dynamic Directory Structure

**Pattern**: Create directories based on project type

```markdown
## Prompt

Detect project type:

If monorepo:
```
packages/{service}/
├── dev/
│   └── {feature}/
│       ├── plan.md
│       └── tasks.md
└── docs/
    └── {feature}.md
```

If standard repo:
```
dev/active/{feature}/
├── plan.md
└── tasks.md
docs/features/{feature}.md
```

Create appropriate structure for: {detected_type}
```

---

## Context Gathering

### Search Before Create

**Pattern**: Gather context before taking action

```markdown
## Prompt

Before creating the plan, gather context:

### 1. Search for Similar Features
```bash
# Use Grep to find related implementations
Grep("similar-pattern", "src/**/*.ts")
```

### 2. Read Relevant Files
```typescript
// Read files found in step 1
Read("src/features/existing-feature.ts")
```

### 3. Check Documentation
```bash
# Look for existing docs
Glob("docs/**/*.md")
```

### 4. Analyze Dependencies
```typescript
// Check package.json for relevant packages
Read("package.json")
```

**After gathering context**, create comprehensive plan incorporating findings.
```

### Read Hook Cache

**Pattern**: Use post-tool-use tracker cache

```markdown
## Prompt

Check what files were edited this session:

```bash
# Read edited files log
cat .claude/tsc-cache/{session_id}/edited-files.log
```

This shows:
- Which files were modified
- What repos were affected
- When changes were made

Use this context to:
- Focus testing on changed areas
- Update related documentation
- Check affected dependencies
```

### Analyze Git History

**Pattern**: Use git to understand changes

```markdown
## Prompt

Understand recent changes:

```bash
# Get recent commits
git log --oneline -20

# Check what changed in relevant files
git diff HEAD~5 -- src/auth/

# Find when feature was introduced
git log --grep="authentication"
```

Use git history to:
- Understand evolution
- Identify related changes
- Find relevant commits
- Locate original implementation
```

### Environment Detection

**Pattern**: Adapt based on environment

```markdown
## Prompt

Detect project environment:

**Check for**:
- `package.json` - Node.js project
- `requirements.txt` - Python project
- `Cargo.toml` - Rust project
- `go.mod` - Go project

**Detect framework**:
- `next.config.js` - Next.js
- `vite.config.ts` - Vite
- `tsconfig.json` - TypeScript

**Detect testing**:
- `jest.config.js` - Jest
- `vitest.config.ts` - Vitest
- `playwright.config.ts` - Playwright

Adapt command behavior based on detected environment.
```

---

## Combining Patterns

### Complex Command Example

Combining multiple patterns:

```markdown
## Prompt

**Pattern Combination**:
- Multi-phase execution
- Context gathering
- Conditional logic
- Agent integration
- File creation

### Phase 1: Context Gathering

Detect project type and gather context:
- Check if monorepo or single repo
- Read recent git commits
- Analyze package structure

### Phase 2: Conditional Analysis

If feature exists:
- Read existing implementation
- Plan refactoring approach
- Identify breaking changes

If feature is new:
- Search for similar patterns
- Design from scratch
- Plan integration points

### Phase 3: Agent-Assisted Planning

If complex refactoring needed:
- Launch refactor-planner agent
- Get detailed refactoring strategy

If new feature:
- Create plan directly
- No agent needed

### Phase 4: File Creation

Create appropriate files based on project type:
- Monorepo: `packages/{service}/dev/`
- Single: `dev/active/`

### Phase 5: Validation

Launch code-reviewer agent to review plan:
- Check for completeness
- Identify potential issues
- Suggest improvements

Report final plan with agent feedback.
```

---

## Best Practices Summary

### Pattern Selection

**Use simple patterns when**:
- Command has single purpose
- Minimal dependencies
- Straightforward execution

**Use complex patterns when**:
- Multiple steps required
- External dependencies
- Conditional execution needed

### Pattern Composition

**✅ Good**: Compose patterns that complement each other
```markdown
Context gathering → Conditional logic → Agent integration
```

**❌ Bad**: Overcomplicating simple tasks
```markdown
Simple file creation → 5-phase execution → Multiple agents
```

### Maintainability

**Keep patterns**:
- Clear and documented
- Reusable across commands
- Easy to understand
- Well-tested

**Avoid**:
- Over-engineering
- Nested complexity
- Unclear flow
- Tight coupling
