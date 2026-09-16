#!/usr/bin/env bash
set -euo pipefail

# Check multiple servers from a hosts file
# Usage: check-all.sh hosts.txt
#   hosts.txt is one user@host per line, blank lines and # comments ignored

HOSTS_FILE="${1:?Usage: check-all.sh hosts.txt}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ ! -f "$HOSTS_FILE" ]; then
  echo "File not found: $HOSTS_FILE"
  exit 1
fi

TOTAL=0
FAILED=0

while IFS= read -r line; do
  line=$(echo "$line" | sed 's/#.*//' | xargs)
  [ -z "$line" ] && continue

  TOTAL=$((TOTAL + 1))
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  if ! "$SCRIPT_DIR/check.sh" "$line"; then
    FAILED=$((FAILED + 1))
  fi
done < "$HOSTS_FILE"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Checked $TOTAL hosts, $FAILED failed to connect."
