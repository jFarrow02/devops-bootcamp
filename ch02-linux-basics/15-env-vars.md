# Environment Variables

## What are Environment Variables?

Each Linux user has its own **environment**, where it can execute commands. Each
uiser can configure its own environment/account by setting preferences. These OS
congigs should be isolated from **other user environments**.

**Where does the OS store all these configurations**? In **environment
variables**, key/value pairs availabled for the whole environment.

By convention, env var names are defined by UPPER CASE. Users can change the
values of the env vars.

## Accessing Environment Variables

### List all Env Vars

-`printenv`

### List Specific Env Vars

- `printenv <VAR-NAME>`
- `printenv | grep <VAR-NAME>`
- `echo $<VAR-NAME>`

## Application Env Vars

### Use Cases of Env Vars

1. Sensitive Data for Application: A common use case for env vars is storing
   sensitive information (e.g. authentication credentials) without checking it
   into SCM. Every programming language has a syntax/library for accessing
   environment variables on a host.

2. Storing data for use in multiple environments (e.g. testing, dev,
   production). You can dynamically set these values using env vars without
   changing code.

## Creating Env Vars in Linux

- `export ${VAR_NAME}={value}`

## Delete Env Vars in Linux

- `unset ${VAR_NAME}`

## Persisting Env Vars for the USER

Note that setting environment variables in the manner above (using `export`
command) will **not** persist the variables beyond the **current terminal
session**! For that, you must modify the `.bashrc` file (or the `rc` file for
whatever the default shell is for the current user {.zshrc, etc.}).

You can do this by adding the env var at the end of the `rc` file as an
`export`:

`.bashrc`

```sh
#!/bin/bash
# ...

export $DB_USER=username
export $DB_PASSWORD=password
```

You must then run `source ~/.bashrc` in the terminal to load the new env vars
into the current shell session. The variables will now be persisted if you close
the terminal, and in any session.

## Persisting Env Vars Systemwide

What if we want to set env vars for **all users on the system**?

There is a a **systemwide** env var file located in `/etc/environment`. It
contains one global var called `PATH`. PATH is a list of diectories to
executable files, separated by `:`. Tells the shell which directories to search
for the executable in response to our executed commands (`java`, `python`,
etc.). This allows us to use these commands/execute these binaries **without
knowing/typing the full file path to the binary**!

### Add a Custom Command/Program to `PATH`

`welcome.sh`

```sh
#!/bin/bash

echo "Welcome to DevOPs Bootcamp $USER
```

- `chmod a+x welcome`

Add to PATH for ONE user:

- `nano ~/.bashrc`
- Append to end of `.bashrc` file: `PATH=$PATH:/home/{user}/{file-directory}`
- Save and quit
