# Command Examples

Real-world slash command implementations demonstrating best practices.

## Table of Contents

1. [Strategic Planning Command](#strategic-planning-command)
2. [Workflow Automation Command](#workflow-automation-command)
3. [Analysis Command](#analysis-command)
4. [Documentation Command](#documentation-command)
5. [Simple Command](#simple-command)

---

## Strategic Planning Command

### dev-docs.md

```markdown
---
name: dev-docs
description: Create a comprehensive strategic plan with structured task breakdown
---

# Command: Development Documentation

## Purpose
Create a comprehensive strategic development plan for implementing features, refactoring systems, or making architectural decisions.

## Usage
/dev-docs [description of what needs to be planned]

Example:
- `/dev-docs refactor authentication system`
- `/dev-docs implement user notification system`
- `/dev-docs migrate to microservices architecture`

## Prompt

You are now creating a comprehensive strategic development plan.

**Task to plan**: {user_input}

Follow this structured approach to create a thorough plan:

## Step 1: Analysis & Understanding

First, gather context:
- Use Grep to search for related code patterns
- Use Glob to find relevant files
- Read existing documentation
- Understand current architecture

Analyze:
- What currently exists
- What needs to change
- Dependencies and impacts
- Risks and challenges

## Step 2: Solution Design

Design the approach:
- High-level architecture
- Key technical decisions
- Technology choices
- Integration points
- Data model changes (if applicable)

## Step 3: Task Breakdown

Break the work into specific, actionable tasks:

```markdown
### Phase 1: Foundation
- [ ] Task 1: [Specific, measurable task]
- [ ] Task 2: [Specific, measurable task]

### Phase 2: Core Implementation
- [ ] Task 3: [Specific, measurable task]
- [ ] Task 4: [Specific, measurable task]

### Phase 3: Integration & Testing
- [ ] Task 5: [Specific, measurable task]
- [ ] Task 6: [Specific, measurable task]

### Phase 4: Deployment
- [ ] Task 7: [Specific, measurable task]
- [ ] Task 8: [Specific, measurable task]
```

## Step 4: Testing Strategy

Define testing approach:
- Unit tests required
- Integration test scenarios
- E2E test cases
- Manual testing checklist
- Performance testing (if applicable)

## Step 5: Risk Assessment

Identify risks and mitigation:
- Technical risks
- Integration risks
- Performance risks
- Security considerations
- Rollback strategy

## Step 6: Timeline Estimation

Provide realistic estimates:
- Per-task time estimates
- Phase durations
- Total project timeline
- Dependencies and blockers

## Step 7: Success Criteria

Define what success looks like:
- Functional requirements met
- Performance benchmarks
- Quality metrics
- User acceptance criteria

## Output

Create the plan in the following structure:

**Directory**: `dev/active/{task-slug}/`

**Files to create**:

1. `dev/active/{task-slug}/plan.md` - The complete plan
2. `dev/active/{task-slug}/tasks.md` - Task checklist
3. `dev/active/{task-slug}/notes.md` - Additional notes and considerations

**Format the plan.md as**:

```markdown
# Project: {Task Name}

**Status**: Planning
**Created**: {Current Date}
**Estimated Duration**: {X weeks}

## Overview

[Brief description of the project]

## Analysis

[Current state analysis]

## Solution Design

[Proposed solution]

## Task Breakdown

[Detailed tasks by phase]

## Testing Strategy

[Testing approach]

## Risks & Mitigation

[Risk analysis]

## Timeline

[Estimated timeline]

## Success Criteria

[Definition of done]
```

After creating the files, provide the user with:
1. A summary of the plan
2. Next steps to begin implementation
3. Any questions or clarifications needed
```

**Key Features:**
- Comprehensive structure
- Context gathering
- Multiple phases
- File creation
- Clear output format

---

## Workflow Automation Command

### route-research-for-testing.md

```markdown
---
name: route-research-for-testing
description: Map edited routes and launch automated testing
---

# Command: Route Research for Testing

## Purpose
Automatically identify recently edited routes, analyze their implementation, and launch the auth-route-tester agent to verify functionality.

## Usage
/route-research-for-testing [optional: extra paths to check]

Example:
- `/route-research-for-testing`
- `/route-research-for-testing /extra/routes/path`

## Prompt

You are executing an automated route testing workflow.

**Workflow Overview**:
1. Identify recently edited route files
2. Analyze route implementations
3. Launch auth-route-tester agent for each route
4. Compile and report results

## Step 1: Identify Edited Routes

Check the post-tool-use tracker cache for edited files:

```bash
cat .claude/tsc-cache/{session_id}/edited-files.log
```

Filter for route files:
- Files matching `**/routes/**/*.ts`
- Files matching `**/api/**/*.ts`
- Files containing router definitions
- Additional paths provided by user: {extra_paths}

## Step 2: Analyze Route Files

For each identified route file:

1. **Read the file** to understand:
   - HTTP methods (GET, POST, PUT, DELETE, PATCH)
   - Route paths
   - Request body expectations
   - Authentication requirements
   - Response formats

2. **Extract route information**:
   - Method + Path
   - Handler function
   - Middleware used
   - Expected input/output

## Step 3: Launch Testing Agent

For each route found, launch the auth-route-tester agent:

```typescript
Task({
  subagent_type: "auth-route-tester",
  prompt: `
Test the route: {METHOD} {PATH}

Route details:
- File: {file_path}:{line_number}
- Handler: {handler_name}
- Authentication: {auth_required}

Please:
1. Execute the route with appropriate test data
2. Verify response status and structure
3. Check database record creation (if applicable)
4. Test error cases
5. Review implementation for best practices

Expected response format: {response_format}
  `,
  description: "Test {METHOD} {PATH}"
})
```

**Launch agents in parallel** if multiple routes found (use single message with multiple Task calls).

## Step 4: Compile Results

After all agents complete:

1. **Summarize test results**:
   ```markdown
   # Route Testing Results

   ## Routes Tested: {count}

   ### ✅ Passing Routes
   - {METHOD} {PATH} - All tests passed

   ### ⚠️ Issues Found
   - {METHOD} {PATH} - {issue description}

   ### 📝 Recommendations
   - {Recommendation 1}
   - {Recommendation 2}
   ```

2. **Create summary file**:
   `dev/test-results/routes-{timestamp}.md`

3. **Report to user**:
   - Total routes tested
   - Pass/fail summary
   - Key issues found
   - Recommended actions

## Error Handling

If no edited routes found:
- Inform user
- Suggest manually specifying paths
- Exit gracefully

If route analysis fails:
- Log the issue
- Continue with other routes
- Report failures in summary

If agent testing fails:
- Note the failure
- Include error details in report
- Suggest manual testing
```

**Key Features:**
- Multi-step workflow
- Context from hooks
- Agent integration
- Parallel execution
- Comprehensive reporting

---

## Analysis Command

### analyze-security.md

```markdown
---
name: analyze-security
description: Perform comprehensive security analysis of the codebase
---

# Command: Security Analysis

## Purpose
Systematically analyze the codebase for common security vulnerabilities and provide actionable recommendations.

## Usage
/analyze-security [optional: specific directory or file]

Example:
- `/analyze-security`
- `/analyze-security src/api/`
- `/analyze-security src/auth/middleware.ts`

## Prompt

You are performing a comprehensive security analysis.

**Scope**: {user_input or "entire codebase"}

## Analysis Checklist

### 1. Input Validation

Search for potential injection vulnerabilities:

```typescript
// Use Grep to find:
- SQL queries with string concatenation
- exec() or eval() calls
- Dynamic imports
- User input directly in queries
```

**Check for**:
- [ ] SQL injection risks
- [ ] NoSQL injection risks
- [ ] Command injection
- [ ] XSS vulnerabilities
- [ ] Path traversal

### 2. Authentication & Authorization

Analyze authentication implementation:

**Check for**:
- [ ] Weak password requirements
- [ ] Missing authentication on sensitive routes
- [ ] Improper session management
- [ ] Missing authorization checks
- [ ] Insecure token storage

### 3. Data Exposure

Review data handling:

**Check for**:
- [ ] Sensitive data in logs
- [ ] Unencrypted sensitive data
- [ ] Exposed API keys/secrets
- [ ] Information disclosure in errors
- [ ] Missing data sanitization

### 4. Cryptography

Review cryptographic implementations:

**Check for**:
- [ ] Weak hashing algorithms (MD5, SHA1)
- [ ] Hardcoded secrets
- [ ] Insecure random number generation
- [ ] Missing encryption for sensitive data
- [ ] Improper certificate validation

### 5. Access Control

Review permissions and access:

**Check for**:
- [ ] Missing CSRF protection
- [ ] Insecure CORS configuration
- [ ] Missing rate limiting
- [ ] Inadequate file permissions
- [ ] Privilege escalation risks

### 6. Error Handling

Review error handling:

**Check for**:
- [ ] Stack traces exposed to users
- [ ] Detailed error messages revealing system info
- [ ] Unhandled exceptions
- [ ] Missing error logging

### 7. Dependencies

Review third-party dependencies:

**Check for**:
- [ ] Known vulnerable dependencies
- [ ] Outdated packages
- [ ] Unnecessary dependencies
- [ ] Missing dependency integrity checks

## Output Format

Create security analysis report:

**File**: `dev/security/analysis-{date}.md`

```markdown
# Security Analysis Report

**Date**: {Current Date}
**Scope**: {Analysis Scope}
**Analyst**: Claude Code

## Executive Summary

[High-level overview of findings]

- Critical Issues: {count}
- High Priority: {count}
- Medium Priority: {count}
- Low Priority: {count}

## Critical Issues (Must Fix Immediately)

### Issue 1: [Title]
**Severity**: Critical
**Location**: {file}:{line}
**Type**: {SQL Injection / XSS / etc.}

**Description**:
[Detailed description of the vulnerability]

**Current Code**:
```typescript
// Vulnerable code
```

**Recommended Fix**:
```typescript
// Secure code
```

**Impact**: [What could happen if exploited]

## High Priority Issues (Fix Soon)

[Similar structure for high priority issues]

## Medium Priority Issues (Should Fix)

[Similar structure for medium priority issues]

## Recommendations

1. **Immediate Actions**:
   - [Action 1]
   - [Action 2]

2. **Short Term** (1-2 weeks):
   - [Action 1]
   - [Action 2]

3. **Long Term** (1-3 months):
   - [Action 1]
   - [Action 2]

## Security Best Practices

[General security recommendations for the project]

## Next Steps

1. [Prioritized action item]
2. [Prioritized action item]
3. [Prioritized action item]
```

After creating the report, provide the user with:
1. Summary of critical findings
2. Immediate actions required
3. Offer to fix critical issues if desired
```

**Key Features:**
- Systematic checklist
- Multiple vulnerability types
- Detailed output format
- Actionable recommendations
- Severity classification

---

## Documentation Command

### document-api.md

```markdown
---
name: document-api
description: Generate comprehensive API documentation
---

# Command: Document API

## Purpose
Create comprehensive, standardized API documentation for REST endpoints.

## Usage
/document-api [service or route file]

Example:
- `/document-api src/routes/users.ts`
- `/document-api user-service`

## Prompt

You are creating comprehensive API documentation.

**Target**: {user_input}

## Step 1: Discover Endpoints

Analyze the specified routes:

1. **Read route files** in scope
2. **Extract endpoints**:
   - HTTP method
   - Route path
   - Handler function
   - Middleware

3. **Identify patterns**:
   - Authentication requirements
   - Request/response formats
   - Error responses

## Step 2: Document Each Endpoint

For each endpoint, create documentation:

### Template

```markdown
## {METHOD} {path}

**Description**: [What this endpoint does]

**Authentication**: [Required/Optional/None]

**Request**

Headers:
```
Authorization: Bearer {token}
Content-Type: application/json
```

Body:
```json
{
  "field1": "string",
  "field2": "number"
}
```

**Request Schema**:
- `field1` (string, required): Description
- `field2` (number, optional): Description

**Response**

Success (200/201):
```json
{
  "id": "string",
  "status": "string",
  "data": {}
}
```

**Response Schema**:
- `id` (string): Unique identifier
- `status` (string): Operation status
- `data` (object): Response payload

**Error Responses**:

400 Bad Request:
```json
{
  "error": "Invalid input",
  "details": []
}
```

401 Unauthorized:
```json
{
  "error": "Authentication required"
}
```

404 Not Found:
```json
{
  "error": "Resource not found"
}
```

**Example Usage**

```bash
curl -X {METHOD} https://api.example.com{path} \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "field1": "value",
    "field2": 123
  }'
```

```typescript
// TypeScript example
const response = await fetch('https://api.example.com{path}', {
  method: '{METHOD}',
  headers: {
    'Authorization': `Bearer ${token}`,
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    field1: 'value',
    field2: 123
  })
});
```
```

## Step 3: Create Documentation File

**File**: `docs/api/{service-name}.md`

**Structure**:

```markdown
# {Service Name} API Documentation

**Base URL**: `https://api.example.com`
**Version**: 1.0

## Table of Contents

- [Authentication](#authentication)
- [Endpoints](#endpoints)
  - [GET /resource](#get-resource)
  - [POST /resource](#post-resource)
  - [PUT /resource/:id](#put-resourceid)
  - [DELETE /resource/:id](#delete-resourceid)
- [Error Codes](#error-codes)
- [Rate Limiting](#rate-limiting)

## Authentication

[Authentication description]

## Endpoints

[All endpoint documentation using template above]

## Error Codes

| Code | Meaning |
|------|---------|
| 400 | Bad Request - Invalid input |
| 401 | Unauthorized - Missing/invalid auth |
| 403 | Forbidden - Insufficient permissions |
| 404 | Not Found - Resource doesn't exist |
| 500 | Internal Server Error |

## Rate Limiting

[Rate limit information]

## Support

For questions or issues, contact: [support info]
```

## Step 4: Summary for User

After creating documentation:

1. **Report**:
   - Number of endpoints documented
   - File location
   - Coverage completeness

2. **Suggest next steps**:
   - Review for accuracy
   - Add examples
   - Update as needed
```

**Key Features:**
- Systematic discovery
- Consistent format
- Complete examples
- Error documentation
- Multiple languages

---

## Simple Command

### create-component.md

```markdown
---
name: create-component
description: Create a new React component with TypeScript and tests
---

# Command: Create Component

## Purpose
Quickly scaffold a new React component following project conventions.

## Usage
/create-component [ComponentName]

Example:
- `/create-component UserProfile`
- `/create-component DataTable`

## Prompt

Create a new React component: **{user_input}**

## Component Structure

Create the following files:

### 1. Component File

**Location**: `src/components/{ComponentName}/{ComponentName}.tsx`

```typescript
import React from 'react';
import styles from './{ComponentName}.module.css';

interface {ComponentName}Props {
  // Define props here
}

export const {ComponentName}: React.FC<{ComponentName}Props> = (props) => {
  return (
    <div className={styles.container}>
      <h2>{ComponentName}</h2>
      {/* Component content */}
    </div>
  );
};
```

### 2. Styles File

**Location**: `src/components/{ComponentName}/{ComponentName}.module.css`

```css
.container {
  /* Component styles */
}
```

### 3. Test File

**Location**: `src/components/{ComponentName}/{ComponentName}.test.tsx`

```typescript
import { render, screen } from '@testing-library/react';
import { {ComponentName} } from './{ComponentName}';

describe('{ComponentName}', () => {
  it('renders without crashing', () => {
    render(<{ComponentName} />);
    expect(screen.getByText('{ComponentName}')).toBeInTheDocument();
  });
});
```

### 4. Index File

**Location**: `src/components/{ComponentName}/index.ts`

```typescript
export { {ComponentName} } from './{ComponentName}';
export type { {ComponentName}Props } from './{ComponentName}';
```

## After Creation

Inform the user:
1. Component created at: `src/components/{ComponentName}/`
2. Next steps:
   - Define props interface
   - Implement component logic
   - Add styles
   - Write tests
3. Import with: `import { {ComponentName} } from '@/components/{ComponentName}';`
```

**Key Features:**
- Simple, focused purpose
- Clear structure
- Minimal configuration
- Immediate value

---

## Key Takeaways

### What Makes Good Commands

1. **Clear Purpose** - Single, well-defined goal
2. **Structured Prompts** - Step-by-step instructions
3. **Specified Output** - Exact format defined
4. **Examples** - Show expected results
5. **Error Handling** - Handle edge cases
6. **Integration** - Work with agents/skills when needed

### Command Patterns

- **Planning**: Analysis → Design → Breakdown → Output
- **Automation**: Discover → Process → Execute → Report
- **Analysis**: Scan → Check → Classify → Recommend
- **Documentation**: Extract → Structure → Format → Create
- **Generation**: Template → Customize → Create → Inform
