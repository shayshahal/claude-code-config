---
name: mcp-expert
description: Model Context Protocol (MCP) expertise including discovery, installation, configuration, and usage of MCP servers. Use when working with MCP, installing MCP servers, filesystem operations, GitHub integration, database queries, web scraping, or when external tool integration would benefit the task. Includes proactive suggestions for when to use specific MCPs.
---

# MCP Expert

## Purpose

Expert guidance on Model Context Protocol (MCP) servers - how to discover, install, configure, and use them to extend Claude Code's capabilities with external tools and integrations.

## When to Use This Skill

**Automatically activates when:**
- User mentions MCP, Model Context Protocol, or MCP servers
- Task involves filesystem operations (→ suggest filesystem MCP)
- Task involves GitHub operations (→ suggest GitHub MCP)
- Task involves database queries (→ suggest database MCP)
- Task involves web scraping (→ suggest puppeteer/fetch MCP)
- Installing or configuring Claude Code integrations
- Working with `.claude/settings.json` MCP configuration

**Be proactive:** Suggest relevant MCPs when detecting tasks that would benefit from them, even if user doesn't mention MCP.

---

## What is MCP?

**Model Context Protocol (MCP)** is an open protocol that enables Claude Code to connect to external tools and data sources through standardized servers.

**Key concepts:**
- **MCP Server**: A program that exposes tools/resources to Claude
- **MCP Client**: Claude Code acts as the client
- **Tools**: Functions the MCP server provides (like file operations, API calls)
- **Resources**: Data sources the MCP server can access

**Benefits:**
- Extend Claude's capabilities beyond built-in tools
- Access external systems (databases, APIs, filesystems)
- Standardized way to integrate new functionality
- Community-built servers for common use cases

---

## Common MCP Servers

### 1. Filesystem MCP
**Package**: `@modelcontextprotocol/server-filesystem`

**When to suggest:**
- Reading/writing files outside project directory
- Batch file operations
- Complex file system navigation
- File search across multiple directories

**Capabilities:**
- Read files from any accessible path
- Write/create files
- List directory contents
- Search for files
- Get file metadata

**Use cases:**
- "List all files in /home/user/documents"
- "Read configuration from /etc/config.json"
- "Copy files from /tmp to /backup"

### 2. GitHub MCP
**Package**: `@modelcontextprotocol/server-github`

**When to suggest:**
- Interacting with GitHub repositories
- Creating/managing issues
- Pull request operations
- Repository management
- GitHub API interactions

**Capabilities:**
- Create/read/update issues
- Manage pull requests
- Repository operations
- Search repositories
- Manage branches

**Use cases:**
- "Create a GitHub issue for this bug"
- "List all open PRs in the repository"
- "Search for issues labeled 'bug'"

### 3. Git MCP
**Package**: `@modelcontextprotocol/server-git`

**When to suggest:**
- Complex git operations
- Repository history analysis
- Branch management
- Commit operations

**Capabilities:**
- Advanced git commands
- Repository analysis
- Commit history
- Branch operations
- Diff operations

**Use cases:**
- "Show commits from the last week"
- "Analyze git history for changes to auth system"
- "Create a new branch and switch to it"

### 4. PostgreSQL MCP
**Package**: `@modelcontextprotocol/server-postgres`

**When to suggest:**
- Direct database queries
- Schema inspection
- Database migrations
- Data analysis

**Capabilities:**
- Execute SQL queries
- Schema inspection
- Table/column metadata
- Query results as structured data

**Use cases:**
- "Query the users table for active users"
- "Show me the schema for the orders table"
- "Count total records in the database"

### 5. Puppeteer MCP
**Package**: `@modelcontextprotocol/server-puppeteer`

**When to suggest:**
- Web scraping
- Browser automation
- Screenshot capture
- Dynamic web content extraction

**Capabilities:**
- Navigate to URLs
- Execute JavaScript in browser
- Take screenshots
- Extract page content
- Interact with web elements

**Use cases:**
- "Scrape product data from this e-commerce site"
- "Take a screenshot of this webpage"
- "Extract all links from this page"

### 6. Fetch MCP
**Package**: `@modelcontextprotocol/server-fetch`

**When to suggest:**
- HTTP API calls
- Fetching web content
- REST API interactions
- Downloading web resources

**Capabilities:**
- HTTP GET/POST/PUT/DELETE requests
- Headers and authentication
- Response parsing
- Binary data handling

**Use cases:**
- "Fetch data from this REST API"
- "Download this JSON file"
- "POST data to this webhook"

### 7. SQLite MCP
**Package**: `@modelcontextprotocol/server-sqlite`

**When to suggest:**
- Working with SQLite databases
- Local database queries
- Simple data storage

**Capabilities:**
- Query SQLite databases
- Schema inspection
- Data manipulation

**Use cases:**
- "Query my local SQLite database"
- "Show tables in this .db file"

---

## Installation Pattern

### Step 1: Check if MCP Already Installed

```bash
# Check settings.json for existing MCP configurations
cat .claude/settings.json | grep -A5 "mcpServers"
```

### Step 2: Install MCP Server

**For npm-based MCPs:**
```bash
npx -y @modelcontextprotocol/server-filesystem /path/to/allowed/directory
```

**The `npx` command:**
- Downloads and runs the MCP server
- `-y` flag: Auto-confirms installation
- MCP name: Package to run
- Arguments: Server-specific configuration

### Step 3: Configure in settings.json

Add to `.claude/settings.json` under `mcpServers`:

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/home/user/allowed-directory"
      ]
    }
  }
}
```

### Step 4: Restart or Reload

**Important:** MCP servers require Claude Code restart/reload to activate:
- New MCPs won't be available until restart
- Tell user to restart Claude Code
- Or check if hot-reload is supported

### Step 5: Verify Installation

```bash
# Check if MCP tools are available
# They will appear with mcp__ prefix
# Example: mcp__filesystem__read_file
```

---

## Configuration Patterns

### Multiple MCPs

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/home/user"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "ghp_your_token_here"
      }
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "postgresql://user:pass@localhost/db"
      }
    }
  }
}
```

### Environment Variables

Some MCPs require authentication:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "ghp_..."
      }
    }
  }
}
```

**Security note:** Use environment variables or config files for secrets, not hardcoded values.

### Path Restrictions (Filesystem MCP)

Restrict filesystem access to specific directories:

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/home/user/projects",
        "/home/user/documents"
      ]
    }
  }
}
```

---

## Usage Patterns

### Calling MCP Tools

MCP tools appear with `mcp__` prefix:

```typescript
// Filesystem MCP
mcp__filesystem__read_file("/path/to/file.txt")
mcp__filesystem__write_file("/path/to/file.txt", "content")
mcp__filesystem__list_directory("/path/to/dir")

// GitHub MCP
mcp__github__create_issue("repo", "title", "body")
mcp__github__list_issues("repo")

// Database MCP
mcp__postgres__query("SELECT * FROM users WHERE active = true")
```

### When to Use MCP vs Built-in Tools

**Use built-in tools when:**
- Working within current project directory
- Standard operations (Read, Write, Edit, Bash)
- No external authentication needed

**Use MCP when:**
- Need access outside project directory
- Specialized operations (browser automation, database queries)
- External service integration (GitHub, APIs)
- Built-in tools insufficient

**Example:**
```typescript
// Within project: Use Read
Read("src/components/App.tsx")

// Outside project: Use filesystem MCP
mcp__filesystem__read_file("/etc/config.json")

// Git operations: Can use Bash
Bash("git log --oneline -10")

// Complex git analysis: Use git MCP
mcp__git__analyze_commit_history("--since='1 week ago'")
```

---

## Proactive Suggestion Patterns

### When User Mentions Filesystem Operations

**Triggers:**
- "list files in /home/..."
- "read configuration from /etc/..."
- "access files outside the project"

**Response pattern:**
```markdown
I can help with that. For filesystem operations outside the project directory,
I recommend installing the Filesystem MCP server.

Let me install it for you:
[Install and configure filesystem MCP]

Once installed (requires restart), I'll be able to access those files.
```

### When User Mentions GitHub Operations

**Triggers:**
- "create a GitHub issue"
- "list pull requests"
- "interact with repository"

**Response pattern:**
```markdown
I can install the GitHub MCP server to interact with GitHub directly.

You'll need:
1. A GitHub personal access token
2. Claude Code restart after installation

Would you like me to set this up?
```

### When User Mentions Database Queries

**Triggers:**
- "query the database"
- "check the users table"
- "run this SQL"

**Response pattern:**
```markdown
I can install the PostgreSQL MCP server for direct database access.

I'll need:
1. Your database connection string
2. Claude Code restart after setup

Shall I configure this?
```

---

## Discovering New MCPs

### When User Needs MCP Not Listed Here

**Approach:**
1. Search npm registry: `npm search @modelcontextprotocol`
2. Check official MCP registry/documentation
3. Search GitHub: "model context protocol server [use-case]"
4. Use web-research-specialist agent if needed

**Example:**
```
User: "I need to interact with Slack"

Your response:
"Let me search for a Slack MCP server..."

[Use WebSearch or web-research-specialist agent]
WebSearch("Slack MCP server model context protocol")

"I found @modelcontextprotocol/server-slack. Let me install it..."
```

---

## Troubleshooting

### MCP Tools Not Available After Installation

**Problem:** Installed MCP but tools don't appear

**Solutions:**
1. **Restart Claude Code** - MCPs load on startup
2. Check settings.json syntax (valid JSON)
3. Verify command path is correct
4. Check MCP server logs

### Permission Errors (Filesystem MCP)

**Problem:** "Access denied" when accessing files

**Solutions:**
1. Check allowed directories in config
2. Verify file permissions
3. Add directory to allowed paths
4. Use absolute paths, not relative

### Authentication Errors (GitHub, Database MCPs)

**Problem:** "Unauthorized" or "Authentication failed"

**Solutions:**
1. Verify token/credentials in env vars
2. Check token has required scopes/permissions
3. Ensure credentials not expired
4. Test connection outside Claude Code

### MCP Server Crashes

**Problem:** MCP tools error with "server not responding"

**Solutions:**
1. Check MCP server logs
2. Verify dependencies installed (node, database client, etc.)
3. Test MCP server standalone
4. Reinstall MCP package

---

## Reference Files

For detailed information, see:

### [MCP_SERVER_CATALOG.md](resources/MCP_SERVER_CATALOG.md)
Complete catalog of available MCP servers:
- Official MCP servers
- Community MCP servers
- Installation commands
- Configuration examples
- Use case descriptions

### [MCP_INSTALLATION_GUIDE.md](resources/MCP_INSTALLATION_GUIDE.md)
Step-by-step installation guide:
- Prerequisites
- Installation methods
- Configuration patterns
- Testing installations
- Common issues

### [MCP_USAGE_EXAMPLES.md](resources/MCP_USAGE_EXAMPLES.md)
Practical usage examples:
- Real-world scenarios
- Code examples
- Best practices
- Performance tips

---

## Quick Reference

### Installation Template

```bash
# 1. Identify MCP needed
# 2. Install with npx
npx -y @modelcontextprotocol/server-[NAME] [ARGS]

# 3. Add to settings.json
# Edit .claude/settings.json
{
  "mcpServers": {
    "[name]": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-[NAME]", "[ARGS]"]
    }
  }
}

# 4. Restart Claude Code
# Tell user to restart
```

### Common MCPs Quick List

- **Filesystem**: `@modelcontextprotocol/server-filesystem`
- **GitHub**: `@modelcontextprotocol/server-github`
- **Git**: `@modelcontextprotocol/server-git`
- **PostgreSQL**: `@modelcontextprotocol/server-postgres`
- **SQLite**: `@modelcontextprotocol/server-sqlite`
- **Fetch**: `@modelcontextprotocol/server-fetch`
- **Puppeteer**: `@modelcontextprotocol/server-puppeteer`

### MCP Tool Naming Pattern

All MCP tools follow this pattern:
```
mcp__[server-name]__[tool-name]
```

Examples:
- `mcp__filesystem__read_file`
- `mcp__github__create_issue`
- `mcp__postgres__query`

---

## Best Practices

### 1. Be Proactive
✅ Suggest MCPs when they would help, even if user doesn't ask
✅ Explain why MCP would be beneficial
✅ Offer to install automatically

### 2. Security First
✅ Use environment variables for secrets
✅ Restrict filesystem access to needed directories
✅ Verify token permissions match requirements
✅ Warn about security implications

### 3. User Experience
✅ Explain MCP requires restart
✅ Test MCP after installation
✅ Provide clear instructions
✅ Handle errors gracefully

### 4. Right Tool for Job
✅ Use built-in tools when possible
✅ Use MCPs for specialized operations
✅ Don't over-install MCPs unnecessarily
✅ Combine MCPs with built-in tools effectively

---

**Skill Status**: READY FOR USE ✅
**Line Count**: ~490 (within 500-line limit) ✅
**Progressive Disclosure**: Reference files for detailed catalogs ✅
