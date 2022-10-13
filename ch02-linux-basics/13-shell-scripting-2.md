# Shell Scripting Part 2: Basic Concepts and Syntax

## Variables

Use variables to store data and reference later. **NOTE:** There must be NO
space around the "=" sign!

### Assign Command Output to Variable

- `config_files=$(ls config)`: save the output of the `ls config` command to a
  variable `config_files`

### Conditional (If/Else) Statements

Allow you to alter the control flow of the program.

```sh

if [ condition ]
then
    # do something...
else
    # do something else...
fi
```

```sh

#!/bin/bash

# Use variables to store data and reference later.

file_name=config.yaml

echo "using file $file_name to configure something"

if [ -d "config" ]
then
    echo "reading config dir contents"
    config_files=$(ls config)
else
    echo "config dir not found. Creating..."
    mkdir config
fi
```

## Basic Operators

### File Conditions

| Command | Use                                                                    |
| ------- | ---------------------------------------------------------------------- |
| -r file | Checks if file is readable; if yes, then condtion becomes true.        |
| -w file | Checks if file is writable; if yes, then condition becomes true.       |
| -x file | Checks if file is executable; if yes, then the condition becomes true. |
| -s file | Checks if file has size > 0; if yes then condition becomes true.       |
| -e file | Checks if file exists; is true even if file is a directory but exists  |

### Number Comparisons

```sh
#!/bin/bash

if [ num_files -eq 10 ]
```

| Command | Use                                                                                                                             |
| ------- | ------------------------------------------------------------------------------------------------------------------------------- |
| -eq     | Checks if the value of two operands are equal; if yes; the condigion becomes true.                                              |
| -ne     | Checks if he value of two operands are not equal; if yes; the condition becomes true.                                           |
| -gt     | Checks if the value of left operand is greater than the value of right operand; if yes, the condition becomes true.             |
| -lt     | Checks if the value of left operand is less than the value of right operand; if yes, the condition becomes true.                |
| -ge     | Checks if the value of left operand is greater than or equal to the value of right operand; if yes, the condition becomes true. |
| -le     | Checks if the value of left operand is less than or equal to the value of right operand; if yes, the condition becomes true     |

### String Operator
