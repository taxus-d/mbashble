# not so grand bash tutorial

## useful cmd's
* `ps -aux` - pids
* `kill -9` kill by **PID**
* `wc -l` - number of lines
*  `ed <filename> <<! ` - create file filled with lines from stdin
* `tee f1` - where to log
* `tail -<n>` - do with last n lines
* `eval` - just evals input string  
* ``a=`expr $a + $b` `` - do numeric
* `echo expr param : par` and also not numeric
(will produce 
> 4
)
*


-----------

## simple operators 

- `cmd1;cmd2`
- `cmd &` - выполнение команды в фоне
- `cmd1 && cmd2` , `cmd1 || cmd2` - понятно что

### groups
- `{cmd1;cmd2};cmd3`
- `(cmd1;cmd2);cmd3` эта еще отрывает новый shell внутри скобок со своей атмосферой

## std files
* 0 - stdin
* 1 - stdout
* 2 - stderr
e.g 
```bash    
    some_buggy_script 2>somefile
    script 1>&2 #stdin to stderr
```
##shell - patterns
* ` * ` -- anything
* `?` -- 1 symbol
* `[a-d]` -- from group
##assigment
* `var="www"`
* `` dat=`date` ``
* `echo "param"; read x`
echo `${a}param` - to prevent concatanation of var. name with word

## screening
this code
```bash
    a=1;b=5;c=6
    d="$a + $b + $c"
    e='$a + $b'
    f=\$a
    echo $d $e $f
```
will produce:
> 1 + 5 + 6 $a + $b $a

## conditional assignment
* `${x-new}` - will return 'new' as value of x
* `${x=new}` - will assign 'new' as value of x
* `${x?new}` - will return 'new' as value of x
* `${x+new}` - will return 'new' if x was assigned before
and '' otherwise

`export` make variable visible for all born processes
## command-line args
* `$n` - arg
* `set` command
```bash
    set `date`
    echo $1 $3 $5
```
##special vars
* `$0` - script name
* `$!` - number of background process
* `$$` - number of a process
* `$?` - returned code of last process
* `$#` - number of args
* `$*` - args as a string
* `$@` - args as words
* `$-` - flags






