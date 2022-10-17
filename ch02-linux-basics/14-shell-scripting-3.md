# Shell Scripting Part 3: Functions

**Functions** are ways of grouping overall functionality of a script into
smaller, logical code blocks. The block can then be referenced anywhere in the
script multiple times.

```sh
#!/bin/bash

function score_sum {
    sum=0
    while true
        do
            read -p "enter a score: " score

        if [ "$score" == "q" ]
        then
            break
        fi

        sum=$(($sum+$score))
        echo "total score: $sum"

        done
}
```

## Pass Parameters to a Function

```sh
#!/bin/bash

function create_file() {
    file_name=$1
    is_shell_script=$2
    touch $file_name
    echo "File $file_name created"

    if [ "$is_shell_script" = true ]
    then
        chmod u+x $file_name
        echo "added execute permission"
    fi
}

create_file test.txt
create_file myfile.yaml
create_file myscript.sh true
```

## Returning Values from Functions

```sh

#!/bin/bash

function sum() {
    total=$(($1+$2))
    return $total
}

# result=$(sum 2 10)
# OR
sum 2 10
result=$? # Captures the value returned by last command

```
