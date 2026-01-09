# MCP Usage Examples

Practical examples of using MCP servers for real-world tasks.

## Table of Contents

1. [Filesystem MCP Examples](#filesystem-mcp-examples)
2. [GitHub MCP Examples](#github-mcp-examples)
3. [Database MCP Examples](#database-mcp-examples)
4. [Puppeteer MCP Examples](#puppeteer-mcp-examples)
5. [Combined MCP Workflows](#combined-mcp-workflows)
6. [Best Practices](#best-practices)

---

## Filesystem MCP Examples

### Example 1: Read Configuration File

**Scenario:** Read app configuration from `/etc/myapp/config.json`

**Setup:**
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/etc"]
    }
  }
}
```

**Usage:**
```typescript
// Read the config file
const config = await mcp__filesystem__read_file("/etc/myapp/config.json");

// Parse and use
const settings = JSON.parse(config);
console.log("Database host:", settings.database.host);
```

### Example 2: Backup Project Files

**Scenario:** Copy important files to backup directory

**Usage:**
```typescript
// List project files
const files = await mcp__filesystem__list_directory("/home/user/project/src");

// Read each file
for (const file of files) {
  if (file.endsWith('.ts')) {
    const content = await mcp__filesystem__read_file(`/home/user/project/src/${file}`);

    // Write to backup
    await mcp__filesystem__write_file(
      `/home/user/backups/${file}`,
      content
    );
  }
}
```

### Example 3: Search for TODO Comments

**Scenario:** Find all TODO comments across multiple projects

**Usage:**
```typescript
// Search for TODOs
const results = await mcp__filesystem__search_files(
  "/home/user/projects",
  "TODO:",
  {recursive: true, filePattern: "*.ts"}
);

// Report findings
results.forEach(result => {
  console.log(`${result.file}:${result.line} - ${result.match}`);
});
```

### Example 4: Monitor Log Files

**Scenario:** Read latest entries from application logs

**Usage:**
```typescript
// Get log file info
const logInfo = await mcp__filesystem__get_file_info("/var/log/myapp/app.log");
console.log("Log file size:", logInfo.size);
console.log("Last modified:", logInfo.modified);

// Read log content
const logContent = await mcp__filesystem__read_file("/var/log/myapp/app.log");

// Get last 100 lines
const lines = logContent.split('\n');
const recentLines = lines.slice(-100);

// Find errors
const errors = recentLines.filter(line => line.includes('ERROR'));
console.log(`Found ${errors.length} errors in recent logs`);
```

---

## GitHub MCP Examples

### Example 5: Create Issue from Error

**Scenario:** Automatically create GitHub issue when error detected

**Setup:**
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

**Usage:**
```typescript
// Detected error in code
const errorMessage = "TypeError: Cannot read property 'userId' of undefined";
const errorFile = "src/components/Dashboard.tsx";
const errorLine = 45;

// Create GitHub issue
const issue = await mcp__github__create_issue(
  "owner/repo",
  `Bug: ${errorMessage}`,
  `
## Error Details
- **File**: ${errorFile}:${errorLine}
- **Message**: ${errorMessage}
- **Environment**: Production

## Steps to Reproduce
1. Navigate to dashboard
2. Error appears on load

## Stack Trace
\`\`\`
${errorMessage}
  at Dashboard (${errorFile}:${errorLine})
\`\`\`
  `,
  {labels: ["bug", "automated"]}
);

console.log("Created issue:", issue.html_url);
```

### Example 6: List and Analyze Open PRs

**Scenario:** Get overview of all open pull requests

**Usage:**
```typescript
// List open PRs
const prs = await mcp__github__list_pull_requests(
  "owner/repo",
  {state: "open"}
);

console.log(`Found ${prs.length} open PRs`);

// Analyze by age
const now = new Date();
prs.forEach(pr => {
  const age = now - new Date(pr.created_at);
  const days = Math.floor(age / (1000 * 60 * 60 * 24));

  console.log(`PR #${pr.number}: ${pr.title}`);
  console.log(`  Age: ${days} days`);
  console.log(`  Status: ${pr.mergeable ? 'Ready' : 'Has conflicts'}`);
  console.log(`  Reviews: ${pr.requested_reviewers.length} pending`);
});

// Find stale PRs (>30 days)
const stalePRs = prs.filter(pr => {
  const age = now - new Date(pr.created_at);
  return age > 30 * 24 * 60 * 60 * 1000;
});

console.log(`\n${stalePRs.length} PRs are stale (>30 days old)`);
```

### Example 7: Search for Related Issues

**Scenario:** Find issues related to authentication

**Usage:**
```typescript
// Search issues
const issues = await mcp__github__search_issues(
  "repo:owner/repo label:authentication is:open"
);

// Group by priority
const critical = issues.filter(i => i.labels.includes('critical'));
const high = issues.filter(i => i.labels.includes('high-priority'));

console.log("Authentication issues:");
console.log(`  Critical: ${critical.length}`);
console.log(`  High: ${high.length}`);
console.log(`  Total: ${issues.length}`);

// List critical ones
critical.forEach(issue => {
  console.log(`  #${issue.number}: ${issue.title}`);
});
```

---

## Database MCP Examples

### Example 8: Query Active Users

**Scenario:** Get list of active users from database

**Setup:**
```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {"POSTGRES_CONNECTION_STRING": "${DATABASE_URL}"}
    }
  }
}
```

**Usage:**
```typescript
// Query active users
const result = await mcp__postgres__query(`
  SELECT id, email, last_login
  FROM users
  WHERE active = true
  ORDER BY last_login DESC
  LIMIT 10
`);

console.log("Active users:", result.rows.length);
result.rows.forEach(user => {
  console.log(`  ${user.email} - Last login: ${user.last_login}`);
});
```

### Example 9: Analyze Data Quality

**Scenario:** Check for data quality issues

**Usage:**
```typescript
// Check for users without email
const missingEmail = await mcp__postgres__query(`
  SELECT COUNT(*) as count
  FROM users
  WHERE email IS NULL OR email = ''
`);

// Check for duplicate emails
const duplicates = await mcp__postgres__query(`
  SELECT email, COUNT(*) as count
  FROM users
  GROUP BY email
  HAVING COUNT(*) > 1
`);

// Check for orphaned records
const orphaned = await mcp__postgres__query(`
  SELECT COUNT(*) as count
  FROM orders
  WHERE user_id NOT IN (SELECT id FROM users)
`);

console.log("Data Quality Report:");
console.log(`  Missing emails: ${missingEmail.rows[0].count}`);
console.log(`  Duplicate emails: ${duplicates.rows.length}`);
console.log(`  Orphaned orders: ${orphaned.rows[0].count}`);
```

### Example 10: Generate Report

**Scenario:** Generate monthly sales report

**Usage:**
```typescript
// Get monthly sales data
const sales = await mcp__postgres__query(`
  SELECT
    DATE_TRUNC('month', created_at) as month,
    COUNT(*) as order_count,
    SUM(total_amount) as revenue
  FROM orders
  WHERE created_at >= NOW() - INTERVAL '12 months'
  GROUP BY DATE_TRUNC('month', created_at)
  ORDER BY month DESC
`);

// Format report
console.log("Monthly Sales Report");
console.log("===================");
sales.rows.forEach(row => {
  const month = new Date(row.month).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'long'
  });
  console.log(`${month}`);
  console.log(`  Orders: ${row.order_count}`);
  console.log(`  Revenue: $${row.revenue.toFixed(2)}`);
});
```

---

## Puppeteer MCP Examples

### Example 11: Screenshot Website

**Scenario:** Take screenshot of production website

**Setup:**
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

**Usage:**
```typescript
// Navigate to website
await mcp__puppeteer__navigate("https://example.com");

// Take screenshot
const screenshot = await mcp__puppeteer__screenshot({
  fullPage: true,
  path: "/home/user/screenshots/homepage.png"
});

console.log("Screenshot saved to:", screenshot.path);
```

### Example 12: Extract Product Data

**Scenario:** Scrape product information from e-commerce site

**Usage:**
```typescript
// Navigate to product page
await mcp__puppeteer__navigate("https://example-shop.com/products");

// Extract product data
const products = await mcp__puppeteer__execute_script(`
  return Array.from(document.querySelectorAll('.product')).map(product => ({
    name: product.querySelector('.product-name').textContent,
    price: product.querySelector('.product-price').textContent,
    inStock: !product.querySelector('.out-of-stock')
  }));
`);

console.log(`Found ${products.length} products:`);
products.forEach(product => {
  console.log(`  ${product.name} - ${product.price} - ${product.inStock ? 'In Stock' : 'Out of Stock'}`);
});
```

### Example 13: Automated Testing

**Scenario:** Test login functionality

**Usage:**
```typescript
// Navigate to login page
await mcp__puppeteer__navigate("https://app.example.com/login");

// Fill in credentials
await mcp__puppeteer__type("#email", "test@example.com");
await mcp__puppeteer__type("#password", "test-password");

// Click login button
await mcp__puppeteer__click("#login-button");

// Wait for navigation
await new Promise(resolve => setTimeout(resolve, 2000));

// Check if logged in
const content = await mcp__puppeteer__get_content();
const loggedIn = content.includes("Welcome, Test User");

console.log("Login test:", loggedIn ? "PASSED" : "FAILED");
```

---

## Combined MCP Workflows

### Example 14: Automated Bug Report

**Scenario:** Detect error in logs, create GitHub issue with details

**Usage:**
```typescript
// 1. Read recent logs (Filesystem MCP)
const logs = await mcp__filesystem__read_file("/var/log/app/error.log");
const lines = logs.split('\n').slice(-100);

// 2. Find errors
const errors = lines.filter(line => line.includes('ERROR'));

if (errors.length > 10) {
  // 3. Extract error details
  const errorSummary = errors[0]; // Most recent
  const errorCount = errors.length;

  // 4. Query database for affected users (Database MCP)
  const affectedUsers = await mcp__postgres__query(`
    SELECT COUNT(DISTINCT user_id) as count
    FROM error_logs
    WHERE created_at > NOW() - INTERVAL '1 hour'
  `);

  // 5. Create GitHub issue (GitHub MCP)
  await mcp__github__create_issue(
    "owner/repo",
    `Critical: ${errorCount} errors in last hour`,
    `
## Error Summary
${errorSummary}

## Impact
- Error count: ${errorCount}
- Affected users: ${affectedUsers.rows[0].count}
- Time period: Last 1 hour

## Recent Errors
\`\`\`
${errors.slice(0, 5).join('\n')}
\`\`\`
    `,
    {labels: ["bug", "critical", "automated"]}
  );

  console.log("Critical bug reported to GitHub");
}
```

### Example 15: Deploy and Verify

**Scenario:** Deploy code and verify it's working

**Usage:**
```typescript
// 1. Check latest commit (Git operations)
const latestCommit = await Bash("git log -1 --oneline");

// 2. Deploy (custom script)
await Bash("./deploy.sh");

// 3. Wait for deployment
await new Promise(resolve => setTimeout(resolve, 30000));

// 4. Verify with Puppeteer
await mcp__puppeteer__navigate("https://app.example.com");
const content = await mcp__puppeteer__get_content();
const deployed = content.includes(`Build: ${latestCommit.split(' ')[0]}`);

// 5. If successful, create PR comment
if (deployed) {
  await mcp__github__create_comment(
    "owner/repo",
    prNumber,
    `✅ Deployment verified successfully. Build ${latestCommit} is live.`
  );
} else {
  await mcp__github__create_comment(
    "owner/repo",
    prNumber,
    `❌ Deployment verification failed. Build not detected on production.`
  );
}
```

### Example 16: Documentation Sync

**Scenario:** Keep GitHub wiki in sync with local docs

**Usage:**
```typescript
// 1. Read local documentation (Filesystem MCP)
const docFiles = await mcp__filesystem__list_directory("/home/user/docs");

for (const file of docFiles) {
  if (file.endsWith('.md')) {
    const content = await mcp__filesystem__read_file(`/home/user/docs/${file}`);

    // 2. Update GitHub wiki
    await mcp__github__update_wiki_page(
      "owner/repo",
      file.replace('.md', ''),
      content
    );

    console.log(`Updated wiki page: ${file}`);
  }
}

// 3. Create PR for documentation updates
await mcp__github__create_pull_request(
  "owner/repo",
  "Update documentation",
  `Automated documentation sync from local files.\n\nUpdated ${docFiles.length} pages.`,
  "main",
  "docs-update"
);
```

---

## Best Practices

### Performance Tips

**1. Cache results when possible:**
```typescript
// ❌ BAD: Re-query on every check
for (let i = 0; i < 100; i++) {
  const users = await mcp__postgres__query("SELECT * FROM users");
  // ...
}

// ✅ GOOD: Query once, process multiple times
const users = await mcp__postgres__query("SELECT * FROM users");
for (let i = 0; i < 100; i++) {
  // Process cached results
}
```

**2. Use specific queries:**
```typescript
// ❌ BAD: Select everything
const result = await mcp__postgres__query("SELECT * FROM users");

// ✅ GOOD: Select only what you need
const result = await mcp__postgres__query("SELECT id, email FROM users WHERE active = true");
```

**3. Batch filesystem operations:**
```typescript
// ❌ BAD: Read files one by one
for (const file of files) {
  const content = await mcp__filesystem__read_file(file);
  processFile(content);
}

// ✅ GOOD: Read all, then process
const contents = await Promise.all(
  files.map(f => mcp__filesystem__read_file(f))
);
contents.forEach(processFile);
```

### Security Tips

**1. Validate user input:**
```typescript
// ❌ BAD: Direct user input in query
const email = userInput;
await mcp__postgres__query(`SELECT * FROM users WHERE email = '${email}'`);

// ✅ GOOD: Use parameterized queries
await mcp__postgres__query(
  "SELECT * FROM users WHERE email = $1",
  [userInput]
);
```

**2. Restrict filesystem access:**
```typescript
// ❌ BAD: Allow access everywhere
{
  "args": ["-y", "@modelcontextprotocol/server-filesystem", "/"]
}

// ✅ GOOD: Specific directories only
{
  "args": ["-y", "@modelcontextprotocol/server-filesystem", "/home/user/safe-dir"]
}
```

**3. Use read-only credentials when possible:**
```json
{
  "env": {
    "POSTGRES_CONNECTION_STRING": "postgresql://readonly_user:pass@host/db"
  }
}
```

### Error Handling

**Always handle MCP errors gracefully:**
```typescript
try {
  const result = await mcp__postgres__query("SELECT * FROM users");
  // Process result
} catch (error) {
  if (error.message.includes('connection')) {
    console.error("Database connection failed");
    // Fallback behavior
  } else if (error.message.includes('permission')) {
    console.error("Insufficient database permissions");
  } else {
    console.error("Query failed:", error.message);
  }
}
```

### Logging and Monitoring

**Track MCP usage for debugging:**
```typescript
console.log("[MCP] Reading configuration file");
const config = await mcp__filesystem__read_file("/etc/config.json");
console.log("[MCP] Configuration loaded successfully");

console.log("[MCP] Querying database");
const users = await mcp__postgres__query("SELECT COUNT(*) FROM users");
console.log(`[MCP] Found ${users.rows[0].count} users`);
```

---

## Common Patterns

### Pattern 1: Read-Process-Write

```typescript
// 1. Read input
const data = await mcp__filesystem__read_file("/input/data.json");

// 2. Process
const parsed = JSON.parse(data);
const processed = parsed.map(item => ({
  ...item,
  processed: true,
  timestamp: new Date()
}));

// 3. Write output
await mcp__filesystem__write_file(
  "/output/processed.json",
  JSON.stringify(processed, null, 2)
);
```

### Pattern 2: Query-Transform-Report

```typescript
// 1. Query data
const orders = await mcp__postgres__query(`
  SELECT * FROM orders WHERE created_at >= NOW() - INTERVAL '7 days'
`);

// 2. Transform
const summary = {
  total: orders.rows.length,
  revenue: orders.rows.reduce((sum, o) => sum + o.total, 0),
  avgOrder: orders.rows.reduce((sum, o) => sum + o.total, 0) / orders.rows.length
};

// 3. Report (create GitHub issue)
await mcp__github__create_issue(
  "owner/repo",
  "Weekly Sales Report",
  `
## Weekly Summary
- Total orders: ${summary.total}
- Revenue: $${summary.revenue.toFixed(2)}
- Average order: $${summary.avgOrder.toFixed(2)}
  `,
  {labels: ["report"]}
);
```

### Pattern 3: Monitor-Alert-Action

```typescript
// 1. Monitor
const metrics = await mcp__postgres__query(`
  SELECT
    COUNT(*) as error_count
  FROM error_logs
  WHERE created_at > NOW() - INTERVAL '5 minutes'
`);

// 2. Alert if threshold exceeded
if (metrics.rows[0].error_count > 100) {
  // 3. Take action
  await mcp__github__create_issue(
    "owner/repo",
    "⚠️ High Error Rate Alert",
    `Error rate exceeded threshold: ${metrics.rows[0].error_count} errors in last 5 minutes`,
    {labels: ["alert", "critical"]}
  );

  console.log("Alert created - high error rate detected");
}
```
