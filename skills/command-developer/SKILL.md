---
name: command-developer
description: Guide for creating and managing custom slash commands in Claude Code. Use when creating slash commands, custom commands, workflow automation, command prompts, strategic planning commands, or working with files in commands/ directory. Includes command structure, naming conventions, prompt patterns, and best practices for extensible workflows.
---

# Command Developer Guide

## Purpose

Guide for creating custom slash commands in Claude Code - user-invokable shortcuts that expand into detailed prompts for strategic planning, workflow automation, and repetitive tasks.

## When to Use This Skill

Automatically activates when:
- Creating or modifying slash commands
- Working with command prompt patterns
- Developing workflow automation
- Creating strategic planning commands
- Working with files in `commands/` directory
- Mentions of "slash command" or "custom command"

---

## What Are Slash Commands?

**Slash commands** are custom shortcuts that users type to invoke predefined prompts. When a user types `/command-name`, Claude Code expands it into a full prompt.

**Key concepts:**
- **Command file**: Markdown file defining the command
- **Command name**: The `/name` users type to invoke it
- **Command prompt**: The expanded content Claude receives
- **Parameters**: Optional arguments users can pass

**Benefits:**
- Standardize complex workflows
- Reduce repetitive prompt writing
- Ensure consistency in task execution
- Create reusable strategic planning patterns
- Enable team-wide command sharing

---

## When to Create Commands

### Good Use Cases

**✅ Strategic Planning:**
- Create development plans with structured breakdowns
- Architecture decision documentation
- Refactoring strategy creation

**✅ Workflow Automation:**
- Standard testing procedures
- Deployment checklists
- Code review workflows
- Documentation generation

**✅ Repetitive Tasks:**
- Common analysis patterns
- Standard report generation
- Recurring maintenance tasks

**✅ Complex Multi-Step Processes:**
- Tasks requiring specific order
- Processes with many considerations
- Workflows with conditional logic

### Poor Use Cases

**❌ Simple Questions:**
- "What is X?" - Just ask directly
- One-sentence requests
- Basic information retrieval

**❌ One-Time Tasks:**
- Rarely repeated processes
- User-specific unique requests
- Experimental workflows

**❌ Overly Generic:**
- "Help me" - Too vague
- "Do something" - No clear purpose
- Commands without specific outcomes

---

## Command File Structure

### Location
```
.claude/commands/{command-name}.md
```

### Basic Template

```markdown
---
name: my-command
description: Brief description of what this command does
---

# Command: My Command

## Purpose
What this command accomplishes

## Usage
/my-command [optional-argument]

## Prompt

[The actual prompt that Claude will receive]

You are now executing the {command-name} command.

[Detailed instructions for Claude]

[Expected output format]

[Any context or constraints]
```

### Complete Example

```markdown
---
name: create-feature-plan
description: Create a comprehensive plan for implementing a new feature
---

# Command: Create Feature Plan

## Purpose
Generate a structured development plan for a new feature including analysis, design, implementation steps, and testing strategy.

## Usage
/create-feature-plan [feature description]

## Prompt

You are now creating a comprehensive feature implementation plan.

The user wants to implement: {user_input}

Please create a detailed plan following this structure:

## 1. Feature Analysis
- Understand the requirements
- Identify dependencies
- Assess complexity
- Determine scope

## 2. Technical Design
- Architecture decisions
- Data model changes
- API design
- Component structure

## 3. Implementation Plan
Break down into specific, actionable tasks:
- Task 1: [description]
- Task 2: [description]
- ...

## 4. Testing Strategy
- Unit tests needed
- Integration tests
- E2E test scenarios
- Manual testing checklist

## 5. Deployment Considerations
- Migration requirements
- Feature flags
- Rollback strategy
- Monitoring

## 6. Timeline Estimate
Provide realistic time estimates for each phase.

Create this plan in a file: `dev/active/{feature-name}/plan.md`
```

---

## Command Naming Conventions

### Name Format
- Lowercase with hyphens: `create-plan`, `test-routes`
- Descriptive and specific: NOT `/helper`, YES `/create-api-docs`
- Action-oriented: Start with verb when possible

### Good Names
✅ `/dev-docs` - Clear purpose (development documentation)
✅ `/create-feature-plan` - Specific action
✅ `/route-research-for-testing` - Descriptive workflow
✅ `/review-security` - Clear intent

### Bad Names
❌ `/help` - Too generic
❌ `/do-stuff` - Not descriptive
❌ `/command` - Meaningless
❌ `/x` - Cryptic abbreviation

---

## Writing Effective Command Prompts

### Structure Your Prompts

**1. Set Context:**
```markdown
You are now executing the {command-name} command.

Context: [Explain the scenario and purpose]
```

**2. Define the Task:**
```markdown
Your goal is to:
- [Objective 1]
- [Objective 2]
- [Objective 3]
```

**3. Provide Instructions:**
```markdown
Follow these steps:

1. **Step One**
   - Detailed instruction
   - What to analyze or consider

2. **Step Two**
   - Next action
   - How to proceed
```

**4. Specify Output:**
```markdown
Create the following deliverables:

1. File: `path/to/output.md`
   - Content structure
   - Required sections

2. Summary for user
   - What to include
   - Format
```

### Use Clear, Imperative Language

**❌ Bad:**
```markdown
Maybe you could look at the code and see if there are issues?
```

**✅ Good:**
```markdown
Analyze the codebase for security vulnerabilities:
1. Check for SQL injection risks
2. Verify input validation
3. Review authentication logic
4. Report findings with file:line references
```

### Include Examples

**Help Claude understand expected output:**
```markdown
## Expected Output Example

```markdown
# Feature Plan: User Authentication

## 1. Analysis
- Requirements: JWT-based auth with refresh tokens
- Dependencies: jsonwebtoken, bcrypt
- Complexity: Medium
```
```

### Handle Parameters

**Simple parameter:**
```markdown
The user provided: {user_input}

Analyze this input and create a plan for: {user_input}
```

**Multiple parameters:**
```markdown
Feature: {param1}
Target completion: {param2}

Create an implementation plan for {param1} to be completed by {param2}.
```

**Optional parameters:**
```markdown
Additional context: {optional_context}

If additional context provided, incorporate it into your analysis.
```

---

## Command Categories

### 1. Strategic Planning Commands

**Purpose:** Create comprehensive plans and strategies

**Example:** `/dev-docs`
```markdown
Create a strategic plan with:
- Problem analysis
- Solution design
- Task breakdown
- Timeline estimation
- Risk assessment
```

**When to use:**
- Starting new projects
- Major refactors
- Architecture decisions
- Complex feature development

### 2. Workflow Automation Commands

**Purpose:** Automate multi-step processes

**Example:** `/route-research-for-testing`
```markdown
Workflow:
1. Identify recently edited routes
2. Analyze route implementations
3. Launch auth-route-tester agent
4. Report test results
```

**When to use:**
- Repetitive testing procedures
- Standard review processes
- Deployment workflows
- Documentation updates

### 3. Analysis Commands

**Purpose:** Perform systematic analysis

**Example:** `/analyze-security`
```markdown
Security analysis checklist:
- Input validation
- Authentication checks
- Authorization logic
- SQL injection prevention
- XSS vulnerabilities
- CSRF protection
```

**When to use:**
- Code reviews
- Security audits
- Performance analysis
- Dependency review

### 4. Documentation Commands

**Purpose:** Generate standardized documentation

**Example:** `/document-api`
```markdown
API documentation structure:
- Endpoint overview
- Request/response formats
- Authentication requirements
- Error codes
- Usage examples
```

**When to use:**
- API documentation
- README generation
- Architecture docs
- Onboarding materials

---

## Testing Commands

### Manual Testing

**Invoke the command:**
```bash
# In Claude Code session
/my-command test input
```

**Verify:**
- Does it expand to the right prompt?
- Does Claude understand the instructions?
- Is the output what you expected?
- Are parameters handled correctly?

### Test Checklist

When testing a new command:

- [ ] Command file in correct location
- [ ] Valid frontmatter (name, description)
- [ ] Clear command purpose documented
- [ ] Usage instructions provided
- [ ] Prompt is comprehensive and clear
- [ ] Expected output specified
- [ ] Parameters handled correctly
- [ ] Examples included
- [ ] Command produces expected results
- [ ] No ambiguous instructions

---

## Integration with Other Systems

### Commands + Agents

**Pattern:** Commands can launch agents for complex tasks

```markdown
## Prompt

First, analyze the codebase for authentication issues.

Then, launch the auth-route-debugger agent to investigate:

Use Task tool with:
- subagent_type: "auth-route-debugger"
- prompt: "Debug authentication issues found in: {findings}"
```

### Commands + Skills

**Pattern:** Commands activate skills for domain knowledge

```markdown
## Prompt

You are creating a backend service.

Use the backend-dev-guidelines skill to ensure:
- Proper layered architecture
- Correct error handling with Sentry
- Database operations with Prisma
- Type safety throughout
```

### Commands + Hooks

**Pattern:** Commands trigger workflows that hooks track

```markdown
## Prompt

Create the following files:
1. routes/new-feature.ts
2. services/new-feature-service.ts
3. tests/new-feature.test.ts

(Hook will track edited files for later testing)
```

---

## Advanced Patterns

### Conditional Logic

```markdown
## Prompt

If the user provided a feature name:
- Create detailed plan in `dev/active/{feature-name}/`

If no feature name provided:
- Ask for clarification
- Suggest similar past features
```

### Multi-Phase Commands

```markdown
## Prompt

This command executes in 3 phases:

### Phase 1: Discovery
- Analyze current state
- Identify requirements
- Assess risks

### Phase 2: Planning
- Create task breakdown
- Estimate timeline
- Define success criteria

### Phase 3: Documentation
- Write plan to file
- Create TODO items
- Summarize for user
```

### Context Gathering

```markdown
## Prompt

Before creating the plan:

1. Search codebase for related features:
   - Use Grep to find similar patterns
   - Use Glob to find relevant files

2. Read existing documentation:
   - Check README files
   - Review architecture docs

3. Analyze dependencies:
   - Check package.json
   - Review import statements

Then create comprehensive plan incorporating findings.
```

---

## Common Pitfalls

### Pitfall 1: Too Vague

**❌ Bad:**
```markdown
Help the user with their task.
```

**✅ Good:**
```markdown
Create a detailed implementation plan for the feature: {user_input}

Include:
1. Technical requirements analysis
2. Step-by-step implementation tasks
3. Testing strategy
4. Deployment considerations
```

### Pitfall 2: Too Rigid

**❌ Bad:**
```markdown
Create exactly 5 tasks, no more, no less.
```

**✅ Good:**
```markdown
Break the work into appropriate tasks (typically 3-10 depending on complexity).
```

### Pitfall 3: Missing Output Specification

**❌ Bad:**
```markdown
Analyze the code and report back.
```

**✅ Good:**
```markdown
Create a security analysis report:

File: `dev/security-audit-{date}.md`

Format:
## Critical Issues
- [Issue 1 with file:line]

## Recommendations
- [Specific actions]

Then summarize findings for the user.
```

### Pitfall 4: No Examples

**❌ Bad:**
```markdown
Create documentation in the standard format.
```

**✅ Good:**
```markdown
Create documentation following this example:

# API Endpoint: POST /users

## Purpose
Creates a new user account

## Request
```json
{
  "email": "user@example.com",
  "name": "John Doe"
}
```

[Continue with response, errors, etc.]
```

---

## Reference Files

For detailed patterns and examples, see:

### [COMMAND_EXAMPLES.md](resources/COMMAND_EXAMPLES.md)
Real command implementations:
- Strategic planning commands
- Workflow automation commands
- Analysis commands
- Documentation commands
- Complete working examples

### [COMMAND_PATTERNS.md](resources/COMMAND_PATTERNS.md)
Common command patterns:
- Parameter handling
- Conditional logic
- Multi-phase execution
- Agent integration
- File creation patterns

### [COMMAND_TESTING.md](resources/COMMAND_TESTING.md)
Testing and debugging:
- How to test commands
- Common issues and fixes
- Debugging strategies
- Iteration and improvement

---

## Quick Reference

### Create New Command (4 Steps)

1. **Create file**: `.claude/commands/{name}.md`
2. **Add frontmatter**: name, description
3. **Write prompt**: Clear, comprehensive instructions
4. **Test**: Invoke and verify behavior

### Command Template Checklist

- [ ] Frontmatter with name and description
- [ ] Clear purpose statement
- [ ] Usage instructions
- [ ] Comprehensive prompt with structure
- [ ] Expected output format specified
- [ ] Examples included
- [ ] Parameter handling (if applicable)
- [ ] Integration points (agents/skills) documented

### Naming Best Practices

✅ Action-oriented (`create-plan`, `analyze-code`)
✅ Specific (`document-api`, not `docs`)
✅ Lowercase with hyphens
✅ Descriptive and clear

### Prompt Best Practices

✅ Set clear context
✅ Use imperative language
✅ Specify exact output format
✅ Include examples
✅ Handle parameters explicitly
✅ Break into numbered steps
✅ Define success criteria

---

## Related Files

**Command Files:**
- `.claude/commands/*.md` - All command definitions

**Configuration:**
- `.claude/settings.json` - Claude Code configuration

**Integration:**
- `.claude/agents/*.md` - Agents commands can launch
- `.claude/skills/*/SKILL.md` - Skills commands can activate

**Documentation:**
- `CLAUDE.md` - Repository overview including command system

---

**Skill Status**: READY FOR USE ✅
**Line Count**: ~490 (within 500-line limit) ✅
**Progressive Disclosure**: Reference files created ✅
