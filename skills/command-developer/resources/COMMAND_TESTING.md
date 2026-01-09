# Command Testing Guide

How to test, debug, and improve slash commands.

## Table of Contents

1. [Testing Methods](#testing-methods)
2. [Common Issues](#common-issues)
3. [Debugging Strategies](#debugging-strategies)
4. [Iteration Process](#iteration-process)
5. [Quality Checklist](#quality-checklist)

---

## Testing Methods

### Method 1: Direct Invocation (Primary)

**How**: Type the command in Claude Code

```
User: /my-command test input
```

**What to observe**:
- Does command expand properly?
- Does Claude understand the instructions?
- Does output match expectations?
- Are parameters handled correctly?

**Example Test**:
```
User: /dev-docs implement user authentication

Expected behavior:
1. Claude creates comprehensive plan
2. Files created in dev/active/user-authentication/
3. Plan includes analysis, design, tasks, timeline
4. User receives summary
```

### Method 2: Prompt Preview (if available)

**How**: Some systems show expanded prompt before execution

**Verify**:
- Prompt expands correctly
- Parameters substituted properly
- No syntax errors in expansion

### Method 3: Incremental Testing

**How**: Test command in parts

**Step 1**: Test just the beginning
```markdown
## Prompt (v1)
You are creating a plan for: {user_input}

Acknowledge that you received: {user_input}
```

**Step 2**: Add next section once working
```markdown
## Prompt (v2)
You are creating a plan for: {user_input}

First, analyze the requirements...
```

**Step 3**: Continue building until complete

---

## Common Issues

### Issue 1: Parameters Not Substituting

**Symptom**: Sees literal `{user_input}` instead of actual input

**Causes**:
- Wrong parameter syntax
- Typo in parameter name
- Parameter not passed by user

**Solutions**:

**❌ Wrong syntax:**
```markdown
Process: ${user_input}  # Wrong
Process: (user_input)   # Wrong
```

**✅ Correct syntax:**
```markdown
Process: {user_input}   # Correct
```

**Test it**:
```
/my-command test
# Should see: "Process: test"
# Not: "Process: {user_input}"
```

### Issue 2: Command Too Vague

**Symptom**: Claude produces generic or off-target results

**Example of vague prompt**:
```markdown
## Prompt
Help the user with their request.
```

**Solution**: Be specific
```markdown
## Prompt
Create a comprehensive implementation plan for: {user_input}

Include:
1. Technical requirements analysis
2. Step-by-step task breakdown
3. Timeline estimation
4. Risk assessment

Create plan file at: dev/active/{sanitized-name}/plan.md
```

**Test it**:
```
/my-command user authentication
# Should get: Specific plan with all 4 sections
# Not: Generic "I can help with authentication"
```

### Issue 3: No Output File Created

**Symptom**: Command runs but doesn't create expected files

**Causes**:
- Didn't specify file creation explicitly
- Path not clear
- Ambiguous instructions

**Solution**: Explicit file creation instructions
```markdown
## Prompt

**MUST CREATE FILE**:

Location: `dev/analysis/{feature}-report.md`

Content structure:
```markdown
# Analysis Report

## Summary
[content]

## Findings
[content]
```

Use Write tool to create this file.
```

**Test it**:
```
/my-command feature-x
# Verify: File exists at dev/analysis/feature-x-report.md
# Verify: File has expected structure
```

### Issue 4: Command Doesn't Activate

**Symptom**: Typing `/command` does nothing

**Causes**:
- Command file not in `.claude/commands/` directory
- File not named correctly
- Missing frontmatter

**Solution**: Check file structure
```bash
# Verify file exists
ls .claude/commands/my-command.md

# Check frontmatter
head -5 .claude/commands/my-command.md
```

Should see:
```markdown
---
name: my-command
description: Brief description
---
```

### Issue 5: Agent Not Launching

**Symptom**: Command supposed to launch agent but doesn't

**Causes**:
- Wrong Task tool syntax
- Agent name typo
- Missing prompt parameter

**Solution**: Verify Task tool usage
```markdown
## Prompt

Launch agent using Task tool:

Task({
  subagent_type: "auth-route-tester",  # Must match exact agent name
  prompt: "Detailed instructions...",   # Must include prompt
  description: "Short description"      # Required
})
```

**Test it**:
```
/my-command
# Verify: See "[Task tool] Launching auth-route-tester"
# Verify: Agent executes and returns results
```

---

## Debugging Strategies

### Strategy 1: Simplify and Build

**Step 1**: Reduce to minimal version
```markdown
---
name: test-command
description: Test command
---

# Test

## Prompt
Received: {user_input}

Just echo back what you received.
```

**Step 2**: Verify basic functionality works

**Step 3**: Add one feature at a time
```markdown
## Prompt
Received: {user_input}

Now create a file with this content: {user_input}
```

**Step 4**: Continue adding until full functionality

### Strategy 2: Add Debug Output

Add temporary debug statements:

```markdown
## Prompt

**DEBUG MODE ENABLED**

Received parameters:
- user_input: {user_input}
- additional_params: {params}

Environment:
- Project directory: {check current directory}
- Available tools: {list available tools}

Now proceeding with actual command logic...
```

Remove debug output once working.

### Strategy 3: Test with Different Inputs

**Test cases to try**:

1. **Minimal input**: `/command a`
2. **Normal input**: `/command implement feature`
3. **Long input**: `/command implement complex authentication with OAuth and JWT`
4. **Special characters**: `/command test-feature_v2`
5. **No input**: `/command`

**Document expected behavior for each**.

### Strategy 4: Compare with Working Commands

**Look at existing working commands**:
```bash
cat .claude/commands/dev-docs.md
```

**Compare**:
- Prompt structure
- Parameter handling
- Output specification
- File creation patterns

**Adopt proven patterns**.

### Strategy 5: Iterative Refinement

**Iteration cycle**:

1. **Test**: Run command
2. **Observe**: What happened vs what should happen
3. **Identify**: Specific issue
4. **Fix**: Make targeted change
5. **Verify**: Test again
6. **Repeat**: Until working correctly

**Document each iteration**:
```markdown
## Iteration 1
Issue: No file created
Fix: Added explicit Write tool instruction
Result: File now created ✅

## Iteration 2
Issue: File content generic
Fix: Added detailed content template
Result: File has proper structure ✅
```

---

## Iteration Process

### Phase 1: Initial Creation

**Create MVP command**:
- Basic structure
- Simple prompt
- One clear output

**Test**: Does it work at all?

### Phase 2: Add Features

**One feature at a time**:
- Parameter handling
- Conditional logic
- File creation
- Agent integration

**Test after each addition**.

### Phase 3: Refinement

**Improve**:
- Clearer instructions
- Better error handling
- More specific output
- Helpful examples

**Test**: Does it handle edge cases?

### Phase 4: Optimization

**Polish**:
- Remove redundancy
- Clarify ambiguity
- Add documentation
- Streamline flow

**Test**: Is it maintainable?

### Phase 5: Validation

**Final checks**:
- Works with all input types
- Handles errors gracefully
- Produces consistent output
- Meets original requirements

**Test**: Production ready?

---

## Quality Checklist

### Before Deployment

- [ ] **Command file in correct location** (`.claude/commands/`)
- [ ] **Valid frontmatter** (name, description)
- [ ] **Clear purpose** documented
- [ ] **Usage instructions** provided
- [ ] **Prompt is comprehensive** and unambiguous
- [ ] **Parameters handled** correctly
- [ ] **Output format specified** explicitly
- [ ] **Examples included** in documentation
- [ ] **Error cases considered**
- [ ] **Tested with multiple inputs**

### Prompt Quality

- [ ] **Context set** clearly
- [ ] **Instructions are imperative** (not suggestive)
- [ ] **Steps are numbered** and sequential
- [ ] **Output location specified**
- [ ] **Output format defined**
- [ ] **Success criteria clear**
- [ ] **Examples provided**
- [ ] **No ambiguous language**

### Functionality Testing

- [ ] **Minimal input**: Works with short input
- [ ] **Normal input**: Works with typical input
- [ ] **Complex input**: Works with long input
- [ ] **No input**: Handles missing parameters
- [ ] **Special characters**: Handles edge cases
- [ ] **File creation**: Creates expected files
- [ ] **Agent launch**: Launches agents correctly (if applicable)
- [ ] **Error handling**: Fails gracefully

### User Experience

- [ ] **Quick to invoke**: Simple command name
- [ ] **Clear purpose**: User knows what it does
- [ ] **Predictable**: Consistent behavior
- [ ] **Helpful output**: User gets actionable results
- [ ] **Fast execution**: Completes in reasonable time
- [ ] **Informative**: User understands what happened

---

## Testing Workflow

### Daily Testing Routine

**When creating command**:

1. **Morning**: Create basic structure
   - Test: Does it invoke?

2. **Midday**: Add core functionality
   - Test: Does it produce output?

3. **Afternoon**: Add refinements
   - Test: Is output correct?

4. **Evening**: Polish and document
   - Test: Does it handle edge cases?

### Pre-Release Testing

**Before sharing command**:

1. **Fresh session test**: Test in clean environment
2. **Different inputs**: Try various input types
3. **Error scenarios**: Try to break it
4. **Documentation check**: Can others use it?
5. **Performance**: Is it reasonably fast?

### Continuous Improvement

**After deployment**:

1. **Gather feedback**: How are users using it?
2. **Monitor issues**: What problems occur?
3. **Track usage**: What inputs are common?
4. **Iterate**: Make improvements
5. **Document**: Update based on learnings

---

## Troubleshooting Flowchart

```
Command not working?
├─ Not invoking?
│  ├─ Check file location (.claude/commands/)
│  ├─ Check filename matches command name
│  └─ Check frontmatter is valid
│
├─ Wrong output?
│  ├─ Prompt too vague → Add specificity
│  ├─ Parameters not substituting → Check syntax
│  └─ Missing output → Specify explicitly
│
├─ Agent not launching?
│  ├─ Check Task tool syntax
│  ├─ Verify agent name correct
│  └─ Ensure prompt provided
│
├─ Files not created?
│  ├─ Add explicit Write instructions
│  ├─ Specify exact file path
│  └─ Define file content structure
│
└─ Edge cases failing?
   ├─ Add conditional logic
   ├─ Handle missing parameters
   └─ Add error messages
```

---

## Performance Testing

### Timing Expectations

**Simple commands**: < 10 seconds
- Parameter echo
- Simple file creation
- Quick analysis

**Medium commands**: 10-60 seconds
- File analysis
- Documentation generation
- Simple planning

**Complex commands**: 1-5 minutes
- Comprehensive planning
- Multiple agent launches
- Large file operations

**Very complex commands**: 5-15 minutes
- Multi-phase execution
- Extensive analysis
- Multiple agent chains

### Optimization Tips

**If command is slow**:

1. **Reduce scope**: Narrow what it analyzes
2. **Limit file reads**: Only read necessary files
3. **Parallel agents**: Launch multiple agents at once
4. **Cache results**: Don't re-analyze same data
5. **Skip optional steps**: Make some steps conditional

**Example optimization**:
```markdown
## Before (slow)
Read every file in src/ directory → Analyze all → Report

## After (fast)
Use Grep to find relevant files → Read only those → Analyze → Report
```

---

## Success Metrics

### Good Command Indicators

✅ **High usage** - Users invoke it frequently
✅ **Consistent results** - Produces reliable output
✅ **Few issues** - Rarely needs debugging
✅ **Saves time** - Faster than manual process
✅ **Clear value** - Purpose is obvious
✅ **Easy to use** - Simple invocation
✅ **Good documentation** - Users understand it

### Command Maturity Levels

**Level 1 - MVP**: Basic functionality works
**Level 2 - Stable**: Handles common cases reliably
**Level 3 - Robust**: Handles edge cases gracefully
**Level 4 - Polished**: Great UX, well-documented
**Level 5 - Production**: Team-wide adoption, proven value

---

## Final Tips

### Testing Best Practices

1. **Test early, test often** - Don't wait until "done"
2. **Test with real data** - Use actual project scenarios
3. **Test edge cases** - Empty input, special chars, long input
4. **Test error paths** - What if things go wrong?
5. **Test with others** - Fresh perspective helps

### When to Stop Testing

✅ Command works with all expected inputs
✅ Handles errors gracefully
✅ Produces consistent, correct output
✅ Documentation is clear
✅ No known issues

**Then**: Ship it! You can always iterate.

### Remember

**Perfect is the enemy of good** - Ship working commands and improve them based on real usage rather than trying to anticipate every scenario upfront.
