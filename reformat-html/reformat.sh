#!/bin/ash

#acfile="/mnt/ext1/system/profiles/iliya/config/Active\ Contents/Tamm-Osnovi-elektrichestva.djvu_D_4268253e8acd9510dc388dcc3f5a5553.html"
#acfile="../../../system/profiles/iliya/config/Active Contents/Tamm-Osnovi-elektrichestva.djvu_D_4268253e8acd9510dc388dcc3f5a5553.html"
acfile="log.txt.html"
tmpfile="../../../tmp/actmp.txt"


# adding dictionaries support to shell
. dicts.sh
cells= # main dictionary

# ----------------------------------------------
# a few words on pocketbook content files
# ----------------------------------------------
# Overview
# ========
# Content file is HTML. Not an XML. I don't 
# know why. Looks not so pleasant, especially
# additional tags in HTML comments.
#
# A record is a cell in an HTML table.
# Every record is preceded by an HTML comment with
# properties that are significant for PB.
#
# Most important properties
# =========================
#
# ** type **
#  ********
# 1   -- part of TOC 
# Tip: One may build custom TOC by simply creating records with
#+ type="1" and proper level
# 2   -- kek knows
# 4   -- Bookmark
# 8   -- kek knows
# 16  -- Pen
# 32  -- Marker
# 64  -- Comment
# 128 -- Snapshot
#
# ** position **
#  ************
# in fb2, txt, anything that fbreader can handle
# -- some weird number
# in epub -- named part of inner html
# in pdf  -- smth like #pdfloc(...)
# in djvu -- page number
#
# AC tries to order records by their position.
# However, the last method might behave strange.
# In my case it attempted to place nodes in the 
#+ reversed order relatively to how I create them,
#+ except ones on the same page.
#
# ** endposition **
#  ***************
# end of 16,32,64
# 
# ** level **
#  *********
# seems to have any meaning only for type 1
#
# ** imglink **
#  ***********
# sets path to preview image for types 128, 16
#
# ** svgpath **
#  ***********
# sets path to svg for type 16 (pen is a set of points and 
#+ straight lines, therefore quality is quite low)
# 
# Summary of valid options for types
# =================================
# Note: an option might be valid, but doesn't have much sense,
#+ like a level for pen
# | type | pos | end | lev | iml | svg | 
# |------|-----|-----|-----|-----|-----|   
# | 1    |  +  |  -  |  +  |  -  |  -  | TOC
# | 2    |  ?  |  ?  |  ?  |  ?  |  ?  | 
# | 4    |  +  |  -  |  +  |  -  |  -  | BM  
# | 8    |  ?  |  ?  |  ?  |  ?  |  ?  |   
# | 16   |  +  |  +  |  +  |  +  |  +  | Pen  
# | 32   |  +  |  +  |  +  |  -  |  -  | MRK  
# | 64   |  +  |  +  |  +  |  -  |  -  | CMT  
# | 128  |  +  |  -  |  +  |  +  |  -  | SS  
# 
# Moral
# =====
# The following script might be useful only
#+ when djviewer is in action. Or if standard
#+ ordering have somehow failed.
# ----------------------------------------------

# extracts keys for the dictionary
# extract <huge string>
extract() {
    str="$1"
    entry='^<tr><td>\\n<!-- type="128" level="[[:digit:]]*" position="\([[:digit:]]*\)" imglink="[^"]*"\\n \?--!>\\n<b><font color="[^"]*" size="[[:digit:]]*" face="[^"]*"><div style="[^"]*">\([^<]*\)<\/div><\/font><\/b><br>.*$'
    _echo "$str" | sed -n "s/${entry}/\\1\.\\2/p" \
        | awk -F '.' '{printf "%05d%04d%03d", $1, $2, $3}'
}

# dumps cells at the end of a table
dump_cells() {
    keys=$(dict_keys "$cells")
    keys_srtd=$(echo "$keys" | sort )
    echo "$keys_srtd" | while read key; do
        dict_get "$cells" "$key"
    done 
}

# regexes for grep
TBL_B='<table\([[:space:]]\+[[:alnum:]]\+="\?[[:alnum:]]\+"\?\)*[[:space:]]*>' # abstract enough, totally useless however 
TBL_E='</table>'
CELL_B='<tr><td>'
CELL_E='</td></tr>'

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
# adding extra newline
{ cat "$acfile" && echo; } | while read -r line; do
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
                dump_cells
            elif matches "$line" "$CELL_B"; then
                state=2
                cell_rec="$line"
                continue
            fi
            echo "$line"
            ;;
        2 ) 
            cell_rec="$cell_rec\n$line"
            if matches "$line" "$CELL_E"; then
                state=1
                key=$(extract "$cell_rec")
                [ -z "$key" ] || cells=$(dict_put "$cells" "$key" "$cell_rec")
            fi
    esac
done
# vim: fo+=ro
