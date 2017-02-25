#!/bin/bash

str=$(cat /dev/urandom | head -3)
num=$(echo $str | wc -c )
echo $num
