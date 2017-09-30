#!/bin/sh
notify-send "$1"
echo $0 \"$1\" \"$2\" | at now + $2
