# Create Git Repo for Local Terraform Project

Create a new Git repository so that:

- Safekeeping
- History of changes
- Team collaboration

- `git init`: Initialize a new git repo in your local project directory.

- `git remote add origin {repo-url}`

- `touch .gitignore`: Create a `.gitignore` file and ignore the following
  files/folders:

`.gitignore`:

```
# local .terraform dir
.terraform/*

# tf state files
*.tfstate
*.tfstate.*

# tf variable files, may include sensitive data
*.tfvars
```

- `git add` and `git commit` all non-ignored files. `git push` your changes to
  the repository.
