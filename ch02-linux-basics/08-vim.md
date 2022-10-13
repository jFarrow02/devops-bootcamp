# Vi and Vim Text Editor

## Introduction

Text editors like **Vim** allow us to edit files inside the terminal. Comes
packaged in most Linux distributions.

### Why use a Terminal Text Editor?

- Small modifications can be faster
- Faster to create and edit at the same time
- Supports multiple file formats
- Sometimes you have to edit a file while working on a remote server (no GUI
  editor available)

## Working with Vim

To install Vim:

- `sudo apt install vim`

Vim has two modes:

1. Command mode: **Default** mode. You cannot **edit text**; whatever you type
   is interpreted as a **command**.

2. Edit/Insert Mode: Allows you to enter text.

### Important Vim Commands

**Open a file**: `vim <filename>`

#### Switch to Insert Mode

- press `i` key

#### Exit Insert Mode

- press `esc` key

#### Save and Close File

- `:wq`

#### Close File w/o Save:

- `:q!`

### Additional Commands

#### Delete a Line in Command Mode

- `esc + dd`
- `esc + d10 + d`: Remove 10 lines

#### Undo a Command:

- `u`

#### Jump To

- `esc + A` jump to end in insert mode
- `esc + 0`: jump to start and enter insert mode
- `esc + <line-number>G`: jump to line number

#### Search

- `/<pattern>`: search for <pattern>

- `n`: jump to next match

- `N`: jump to previous match

#### Replace

- `:%s/<oldstring>/<newstring>`: Replace old string with new string
