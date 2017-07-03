#!/usr/bin/env bash

. ~/libs/sh/args.fn.sh 
[ -z $DEBUG ] && DEBUG=false
usage() {
    echo "
relink.sh -n NAME -f PATT1 -t PATT2
    Renames symlink NAME from PATT1 to PATT2
    "
}

passive=false
handle_flag() {
    case "$1" in 
        -h | --help )
            usage
            ;;
        -n )
            eval `make_with_argument`
            lname=$2
            ;;
        -f )
            eval `make_with_argument`
            from=$2
            ;;
        -t )
            eval `make_with_argument`
            to=$2
            ;;
        -p)
            passive=true
    esac
}
parse_args "$@"
flags='-s -f' 
ldest=$(readlink "$lname")
lndest=$(echo "$ldest" | sed -e "s/$from/$to/g")
( echo $ldest | grep -q '\.\.' ) && flags="$flags -r"
$DEBUG && echo ln $flags "$lndest" "$lname"
if $passive; then 
    echo ln $flags "$lndest" "$lname"
else
    ln $flags "$lndest" "$lname"
fi
