# todo-cli

With this small and simple program, you will never need another program to save your TODOs. It is very simple to use.

```
$ lua init.lua help
cli-todo basic command line interpreter.
-- Help:
- help          : Display this help message.
-- Action:
- add <msg>     : Append <msg> at the bottom of file.
- mark <id>     : Mark msg with <id>, using character 🗸.
- unmark <id>   : UnMark msg with <id>, leaving it as [ ].
- delete <id>   : Delete msg with <id>.
-- List:
- list          : List all msg with correspondent ids.
```

## Use

1. Install Lua
2. Change variable that has the path to the file.
3. Execute.

If you want to it as a command, you can add it to `.zshrc` or `.bashrc`.

```
export TODO_FILE="$HOME/Documents/todo-cli/init.lua"

alias todo-help='lua $TODO_FILE help'
alias todo-add='lua $TODO_FILE add'
alias todo-mark='lua $TODO_FILE mark'
alias todo-unmark='lua $TODO_FILE unmark'
alias todo-delete='lua $TODO_FILE delete'
alias todo-list='lua $TODO_FILE list'

echo "THINGS TO DO:\n"
echo "---------------"
todo-list
```

Of course, you can change it as you want.
