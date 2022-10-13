# Package Managers on Linux

Most software in Linux is installed using a **package manager**.

## What is a Package Manager?

A **software package** is a compressed archive containing the required files for
the software to run. However, software often requires other dependencies to run.
Installing software on Linux is complicated because the files are split across
different folders. Managing apps, like uninstalling everything completely, is
more difficult.

A **package manager** downloads, installs, and updates existing software from a
repository. It ensures the integrity and authenticity of a package, and manages
and resolves all required dependencies. It knows wehre to put all the files in
the Linux file system.

Every Linux distribution already includes a package manager. For Ubuntu, its
`apt` ("Advanced Package Tool").

## Manage Software with `apt`

- `apt`: List commands for apt package manager

- `sudo apt search <package-name>`: search for a package on `apt`

### Install a Package

- `sudo apt install <package-name>`: install package <package-name>

### Uninstall a Package

- `sudo apt remove <package-name>`

## `apt` vs `apt-get`

`apt-get` is a packagae manager that is available on Ubuntu systems alongside
`apt`:

| `apt-get`                                               | `apt`                                     |
| ------------------------------------------------------- | ----------------------------------------- |
| requires additional command options, less user-friendly | more user friendly, fewer command options |
| search command not available                            | recommended by Linux                      |

## Repositories

Where does the package manager **find** the software and dependencies it
installs?

Linux uses **repositories**, storage locations containing thousands of programs,
mostly hosted online. The package manager fetches the packages from these
repositories.

The repositories for the system package manager are stored in
`/etc/apt/sources.list`.

### Update the Local Package Index

- `sudo apt update`: Pulls the latest from the package manager repository

## Alternate Ways to Install Software

You may need to install software in a different way, for the following reasons:

1. The package isn't available in the official repo
2. The latest package version may not be available in the repository

Alternatives Include:

### Ubuntu Software Center

Use the **Ubuntu Software Application** GUI tool.

### Snap Package Manager

`snap` is a software packaging and deployment tool for Linux systems.

- `snap`: List available commands for `snap`. Snap uses self-contained packages
  to install applications, including all the dependencies.

- `sudo snap install <package-name>`: Install package <package-name>

#### Snap vs. Apt

| `snap`                                                 | `apt`                                                       |
| ------------------------------------------------------ | ----------------------------------------------------------- |
| Self-contained; dependencies contained in the package  | Dependencies are shared/distributed across multiple folders |
| Supports universal Linux packages (package type .snap) | Only for specific Linux distributions (package type .deb)   |
| Automatic updates                                      | Manual updates                                              |
| Larger installation size                               | Smaller installation size                                   |
| Shared dependencies **duplicated**                     | Shared dependencies installed **once** and re-used          |

**Prefer `apt` over `snap` when you have the choice on Linux.**

### Adding a Repository to Official List

To add a new repository to the official list (at `/etc/apt/sources.list`)

## Package Managers for Other Linux Distros

Not all Linux distros use `apt`, however Linux distros based on the same source
code use the same manager. **Debian** based distros such as Ubuntu, Debian, and
Mint use `apt` and `apt-get`. **Red Hat** based distros like RHEL, CentOS, and
Fedora use `yum` package manager. Even though the package managers are
different, the concepts are similar. However, the repositories may differ.
