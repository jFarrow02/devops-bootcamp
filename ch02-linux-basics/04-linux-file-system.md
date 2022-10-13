# The Linux File System

The **Linux File System** is a hierarchichal tree structure. The `root` folder
is the "root" under which all other folders are grouped. In contrast, Windows
has multiple root folders (`A:`, `B:`, `C`...).

## Folder Structure

- `/home`: Contains the folders for all the users for the system except for the
  `root` user. Each user in Linux has its own space and configuration.

- `/bin`: Contains basic Linux commands and executables that are available
  **system-wide**. `bin` stands for "binary" (computer-readable format
  executable by the machine).

- `/sbin`: Contains binaries for the **system**, that need a super user to
  execute them (e.g. `adduser`).

- `/lib`: Contains share libraries that executalbes from `/bin` or `/sbin` use.
  In Linux, one program can be split into multiple locations (such as having the
  executable/binary in `/bin` and libraries for the binary in `/lib`).

- `/usr`: Duplicates `/bin` and `/sbin` for historical reasons. When we execute
  commands in the terminal they usually execute from the `/usr` dir.
  `/usr/local` contains the programs that **YOU** as a Linux user install on the
  computer: docker, minikube, java, etc... Note that `/usr` is installed nested
  inside root, so all programs will be available system-wide.

  - `/opt`: Third-party programs that you install that **do not** split their
    code across multiple directories (e.g. most IDEs, web browsers etc.).
    Anything installed here is system-wide (available for all users).

- `/boot`: Contains files required for booting up system (DO NOT TOUCH)

- `/etc`: Contains writable system configurations (users/passwords, network
  configuration, etc.).

- `/dev`: Location of device files, like webcam, keyboard, hard drive, etc. Apps
  and drivers access this folder, not the user.

- `/var`: Contains files to which the system writes system logs, caches etc.

- `/tmp`: Stores temporary resources required for some processes.

## Hidden Files in Linux

Some files in Linux are **hidden by default**. This is primarily used to help
prevent important data from being accidentally deleted. They are auto-generated
by programs and/or the OS, and are preceded by a `.`.
