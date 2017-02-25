#!/bin/bash
. moves.sh
. common.sh

x=$(( $RANDOM % $WIDTH  ))
y=$(( $RANDOM % $HEIGHT ))

move_to $x 0

echo -ne '\033[?25l' # make cursor invisible 
for t in $(seq $ERASE_LEN); do    
    i=' '
    printf "$i"
    move_back 1
    move_down 1    
    sleep $SHORT_DELAY
done
