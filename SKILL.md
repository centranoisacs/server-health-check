---
name: server-health-check
description: Checks remote server health over SSH — disk, memory, load, uptime. Use when asked to check server status, diagnose a slow host, or verify a server is healthy after deployment.
compatibility: Requires ssh CLI and access to target host. Remote host must be Linux with standard coreutils.
---

## What this does

Connects to a remote server via SSH and runs health checks. Reports disk usage, memory, load average, and uptime with color-coded output.

## Usage

When asked to check a server, run:

```
scripts/check.sh <user@host>
```

The script flags issues automatically:
- **CRIT** — Disk usage above 85% or memory above 90%
- **WARN** — Load average exceeds CPU count, or uptime under 1 hour
- **OK** — Everything within normal range

## Notes

- Uses `BatchMode=yes` so it won't hang on password prompts — SSH key auth required
- Timeout is 5 seconds, so unreachable hosts fail fast
