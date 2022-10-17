# Intro to Multibranch Pipelines

In real-life, multi-branch development workflows, a CI/CD pipeline should have:

1. Pipelines for **all** branches in SCM
2. **Different behavior** based on branch (main branch should deploy on success,
   feature branches should not deploy, etc.)

How to achieve these goals?

## Create a Multibranch Pipeline

Whenever a new branch is **created** in SCM, a new **pipeline** should be
created in Jenkins.

### How to Create a Multibranch Pipeline

1. Dashboard > New Item > Multibranch Pipeline > Branch Sources > Add Source
2. Git > {add repo name and credentials} > Discover branches > Filter by Name
   with regular expression
3. Can use regex to define which branches to discover, "\*" to discover all
   branches
4. Build Configuration > Mode > by Jenkinsfile
5. Jenkins will scan each branch with a Jenkinsfile and discover it

### Branch-based Logic for Multibranch Pipeline

Add logic to Jenkinsfile that determines whether to execute a stage based on
**which branch** is currently building:

`Jenkinsfile`:

```groovy

pipeline {

    stages {

        stage("test") {
            steps {
                script {
                    echo "Testing the application..."
                    echo "executing pipeline for branch $BRANCH_NAME"
                }
            }
        }

        stage("build") {
            when {
                expression {
                    BRANCH_NAME == "master" // env var available for all multibranch pipelines; holds currently-building branch name
                }
            }
            steps {
                script {
                    echo "Building the application..."
                }
            }
        }

        stage("deploy") {
            when {
                expression {
                    BRANCH_NAME == "master" // env var available for all multibranch pipelines; holds currently-building branch name
                }
            }
            steps {
                script {
                    echo "Deploying the application..."
                }
            }
        }
    }
}
```

- Scan Multibranch Pipeline Now --> executes and builds all branches
- Add a new remote branch > Scan Multibrancgh Pipeline Now --> Jenkins
  automatically detects new branch
