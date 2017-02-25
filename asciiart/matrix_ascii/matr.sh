#!/bin/bash
###################################
#main()
. common.sh
clear
while true; do
    #printf "$(symtype)\n"
    ./draw_spark.sh
    ./erase_spark.sh
    ./erase_spark.sh
done
###################################

