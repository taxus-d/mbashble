#!/bin/bash

# Andy Spencer - Public domain
#  modified by taxus-d

curdir=`dirname $0`
. "$curdir/../args.fn.sh"

options=''
file_def='-'
file="$file_def"
clipboardp=false

uri="http://vpaste.net/"
post="curl -F"
# post="echo $post"
[ -z $DEBUG ] && DEBUG=false

# Pasting
usage() {
    cat <<EOF
  From a shell
     vpaste <file> [-o <option>=<value>,.. -]
     vpaste <file>
     <command> | vpaste [-o <option>=<value>,..-]
  From Vim
     :map vp :exec "w !vpaste -o ft=".&ft<CR> -
     :vmap vp <ESC>:exec "'<,'>w !vpaste -o ft=".&ft<CR> -
  With curl
      <command> | curl -F 'text=<-' http://vpaste.net/[?option=value,..]
  
  Options
  
  Add ?option[=value],.. to make your text a rainbow.
  
  Options specified when uploading are saved as defaults.
  
  bg, background={light|dark}
      Background color to use for the page
  et, expandtab
      Expand tabs to spaces
  fdm, foldmethod=(syntax|indent)
      Turn on dynamic code folding
  ft, filetype={filetype}
      A filetype to use for highlighting, see above menu for supported types
  nu, number
      Add line numbers
  ts, tabstop=[N]
      Number of spaces to use for tabs when et is set
  ...
      See :help modeline for more information
EOF
}                


handle_flag() {
    case "$1" in
        -h|--help )
            usage
            ;;
        -f|--file )
            eval `make_with_argument`
            file="$2"
            ;;
        -o | --options)
            eval `make_slurpy`
            shift 1
            options=`eval echo $*` #remove one layer of "
            ;;
        -c | --clipboard) #copy text to clipboard
            clipboardp=true
            ;;
        * )
            eval `unknown_flag`
            ;;
    esac
}
parse_args "$@" 
set - $ARGC # anything other will be handled


# yet another usecase
if [[ "$file" == '-' && ! -z "$1" ]]; then
    file="$1"
fi


$DEBUG && echo "file = {$file}"
$DEBUG && echo "opts = {$options}"

out=`$post "text=<$file" "$uri?$options"`
echo "$out"

if [[ -x "`which xclip 2>/dev/null`" && "$DISPLAY" ]] && $clipboardp ; then
  echo -n "$out" | xclip -i -selection primary
  echo -n "$out" | xclip -i -selection clipboard
fi
