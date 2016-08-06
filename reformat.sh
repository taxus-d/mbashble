#!/bin/ash

#acfile="/mnt/ext1/system/profiles/iliya/config/Active\ Contents/Tamm-Osnovi-elektrichestva.djvu_D_4268253e8acd9510dc388dcc3f5a5553.html"
acfile="../../../system/profiles/iliya/config/Active Contents/Tamm-Osnovi-elektrichestva.djvu_D_4268253e8acd9510dc388dcc3f5a5553.html"
tmpfile="../../../tmp/actmp.txt"

# loading dictionaries support in shell
. dicts.sh 
# current dicts does not support multiline
#+ values, so, i'm going to store line numbers
# UPD: fixed all multiline stuff, no need for 
#+ storing numbers

# main loop
in_table=0
in_cell=0
while read line; do
    echo "$line"
done < "$acfile"
# vim: fo+=ro
