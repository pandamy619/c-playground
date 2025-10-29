#!/usr/bin/env bash
set -euo pipefail

# SRC — путь до C файла, который хотим собрать.
# По умолчанию компилируем examples/hello.c
SRC=${1:-examples/hello.c}

# OUT — имя выходного бинарника.
# По умолчанию a.out (как у gcc без -o)
OUT=${2:-a.out}

echo "[*] gcc -Wall -Wextra -O2 $SRC -o $OUT"
gcc -Wall -Wextra -O2 "$SRC" -o "$OUT"

echo "[+] Built $OUT"
