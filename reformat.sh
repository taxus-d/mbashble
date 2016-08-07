#!/bin/ash

#acfile="/mnt/ext1/system/profiles/iliya/config/Active\ Contents/Tamm-Osnovi-elektrichestva.djvu_D_4268253e8acd9510dc388dcc3f5a5553.html"
# acfile="../../../system/profiles/iliya/config/Active Contents/Tamm-Osnovi-elektrichestva.djvu_D_4268253e8acd9510dc388dcc3f5a5553.html"
acfile="Tamm-Osnovi-elektrichestva.djvu_D_4268253e8acd9510dc388dcc3f5a5553.html"
tmpfile="../../../tmp/actmp.txt"

# loading dictionaries support in shell
. ./dicts.sh 
cells= # main dictionary

# extracts keys for the dictionary
# extract <huge string>
extract() {
    str="$1"
    _echo "$str" | sed 's/<[^>]+>//'
}

# dumps cells at the end of a table
dump_cells() {
    keys=$(dict_keys "$cells")
    keys_srtd=$(echo "$keys" | sort)
    echo "$keys_srtd" | while read key; do
        dict_get "$cells" "$key"
    done 
}

# regexes for grep
TBL_B='<table\([[:space:]]\+[[:alnum:]]\+="\?[[:alnum:]]\+"\?\)*[[:space:]]*>' # abstract enough, totally useless however 
TBL_E='</table>'
CELL_B='<tr><td>'
CELL_E='</tr></td>'

# abstract layer for regex matches ( grep || expr || sed ... )
# matches <string> <regex>
matches() {
    string="$1"
    regex="$2"
    echo "$string" | grep -q "$regex"
    return $?
}

# main loop
# 0 -- default mode
# 1 -- inside table
# 2 -- inside cell
state=0
cell_rec=
while read line; do
    case $state in
        0 )
            echo "$line"
            if matches "$line" "$TBL_B"; then
                state=1
            fi
            ;;
        1 )
            if matches "$line" "$TBL_E"; then
                state=0
#                 dump_cells
                echo "$line"
            elif matches "$line" "$CELL_B"; then
                state=2
                cell_rec="$line"
            fi
            ;;
        2 ) 
#             cell_rec="$cell_rec\n$line"
            if matches "$line" "$CELL_E"; then
                state=1
#                 key=$(extract "$cell_rec")
#                 dict_put "$cells" "$key" "$cell_rec"
            fi
    esac
done < "$acfile"
# vim: fo+=ro
