---
name: server-health-check
description: Checks server health over SSH — disk, memory, load, uptime. Use when asked to check server status or diagnose a slow/unresponsive host.
compatibility: Requires ssh CLI and access to target host.
---

## What this does

Connects to a server via SSH and runs health checks. Reports disk usage, memory, load average, and uptime.

## Usage

When asked to check a server, run:

\`\`\`
scripts/check.sh <user@host>
\`\`\`

The script outputs a summary. Flag anything that looks concerning:
- Disk usage above 85%
- Memory usage above 90%
- Load average above the CPU count
- Uptime under 1 hour (recent reboot)
