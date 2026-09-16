#!/usr/bin/env bash
set -euo pipefail

HOST="${1:?Usage: check.sh user@host}"

ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=accept-new "$HOST" bash << 'REMOTE'
echo "=== disk ==="
df -h / | tail -1

echo "=== memory ==="
free -m | grep Mem

echo "=== load ==="
cat /proc/loadavg

echo "=== uptime ==="
uptime -p
REMOTE
