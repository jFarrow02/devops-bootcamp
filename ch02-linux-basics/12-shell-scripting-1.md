# Intro to Shell Scripting: Part 1

## Introduction

**Shell scripts** allow you to group Linux commands into files:

- Avoid repetitive work
- Keep configuration history
- Share the files with other developers

**Shell** is the program that interprets and executes the various commands that
we type in the terminal. It translates our commands into commands that the
**kernel** can understand. Various shells available:

- `sh (Bourne Shell)` - /bin/sh
- `Bash (Bourne again shell)` -/bin/bash: Improved, default version of `sh` for
  most UNIX-like systems

## Writing Shell Scripts

- `touch setup.sh`

How does the OS know which version of shell to use when executing a shell
script? We need to tell it!

The **shebang line** tells the OS which shell to use when executing the script.
Points to the interpreter for your shell:

```sh
#!/bin/bash

echo "Setup and configure server"
```

### Adding Execute Permissions

You must explicitly add **execute permissions** for a `.sh` script using the
`chmod` command before the script can be executed.

To execute the script once it's become executable:

`./<script-name>`
