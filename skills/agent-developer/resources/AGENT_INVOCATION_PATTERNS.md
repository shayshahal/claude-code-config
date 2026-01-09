# Agent Invocation Patterns

How main Claude should invoke agents effectively with proper context and instructions.

## Table of Contents

1. [Good vs Bad Invocations](#good-vs-bad-invocations)
2. [Context Preparation](#context-preparation)
3. [Prompt Structure](#prompt-structure)
4. [When to Use Which Agent](#when-to-use-which-agent)
5. [Parallel Agent Invocations](#parallel-agent-invocations)
6. [Handling Agent Results](#handling-agent-results)

---

## Good vs Bad Invocations

### Error Fixing Agent

**BAD** ❌
```typescript
Task({
  subagent_type: "frontend-error-fixer",
  prompt: "Fix the error",
  description: "Fix error"
})
```

**Problems:**
- No context about what error
- No file information
- No error message
- Agent will struggle to find the issue

**GOOD** ✅
```typescript
Task({
  subagent_type: "frontend-error-fixer",
  prompt: `Fix the TypeScript error in src/components/Dashboard.tsx:45

Error message:
Property 'userId' does not exist on type 'User'.

Context:
- The Dashboard component is trying to access user.userId
- The User type is defined in src/types/User.ts
- This field is used in 3 other components without issues

Please:
1. Fix the type definition
2. Verify the build passes
3. Check all components using this field
4. Report the changes made`,
  description: "Fix TypeScript userId error"
})
```

**What makes it good:**
- Specific file and line number
- Exact error message
- Relevant context
- Clear expectations
- Specific instructions

---

### Code Review Agent

**BAD** ❌
```typescript
Task({
  subagent_type: "code-architecture-reviewer",
  prompt: "Review the new code",
  description: "Code review"
})
```

**Problems:**
- No scope defined
- No files specified
- No review criteria
- No context about what changed

**GOOD** ✅
```typescript
Task({
  subagent_type: "code-architecture-reviewer",
  prompt: `Review the new authentication system implementation.

Files to review:
- src/auth/middleware.ts (new)
- src/auth/service.ts (new)
- src/auth/routes.ts (modified)
- src/auth/types.ts (new)

Context:
- We migrated from JWT in headers to JWT in cookies
- Previous implementation was in src/legacy-auth/
- New system should follow backend-dev-guidelines skill patterns
- Must integrate with existing Keycloak service
- Sessions should be stored in Redis

Review criteria:
1. Security vulnerabilities (XSS, CSRF, injection)
2. Error handling with Sentry integration
3. Cookie security settings (httpOnly, secure, sameSite)
4. Session cleanup and expiration logic
5. Consistency with project patterns
6. Performance considerations

Please provide:
- Critical issues that MUST be fixed
- High priority improvements
- Medium priority suggestions
- Positive findings
- Specific file:line references for all issues`,
  description: "Review auth system implementation"
})
```

**What makes it good:**
- Specific files listed
- Context about migration
- Clear review criteria
- Expected integrations
- Specific output format requested

---

### Testing Agent

**BAD** ❌
```typescript
Task({
  subagent_type: "auth-route-tester",
  prompt: "Test the new route",
  description: "Test route"
})
```

**Problems:**
- Which route?
- What method?
- What data to send?
- What to verify?

**GOOD** ✅
```typescript
Task({
  subagent_type: "auth-route-tester",
  prompt: `Test the new workflow launch route.

Route details:
- Method: POST
- Path: /workflow/launch/monthly-report
- File: src/routes/workflow.ts:156-198

Test with:
```json
{
  "month": "2025-01",
  "recipients": ["user@example.com"],
  "includeCharts": true
}
```

Expected behavior:
1. Should create a new workflow record in database
2. Should create initial task assignments
3. Should send notification emails
4. Should return workflow ID and status
5. Should return 201 status code

Verify:
- Database: workflow record exists with correct status
- Database: task records created for each step
- Response: includes workflowId and status fields
- Response: status is "in_progress"

Error cases to test:
- Missing month field (should return 400)
- Invalid email format (should return 400)
- Unauthenticated request (should return 401)

Please test all scenarios and review the route implementation for:
- Proper error handling
- Input validation
- Transaction usage
- Authentication checks`,
  description: "Test workflow launch route"
})
```

**What makes it good:**
- Specific route identified
- Test data provided
- Expected behavior documented
- Verification steps clear
- Error cases included
- Implementation review requested

---

### Documentation Agent

**BAD** ❌
```typescript
Task({
  subagent_type: "documentation-architect",
  prompt: "Document the API",
  description: "Create docs"
})
```

**Problems:**
- Which API?
- What aspects?
- For whom?
- What format?

**GOOD** ✅
```typescript
Task({
  subagent_type: "documentation-architect",
  prompt: `Create comprehensive API documentation for the Form Service.

Scope:
- All routes in src/routes/forms.ts
- All routes in src/routes/form-submissions.ts
- Authentication requirements
- Request/response formats
- Error responses

Target audience:
- Frontend developers integrating with API
- Backend developers maintaining the service
- QA team writing test cases

Documentation should include:

1. **Overview Section**
   - Purpose of the Form Service
   - Authentication method (JWT cookies)
   - Base URL and versioning
   - Common headers required

2. **Endpoints** (for each):
   - HTTP method and path
   - Purpose and description
   - Authentication requirements
   - Request body schema (with types)
   - Response schema (with types)
   - Error responses (status codes and formats)
   - Example request/response
   - Related endpoints

3. **Data Models**
   - Form schema
   - FormSubmission schema
   - FormField schema
   - Relationship diagrams

4. **Error Handling**
   - Standard error format
   - Common error codes
   - How to handle errors

5. **Examples**
   - Complete workflow examples
   - Common use cases
   - Code snippets

Format:
- Create docs/api/forms.md
- Use Markdown with code blocks
- Include table of contents
- Add diagrams if helpful (mermaid syntax)

Please also identify:
- Any undocumented endpoints
- Inconsistencies in current implementation
- Missing error handling`,
  description: "Create Form Service API docs"
})
```

**What makes it good:**
- Clear scope defined
- Target audience specified
- Detailed structure requested
- Format requirements clear
- Additional analysis requested
- Specific output location

---

## Context Preparation

### Preparing Context BEFORE Invoking Agent

**Main Claude should:**

1. **Gather relevant information:**
   ```typescript
   // Read error logs
   Read("build-output.log")

   // Find relevant files
   Glob("src/components/**/*.tsx")

   // Search for patterns
   Grep("userId", "src/types/**/*.ts")
   ```

2. **Synthesize findings:**
   - Identify key files
   - Extract error messages
   - Note relevant context
   - Understand relationships

3. **Formulate comprehensive prompt:**
   - Include all gathered context
   - Specify exact files and locations
   - Provide error messages verbatim
   - List expectations clearly

**Example workflow:**

```typescript
// 1. User asks to fix an error
user: "The build is failing with a TypeScript error"

// 2. Main Claude investigates
Bash("npm run build 2>&1")
// Output shows: src/components/Dashboard.tsx:45 - Property 'userId' does not exist

// 3. Read the problematic file
Read("src/components/Dashboard.tsx")
// Sees line 45: const id = user.userId

// 4. Read the type definition
Read("src/types/User.ts")
// Sees User interface missing userId field

// 5. Now invoke agent with complete context
Task({
  subagent_type: "frontend-error-fixer",
  prompt: `Fix TypeScript error...
  [Complete context from investigation]`,
  description: "Fix userId type error"
})
```

---

## Prompt Structure

### Effective Prompt Template

```markdown
[One sentence summary of task]

[Detailed context section with relevant information]

Files to [fix/review/test/document]:
- file1.ts (line X) - [why relevant]
- file2.ts - [why relevant]

[Specific requirements or constraints]

Expected outcome:
1. [Specific outcome 1]
2. [Specific outcome 2]
3. [Specific outcome 3]

Verification criteria:
- [How to verify success 1]
- [How to verify success 2]

Please provide:
- [Specific output requirement 1]
- [Specific output requirement 2]
```

### Real Example

```markdown
Fix the database connection timeout errors in production.

Context:
- Errors started appearing after migration to RDS Proxy
- Error: "Connection timeout after 30000ms"
- Occurs on high-load endpoints (>100 req/s)
- Database pool settings in src/config/database.ts
- RDS Proxy configured with 100 max connections
- Application has 10 instances running

Files to review:
- src/config/database.ts - Connection pool configuration
- src/middleware/db-connection.ts - Connection lifecycle
- src/services/health-check.ts - Health check implementation

Constraints:
- Cannot increase RDS Proxy max connections (AWS limit)
- Need to maintain current response times (<200ms)
- Must handle connection failures gracefully

Expected outcome:
1. Identify root cause of timeout
2. Adjust pool settings appropriately
3. Implement connection retry logic
4. Add monitoring for connection health

Verification criteria:
- No timeout errors in logs
- Response times remain <200ms
- Connection pool stats look healthy
- Graceful degradation on connection issues

Please provide:
- Root cause analysis
- Specific configuration changes with rationale
- Code changes for retry logic
- Monitoring recommendations
- Testing plan for verification
```

---

## When to Use Which Agent

### Decision Tree

**Encountering an error?**
→ `frontend-error-fixer` (frontend errors)
→ `auto-error-resolver` (TypeScript compilation)
→ `auth-route-debugger` (auth/route errors)

**Need to review code?**
→ `code-architecture-reviewer` (general review)
→ `plan-reviewer` (review a plan before implementing)

**Need to test something?**
→ `auth-route-tester` (API route testing)

**Need to create/update documentation?**
→ `documentation-architect`

**Need to refactor code?**
→ `refactor-planner` (create plan first)
→ `code-refactor-master` (execute refactoring)

**Need to research a topic?**
→ `web-research-specialist`

**Exploring unfamiliar codebase?**
→ `Explore` agent

**Creating a plan?**
→ `Plan` agent

---

## Parallel Agent Invocations

### When to Run Agents in Parallel

**Run in parallel when:**
- Tasks are independent
- No dependencies between agents
- Results don't affect each other
- Want faster overall completion

**Example: Testing multiple routes**

```typescript
// Single message with multiple Task calls
Task({
  subagent_type: "auth-route-tester",
  prompt: "Test POST /form/submit...",
  description: "Test form submit route"
})

Task({
  subagent_type: "auth-route-tester",
  prompt: "Test GET /form/:id...",
  description: "Test form retrieval route"
})

Task({
  subagent_type: "auth-route-tester",
  prompt: "Test DELETE /form/:id...",
  description: "Test form deletion route"
})
```

**Example: Review and test in parallel**

```typescript
Task({
  subagent_type: "code-architecture-reviewer",
  prompt: "Review auth system implementation...",
  description: "Review auth code"
})

Task({
  subagent_type: "auth-route-tester",
  prompt: "Test auth routes...",
  description: "Test auth routes"
})
```

### When to Run Agents Sequentially

**Run sequentially when:**
- Second agent needs first agent's results
- Tasks have dependencies
- Need to react to first agent's findings

**Example: Fix, then test**

```typescript
// First: Fix the error
Task({
  subagent_type: "frontend-error-fixer",
  prompt: "Fix TypeScript error...",
  description: "Fix error"
})

// Wait for result...

// Then: Test the fix
Task({
  subagent_type: "auth-route-tester",
  prompt: "Test the route that was failing...",
  description: "Verify fix"
})
```

---

## Handling Agent Results

### Main Claude's Role After Agent Completes

**1. Receive agent's report**
Agent returns comprehensive structured report

**2. Summarize for user**
Main Claude should create concise summary:

```markdown
The frontend-error-fixer agent has successfully resolved the TypeScript error.

Summary:
- **Issue**: Missing `userId` field in User type
- **Fix**: Added `userId: string` to User interface
- **Verification**: Build passes, all tests green
- **Impact**: 3 components now properly type-safe

The specific changes made:
- Updated `src/types/User.ts:12` to include userId field
- No other changes needed - existing usage was correct

Your application should now build without errors.
```

**3. Take follow-up actions if needed**

Based on agent's report:
- Launch additional agents if issues found
- Make additional changes suggested
- Ask user for decisions on recommendations
- Update documentation or todos

**Example:**

```typescript
// Agent reported medium-priority issues
assistant: "The code review found 2 medium-priority improvements. Would you like me to implement them?"

// If user says yes:
assistant: "[Makes the improvements using Edit tool]"

// Or launch another agent:
Task({
  subagent_type: "code-refactor-master",
  prompt: "Implement the improvements suggested in the review...",
  description: "Apply review suggestions"
})
```

**4. Update task tracking**

```typescript
TodoWrite({
  todos: [
    {content: "Fix TypeScript errors", status: "completed", ...},
    {content: "Review auth implementation", status: "completed", ...},
    {content: "Apply review suggestions", status: "in_progress", ...}
  ]
})
```

---

## Common Invocation Mistakes

### Mistake 1: Too Vague

❌ "Review the code"
✅ "Review the authentication middleware in src/auth/ against security best practices, focusing on CSRF protection, session management, and cookie security"

### Mistake 2: Missing Context

❌ "Fix the error"
✅ "Fix the database connection error that occurs when >100 concurrent requests hit the API. Error log shows 'connection timeout after 30000ms'. Connection pool config is in src/config/database.ts."

### Mistake 3: No Verification Criteria

❌ "Test the route"
✅ "Test the POST /workflow/launch route and verify: 1) Database record created, 2) Status is 201, 3) Response includes workflowId, 4) Related tasks created"

### Mistake 4: No Expected Output Format

❌ "Document the API"
✅ "Document the API in docs/api/forms.md with sections for: Overview, Authentication, Endpoints (with request/response examples), Error Handling, and Complete Workflow Example"

### Mistake 5: Wrong Agent Type

❌ Using `auth-route-tester` to create new routes
✅ Using `auth-route-tester` only to TEST existing routes

❌ Using `documentation-architect` to fix code
✅ Using `documentation-architect` only to create/update documentation

---

## Best Practices Summary

### For Main Claude When Invoking Agents

✅ **Investigate first**, then invoke with complete context
✅ **Be specific** about files, lines, errors, expectations
✅ **Provide context** about system, constraints, requirements
✅ **Define success** criteria and verification steps
✅ **Request specific** output format
✅ **Use right agent** for the task type
✅ **Run in parallel** when tasks are independent
✅ **Summarize results** for user after agent completes
✅ **Follow up** on agent recommendations

❌ **Don't invoke** without investigation
❌ **Don't be vague** about what needs to be done
❌ **Don't omit** important context or constraints
❌ **Don't assume** agent knows your expectations
❌ **Don't misuse** agents for wrong task types
❌ **Don't ignore** agent results - always summarize for user

---

## Template Checklist

When invoking any agent, ensure prompt includes:

- [ ] Clear, one-sentence task summary
- [ ] Relevant context and background
- [ ] Specific files/locations if applicable
- [ ] Exact error messages if applicable
- [ ] Requirements and constraints
- [ ] Expected outcomes (numbered list)
- [ ] Verification criteria
- [ ] Requested output format
- [ ] Any special considerations

If you can check all boxes, your invocation is likely effective!
