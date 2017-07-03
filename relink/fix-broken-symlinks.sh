#!/usr/bin/env bash


. ~/libs/sh/args.fn.sh 

usage() {
    echo "
fix-broken-symlinks.sh -f PATT1 -t PATT2
    Renames symlink destinations recursively from PATT1 to PATT2
    "
}
dir=.
handle_flag() {
    case "$1" in 
        -h | --help )
            usage
            ;;
        -f )
            eval `make_with_argument`
            from=$2
            ;;
        -t )
            eval `make_with_argument`
            to=$2
            ;;
        -d )
            eval `make_with_argument`
            dir="$2"
            ;;
        -p)
            passive=-p
    esac
}
parse_args "$@"

# And now, script logic

find "$dir" -lname "*$from*" -xtype l -print0  \
    | xargs -0 -I '{}' relink -n '{}' -f "$from"  -t "$to" $passive

# vim: sw=4
