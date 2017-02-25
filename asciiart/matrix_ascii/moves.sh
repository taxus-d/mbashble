#!/bin/bash

move_to() {
    x=$1
    y=$2
    echo -ne "\\033[${y};${x}H"
}
move_up() {
    h=$1
    echo -ne "\\033[${1}A"
}
move_down() {
    d=$1
    echo -ne "\\033[${1}B"
}
move_back() {
    b=$1
    echo -ne "\\033[${b}D"
}
save_pos() {
    echo -ne '\033[s'
}
load_pos() {
    echo -ne '\033[u'
}

