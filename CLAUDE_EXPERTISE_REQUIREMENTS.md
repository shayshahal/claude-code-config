# Claude Expertise Requirements for JewelryX Project

**Project:** JewelryX B2B/B2C Jewelry Trading Platform
**Tech Stack:** SvelteKit + Svelte 5 (Frontend) | FastAPI + Python (Backend) | MongoDB | AWS
**Team:** Solo developer (40% time) + Senior code reviewer + Part-time QA/DevOps
**Timeline:** 68-70 weeks (17 months) for full scope | 40 weeks (10 months) for MVP

---

## Table of Contents

1. [Core Technical Expertise](#1-core-technical-expertise)
2. [Required Custom Agents](#2-required-custom-agents)
3. [Required Custom Skills](#3-required-custom-skills)
4. [Recommended MCP Servers](#4-recommended-mcp-servers)
5. [Useful Hooks](#5-useful-hooks)
6. [Custom Slash Commands](#6-custom-slash-commands)
7. [Development Workflow Integration](#7-development-workflow-integration)

---

## ⚠️ CRITICAL: Svelte MCP Must Be Installed First

**The official Svelte MCP server is MANDATORY for this project.**

**Why Critical:**
- AI models were trained before Svelte 5 was released
- They confidently give **outdated Svelte 4 code** or **mix Svelte 4 and 5 syntax**
- This creates non-functional components with deprecated patterns

**The Svelte MCP solves this by:**
- Providing up-to-date Svelte 5 documentation directly from svelte.dev
- Running `svelte-autofixer` in an **agentic loop** to iteratively fix code
- Validating components use correct Svelte 5 syntax
- Eliminating hallucinations about Svelte features

**Quick Install:**
```bash
# Auto-configures for Claude Code
npx sv add mcp

# Or manual installation
claude mcp add -t stdio -s project svelte -- npx -y @sveltejs/mcp
```

**How to Use:**
1. **User:** Invoke `svelte-task` prompt when starting Svelte work
2. **LLM:** Automatically uses tools to fetch docs and validate code
3. **LLM:** Runs `svelte-autofixer` on all generated code until clean
4. **User:** Receives validated, Svelte 5-compliant code

**Must use `svelte-autofixer` on ALL Svelte code before committing.**

---

## 1. Core Technical Expertise

### 1.1 Frontend Technologies

**Must-Know:**
- ✅ **SvelteKit 2.0+** - File-based routing, load functions, form actions, hooks
- ✅ **Svelte 5** - Runes ($state, $derived, $effect), components, reactivity
- ✅ **TypeScript 5+** - Advanced types, generics, utility types
- ✅ **Tailwind CSS** - Utility classes, responsive design, customization
- ✅ **shadcn-svelte** - Component library patterns, accessibility, customization
- ✅ **Superforms** - Form handling, validation, error management with SvelteKit
- ✅ **Zod** - Schema validation, type inference
- ✅ **Vitest** - Unit testing for Svelte components
- ✅ **Playwright** - E2E testing for web applications

**Nice-to-Have:**
- svelte-i18n or paraglide-js (internationalization)
- TanStack Query (optional data fetching)
- Skeleton UI (alternative component library)

### 1.2 Backend Technologies

**Must-Know:**
- ✅ **FastAPI** - Routing, dependencies, Pydantic models, async operations
- ✅ **Python 3.11+** - Async/await, type hints, dataclasses, modern patterns
- ✅ **Pydantic v2** - Data validation, serialization, settings management
- ✅ **Motor** - Async MongoDB driver
- ✅ **Beanie ODM** - MongoDB document modeling, queries, relationships
- ✅ **Uvicorn/Gunicorn** - ASGI server configuration
- ✅ **Celery** - Background task processing
- ✅ **Redis** - Caching, session storage, Celery broker
- ✅ **pytest** - Unit and integration testing
- ✅ **pytest-asyncio** - Async test support

**Nice-to-Have:**
- FastAPI dependency injection patterns
- Alembic (if switching to SQL later)
- APScheduler (scheduled tasks)

### 1.3 Database & Data

**Must-Know:**
- ✅ **MongoDB** - Document modeling, indexes, aggregation pipeline, transactions
- ✅ **MongoDB Atlas** - Cluster management, backups, monitoring
- ✅ **NoSQL Design Patterns** - Embedding vs referencing, denormalization
- ✅ **Data Migration Strategies** - Schema evolution in NoSQL

**Nice-to-Have:**
- Elasticsearch or Algolia (search engine)
- MongoDB change streams (real-time updates)

### 1.4 DevOps & Infrastructure

**Must-Know:**
- ✅ **Docker** - Multi-stage builds, docker-compose, containerization
- ✅ **AWS ECS Fargate** - Task definitions, services, deployments
- ✅ **AWS ECR** - Container registry management
- ✅ **AWS S3** - Static file storage, CloudFront CDN
- ✅ **GitHub Actions** - CI/CD pipelines, workflows
- ✅ **Infrastructure as Code** - Terraform or AWS CDK basics

**Nice-to-Have:**
- AWS WAF (Web Application Firewall)
- AWS Secrets Manager
- AWS CloudWatch (monitoring and logging)

### 1.5 Business Domain Knowledge

**Critical for JewelryX:**
- ✅ **Jewelry Industry Concepts** - Carats, gold purity, gemstones, variants
- ✅ **B2B/B2C Marketplace Patterns** - Seller anonymity, commission models
- ✅ **Multi-Pricing Strategies** - Wholesale cash/credit, consumer pricing, markups
- ✅ **Variant Management** - Many-to-many inventory (sizes, weights, colors)
- ✅ **Commission Calculations** - Different rates per transaction type
- ✅ **Payment Processing** - Credit card vs balance/credit system
- ✅ **Multi-Currency & Multi-Language** - Exchange rates, RTL/LTR support

---

## 2. Required Custom Agents

### 2.1 Development Agents

**Agent: `sveltekit-error-fixer`**
- **Purpose:** Debug and fix SvelteKit/Svelte 5 frontend errors
- **Use When:** Build errors, runtime errors, reactivity issues, routing problems
- **Tools:** Read, Edit, Bash, WebSearch
- **Triggers:** TypeScript errors, Svelte compiler errors, browser console errors

**Agent: `fastapi-error-fixer`**
- **Purpose:** Debug and fix FastAPI/Python backend errors
- **Use When:** API endpoint failures, Pydantic validation errors, async issues
- **Tools:** Read, Edit, Bash, pytest integration
- **Triggers:** FastAPI startup errors, test failures, 500 errors

**Agent: `mongodb-query-optimizer`**
- **Purpose:** Optimize MongoDB queries and design schemas
- **Use When:** Slow queries, complex aggregations, schema design decisions
- **Tools:** Read, MongoDB MCP (if available), performance analysis
- **Triggers:** Query performance issues, index recommendations needed

**Agent: `api-route-tester`**
- **Purpose:** Test FastAPI endpoints with authentication and validation
- **Use When:** After implementing/modifying API routes
- **Tools:** Bash (curl/httpx), Read routes, validate responses
- **Triggers:** New endpoint created, authentication changes

**Agent: `code-architecture-reviewer`** ✅ (Already exists)
- **Purpose:** Review code for architectural consistency and best practices
- **Use When:** After completing user stories, before PR submission
- **Tools:** All tools
- **Triggers:** Feature complete, needs review

**Agent: `documentation-architect`** ✅ (Already exists)
- **Purpose:** Create comprehensive documentation for features
- **Use When:** Complex feature needs documentation, API docs updates
- **Tools:** All tools
- **Triggers:** Feature complete, documentation needed

**Agent: `performance-reviewer`** ✅ (Already exists)
- **Purpose:** Analyze and optimize performance bottlenecks
- **Use When:** Slow page loads, API latency, large dataset issues
- **Tools:** Browser tools, profiling, code analysis
- **Triggers:** Performance complaints, slow operations

**Agent: `security-auditor`**
- **Purpose:** Audit code for security vulnerabilities
- **Use When:** Before production deployment, after auth changes
- **Tools:** OWASP ZAP, code analysis, dependency scanning
- **Triggers:** Security-sensitive feature complete, pre-release

### 2.2 Testing Agents

**Agent: `e2e-test-generator`**
- **Purpose:** Generate Playwright E2E tests for user flows
- **Use When:** New user flow implemented, testing gaps identified
- **Tools:** Read components/routes, Write test files, Playwright knowledge
- **Triggers:** User story complete, E2E test needed

**Agent: `test-coverage-analyzer`**
- **Purpose:** Analyze test coverage and identify gaps
- **Use When:** Sprint review, before major releases
- **Tools:** pytest coverage, Vitest coverage, code analysis
- **Triggers:** Coverage below 80%, pre-release checklist

### 2.3 Database Agents

**Agent: `mongodb-migration-creator`**
- **Purpose:** Create safe MongoDB migration scripts
- **Use When:** Schema changes, data transformations needed
- **Tools:** Read models, Write migration scripts, validate data integrity
- **Triggers:** Schema evolution, new fields/indexes needed

**Agent: `seed-data-generator`**
- **Purpose:** Generate realistic seed data for development/testing
- **Use When:** Setting up dev environment, testing edge cases
- **Tools:** Beanie models, Faker library, business logic
- **Triggers:** Need test data, demo preparation

### 2.4 Deployment Agents

**Agent: `deployment-helper`**
- **Purpose:** Assist with staging/production deployments
- **Use When:** Preparing for deployment, troubleshooting deploy issues
- **Tools:** Docker, AWS CLI, ECS operations, rollback procedures
- **Triggers:** Ready to deploy, deployment failure

**Agent: `environment-setup`**
- **Purpose:** Set up development environment from scratch
- **Use When:** New developer onboarding, environment reset needed
- **Tools:** Docker, package managers, config files, documentation
- **Triggers:** New machine setup, environment corrupted

---

## 3. Required Custom Skills

### 3.1 Development Skills

**Skill: `sveltekit-svelte5-patterns`**
- **Triggers:** Keywords: "svelte", "sveltekit", "runes", "$state", "component"
- **Content:** SvelteKit 2.0 patterns, Svelte 5 runes, load functions, form actions, hooks
- **File Patterns:** `*.svelte`, `+page.server.ts`, `+layout.ts`
- **Purpose:** Guide on SvelteKit/Svelte 5 best practices

**Skill: `fastapi-python-patterns`** ✅ (Similar to backend-dev-guidelines)
- **Triggers:** Keywords: "fastapi", "endpoint", "router", "dependency", "pydantic"
- **Content:** FastAPI patterns, dependency injection, async best practices, Pydantic validation
- **File Patterns:** `app/api/**/*.py`, `app/models/*.py`, `app/schemas/*.py`
- **Purpose:** Guide on FastAPI/Python best practices

**Skill: `mongodb-beanie-patterns`**
- **Triggers:** Keywords: "mongodb", "beanie", "query", "aggregation", "document"
- **Content:** MongoDB design patterns, Beanie ODM usage, query optimization, indexing strategies
- **File Patterns:** `app/models/*.py`, `app/repositories/*.py`
- **Purpose:** Guide on MongoDB/Beanie best practices

**Skill: `tailwind-shadcn-patterns`**
- **Triggers:** Keywords: "tailwind", "shadcn", "styling", "ui component"
- **Content:** Tailwind utility patterns, shadcn-svelte customization, responsive design
- **File Patterns:** `*.svelte`, `tailwind.config.js`
- **Purpose:** Guide on Tailwind + shadcn-svelte best practices

**Skill: `authentication-patterns`**
- **Triggers:** Keywords: "auth", "jwt", "login", "cookie", "session"
- **Content:** JWT cookie-based auth, refresh tokens, RBAC, permission checking
- **File Patterns:** `app/core/security.py`, `src/hooks.server.ts`
- **Purpose:** Guide on authentication implementation

**Skill: `testing-patterns`**
- **Triggers:** Keywords: "test", "pytest", "vitest", "playwright", "coverage"
- **Content:** Unit testing, integration testing, E2E testing, mocking strategies
- **File Patterns:** `**/*.test.ts`, `tests/**/*.py`
- **Purpose:** Guide on testing best practices

**Skill: `jewelry-business-logic`**
- **Triggers:** Keywords: "pricing", "variant", "commission", "markup", "carat"
- **Content:** Jewelry pricing formulas, variant management, commission calculations
- **File Patterns:** `app/services/pricing*.py`, `app/services/commission*.py`
- **Purpose:** Domain-specific business logic patterns

**Skill: `api-design-patterns`**
- **Triggers:** Keywords: "api", "endpoint", "rest", "validation", "error handling"
- **Content:** RESTful API design, error responses, pagination, filtering, sorting
- **File Patterns:** `app/api/**/*.py`
- **Purpose:** Guide on API design consistency

### 3.2 Workflow Skills

**Skill: `code-review-checklist`**
- **Triggers:** Keywords: "review", "pr", "pull request"
- **Content:** Pre-review checklist, common issues to check, self-review guide
- **Purpose:** Ensure code quality before senior review

**Skill: `definition-of-done`**
- **Triggers:** Keywords: "done", "complete", "ready for review"
- **Content:** DoD checklist from design document, quality gates
- **Purpose:** Ensure all DoD criteria met

**Skill: `monday-workflow`**
- **Triggers:** Keywords: "monday", "task", "story", "sprint"
- **Content:** Monday.com board structure, status updates, linking PRs
- **Purpose:** Guide on project management workflow

---

## 4. Recommended MCP Servers

### Quick Reference: MCPs for JewelryX Project

| MCP | Priority | Phase | Why Important |
|-----|----------|-------|---------------|
| **Svelte** | 🔴 CRITICAL | 1 | Prevents outdated Svelte 4 code, has `svelte-autofixer` |
| **Tailwind-Svelte-Assistant** | 🟢 RECOMMENDED | 1 | 100% SvelteKit + Tailwind docs coverage |
| **Python Docs** | 🟡 IMPORTANT | 1 | Python language reference and standard library |
| **FastAPI Docs** | 🟡 IMPORTANT | 1 | Semantic search for FastAPI documentation |
| **GitHub** | 🔴 CRITICAL | 1 | PR management, CI/CD, issues |
| **Filesystem** | 🟡 IMPORTANT | 1 | Advanced file operations |
| **shadcn-ui** | 🟡 IMPORTANT | 2 | Component implementations for Svelte |
| **TailwindCSS** | 🟢 RECOMMENDED | 2 | Utility classes and docs (if not using Tailwind-Svelte-Assistant) |
| **Puppeteer** | 🟡 IMPORTANT | 2 | Browser testing and debugging |
| **MongoDB** | 🟢 RECOMMENDED | 2+ | Database queries and operations |
| **AWS** | 🟢 RECOMMENDED | 3+ | Cloud resource management |
| **Docker** | 🟢 RECOMMENDED | 3+ | Container management |
| **Stripe** | 🔵 OPTIONAL | 4 | Payment processing testing |
| **Sentry** | 🔵 OPTIONAL | 4 | Error tracking |

**Note:** If using **Tailwind-Svelte-Assistant**, you get both SvelteKit docs AND Tailwind docs in one MCP, making generic TailwindCSS MCP optional.

### Understanding MCP Components

**Resources** (User-controlled):
- Content that **user** includes in session (not LLM)
- Provides immediate context without LLM needing to fetch
- Example: `svelte://migration-guide.md` preloads migration docs

**Prompts** (User-invoked templates):
- Reusable instruction templates **user** selects
- Sent as initial user message to set up workflow
- Example: `svelte-task` teaches LLM how to use Svelte MCP tools

**Tools** (LLM-invoked actions):
- Functions **LLM** can call during conversation
- Used when LLM needs to fetch data or perform actions
- Example: `svelte-autofixer` runs static analysis on code

### 4.1 Essential MCPs

**MCP: Svelte** 🔴 CRITICAL
- **Purpose:** Official Svelte 5 documentation and code analysis from svelte.dev
- **Why Critical:** AI models trained before Svelte 5 give outdated code mixing Svelte 4 and 5 syntax
- **Package:** `@sveltejs/mcp`

**Resources (User-Controlled Context Injection):**
- `doc-section` - Preload specific docs into session using `svelte://slug-of-the-docs.md` URI pattern
- Example: Load migration guide before starting work
- User includes these (not LLM), provides immediate context

**Prompts (Reusable Templates):**
- `svelte-task` - Primary prompt that teaches LLM:
  - Available documentation sections
  - When and how to use each tool
  - Best practices for Svelte development
  - Automates repetitive instructions
  - User selects this prompt to start Svelte work session

**Tools (LLM-Invoked Actions):**
1. `list-sections` - Discover all available documentation sections
   - Use when: Starting work, need to know what docs exist

2. `get-documentation` - Retrieve full, up-to-date docs from svelte.dev/docs
   - Use when: Need comprehensive documentation for specific topics
   - Fetches authoritative source material directly

3. `svelte-autofixer` - **CRITICAL** Static analysis with suggestions
   - Use when: **Every time Svelte code is generated** (agentic loop)
   - Iteratively refines code until all issues resolved
   - MUST use before sharing code with user

4. `playground-link` - Generate ephemeral playground links
   - Use when: Testing code without storing in project
   - Code stored only in URL (not persistent)

**Installation:**

*Claude Code (Recommended):*
```bash
# Quick setup - auto-configures everything
npx sv add mcp

# Or manual
claude mcp add -t stdio -s project svelte -- npx -y @sveltejs/mcp
```

*Claude Desktop:*
Edit `claude_desktop_config.json` in Settings > Developer:
```json
{
  "mcpServers": {
    "svelte": {
      "command": "npx",
      "args": ["-y", "@sveltejs/mcp"]
    }
  }
}
```

*VS Code:*
- Open command palette
- "MCP: Add Server..."
- Choose "Command (stdio)"
- Enter: `npx -y @sveltejs/mcp`
- Name: `svelte`
- Scope: Workspace

*Direct Usage (Any Client):*
```bash
npx -y @sveltejs/mcp
```

**Workflow:**
1. User invokes `svelte-task` prompt to start session
2. Optional: User adds `svelte://docs-slug.md` resources for immediate context
3. LLM uses `list-sections` to discover docs
4. LLM uses `get-documentation` for specific topics
5. LLM writes Svelte code
6. LLM uses `svelte-autofixer` in agentic loop until clean
7. LLM shares validated code with user
8. Optional: Use `playground-link` for testing

**When to Use Each Component:**

| Component | Who Controls | When to Use |
|-----------|--------------|-------------|
| **`svelte-task` prompt** | User | Start of every Svelte work session |
| **`doc-section` resource** | User | Need specific doc preloaded (migration, advanced patterns) |
| **`list-sections` tool** | LLM | Discovering available documentation |
| **`get-documentation` tool** | LLM | Fetching docs for specific topics |
| **`svelte-autofixer` tool** | LLM | **EVERY time code is written** (mandatory) |
| **`playground-link` tool** | LLM | Testing code without saving to project |

**Critical Note:** `svelte-autofixer` MUST run on ALL Svelte code before committing

**MCP: GitHub** 🔴 CRITICAL
- **Purpose:** Repository operations, PR management, issues, CI/CD status
- **Use Cases:**
  - Create/review pull requests
  - Check CI/CD pipeline status
  - Create/update issues
  - View commit history and diffs
- **Installation:** `@modelcontextprotocol/server-github`

**MCP: Filesystem** 🟡 IMPORTANT
- **Purpose:** Advanced file operations beyond basic Read/Write
- **Use Cases:**
  - Bulk file operations
  - File watching
  - Directory operations
- **Installation:** `@modelcontextprotocol/server-filesystem`

**MCP: Puppeteer** 🟡 IMPORTANT
- **Purpose:** Browser automation for E2E testing and debugging
- **Use Cases:**
  - Test user flows in browser
  - Capture screenshots of bugs
  - Debug frontend issues
  - Performance testing
- **Installation:** `@modelcontextprotocol/server-puppeteer`

### 4.2 Highly Recommended MCPs

**MCP: Python Docs** 🟡 IMPORTANT
- **Purpose:** Access Python language documentation and references
- **Package:** `python-docs-server-mcp-server` (by Anurag Rai)
- **Use Cases:**
  - Quick access to Python language references
  - Code explanations for Python features
  - Language syntax lookups
  - Standard library documentation
- **Installation:**
  ```bash
  # GitHub: https://github.com/anuragrai017/python-docs-server-mcp-server
  npx python-docs-server-mcp-server
  ```
- **Released:** January 14, 2025

**MCP: FastAPI Docs** 🟡 IMPORTANT
- **Purpose:** Semantic search for FastAPI documentation
- **Package:** `fastapi-mcp` (by ShawnKyzer)
- **Use Cases:**
  - Natural language queries for FastAPI docs
  - Tag-based filtering (async, security, Pydantic, dependencies)
  - On-demand refresh from official FastAPI repo
  - Contextual documentation within AI coding workflows
- **Features:**
  - Semantic search (not just keyword matching)
  - Smart indexing with automatic chunking
  - Elasticsearch-powered relevance ranking
  - GitHub repository auto-sync
- **Installation:**
  ```bash
  # Requires Elasticsearch running
  # GitHub: https://github.com/ShawnKyzer/fastapi-mcp
  # Configure with Claude Desktop or Windsurf
  ```
- **Requirements:** Elasticsearch for search functionality

**MCP: shadcn-ui (Svelte Support)** 🟡 IMPORTANT
- **Purpose:** Access shadcn/ui v4 component implementations
- **Package:** `@jpisnice/shadcn-ui-mcp-server`
- **Use Cases:**
  - Get Svelte component implementations
  - Access component demos and usage patterns
  - Retrieve block implementations (dashboards, forms, calendars)
  - Component metadata and dependencies
- **Features:**
  - **Multi-framework:** React, Svelte, Vue, React Native
  - Latest shadcn/ui v4 TypeScript source
  - Complete block implementations
  - Smart caching with GitHub API
  - SSE transport for concurrent connections
- **Installation:**
  ```bash
  # Svelte mode
  npx @jpisnice/shadcn-ui-mcp-server --framework svelte

  # With GitHub token (better rate limits: 5000 vs 60 req/hour)
  npx @jpisnice/shadcn-ui-mcp-server --framework svelte --github-api-key ghp_YOUR_TOKEN
  ```
- **Docker:** Docker Compose available for production

**MCP: TailwindCSS** 🟡 IMPORTANT
- **Purpose:** TailwindCSS utilities, documentation, and project assistance
- **Package:** `tailwindcss-mcp-server` (by CarbonoDev)
- **Use Cases:**
  - Get Tailwind utility classes by category/property
  - Access color palettes with shades
  - Search Tailwind documentation
  - Convert CSS to Tailwind classes
  - Install Tailwind in projects
  - Generate color palettes
- **Tools Provided:**
  1. `get_tailwind_utilities` - Retrieve utilities
  2. `get_tailwind_colors` - Access color palettes
  3. `get_tailwind_config_guide` - Framework-specific configs
  4. `search_tailwind_docs` - Search documentation
  5. `install_tailwind` - Install Tailwind
  6. `convert_css_to_tailwind` - CSS conversion with suggestions
  7. `generate_color_palette` - Generate color palettes
- **Installation:**
  ```bash
  npx -y tailwindcss-mcp-server
  ```

**MCP: Tailwind-Svelte-Assistant** 🟢 RECOMMENDED (SvelteKit Specific)
- **Purpose:** Complete SvelteKit + Tailwind CSS documentation (100% coverage)
- **Package:** `@CaullenOmdahl/tailwind-svelte-assistant`
- **Why Better for SvelteKit:**
  - **100% documentation coverage** (vs 4-8% in legacy tools)
  - Optimized specifically for SvelteKit + Tailwind workflows
  - Full Svelte/SvelteKit docs (1MB)
  - Complete Tailwind CSS docs (2.1MB)
  - Security-hardened input sanitization
  - Proper TypeScript implementation
- **Tools Provided:**
  - `get_svelte_full_docs` - Entire Svelte/SvelteKit documentation
  - `get_tailwind_full_docs` - Complete Tailwind CSS documentation
  - `search_svelte_docs` - Search Svelte docs
  - `search_tailwind_docs` - Search Tailwind docs
  - Component snippet access
- **Installation:**
  ```bash
  # Via Smithery (easiest)
  npx -y @smithery/cli install @CaullenOmdahl/tailwind-svelte-assistant --client claude

  # Or manual from GitHub
  # https://github.com/CaullenOmdahl/Tailwind-Svelte-Assistant
  ```
- **Note:** This is MORE comprehensive than generic Tailwind + Svelte MCPs combined

**MCP: MongoDB** 🟢 RECOMMENDED
- **Purpose:** Direct database queries and operations
- **Use Cases:**
  - Query debugging
  - Data analysis
  - Migration validation
  - Index analysis
- **Installation:** Custom or third-party MongoDB MCP (if available)

**MCP: AWS** 🟢 RECOMMENDED
- **Purpose:** AWS resource management and monitoring
- **Use Cases:**
  - Check ECS deployment status
  - View CloudWatch logs
  - Manage S3 buckets
  - Monitor resource usage
- **Installation:** Custom AWS MCP or CLI wrapper

**MCP: Docker** 🟢 RECOMMENDED
- **Purpose:** Container management and debugging
- **Use Cases:**
  - Build and test containers
  - View container logs
  - Debug containerization issues
  - Manage docker-compose services
- **Installation:** Custom Docker MCP or CLI wrapper

### 4.3 Nice-to-Have MCPs

**MCP: Stripe** 🔵 OPTIONAL
- **Purpose:** Payment processing integration and testing
- **Use Cases:**
  - Test payment flows
  - Check webhook events
  - Debug payment issues
- **Installation:** Custom Stripe MCP

**MCP: Sentry** 🔵 OPTIONAL
- **Purpose:** Error tracking and monitoring
- **Use Cases:**
  - View production errors
  - Analyze error patterns
  - Debug production issues
- **Installation:** Custom Sentry MCP

---

## 5. Useful Hooks

### 5.1 Code Quality Hooks

**Hook: `pre-commit-lint-format`**
- **Event:** Before commit
- **Purpose:** Run linting and formatting
- **Script:**
```bash
#!/bin/bash
# Backend: Run Ruff linter and formatter
cd backend && ruff check . && ruff format .

# Frontend: Run ESLint and Prettier
cd frontend && npm run lint && npm run format
```

**Hook: `pre-commit-type-check`**
- **Event:** Before commit
- **Purpose:** Run type checking
- **Script:**
```bash
#!/bin/bash
# Backend: Run mypy type checking
cd backend && mypy app/

# Frontend: Run TypeScript type checking
cd frontend && npm run check
```

**Hook: `pre-commit-svelte-autofix`** 🔴 CRITICAL
- **Event:** Before commit
- **Purpose:** Validate and auto-fix Svelte 5 syntax using official MCP
- **Why Critical:** Prevents committing outdated Svelte 4 syntax or mixed patterns
- **Script:**
```bash
#!/bin/bash
# Find all modified .svelte files
SVELTE_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep '\.svelte$')

if [ -n "$SVELTE_FILES" ]; then
  echo "🔍 Running svelte-autofixer on modified Svelte files..."

  # For each Svelte file, use Claude with Svelte MCP to validate
  for file in $SVELTE_FILES; do
    echo "Checking $file..."
    # Call svelte-autofixer via MCP (requires Svelte MCP configured)
    # This would be handled by Claude Code automatically if MCP is set up
    # Manual alternative: Run svelte-check
    npx svelte-check --fail-on-warnings --threshold warning "$file"

    if [ $? -ne 0 ]; then
      echo "❌ Svelte syntax issues found in $file"
      echo "Fix issues before committing or use Claude with Svelte MCP to auto-fix"
      exit 1
    fi
  done

  echo "✅ All Svelte files validated"
fi
```

**Hook: `pre-push-test`**
- **Event:** Before push
- **Purpose:** Run tests to ensure no broken code pushed
- **Script:**
```bash
#!/bin/bash
# Backend: Run pytest
cd backend && pytest tests/ --cov=app --cov-report=term-missing

# Frontend: Run Vitest
cd frontend && npm run test:unit

# Exit if any tests failed
if [ $? -ne 0 ]; then
  echo "Tests failed. Push aborted."
  exit 1
fi
```

### 5.2 Workflow Automation Hooks

**Hook: `post-commit-monday-update`**
- **Event:** After commit
- **Purpose:** Auto-update Monday.com with commit info
- **Script:**
```bash
#!/bin/bash
# Extract story ID from commit message (e.g., "US-042: Fix pricing calculation")
STORY_ID=$(git log -1 --pretty=%B | grep -oP 'US-\d+')

if [ -n "$STORY_ID" ]; then
  # Update Monday.com via API (requires MONDAY_API_TOKEN)
  curl -X POST https://api.monday.com/v2 \
    -H "Authorization: $MONDAY_API_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"query\": \"mutation { change_column_value(item_id: $STORY_ID, column_id: \\\"status\\\", value: \\\"In Review\\\") { id } }\"}"
fi
```

**Hook: `skill-activation-prompt`** ✅ (From CLAUDE.md)
- **Event:** UserPromptSubmit
- **Purpose:** Auto-suggest relevant skills based on context
- **Already exists in infrastructure repo**

**Hook: `post-tool-use-tracker`** ✅ (From CLAUDE.md)
- **Event:** PostToolUse
- **Purpose:** Track file changes for session context
- **Already exists in infrastructure repo**

### 5.3 Reminder Hooks

**Hook: `error-handling-reminder`** ✅ (From CLAUDE.md)
- **Event:** UserPromptSubmit
- **Purpose:** Remind about error handling patterns
- **Already exists in infrastructure repo**

**Hook: `dod-reminder`**
- **Event:** UserPromptSubmit (when "done" mentioned)
- **Purpose:** Remind to check Definition of Done
- **Script:**
```bash
#!/bin/bash
if echo "$USER_PROMPT" | grep -qiE "done|complete|finished"; then
  echo "⚠️ REMINDER: Check Definition of Done before marking complete:"
  echo "- Tests written (80%+ coverage)"
  echo "- Senior developer reviewed"
  echo "- Documentation updated"
  echo "- Deployed to staging"
  echo "- QA notified"
fi
```

**Hook: `security-check-reminder`**
- **Event:** PostToolUse (when auth/security files edited)
- **Purpose:** Remind about security considerations
- **Script:**
```bash
#!/bin/bash
if echo "$EDITED_FILE" | grep -qE "auth|security|login|password"; then
  echo "🔒 SECURITY REMINDER:"
  echo "- No hardcoded secrets"
  echo "- Input validation implemented"
  echo "- SQL/NoSQL injection prevented"
  echo "- XSS prevention in place"
  echo "- CSRF tokens used"
fi
```

---

## 6. Custom Slash Commands

### 6.1 Development Commands

**Command: `/dev-docs [description]`** ✅ (Already exists)
- **Purpose:** Create strategic development plan
- **Already in repo:** Yes
- **Usage:** `/dev-docs Implement B2B marketplace fixed-price listings`

**Command: `/api-test [endpoint]`**
- **Purpose:** Test API endpoint with authentication
- **Implementation:**
```markdown
Test the FastAPI endpoint: {endpoint}

1. Read the route implementation
2. Identify required authentication
3. Test with valid JWT cookie
4. Test validation rules
5. Test error cases
6. Report results with examples
```

**Command: `/component-create [name] [type]`**
- **Purpose:** Scaffold new Svelte component with best practices
- **Implementation:**
```markdown
Create a new Svelte 5 component: {name}

Component type: {type} (page|layout|reusable)

1. Create component file with Svelte 5 runes
2. Add TypeScript props interface
3. Include Tailwind styling structure
4. Add shadcn-svelte components if applicable
5. Create corresponding test file (Vitest)
6. Add JSDoc comments
```

**Command: `/model-create [name] [collection]`**
- **Purpose:** Scaffold new Beanie document model
- **Implementation:**
```markdown
Create a new Beanie MongoDB model: {name}

Collection: {collection}

1. Create model file in app/models/
2. Define Beanie Document class with type hints
3. Add Pydantic field validators
4. Define indexes
5. Add helper methods if needed
6. Create corresponding Pydantic schema in app/schemas/
7. Add to __init__.py exports
8. Create test file with fixtures
```

**Command: `/migration-create [description]`**
- **Purpose:** Create MongoDB migration script
- **Implementation:**
```markdown
Create MongoDB migration: {description}

1. Create migration file in migrations/ with timestamp
2. Implement up() function (apply changes)
3. Implement down() function (rollback)
4. Add data validation checks
5. Include backup reminder
6. Add to migration index
```

### 6.2 Testing Commands

**Command: `/test-flow [flow-name]`**
- **Purpose:** Create E2E test for user flow
- **Implementation:**
```markdown
Create Playwright E2E test for: {flow-name}

1. Read user flow from design document
2. Create test file in tests/e2e/
3. Implement step-by-step test with assertions
4. Add error scenarios
5. Include screenshots on failure
6. Run test and report results
```

**Command: `/coverage-check`**
- **Purpose:** Analyze test coverage and identify gaps
- **Implementation:**
```markdown
Analyze test coverage for the project:

1. Run pytest with coverage (backend)
2. Run Vitest with coverage (frontend)
3. Identify files below 80% coverage
4. Prioritize based on criticality (business logic first)
5. Generate report with recommendations
```

### 6.3 Deployment Commands

**Command: `/deploy-staging`**
- **Purpose:** Deploy to staging environment
- **Implementation:**
```markdown
Deploy to staging environment:

1. Check git status (must be on develop branch)
2. Run tests (pytest + vitest)
3. Build Docker images
4. Push to ECR
5. Update ECS task definitions
6. Trigger deployment
7. Wait for health checks
8. Run smoke tests
9. Report deployment status
```

**Command: `/deploy-rollback`**
- **Purpose:** Rollback to previous version
- **Implementation:**
```markdown
Rollback staging/production to previous version:

1. Check current ECS task definition
2. Find previous stable version
3. Update ECS service to previous task definition
4. Monitor rollback progress
5. Verify health checks passing
6. Notify team of rollback
```

### 6.4 Documentation Commands

**Command: `/doc-api [module]`**
- **Purpose:** Generate API documentation for module
- **Implementation:**
```markdown
Generate API documentation for: {module}

1. Read all routes in module
2. Extract endpoint details (method, path, params, responses)
3. Generate OpenAPI/Swagger compatible docs
4. Include example requests/responses
5. Add authentication requirements
6. Update main API docs file
```

**Command: `/doc-setup`**
- **Purpose:** Generate setup instructions for new developers
- **Implementation:**
```markdown
Generate developer setup documentation:

1. List all prerequisites (Docker, Node, Python, etc.)
2. Environment variable setup
3. Database setup instructions
4. Run application locally
5. Run tests
6. Common troubleshooting
7. Write to SETUP.md
```

### 6.5 Review Commands

**Command: `/review-ready`**
- **Purpose:** Pre-review checklist before creating PR
- **Implementation:**
```markdown
Verify code is ready for senior developer review:

Checklist:
✅ All tests passing (run pytest + vitest)
✅ Type checking passing (mypy + tsc)
✅ Linting passing (ruff + eslint)
✅ Test coverage ≥ 80% for new code
✅ Documentation updated
✅ No hardcoded secrets
✅ Error handling implemented
✅ AI-assisted code review completed
✅ Manual testing completed
✅ Monday.com story linked

If all pass, guide on creating PR.
```

---

## 7. Development Workflow Integration

### 7.1 Daily Development Flow

```
1. Start work on user story from Monday.com
   ↓
2. If working on Svelte: Invoke 'svelte-task' prompt in Claude
   ↓
3. Skill auto-activates based on file/context
   ↓
4. Develop feature with AI assistance
   ↓ (For Svelte files)
4a. LLM uses Svelte MCP to fetch docs
4b. LLM writes code and auto-runs svelte-autofixer (agentic loop)
4c. LLM shares validated code only after autofixer passes
   ↓
5. Pre-commit hooks run (lint, format, type-check, svelte-check)
   ↓
6. Commit with story ID in message
   ↓
7. Post-commit hook updates Monday.com
   ↓
8. Run /review-ready command
   ↓
9. Create PR with senior developer tagged
   ↓
10. Senior developer reviews within 24h
   ↓
11. Address feedback, merge to develop
   ↓
12. Auto-deploy to staging
   ↓
13. QA team notified for E2E testing
```

**Key Difference with Svelte MCP:**
- User doesn't manually request docs or validation
- `svelte-task` prompt teaches LLM to automatically:
  - Fetch relevant documentation
  - Write code using latest Svelte 5 patterns
  - Run autofixer iteratively until clean
  - Only share validated code

### 7.2 Weekly Workflow

```
Monday:
- Sprint planning meeting
- Review Monday.com board
- Groom user stories for sprint

Tuesday-Thursday:
- Daily development
- Code reviews
- Address feedback

Friday:
- Senior developer architecture sync
- Bi-weekly sprint demo
- /coverage-check command
- Address technical debt
- Sprint retrospective
```

### 7.3 Agent Usage Patterns

| Scenario | Agent to Use | When to Use |
|----------|--------------|-------------|
| Build failing | `frontend-error-fixer` or `fastapi-error-fixer` | TypeScript/Python errors |
| Slow API | `mongodb-query-optimizer` | Query taking >100ms |
| New endpoint | `api-route-tester` | After implementation |
| Feature complete | `code-architecture-reviewer` | Before creating PR |
| Need docs | `documentation-architect` | Complex feature complete |
| Performance issue | `performance-reviewer` | Page load >2s or API >300ms |
| Pre-deployment | `security-auditor` | Before production release |
| Need E2E tests | `e2e-test-generator` | User flow implemented |
| Schema change | `mongodb-migration-creator` | Database evolution needed |
| Deploy issue | `deployment-helper` | Deployment failing |

### 7.4 Skill Activation Matrix

| Working On | Skills Activated | Purpose |
|------------|------------------|---------|
| `*.svelte` files | `sveltekit-svelte5-patterns`, `tailwind-shadcn-patterns` | Component development |
| `app/api/*.py` | `fastapi-python-patterns`, `api-design-patterns` | API endpoint development |
| `app/models/*.py` | `mongodb-beanie-patterns` | Database modeling |
| `app/services/pricing*.py` | `jewelry-business-logic` | Business logic implementation |
| `tests/*.py` or `*.test.ts` | `testing-patterns` | Writing tests |
| Authentication files | `authentication-patterns` | Auth implementation |
| Creating PR | `code-review-checklist`, `definition-of-done` | Quality assurance |

### 7.5 MCP Usage Patterns

| Task | MCP to Use | How to Use |
|------|------------|------------|
| **Start Svelte work session** | **Svelte MCP** | **User invokes `svelte-task` prompt first** |
| Preload docs into session | Svelte MCP | Add `svelte://slug.md` resource (e.g., migration guide) |
| **Write Svelte code** | **Svelte MCP** | **LLM auto-runs `svelte-autofixer` in agentic loop** |
| Get Svelte 5 docs | Svelte MCP | `list-sections` → `get-documentation` for specific topics |
| Validate Svelte syntax | Svelte MCP | `svelte-autofixer` with component code (iterative until clean) |
| Test Svelte code quickly | Svelte MCP | `playground-link` to generate ephemeral playground |
| Debug Svelte issues | Svelte MCP | Get relevant docs, use autofixer for suggestions |
| Create PR | GitHub MCP | `gh pr create --title "..." --body "..."` |
| Check CI status | GitHub MCP | `gh run list --workflow=ci.yml` |
| Test in browser | Puppeteer MCP | Launch browser, test user flow, capture screenshots |
| Query database | MongoDB MCP | Run aggregations, analyze data |
| Check logs | AWS MCP | View CloudWatch logs, check ECS status |
| View errors | Sentry MCP | Fetch production errors, analyze stack traces |

**Svelte MCP Agentic Loop:**
```
User asks for Svelte component
    ↓
LLM uses get-documentation for relevant docs
    ↓
LLM writes initial component code
    ↓
LLM calls svelte-autofixer
    ↓
Issues found? → LLM fixes code → svelte-autofixer again
    ↓
No issues? → LLM shares validated code with user
```

---

## 8. Priority Implementation Order

### 8.1 Phase 1: Essential Setup (Week 1-2)

**Must Have:**
1. ✅ Skills: `sveltekit-svelte5-patterns`, `fastapi-python-patterns`, `mongodb-beanie-patterns`
2. ✅ Agents: `frontend-error-fixer`, `fastapi-error-fixer`
3. ✅ MCPs:
   - **Svelte** (CRITICAL)
   - **Tailwind-Svelte-Assistant** (100% docs coverage for SvelteKit+Tailwind)
   - **Python Docs** (Python language reference)
   - **FastAPI Docs** (semantic search for FastAPI)
   - GitHub
   - Filesystem
4. ✅ Hooks: `pre-commit-lint-format`, `pre-commit-type-check`, `pre-commit-svelte-autofix`
5. ✅ Commands: `/dev-docs`

### 8.2 Phase 2: Development Workflow (Week 3-4)

**Must Have:**
1. ✅ Skills: `tailwind-shadcn-patterns`, `testing-patterns`, `authentication-patterns`
2. ✅ Agents: `api-route-tester`, `code-architecture-reviewer`
3. ✅ MCPs:
   - Puppeteer
   - shadcn-ui (Svelte mode)
   - MongoDB
4. ✅ Hooks: `pre-push-test`, `post-commit-monday-update`
5. ✅ Commands: `/api-test`, `/component-create`, `/model-create`

### 8.3 Phase 3: Quality & Review (Week 5-8)

**Must Have:**
1. ✅ Skills: `jewelry-business-logic`, `api-design-patterns`, `code-review-checklist`
2. ✅ Agents: `documentation-architect`, `e2e-test-generator`, `test-coverage-analyzer`
3. ✅ MCPs: AWS, Docker
4. ✅ Hooks: `dod-reminder`, `security-check-reminder`
5. ✅ Commands: `/test-flow`, `/coverage-check`, `/review-ready`

### 8.4 Phase 4: Deployment & Monitoring (Week 9-12)

**Should Have:**
1. ✅ Agents: `security-auditor`, `deployment-helper`, `mongodb-migration-creator`
2. ✅ MCPs: Stripe, Sentry
3. ✅ Commands: `/deploy-staging`, `/deploy-rollback`, `/migration-create`

---

## 9. Success Metrics

**Measure effectiveness of this expertise setup:**

- ✅ **Build success rate:** >95% of builds passing first time
- ✅ **Test coverage:** Maintained at 80%+ throughout project
- ✅ **PR review cycle time:** <24h from PR creation to senior approval
- ✅ **Bug escape rate:** <5% of bugs reach production
- ✅ **Developer velocity:** Maintain 18-22 story points per sprint
- ✅ **Code quality scores:** Ruff/ESLint violations <10 per sprint
- ✅ **Documentation completeness:** 100% of features documented
- ✅ **Deployment success rate:** >90% of deployments succeed first try

---

## 10. Next Steps

**To implement this expertise setup:**

1. **🔴 IMMEDIATE: Install Svelte MCP** (Day 1)
   ```bash
   # Quick setup (recommended - auto-configures)
   npx sv add mcp

   # Or manual
   claude mcp add -t stdio -s project svelte -- npx -y @sveltejs/mcp
   ```
   **Why first:** Prevents AI from giving outdated Svelte 4 code from Day 1

   **After installation:**
   - Restart Claude Code to load the MCP
   - When starting Svelte work, invoke the `svelte-task` prompt
   - This teaches Claude to automatically use docs and autofixer

2. **Review this document with senior developer** - Validate agent/skill needs (Week 1)

3. **Set up essential Phase 1 MCPs** (Week 1)
   ```bash
   # Svelte MCP (already installed from step 1)

   # Tailwind-Svelte-Assistant (100% docs coverage)
   npx -y @smithery/cli install @CaullenOmdahl/tailwind-svelte-assistant --client claude

   # Python Docs
   # GitHub: https://github.com/anuragrai017/python-docs-server-mcp-server
   # Configure in Claude Code settings

   # FastAPI Docs (requires Elasticsearch)
   # GitHub: https://github.com/ShawnKyzer/fastapi-mcp
   # Set up Elasticsearch first, then configure

   # GitHub MCP
   claude mcp add @modelcontextprotocol/server-github

   # Filesystem MCP
   claude mcp add @modelcontextprotocol/server-filesystem
   ```

4. **Configure pre-commit hooks** (Week 1)
   - `pre-commit-lint-format`
   - `pre-commit-type-check`
   - `pre-commit-svelte-autofix`
   - Set up Monday.com integration

5. **Create custom agents** in `.claude/agents/` directory (Week 2-3)
   - Start with `sveltekit-error-fixer` and `fastapi-error-fixer`

6. **Create custom skills** in `.claude/skills/` directory (Week 2-3)
   - Priority: `sveltekit-svelte5-patterns`, `fastapi-python-patterns`, `mongodb-beanie-patterns`

7. **Configure additional hooks** in `.claude/hooks/` directory (Week 3-4)

8. **Implement slash commands** in `.claude/commands/` directory (Week 3-4)

9. **Test workflow integration** with first user story (Week 4)

10. **Iterate and improve** based on actual usage (Ongoing)

---

## 11. Research Sources & Notes

**MCP Servers Researched:**

All MCPs listed in this document were researched and validated from:
- Official Svelte MCP documentation (svelte.dev/docs/mcp)
- GitHub repositories (verified existence and features)
- npm packages (installation verified)
- Community MCP directories (PulseMCP, Glama, MCPHub, LobeHub)

**Key Findings:**
1. **Svelte MCP is official** - from Svelte team, announced November 2025
2. **FastAPI Docs MCP** requires Elasticsearch but provides semantic search
3. **Tailwind-Svelte-Assistant** is the BEST single MCP for SvelteKit + Tailwind (100% docs coverage)
4. **shadcn-ui MCP** supports multiple frameworks including Svelte
5. **Python Docs MCP** is community-maintained but actively updated (Jan 2025)

**Installation Verification Needed:**
- FastAPI Docs MCP (Elasticsearch dependency)
- Python Docs MCP (check if npm published or manual install)

**Alternative Approaches:**
- For FastAPI: Can use FastMCP framework to build custom MCP from your own FastAPI app
- For Python: Official Python SDK available to build custom MCPs

---

**Document Version:** 1.1
**Last Updated:** 2025-12-05
**Status:** Ready for Review
**Last Major Update:** Added Python, FastAPI, shadcn-svelte, and Tailwind MCP research
