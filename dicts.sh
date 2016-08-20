#!/bin/sh

# quick-and-dirty a bit
# dict is list of newline-separated strings
# escaped are characters special
# like that:
#   key1:value1:dvhxj,,;/:
#   key2:val2;.;:::mmm
# and so on
# only first colon is taken into account

# fixing echo (some shells enable -e flag by default

echolines=$(echo "a\nb" | wc -l) 
case "$echolines" in
    2 ) 
        _echo() {
            NL="\n"
            [ "$1" = '-n' ] && { NL=''; shift; }
            printf "%s$NL" $*
        }
        _echo_e() { echo $*; }
        ;;
    1 )
        _echo() { echo $*; }
        _echo_e() { echo -e  $*; }
        ;;
    * )
        echo "Something went wrong"
        exit 1
        ;;
esac

# escapes a string in a simple way
shellescape() {
    str="$1"
    # not extended `echo' here! 
    esc_str=$(_echo "$str" | sed 's/\\/\\\\/g')
    _echo "$esc_str"
}

# dict_get <dict string> <key>
# gets value by the key
dict_get() {
    dict="$1"
    key="$2"
    val=`_echo_e "$dict" | sed -n "s/^${key}://p"`
    _echo_e "$val"
    return $?
}

# dict_put <dict string> <key> <value> 
dict_put() {
    dict="$1"
    key="$2"
    value="$3"
    # check if key exists
    _echo_e "$dict" | grep -q "^${key}:" && { _echo "$dict"; return 1; }
    # magic with newlines to handle empty dict
    [ ! -z "$dict" ] && _echo -n "$dict\n"
    # shellescape here protects strings from
    #+ extended echo, when we are doing lookup 
    _echo -n "${key}:$(shellescape "${value}" )"
    return $?
}

dict_print() {
    _echo_e -n "$1"
}

# dict_keys <dict string>
dict_keys() {
    dict="$1"
    _echo_e "$dict" | sed 's/:.*$//'
    return $?
}

# testing area
if [ "$0" = "./dicts.sh" ]; then
    echo == testing _echo == 
    echo '_echo   "a\\nb": ' 
    _echo "a\nb"
    echo '_echo_e "a\\nb": ' 
    _echo_e "a\nb"

    echo == testing dict funcs ==
    dict="a:foo\nb:bar"
    dict_get "$dict" b
    dict=`dict_put "$dict" c 'baaz\nk\te ek\\' `
    _echo "$dict"
    _echo_e "$dict"
    dict_get "$dict" c
    dict_keys "$dict"
fi

