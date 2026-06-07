#!/bin/bash

unset HISTFILE
trap '' INT TERM

D=$(mktemp -d /tmp/...._XXXXXX)
cd "$D" || exit 1

for i in $(seq 1 $((RANDOM % 50 + 20))); do
    dd if=/dev/urandom of="cell_${i}.bin" bs=$((RANDOM % 1024 + 128)) count=1 &>/dev/null
done

shred -n 3 -z cell_*.bin &>/dev/null
rm -f cell_*.bin

dd if=/dev/urandom bs=1 count=4 2>/dev/null | xxd -p

cd /
rm -rf "$D"