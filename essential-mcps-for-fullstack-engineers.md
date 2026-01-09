# Essential MCPs for Full-Stack Engineers

A comprehensive guide to Model Context Protocol (MCP) servers that enhance AI-assisted development workflows.

**Last Updated**: 2025-01-03

---

## Table of Contents

- [What is MCP?](#what-is-mcp)
- [Official Anthropic Reference Servers](#official-anthropic-reference-servers)
- [Git & Version Control](#git--version-control)
- [Browser Automation & Testing](#browser-automation--testing)
- [Testing & QA](#testing--qa)
- [Database & Data](#database--data)
- [Code Analysis & Review](#code-analysis--review)
- [Documentation & Search](#documentation--search)
- [Enterprise Integrations](#enterprise-integrations)
- [Recommended Setup](#recommended-setup)
- [Installation Guide](#installation-guide)
- [Resources](#resources)

---

## What is MCP?

The **Model Context Protocol (MCP)** is an open standard introduced by Anthropic in November 2024 to standardize how AI systems like LLMs integrate with external tools, systems, and data sources.

**Key Features:**
- Universal interface for reading files, executing functions, and handling contextual prompts
- Official SDKs in Python, TypeScript, C#, Java, Go, and Rust
- Adopted by OpenAI (March 2025) and Google DeepMind (April 2025)
- 6360+ community servers available

---

## 📦 Official Anthropic Reference Servers

### 1. Git MCP
**Package**: `@modelcontextprotocol/server-git`

**Description**: Tools to read, search, and manipulate Git repositories

**Use Cases**:
- Read repository structure and files
- Search code and commits
- Analyze Git history
- Repository manipulation

**Installation**:
```bash
npx @modelcontextprotocol/server-git
```

---

### 2. Memory MCP
**Package**: `@modelcontextprotocol/server-memory`

**Description**: Knowledge graph-based persistent memory system

**Use Cases**:
- Remember information across conversations
- Store entities, relations, and observations
- Context persistence across sessions
- Build knowledge graphs about your codebase

**Key Components**:
- **Entities**: Primary nodes in knowledge graph
- **Relations**: Directed connections between entities
- **Observations**: Discrete pieces of information about entities

**Installation**:
```bash
npx @modelcontextprotocol/server-memory
```

---

### 3. Filesystem MCP
**Package**: `@modelcontextprotocol/server-filesystem`

**Description**: Secure file operations with configurable access controls

**Use Cases**:
- Read/write files safely
- Directory operations
- File search and manipulation

**Installation**:
```bash
npx @modelcontextprotocol/server-filesystem /path/to/allowed/directory
```

**Security**: Requires explicit directory allowlist for safety

---

### 4. Fetch MCP
**Package**: `@modelcontextprotocol/server-fetch`

**Description**: Web content fetching and conversion for efficient LLM usage

**Use Cases**:
- Fetch documentation
- Browse web content
- Research APIs and libraries
- Convert web pages to LLM-friendly format

**Installation**:
```bash
npx @modelcontextprotocol/server-fetch
```

---

### 5. Sequential Thinking MCP
**Package**: `@modelcontextprotocol/server-sequential-thinking`

**Description**: Dynamic and reflective problem-solving through thought sequences

**Use Cases**:
- Complex debugging
- Architecture planning
- Step-by-step code analysis
- Multi-step problem solving

**Installation**:
```bash
npx @modelcontextprotocol/server-sequential-thinking
```

---

### 6. Time MCP
**Package**: `@modelcontextprotocol/server-time`

**Description**: Time and timezone conversion capabilities

**Use Cases**:
- Timezone conversions
- Timestamp parsing
- Date calculations

**Installation**:
```bash
npx @modelcontextprotocol/server-time
```

---

### 7. Everything MCP
**Package**: `@modelcontextprotocol/server-everything`

**Description**: Reference/test server with prompts, resources, and tools

**Use Cases**:
- Testing MCP features
- Learning MCP capabilities
- Reference implementation

**Installation**:
```bash
npx @modelcontextprotocol/server-everything
```

---

## 🔧 Git & Version Control

### 8. GitHub Official MCP
**Repository**: `github/github-mcp-server`

**Description**: Official GitHub MCP server with full platform integration

**Key Capabilities**:
- **Repository Management**: Browse code, search files, analyze commits, understand project structure
- **Issue & PR Automation**: Create, update, and manage issues and pull requests
- **CI/CD Intelligence**: Monitor GitHub Actions, analyze build failures, manage releases
- **Code Review**: Automated PR review and triage

**Features**:
- Natural language interaction with GitHub
- Access to all repositories you have permissions for
- Workflow automation
- Build failure analysis

**Why Essential**: Direct GitHub integration eliminates context switching between AI assistant and GitHub web UI

**Setup**: Clone repository and follow installation instructions
```bash
git clone https://github.com/github/github-mcp-server.git
cd github-mcp-server
npm install
```

---

### 9. Git MCP Server (Advanced)
**Repository**: `cyanheads/git-mcp-server`

**Description**: Comprehensive Git operations via MCP with STDIO & HTTP support

**Features**:
- **Basic Operations**: clone, commit, branch, diff, log, status
- **Advanced Operations**: push, pull, merge, rebase
- **Worktree Management**: Create and manage worktrees
- **Tag Management**: Create, list, delete tags
- **Both Protocols**: STDIO and HTTP support

**Why Essential**: Complete Git workflow automation for complex repository operations

**Installation**: Available on npm or from source

---

### 10. GitMCP
**Website**: https://gitmcp.io/

**Description**: Creates dedicated MCP server for any GitHub project

**Features**:
- Project-specific context
- Code understanding in context
- Automatic repository analysis

**Why Essential**: Deep project-specific AI assistance

---

## 🌐 Browser Automation & Testing

### 11. Microsoft Playwright MCP (Official)
**Repository**: `microsoft/playwright-mcp`

**Description**: Official Playwright browser automation for LLMs

**Key Innovation**: Uses accessibility tree rather than screenshots/pixels

**Features**:
- Structured accessibility snapshots (no vision model needed)
- Persistent profile support (use like regular browser)
- Isolated contexts for testing sessions
- Connect to existing browsers via extension
- Pure structured data operation

**Why Essential**:
- Industry-standard browser automation
- Accessibility-first approach
- No need for vision models
- Official Microsoft support

**Use Cases**:
- Automated testing
- Web scraping
- Form filling
- Multi-step workflows

**Installation**: Follow Microsoft's official documentation

---

### 12. Puppeteer MCP Servers

Multiple community implementations available:

#### Python/Playwright Version
**Repository**: `twolven/mcp-server-puppeteer-py`

**Features**:
- Python-based Playwright integration
- Browser automation
- Screenshot capture
- JavaScript execution in real browser

#### Execute Automation Version
**Repository**: `executeautomation/mcp-playwright`

**Features**:
- Compatible with Claude Desktop, Cline, Cursor IDE
- Browser and API automation
- Full Playwright capabilities

**Common Capabilities**:
- Navigate web pages
- Take screenshots
- Fill forms
- Execute JavaScript
- Web scraping dynamic content
- Test automation

**Why Essential**: Alternative to Microsoft's official server with different feature sets

---

## 🧪 Testing & QA

### 13. BrowserStack MCP

**Description**: Access BrowserStack's professional testing platform

**Features**:
- Debug tests across browsers
- Write and fix tests
- Accessibility testing
- Cross-browser compatibility testing
- Real device testing

**Why Essential**: Professional testing infrastructure without manual browser testing

**Use Cases**:
- Multi-browser testing
- Mobile device testing
- Automated QA workflows
- Accessibility compliance

---

### 14. QA Sphere MCP

**Description**: Integration with QA Sphere test management system

**Features**:
- Discover test cases
- Summarize test coverage
- Interact with test cases from AI IDEs
- Test case management

**Why Essential**: Organized test management directly from AI assistant

---

## 💾 Database & Data

### 15. Postgres MCP
**Package**: Official Anthropic server

**Description**: PostgreSQL database integration

**Features**:
- Query databases
- Schema exploration
- Data analysis
- Database operations via natural language

**Use Cases**:
- Database debugging
- Query optimization
- Schema analysis
- Data exploration

---

### 16. Neo4j MCP
**Repository**: `mcp-neo4j-memory`

**Description**: Neo4j graph database integration with knowledge graph capabilities

**Features**:
- Store entities and relationships
- Search and retrieve subgraphs
- Knowledge graph persistence
- Complex relationship queries

**Why Essential**: Advanced knowledge graph capabilities for complex data relationships

**Use Cases**:
- Knowledge management
- Relationship tracking
- Context persistence across sessions
- Complex data modeling

---

## 📚 Documentation & Search

### 17. Brave Search MCP

**Description**: Web and local search using Brave's Search API

**Features**:
- Search the web
- Find technical documentation
- Research libraries and tools
- Privacy-focused search

**Why Essential**: Quick access to technical documentation and resources

---

## 🛠️ Enterprise Integrations

### 18. Slack MCP

**Description**: Slack workspace integration

**Features**:
- Send messages
- Read channels
- Manage workflows
- Team communication automation

**Use Cases**:
- Automated notifications
- Incident management
- Team updates

---

### 19. Google Drive MCP

**Description**: Google Drive file operations

**Features**:
- Document management
- File sharing
- Collaboration workflows

**Use Cases**:
- Documentation management
- Shared resource access

---

### 20. AWS Knowledge Base Retrieval MCP

**Description**: Retrieval from AWS Knowledge Base using Bedrock Agent Runtime

**Features**:
- Access AWS documentation
- Query knowledge bases
- Enterprise knowledge management

---

## 🚀 Recommended Setup

### Tier 1: Core Stack (Must-Have)

Essential for all full-stack engineers:

1. **GitHub MCP** - Repository management, PRs, issues, CI/CD
2. **Git MCP** (Advanced) - Local Git operations, worktrees, complex workflows
3. **Memory MCP** - Context persistence across sessions, knowledge graphs
4. **Filesystem MCP** - Safe file operations, directory management
5. **Playwright/Puppeteer MCP** - Browser testing & automation

**Why These?**: Cover the complete development lifecycle from code to deployment

---

### Tier 2: Extended Stack (Highly Recommended)

Enhance productivity significantly:

6. **Fetch MCP** - Documentation browsing, web research
7. **Postgres MCP** - Database operations (if using PostgreSQL)
8. **Sequential Thinking MCP** - Complex problem solving, debugging
9. **BrowserStack MCP** - Professional cross-browser testing
10. **Git MCP** (Official) - Basic Git operations

**When to Add**: Once comfortable with core stack

---

### Tier 3: Specialized (Based on Stack)

Add based on specific needs:

11. **Slack/Google Drive MCPs** - If using these in workflow
12. **Neo4j MCP** - If need advanced knowledge graphs
13. **QA Sphere MCP** - If need test management system
14. **Brave Search MCP** - For privacy-focused web search
15. **AWS KB MCP** - If using AWS infrastructure

**When to Add**: Project-specific requirements

---

## 📝 Installation Guide

### Official Anthropic Servers

Most official servers can be installed via npm/npx:

```bash
# Git operations
npx @modelcontextprotocol/server-git

# Persistent memory
npx @modelcontextprotocol/server-memory

# File operations (requires directory path)
npx @modelcontextprotocol/server-filesystem /path/to/allowed/directory

# Web content fetching
npx @modelcontextprotocol/server-fetch

# Problem solving
npx @modelcontextprotocol/server-sequential-thinking

# Time operations
npx @modelcontextprotocol/server-time

# Reference server
npx @modelcontextprotocol/server-everything
```

---

### Third-Party Servers

#### GitHub MCP
```bash
git clone https://github.com/github/github-mcp-server.git
cd github-mcp-server
npm install
# Follow repository-specific setup instructions
```

#### Microsoft Playwright MCP
```bash
git clone https://github.com/microsoft/playwright-mcp.git
cd playwright-mcp
npm install
# Follow repository-specific setup instructions
```

#### Advanced Git MCP
```bash
git clone https://github.com/cyanheads/git-mcp-server.git
cd git-mcp-server
npm install
# Follow repository-specific setup instructions
```

---

### Configuration in Claude Desktop

Add to your Claude Desktop configuration file (typically `~/Library/Application Support/Claude/claude_desktop_config.json` on macOS):

```json
{
  "mcpServers": {
    "git": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-git"]
    },
    "memory": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-memory"]
    },
    "filesystem": {
      "command": "npx",
      "args": [
        "@modelcontextprotocol/server-filesystem",
        "/path/to/your/projects"
      ]
    },
    "fetch": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-fetch"]
    }
  }
}
```

---

## 🔗 Resources

### Official Documentation
- **MCP Official Site**: https://modelcontextprotocol.io/
- **Anthropic MCP Announcement**: https://www.anthropic.com/news/model-context-protocol
- **Official Servers Repository**: https://github.com/modelcontextprotocol/servers
- **Claude MCP Documentation**: https://docs.claude.com/en/docs/agents-and-tools/remote-mcp-servers

### Community Resources
- **Awesome MCP Servers** (punkpeye): https://github.com/punkpeye/awesome-mcp-servers
- **Awesome MCP Servers** (appcypher): https://github.com/appcypher/awesome-mcp-servers
- **MCP Server Directory** (PulseMCP): https://www.pulsemcp.com/servers (6360+ servers)
- **MCP Server Finder**: https://www.mcpserverfinder.com/
- **GitMCP**: https://gitmcp.io/

### GitHub Repositories
- **GitHub Official MCP**: https://github.com/github/github-mcp-server
- **Microsoft Playwright MCP**: https://github.com/microsoft/playwright-mcp
- **Advanced Git MCP**: https://github.com/cyanheads/git-mcp-server
- **Puppeteer Python MCP**: https://github.com/twolven/mcp-server-puppeteer-py
- **Execute Automation Playwright**: https://github.com/executeautomation/mcp-playwright

### Guides and Tutorials
- **GitHub MCP Guide**: https://github.blog/ai-and-ml/generative-ai/a-practical-guide-on-how-to-use-the-github-mcp-server/
- **MCP Complete Guide 2025**: https://www.keywordsai.co/blog/introduction-to-mcp
- **Best MCP Servers 2025**: https://www.pomerium.com/blog/best-model-context-protocol-mcp-servers-in-2025

---

## 🎯 Use Case Matrix

| Task | Recommended MCPs |
|------|-----------------|
| **Code Management** | GitHub MCP, Git MCP, Filesystem MCP |
| **Testing** | Playwright MCP, Puppeteer MCP, BrowserStack MCP |
| **Context Persistence** | Memory MCP, Neo4j MCP |
| **Documentation** | Fetch MCP, Brave Search MCP |
| **Database Work** | Postgres MCP, Neo4j MCP |
| **Problem Solving** | Sequential Thinking MCP, Memory MCP |
| **Team Collaboration** | Slack MCP, GitHub MCP, Google Drive MCP |
| **Browser Automation** | Playwright MCP, Puppeteer MCP |
| **CI/CD** | GitHub MCP (Actions integration) |
| **Knowledge Management** | Memory MCP, Neo4j MCP, AWS KB MCP |

---

## 📊 Quick Comparison

### Browser Automation: Playwright vs Puppeteer

| Feature | Microsoft Playwright MCP | Puppeteer MCP |
|---------|-------------------------|---------------|
| **Approach** | Accessibility tree | Traditional automation |
| **Vision Model** | Not needed | Optional |
| **Official Support** | Microsoft official | Community |
| **Data Type** | Structured | Mixed |
| **Use Case** | Modern, accessible testing | General automation |

### Git: Official vs Advanced

| Feature | Official Git MCP | Advanced Git MCP |
|---------|-----------------|------------------|
| **Operations** | Basic Git ops | Comprehensive |
| **Worktrees** | Limited | Full support |
| **Protocol** | STDIO | STDIO + HTTP |
| **Complexity** | Simple | Advanced |
| **Best For** | Most users | Power users |

---

## 🔐 Security Considerations

### Best Practices

1. **Filesystem Access**: Always specify explicit directory allowlists
2. **API Keys**: Store credentials securely, never in config files
3. **Repository Access**: Use least privilege principle for GitHub/Git MCPs
4. **Network Access**: Understand which MCPs require internet access
5. **Data Privacy**: Be aware of what data is sent to MCP servers

### Sensitive Data

- Memory MCP stores locally by default (knowledge graph on disk)
- GitHub MCP requires GitHub authentication token
- Browser automation MCPs may capture sensitive information in screenshots

---

## 🚦 Getting Started Guide

### Step 1: Install Core MCPs
Start with the essential four:
```bash
npx @modelcontextprotocol/server-git
npx @modelcontextprotocol/server-memory
npx @modelcontextprotocol/server-filesystem /your/projects/directory
npx @modelcontextprotocol/server-fetch
```

### Step 2: Configure Claude Desktop
Add MCP servers to your configuration file

### Step 3: Test Basic Functionality
- Ask Claude to read a file (Filesystem MCP)
- Ask Claude about your Git history (Git MCP)
- Browse documentation (Fetch MCP)
- Store and retrieve information (Memory MCP)

### Step 4: Add Specialized MCPs
Based on your workflow:
- GitHub MCP for repository management
- Playwright MCP for testing
- Postgres MCP for database work

### Step 5: Customize Your Setup
- Add project-specific directory paths
- Configure API keys for third-party services
- Set up automation workflows

---

## 📈 Adoption Timeline

**November 2024**: MCP introduced by Anthropic
**March 2025**: OpenAI officially adopts MCP
**April 2025**: Google DeepMind confirms MCP support
**September 2025**: MCP Registry launches in preview
**November 2025**: Next major release planned

**Current Status**: Growing ecosystem with 6360+ community servers

---

## 🤝 Contributing

If you discover new essential MCPs or have improvements to this guide, consider:
- Contributing to awesome-mcp-servers lists
- Reporting issues to MCP maintainers
- Sharing your setup and workflows with the community

---

## 📄 License

This document is for educational purposes. Individual MCP servers have their own licenses - check each repository for details.

---

**Last Updated**: 2025-01-03
**Maintained by**: Full-Stack Engineering Community
**Version**: 1.0.0
