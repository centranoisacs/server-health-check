# server-health-check

Agent skill that checks remote server health over SSH.

Runs disk, memory, load, and uptime checks and flags anything abnormal.

## Install

Copy this folder into your skills directory.

## Requirements

- SSH access to the target server
- `bash` on the remote host
- Standard coreutils (`df`, `free`, `uptime`)
