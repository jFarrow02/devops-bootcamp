# Docker Best Practices

1. Use official Docker images as Base Image

2. Avoid using the "latest" tag. Fixate/specify the version. The more specific, the better.

3. Avoid using images based on full-blown operating system distros:
    - Larger in size
    - Larger surface area for security vulnerabilities
    - `alpine` versions preferred

4. Optimize caching image layers. **Order commands in dockerfile from least to most frequently changing.** Running the `COPY` command for `package.json` makes subsequent copy and run commands execute only on change of `package.json`:

```dockerfile

FROM node:17.0.1-alpine

WORKDIR /app

COPY package.json package-lock.json .

RUN npm install --production

COPY myapp /app

CMD ["node", "src/index.js"]
```

5. Exclude unnecessary files with `.dockerignore` file. Docker will ignore files in `.dockerignore` when building the image:

`.dockerignore`:
```
# ignore .git and .cache folders
.git
.cache

# ignore all markdown files
*.md

# ignore sensitive files
private.key
settings.json
```

Exclude build dependencies from final image while still having them available during the image build with **multi-stage builds**:

6. Don't run Docker containers as root user (default behavior). Could allow hackers to operate as root user **on host machine**.

Create a dedicated user and group with least privileges when building the image:

`dockerfile`:

```dockerfile

# create group and user with linux commands
RUN groupadd -r tom && useradd -g tom tom

# set ownership and permissions
RUN chown -R tom:tom /app

# switch to user
USER tom

CMD node index.js
```

7. Validate built image for security vulnerabilities:
    - Scan image for vulnerabilities using `docker scan <image-name>:<tag>