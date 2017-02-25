#!/bin/bash
. moves.sh
. common.sh

x=$(( $(./random.sh) % $WIDTH  ))
y=$(( $(./random.sh) % $HEIGHT ))

move_to $x $y

echo -ne '\033[?25h' # make cursor visible
for t in $(seq $SPARK_LEN); do
    echo -ne '\033[0;32m' #green    
    printf "$(symtype)"
    move_back 1
    move_down 1
    echo -ne '\033[1;36m' #bright cyan    
    printf "$(symtype)"
    move_back 1
    sleep $DELAY
done
#echo -ne '\033[0;32m'
#printf "$i"
