# Basic Linux Commands

`username@computer-name:~$`: the tilde (`~`) represents the user's home
directory. `$` means that the user is a regular (non-super) user; for super user
this would be a `#`.

- `pwd`: "print working directory". Prints current fs location.

- `ls`: List files in current directory
- `ls -R <dirname>`: Displays contents of <dirname> recursively
- `ls -la`: Display hidden files/directories

- `cd <dirname>`: Change directory to <dirname>

- `mkdir <dirname>`: create a new directory <dirname>

## File Operations

- `touch <filename>`: Create a new file <filename> in current directory

- `rm <file/dirname>`: Delete file or directory - `rm -r <dirname>`: Remove
  directories recursively

- `cd /`: Navigate to root folder

### Everything in Linux is a File

Text documents, pictures, directories, commands likd `pwd`, devices:
**EVERYTHING** is a file. You can copy them, move them, display their contents,
etc.

## Navigating the File System

- `cd <file-path>`: Navigate to <filepath>
- `cd <absolute-path>`
- `cd <relative-path>`
- `cd ~`: Navigate to user's home dir

## Additional File Operations

- `mv <old-location> <new-location>`: Moves/changes file/dir name

- `cp <current-file> <new-file>`: Copies current file to new location
- `cp -r <current-dir> <new-dir>`: Copies directory to new location

- `history`: Gives a list of all past commands typed in the current terminal
  session

### Useful Key Commands

- `CTRL + r`: Allows you to search previous commands

- `CTRL + c`: Kill current process running in terminal

- `CTRL + SHIFT + v`: paste text in terminal

### Display contents of a File

- `cat <filename>`: Display contents of a File

## Display OS Information

- `cat /etc/issue`: Display OS name and version information

- `uname -a`: Display system information and kernel

- `cat /etc/os-release`: Display OS information

- `lscpu`: Display detailed cpu info

- `lsmem`: Display info for system memory

## Executing Commands as a Superuser

To execute commands as the `root` user, append `sudo` to the command.
