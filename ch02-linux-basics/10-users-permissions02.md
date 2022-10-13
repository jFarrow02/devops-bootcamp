# Linux Accounts & Groups (Users and Permissions): Part 2

## Ownership and File Permissions

User permissions are related to reading, writing, and executing files.

- `ls -l`: List files and permissions for each file in directory
- `ls -la`: List all files including hidden files

### Ownership

**Ownership** means: "Who owns the file/directory?" For a file, the owner is the
user, group is the primary group for that user.

#### Change Ownership of a File

- `sudo chown <username>:<groupname> <filename>`
- `sudo chown <username> <filename>`: Change user to <username> (group name
  defaults to username)
- `sudo chgrp <groupname> <filename>`: Change group only

## File Permissions

Aside from **ownership** of a file/directory, you can also change the
**permissions**:

File Type:

- "-" regular file
- "d" directory
- "c" charactore device file = "l" symbolic link

`d rwx rwx r-x` d [user/owner] [group] [other]

- r read
- w write
- x execute a script/executable
- - no permission

### Modifying Permission Values

#### `chmod`

- `sudo chmod -x <filename>`: remove execute permission for all owners

- `sudo chmod g-w <filename>`: remove write permission for the **group**

- `sudo chmod g+x <filename>`: ADD execute permission for the **group**

**Note:** substitute `u` for user, or `o` for others where `g` is used in the
above commands.

#### Change Multiple Permissions for One Owner

- `sudo chmod g=rwx <filename>`: Set all three permissions for group on
  <filename>

- `sudo chmod 700 <filename>`: Add all permissions for user, no permissions for
  group and others on <filename>

`Absolute (Numeric) Mode`:

| Number | Permission Type        | Symbol |
| ------ | ---------------------- | ------ |
| 0      | No Permission          | ---    |
| 1      | Execute                | --x    |
| 2      | Write                  | -w-    |
| 3      | Execute + Write        | -wx    |
| 4      | Read                   | r--    |
| 5      | Read + Execute         | r-x    |
| 6      | Read + Write           | rw-    |
| 7      | Read + Write + Execute | rwx    |
