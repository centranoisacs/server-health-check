#!/usr/bin/env bash
set -euo pipefail

HOST="${1:?Usage: check.sh user@host}"
DISK_WARN=85
MEM_WARN=90

RED='\033[0;31m'
YEL='\033[0;33m'
GRN='\033[0;32m'
NC='\033[0m'

warn() { printf "${YEL}WARN${NC} %s\n" "$1"; }
ok()   { printf "${GRN}OK${NC}   %s\n" "$1"; }
crit() { printf "${RED}CRIT${NC} %s\n" "$1"; }

echo "Connecting to $HOST ..."

DATA=$(ssh -o ConnectTimeout=5 -o BatchMode=yes -o StrictHostKeyChecking=accept-new "$HOST" bash << 'REMOTE'
echo "DISK=$(df / --output=pcent | tail -1 | tr -d ' %')"
echo "DISK_TOTAL=$(df -h / --output=size | tail -1 | tr -d ' ')"
echo "DISK_USED=$(df -h / --output=used | tail -1 | tr -d ' ')"

MEM_TOTAL=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
MEM_AVAIL=$(awk '/MemAvailable/ {print $2}' /proc/meminfo)
MEM_USED=$((MEM_TOTAL - MEM_AVAIL))
MEM_PCT=$((MEM_USED * 100 / MEM_TOTAL))
echo "MEM_PCT=$MEM_PCT"
echo "MEM_TOTAL=$((MEM_TOTAL / 1024))M"
echo "MEM_USED=$((MEM_USED / 1024))M"

echo "LOAD=$(awk '{print $1}' /proc/loadavg)"
echo "CPUS=$(nproc)"

echo "UPTIME_SEC=$(awk '{printf "%d", $1}' /proc/uptime)"
REMOTE
)

eval "$DATA"

echo ""
echo "-- $HOST --"
echo ""

# disk
if [ "$DISK" -ge "$DISK_WARN" ]; then
  crit "Disk: ${DISK}% used (${DISK_USED} / ${DISK_TOTAL})"
else
  ok "Disk: ${DISK}% used (${DISK_USED} / ${DISK_TOTAL})"
fi

# memory
if [ "$MEM_PCT" -ge "$MEM_WARN" ]; then
  crit "Memory: ${MEM_PCT}% used (${MEM_USED} / ${MEM_TOTAL})"
else
  ok "Memory: ${MEM_PCT}% used (${MEM_USED} / ${MEM_TOTAL})"
fi

# load
LOAD_INT=${LOAD%.*}
CPUS_INT=${CPUS:-1}
if [ "$LOAD_INT" -ge "$CPUS_INT" ]; then
  warn "Load: $LOAD (${CPUS} cpus)"
else
  ok "Load: $LOAD (${CPUS} cpus)"
fi

# uptime
if [ "$UPTIME_SEC" -lt 3600 ]; then
  warn "Uptime: less than 1 hour (recent reboot?)"
else
  DAYS=$((UPTIME_SEC / 86400))
  HOURS=$(( (UPTIME_SEC % 86400) / 3600 ))
  ok "Uptime: ${DAYS}d ${HOURS}h"
fi

echo ""
