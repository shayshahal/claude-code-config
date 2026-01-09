# MCP Installation Guide

Step-by-step guide for installing and configuring MCP servers in Claude Code.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Installation Methods](#installation-methods)
3. [Configuration Steps](#configuration-steps)
4. [Testing Installation](#testing-installation)
5. [Common Issues](#common-issues)
6. [Advanced Configuration](#advanced-configuration)

---

## Prerequisites

### System Requirements

**Required:**
- Node.js installed (v16+ recommended)
- npm or npx available
- Claude Code installed

**Check installation:**
```bash
node --version  # Should show v16.x.x or higher
npx --version   # Should show npm version
```

### Permissions

**Filesystem MCP:**
- Read/write access to directories you want to expose
- Check with: `ls -la /path/to/directory`

**Database MCPs:**
- Database connection credentials
- Network access to database server
- Appropriate database permissions

**GitHub MCP:**
- GitHub Personal Access Token
- Token with appropriate scopes

---

## Installation Methods

### Method 1: Direct npx Installation (Recommended)

**Advantages:**
- No local installation needed
- Always uses latest version
- Simple to set up

**Process:**
```bash
# Test the MCP server runs
npx -y @modelcontextprotocol/server-filesystem /tmp

# If successful, add to settings.json
```

### Method 2: Global npm Installation

**Advantages:**
- Faster startup (already installed)
- Works offline
- Version control

**Process:**
```bash
# Install globally
npm install -g @modelcontextprotocol/server-filesystem

# Use in settings.json with full path
which @modelcontextprotocol/server-filesystem
```

### Method 3: Local Project Installation

**Advantages:**
- Project-specific versions
- npm package.json tracking
- Team consistency

**Process:**
```bash
# In project directory
npm install @modelcontextprotocol/server-filesystem

# Reference in settings.json with local path
```

---

## Configuration Steps

### Step 1: Locate settings.json

**File location:**
```
.claude/settings.json
```

**Create if doesn't exist:**
```bash
mkdir -p .claude
echo '{"mcpServers": {}}' > .claude/settings.json
```

### Step 2: Add MCP Configuration

**Basic structure:**
```json
{
  "mcpServers": {
    "server-name": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-name", "arg1", "arg2"],
      "env": {
        "ENV_VAR": "value"
      }
    }
  }
}
```

**Example - Filesystem MCP:**
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/home/user/documents"
      ]
    }
  }
}
```

### Step 3: Add Environment Variables (if needed)

**For MCPs requiring authentication:**
```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "ghp_your_token_here"
      }
    }
  }
}
```

**Security best practice:**
```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"  // References system env var
      }
    }
  }
}
```

Then set system environment variable:
```bash
export GITHUB_TOKEN="ghp_your_token_here"
```

### Step 4: Restart Claude Code

**IMPORTANT:** MCPs only load on startup

**Methods to restart:**
1. Close and reopen Claude Code
2. Use reload command (if available)
3. Restart IDE/terminal

**Verify restart needed:**
- New MCPs won't appear until restart
- Existing MCPs continue working
- Configuration changes require restart

---

## Testing Installation

### Step 1: Check MCP Tools Available

After restart, MCP tools should appear with `mcp__` prefix.

**List available tools:**
Check if tools like `mcp__filesystem__read_file` are available.

### Step 2: Test Simple Operation

**Filesystem MCP test:**
```
Try: mcp__filesystem__list_directory("/allowed/path")
```

**Expected result:**
- Success: List of files and directories
- Error: "Access denied" or "Path not allowed"

**GitHub MCP test:**
```
Try: mcp__github__list_issues("owner/repo")
```

**Expected result:**
- Success: List of issues
- Error: "Authentication failed" or "Repository not found"

### Step 3: Verify Configuration

**Check settings.json syntax:**
```bash
cd .claude
cat settings.json | python -m json.tool
# or
cat settings.json | jq .
```

**Common syntax errors:**
- Missing commas
- Trailing commas
- Unquoted strings
- Invalid escape sequences

### Step 4: Check MCP Server Logs

**If MCP not working, check logs:**
- Claude Code console output
- MCP server stderr
- System logs

**Debug mode (if available):**
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path"],
      "debug": true  // Enable debug logging
    }
  }
}
```

---

## Common Issues

### Issue 1: MCP Tools Not Appearing

**Symptoms:**
- MCP tools don't show up after installation
- No `mcp__*` tools available

**Solutions:**
1. **Restart Claude Code** (most common fix)
2. Check settings.json syntax:
   ```bash
   jq . .claude/settings.json
   ```
3. Verify command path:
   ```bash
   which npx
   npx -y @modelcontextprotocol/server-filesystem --help
   ```
4. Check Claude Code console for errors

### Issue 2: Permission Denied (Filesystem MCP)

**Symptoms:**
- "Access denied" or "Path not allowed" errors
- Cannot read/write files

**Solutions:**
1. **Add directory to allowed paths:**
   ```json
   {
     "mcpServers": {
       "filesystem": {
         "args": [
           "-y",
           "@modelcontextprotocol/server-filesystem",
           "/home/user/documents",  // Add this path
           "/home/user/projects"
         ]
       }
     }
   }
   ```
2. Check file system permissions:
   ```bash
   ls -la /path/to/directory
   ```
3. Use absolute paths, not relative
4. Restart after configuration changes

### Issue 3: Authentication Failed (GitHub, Database MCPs)

**Symptoms:**
- "Unauthorized" or "Authentication failed"
- "Invalid credentials"

**Solutions:**
1. **Verify token/credentials:**
   ```bash
   # Test GitHub token
   curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user

   # Test database connection
   psql "$POSTGRES_CONNECTION_STRING" -c "SELECT 1"
   ```
2. Check token scopes/permissions
3. Verify environment variable set:
   ```bash
   echo $GITHUB_TOKEN
   ```
4. Check for typos in env var names
5. Restart Claude Code after setting env vars

### Issue 4: MCP Server Crashes

**Symptoms:**
- MCP tools work then stop
- "Server not responding" errors
- Timeout errors

**Solutions:**
1. **Check dependencies installed:**
   ```bash
   # Puppeteer needs Chromium
   npx -y @modelcontextprotocol/server-puppeteer --version
   ```
2. Check system resources (memory, disk)
3. Review MCP server logs
4. Try reinstalling MCP package:
   ```bash
   npm cache clean --force
   npx -y @modelcontextprotocol/server-name
   ```
5. Update Node.js version

### Issue 5: Connection Timeout (Database MCPs)

**Symptoms:**
- "Connection timeout" errors
- "Cannot reach database" errors

**Solutions:**
1. **Verify database is accessible:**
   ```bash
   psql "$POSTGRES_CONNECTION_STRING" -c "SELECT 1"
   ```
2. Check firewall rules
3. Verify connection string format:
   ```
   postgresql://user:password@host:port/database
   ```
4. Test from same network/machine
5. Check database server logs

---

## Advanced Configuration

### Multiple MCPs

**Configure multiple MCP servers:**
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
      "env": {"GITHUB_TOKEN": "${GITHUB_TOKEN}"}
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {"POSTGRES_CONNECTION_STRING": "${DATABASE_URL}"}
    }
  }
}
```

### Custom Aliases

**Give MCPs custom names:**
```json
{
  "mcpServers": {
    "my-docs": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/home/user/documents"]
    },
    "my-projects": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/home/user/projects"]
    }
  }
}
```

Tools will appear as:
- `mcp__my-docs__read_file`
- `mcp__my-projects__read_file`

### Environment Variable Interpolation

**Reference system environment variables:**
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "${HOME}/documents"  // Uses $HOME env var
      ]
    }
  }
}
```

### Conditional Configuration

**Different configs for different environments:**

**Development:**
```json
{
  "mcpServers": {
    "postgres": {
      "env": {
        "POSTGRES_CONNECTION_STRING": "postgresql://localhost/dev_db"
      }
    }
  }
}
```

**Production:**
```json
{
  "mcpServers": {
    "postgres": {
      "env": {
        "POSTGRES_CONNECTION_STRING": "${PROD_DATABASE_URL}"
      }
    }
  }
}
```

### Security Hardening

**1. Use read-only credentials:**
```json
{
  "mcpServers": {
    "postgres": {
      "env": {
        "POSTGRES_CONNECTION_STRING": "postgresql://readonly_user:pass@host/db"
      }
    }
  }
}
```

**2. Restrict filesystem access:**
```json
{
  "mcpServers": {
    "filesystem": {
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/home/user/safe-directory"  // Only this directory
      ]
    }
  }
}
```

**3. Use environment variables for secrets:**
```bash
# Set in shell profile (.bashrc, .zshrc)
export GITHUB_TOKEN="ghp_token"
export DATABASE_URL="postgresql://..."

# Reference in settings.json
{
  "mcpServers": {
    "github": {
      "env": {"GITHUB_TOKEN": "${GITHUB_TOKEN}"}
    }
  }
}
```

**4. Rotate credentials regularly:**
- GitHub tokens: Rotate every 90 days
- Database credentials: Follow org policy
- Never commit secrets to git

---

## Troubleshooting Checklist

When MCP not working:

- [ ] Restarted Claude Code after configuration changes
- [ ] Verified settings.json is valid JSON (use `jq`)
- [ ] Checked command is accessible (`which npx`)
- [ ] Tested MCP server runs standalone
- [ ] Verified environment variables set (`echo $VAR`)
- [ ] Checked file/network permissions
- [ ] Reviewed Claude Code console for errors
- [ ] Tested credentials work outside Claude Code
- [ ] Updated Node.js to latest LTS version
- [ ] Cleared npm cache (`npm cache clean --force`)

---

## Quick Start Templates

### Filesystem Only
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "${HOME}"]
    }
  }
}
```

### GitHub Integration
```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {"GITHUB_TOKEN": "${GITHUB_TOKEN}"}
    }
  }
}
```

### Full Stack Developer Setup
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "${HOME}"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {"GITHUB_TOKEN": "${GITHUB_TOKEN}"}
    },
    "git": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-git"]
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {"POSTGRES_CONNECTION_STRING": "${DATABASE_URL}"}
    }
  }
}
```
