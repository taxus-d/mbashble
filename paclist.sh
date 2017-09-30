#!/usr/bin/env bash

LC_ALL=C pacman -Qiet \
    | grep "Name\|Installed Size" \
    | sed -e 's/[^:]*:[[:space:]]*//' \
    | sed -e 'N;s/\n/ /;s/MiB/M/;s/KiB/K/;s/GiB/G/' \
    | awk '{printf "%s %i%s\n", $1, $2, $3}' \
    | sort -r -h -k2 \
    | column -t \
    #
