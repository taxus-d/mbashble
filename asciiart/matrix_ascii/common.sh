#!/bin/bash
symtype() {
    echo "\\$(printf '%03o' $(( $RANDOM % 93 + 33 )))"
}
set -- $(stty size)
LINES=$1
COLUMNS=$2
WIDTH=$COLUMNS
HEIGHT=$(($LINES / 4 ))
SPARK_LEN=$(($LINES - $HEIGHT ))
ERASE_LEN=$LINES
DELAY=0.05
SHORT_DELAY=0.001

