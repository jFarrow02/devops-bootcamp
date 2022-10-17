# Jenkinsfile Syntax

`Jenkinsfile`:

```groovy
def gv

pipeline {

    agent any

    parameters {
        choice(name: 'VERSION', choices: ['1.1.0', '1.2.0', '1.3.0'], description: 'some version choices')
        booleanParam(name: 'executeTests', defaultValue: true, description: '')
    }
    // Define env vars
    environment {
        NEW_VERSION = '1.3.0'
        // SERVER_CREDENTIALS = credentials('server-credentials') // Bind credentials to env var
    }

    tools {
        maven 'maven-3.8.4(default)'
    }
    stages {

        stage("init") {
            steps {
                script {
                    gv = load "script.groovy"
                }
            }
        }

        stage("build") {
            steps {
                script {
                    gv.buildApp()
                }
            }
        }

        stage("test") {
            // Conditional; execute steps only when condition is true
            when {
                expression {
                    BRANCH_NAME == 'dev' || BRANCH_NAME == 'master'
                }
            }

            when {
                expression {
                    params.executeTests == true
                }
            }
            steps {

            }
        }

        stage("deploy") {
            input {
                message "Select the deployment environment:"
                ok "Done"
                parameters {
                    choice(name: "ENVIRONMENT", choices: ['dev', 'staging', 'prod'], description: "")
                }
            }
            withCredentials([
                usernamePassword(credentialsId: 'server-credentials', usernameVariable: 'USER', passwordVariable: 'PWD')
            ])
            {
                sh "some script ${USER} ${PWD}"
                echo "Deploying to ${ENV}"
            }
            <!-- echo "deploying with ${SERVER_CREDENTIALS}..." -->
        }
    }

    post {
        always {

        }

        success {

        }

        failure {

        }
    }
}
```

## Attributes

1. `post`: executes some logic/scripts after all the stages are done

   - `always`: logic always executes regardless of pipeline success/failure
   - `success`: logic executes only on success
   - `failure`: executes only on failure

2. **Conditionals** for each stage: execute logic when a certain condition is
   true

3. **Environmental variables**

   - location for available env vars provided by Jenkins: /env-vars.html
   - Define your own in `environment`

4. **Using Credentials in Jenkinsfile**:

   - Define credentials in Jenkins GUI
   - `credentials("credentialId") binds the credentials to your env var:

   ```groovy
    pipeline {

        agent any
        environment {
            NEW_VERSION='1.2.3'
            // Bind SERVER_CREDENTIALS to the value of 'server-creds-id`
            SERVER_CREDENTIALS = credentials("server-creds-id")
        }

        // ...
            stage("deploy") {
                steps {
                    script {
                        sh "cat ${SERVER_CREDENTIALS} > file.txt"
                    }
                }
            }

            // Use withCredentials to access credential variables to access creds in one stage
            stage("deploy again") {
                steps {
                    script {
                        withCredentials(
                            [
                                usernamePassword(
                                    credentialsId: "server-creds-id",
                                    usernameVariable: "USR",
                                    passwordVariable: "PWD"
                                )
                            ]
                        ) {
                            // Do something with credentials (e.g. deploy docker image, etc.)
                        }
                    }
                }
            }
    }

   ```

   - For that you need "Credentials Plugin" & "Credentials Binding" plugin (?)

5. `tools`: access build tools for your projects

   - currently, only Gradle, Maven and JDK supported by `tools` attribute
   - Jenkins > Global Tool Configuration > find name of desired tool and provide
     to `tools` attr

6. **Parameters**: Allow users to make selections to modify/customize the build
   (think dropdown menus to select environment, etc.).

   - string(name, defaultValue, description)
   - choice(name, choices, description)
   - booleamParam(name, defaultValue, description)

Parameters are suitable for **expressions** in Jenkinsfile:

```groovy

pipeline {
    agent any
    parameters {
        booleanParam(name: 'executeTests', defaultValue: true, description: '')
    }

    stages {
        //...

        stage("test") {
            when {
                expresssion {
                    params.executeTests == true
                }
            }
        }
        steps {
            // Do this when params.executeTests is true
        }
    }
}
```

Executing the Jenkins job with "Build with Parameters" option will allow you to
build the project and select the desired parameters to pass to the pipeline
build.

## Using External Groovy Scripts

You can load external Groovy scripts (see above for example)

## Replaying a Build

Use the "Replay" button to edit scripts **inside Jenkins' GUI** for testing
changes and replaying builds

## Input Parameters in Jenkinsfile

You can configure Jenkins to allow users to **input** parameters for an
execution step: - Allow users to select which env to deploy build artifact -
Allow users to input which version of artifact to deploy - etc.
