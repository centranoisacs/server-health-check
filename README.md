# server-health-check

Agent skill that checks remote server health over SSH.

Runs disk, memory, load, and uptime checks on one or more servers and flags anything abnormal with color-coded output.

## Quick start

Single server:
```bash
scripts/check.sh root@10.0.0.1
```

Multiple servers:
```bash
cp hosts.example.txt hosts.txt
# edit hosts.txt with your servers
scripts/check-all.sh hosts.txt
```

## Output

```
Connecting to root@10.0.0.1 ...

-- root@10.0.0.1 --

OK   Disk: 42% used (18G / 40G)
OK   Memory: 63% used (2021M / 3204M)
OK   Load: 0.12 (2 cpus)
OK   Uptime: 34d 6h
```

Thresholds:
- **CRIT** — disk > 85% or memory > 90%
- **WARN** — load > cpu count, or uptime < 1 hour
- **OK** — normal

## Requirements

- SSH key access to target hosts (no password prompt)
- Linux remote host with `df`, `free`, `nproc`, `uptime`

## As an Agent Skill

This is an [Agent Skill](https://github.com/agentskills/agentskills). Copy the folder into your skills directory and any compatible agent will pick it up when you ask it to check server health.
