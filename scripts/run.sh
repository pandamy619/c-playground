#!/usr/bin/env bash
set -euo pipefail

# BIN — какой бинарник запускать
# по умолчанию ./a.out
BIN=${1:-./a.out}

echo "[*] Running $BIN"
$BIN
