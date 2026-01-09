# MCP Server Catalog

Complete catalog of available Model Context Protocol servers with installation commands, capabilities, and use cases.

## Table of Contents

1. [Official MCP Servers](#official-mcp-servers)
2. [Community MCP Servers](#community-mcp-servers)
3. [Finding New MCPs](#finding-new-mcps)

---

## Official MCP Servers

Official servers maintained by Anthropic/Model Context Protocol team.

### Filesystem MCP

**Package**: `@modelcontextprotocol/server-filesystem`

**Installation**:
```bash
npx -y @modelcontextprotocol/server-filesystem /path/to/allowed/directory
```

**Configuration**:
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/home/user/documents",
        "/home/user/projects"
      ]
    }
  }
}
```

**Capabilities**:
- Read files from allowed directories
- Write/create new files
- List directory contents
- Search for files
- Get file metadata (size, modified date, etc.)
- Support for multiple allowed directories

**Available Tools**:
- `mcp__filesystem__read_file`
- `mcp__filesystem__write_file`
- `mcp__filesystem__list_directory`
- `mcp__filesystem__search_files`
- `mcp__filesystem__get_file_info`

**Use Cases**:
- Access configuration files outside project
- Read logs from system directories
- Batch file operations
- Backup/restore operations
- Cross-directory file management

**Security**: Restricts access to only specified directories

---

### GitHub MCP

**Package**: `@modelcontextprotocol/server-github`

**Installation**:
```bash
npx -y @modelcontextprotocol/server-github
```

**Configuration**:
```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "ghp_your_personal_access_token"
      }
    }
  }
}
```

**Capabilities**:
- Create, read, update, close issues
- List issues with filters
- Create and manage pull requests
- Search repositories
- Manage branches
- Repository operations
- Comment on issues/PRs

**Available Tools**:
- `mcp__github__create_issue`
- `mcp__github__list_issues`
- `mcp__github__update_issue`
- `mcp__github__create_pull_request`
- `mcp__github__list_pull_requests`
- `mcp__github__search_repositories`
- `mcp__github__get_repository`

**Use Cases**:
- Automated issue creation from errors
- PR management and review
- Repository analysis
- Project management automation
- Issue tracking integration

**Requirements**:
- GitHub Personal Access Token
- Token scopes: `repo`, `read:org` (minimum)

---

### Git MCP

**Package**: `@modelcontextprotocol/server-git`

**Installation**:
```bash
npx -y @modelcontextprotocol/server-git
```

**Configuration**:
```json
{
  "mcpServers": {
    "git": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-git"]
    }
  }
}
```

**Capabilities**:
- Advanced git operations
- Commit history analysis
- Branch management
- Diff operations
- Repository statistics
- Blame/history tracking

**Available Tools**:
- `mcp__git__log`
- `mcp__git__diff`
- `mcp__git__show`
- `mcp__git__blame`
- `mcp__git__status`
- `mcp__git__branch_operations`

**Use Cases**:
- Analyze commit history
- Find when bugs were introduced
- Track code evolution
- Generate changelogs
- Code archaeology

---

### PostgreSQL MCP

**Package**: `@modelcontextprotocol/server-postgres`

**Installation**:
```bash
npx -y @modelcontextprotocol/server-postgres
```

**Configuration**:
```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "postgresql://user:password@localhost:5432/database"
      }
    }
  }
}
```

**Capabilities**:
- Execute SQL queries
- Schema inspection
- Table/column metadata
- Query results as structured data
- Support for parameterized queries
- Transaction support

**Available Tools**:
- `mcp__postgres__query`
- `mcp__postgres__list_tables`
- `mcp__postgres__describe_table`
- `mcp__postgres__get_schema`

**Use Cases**:
- Direct database queries for analysis
- Schema inspection
- Data validation
- Report generation
- Database exploration

**Security**: Use read-only credentials when possible

---

### SQLite MCP

**Package**: `@modelcontextprotocol/server-sqlite`

**Installation**:
```bash
npx -y @modelcontextprotocol/server-sqlite /path/to/database.db
```

**Configuration**:
```json
{
  "mcpServers": {
    "sqlite": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-sqlite",
        "/path/to/database.db"
      ]
    }
  }
}
```

**Capabilities**:
- Query SQLite databases
- Schema inspection
- Table operations
- Data manipulation

**Available Tools**:
- `mcp__sqlite__query`
- `mcp__sqlite__list_tables`
- `mcp__sqlite__describe_table`

**Use Cases**:
- Local database queries
- Application database inspection
- Simple data storage
- Testing database operations

---

### Puppeteer MCP

**Package**: `@modelcontextprotocol/server-puppeteer`

**Installation**:
```bash
npx -y @modelcontextprotocol/server-puppeteer
```

**Configuration**:
```json
{
  "mcpServers": {
    "puppeteer": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-puppeteer"]
    }
  }
}
```

**Capabilities**:
- Navigate to URLs
- Execute JavaScript in browser context
- Take screenshots
- Extract page content
- Interact with web elements
- Handle dynamic content
- Wait for page loads

**Available Tools**:
- `mcp__puppeteer__navigate`
- `mcp__puppeteer__screenshot`
- `mcp__puppeteer__execute_script`
- `mcp__puppeteer__get_content`
- `mcp__puppeteer__click`
- `mcp__puppeteer__type`

**Use Cases**:
- Web scraping
- Screenshot generation
- Automated testing
- Dynamic content extraction
- Browser automation

**Requirements**: Chromium/Chrome browser

---

### Fetch MCP

**Package**: `@modelcontextprotocol/server-fetch`

**Installation**:
```bash
npx -y @modelcontextprotocol/server-fetch
```

**Configuration**:
```json
{
  "mcpServers": {
    "fetch": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-fetch"]
    }
  }
}
```

**Capabilities**:
- HTTP GET/POST/PUT/DELETE/PATCH requests
- Custom headers
- Authentication (Basic, Bearer, API keys)
- Response parsing (JSON, text, binary)
- File downloads
- Form data submission

**Available Tools**:
- `mcp__fetch__get`
- `mcp__fetch__post`
- `mcp__fetch__put`
- `mcp__fetch__delete`
- `mcp__fetch__patch`

**Use Cases**:
- REST API interactions
- Web content fetching
- API testing
- Webhook calls
- Download files from web

---

## Community MCP Servers

Community-built MCP servers (verify before use).

### Slack MCP

**Package**: Various community implementations

**Capabilities**:
- Send messages to channels
- Read channel history
- Manage conversations
- Upload files

**Use Cases**:
- Slack notifications
- Channel management
- Message automation

### Discord MCP

**Capabilities**:
- Send messages
- Manage servers
- Bot operations

**Use Cases**:
- Discord bot automation
- Server management
- Notifications

### AWS MCP

**Capabilities**:
- S3 operations
- EC2 management
- Lambda functions
- CloudWatch logs

**Use Cases**:
- Cloud resource management
- Deployment automation
- Log analysis

### Google Drive MCP

**Capabilities**:
- File upload/download
- Folder management
- Sharing permissions
- Search files

**Use Cases**:
- Document management
- File backup
- Collaboration automation

---

## Finding New MCPs

### Search npm Registry

```bash
npm search @modelcontextprotocol
```

### Search GitHub

```
site:github.com "model context protocol" server
```

### Official MCP Registry

Check official MCP documentation for registry/marketplace (if available).

### Community Resources

- GitHub Topics: `model-context-protocol`
- npm packages: `@modelcontextprotocol/*`
- Community forums and discussions

### Verification Before Use

When using community MCPs:
- ✅ Check source code
- ✅ Verify maintainer reputation
- ✅ Check recent updates
- ✅ Read security implications
- ✅ Test in isolated environment first

---

## Quick Comparison Table

| MCP Server | Use Case | Auth Required | Complexity |
|------------|----------|---------------|------------|
| Filesystem | File operations | No | Low |
| GitHub | Repository management | Yes (token) | Medium |
| Git | Git operations | No | Low |
| PostgreSQL | Database queries | Yes (connection) | Medium |
| SQLite | Local database | No | Low |
| Puppeteer | Web scraping | No | Medium |
| Fetch | HTTP requests | Optional | Low |

---

## Installation Priority

**Start with these (most useful):**
1. Filesystem - Universal file access
2. Git - Repository operations
3. Fetch - HTTP requests

**Add as needed:**
4. GitHub - If using GitHub heavily
5. PostgreSQL/SQLite - If querying databases
6. Puppeteer - If web scraping needed

**Specialized:**
7. Community MCPs - For specific integrations
