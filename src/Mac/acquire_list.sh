#!/bin/bash

echo "Searching for .dat files and sorting by filename..."

# Get absolute paths and sort by filename
find "$(pwd)" -name "*.dat" -type f | awk -F'/' '{printf "%s|%s\n", $NF, $0}' | sort -k1,1 | cut -d'|' -f2 > list

count=$(wc -l < list)
echo "========================================"
echo "Complete! Found $count .dat files"
echo "Absolute paths sorted by filename saved to: list.txt"
echo "========================================"

if [ $count -gt 0 ]; then
    echo "Sorted preview:"
    echo "----------------------------------------"
    head -n 10 list
    if [ $count -gt 10 ]; then
        echo "... (and $((count - 10)) more files)"
    fi
else
    echo "No .dat files found"
    rm -f list
fi