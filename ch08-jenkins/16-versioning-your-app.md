## Dynamically Increment Application Version in Jenkins Pipeline - Part I

3 Parts of a Version:

| **3**. | **2**. | **1** |
| ------ | ------ | ----- |
| Major  | Minor  | Patch |

1.  **Major**: Contains big/breaking changes, NOT backwards-compatible
2.  **Minor**: New, but backwards-compatible changes
3.  **Patch**: Minor changes and bug fixes, doesn't change application API
4.  **Suffix**(optional): Additional info about the version (e.g. SNAPSHOT to
    indicate non-release version in Maven packages, RELEASE to indicate release
    version, etc.)

## Incrementing the Version

When creating a new version, you need to increment the version in the package
manager dependency file (package.json, pom.xml, etc.)

The best practice is to increment the version **automatically** in the build
automation. Build tools have commands to increment the version automatically:

This command increments to the next patch version of the package:

```
   // maven plugin parses the version found in pom.xml
   mvn build-helper:parse-version versions:set \
   -DnewVersion=\${parsedVersion.majorVersion}.\${parsedVersion.minorVersion}.\${parsedVersion.nextIncrementalVersion} versions:commit
```

This command increments to the next minor version of the package:

```
   // maven plugin parses the version found in pom.xml
   mvn build-helper:parse-version versions:set \
   -DnewVersion=\${parsedVersion.majorVersion}.\${parsedVersion.nextMinorVersion}.\${parsedVersion.incrementalVersion} versions:commit
```

## Incrementing the Version in Jenkins Pipeline

`Jenkinsfile`:

```groovy

   pipeline {

       agent any

       tools {
           maven "maven-3.8.4(default)"
       }

       stages {

           stage("increment version") {
               steps {
                   script {
                       echo "incrementing app version..."
                        sh 'mvn build-helper:parse-version versions:set \
                        -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} \
                        versions:commit'

                        // Read the version number from pom.xml
                        def matcher = readFile('pom.xml') =~ '<version>(.+)</version>'
                        // Returns an array of matched tags and children tags inside
                        def version = matcher[0][1] // 0.0.0
                        env.IMAGE_NAME = "$version-$BUILD_NUMBER" // 0.0.0-{jenkins-build-number}
                   }
               }
           }

           stage("build app") {
               steps {
                   script {
                       echo "Building the app..."
                       sh "mvn clean package"
                   }
               }
           }

           stage("build image") {
               steps {
                   script {
                       echo "Building the Docker image..."
                       withCredentials([ credentialsId: '{credential-id-name}', passwordVariable: 'PWD', usernameVariable: 'USER']) {
                           sh 'docker build -t {artifact-repoaddr}:{artifact-repoport}/{image-name}:${IMAGE_VERSION} {dockerfile-location}'
                           sh "echo $PWD | docker login -u $USER --password-stdin {artifact-repoaddr}:{artifact-port}"
                           sh 'docker push {artifact-repoaddr}:{artifact-repoport}/{imagename}:${IMAGE_VERSION}
                       }
                   }
               }
           }

           // ...
       }
   }

```

`Dockerfile`:

```dockerfile
   FROM openjdk:8-jre-alpine

   EXPOSE 8080

   COPY ./target/java-maven-app-*.jar /usr/app  #"*" matches any version number text; allows for DYNAMIC VERSIONING
   WORKDIR /usr/app

   CMD java -jar java-maven-app-*.jar
```

## Dynamically Increment Application Version in Jenkins Pipeline - Part II

## Committing Version Bump from Jenkins

Problem: Although Jenkins updates the package version, the updated version never
gets pushed to SCM. When the pipeline checks out the branch on commit, the
**old** version is still checked out. Jenkins increments to the new version, but
SCM never receives the update.

Must commit the updated (pom.xml, etc.) from Jenkinsfile:

`Jenkinsfile`:

```groovy

   pipeline {

       agent any

       tools {
           maven "maven-3.8.4(default)"
       }

       stages {

           // Increment version and build app stages from above...

           stage("build image") {
               steps {
                   script {
                       echo "Building the Docker image..."
                       withCredentials([ credentialsId: '{credential-id-name}', passwordVariable: 'PWD', usernameVariable: '']) {
                           sh 'docker build -t {artifact-repoaddr}:{artifact-repoport}/{image-name}:${IMAGE_VERSION}{dockerfile-location}'
                           sh "echo $PWD | docker login -u $USER --password-stdin {artifact-repoaddr}:{artifact-port}"
                           sh 'docker push {artifact-repoaddr}:{artifact-repoport}/{imagename}:${IMAGE_VERSION}'
                       }
                   }
               }
           }

           stage("deploy") { // ... }

           stage('commit version update') {
               steps {
                   script {
                       withCredentials([ credentialsId: '{git-credentials-id}', usernameVariable: 'USER', passwordVariable: 'PWD']) {

                           // Set global git config, OR ssh into jenkins server and set
                           sh 'git config --global user.email "jenkins@example.com"'
                           sh 'git config --global user.name "jenkins"'

                           // sh 'git status'
                           // sh 'git branch'
                           // sh 'git config --list'

                           // commit changes from Jenkinsfile
                           sh "git remote set-url origin https://$USER:$PWD@{git-repo-url}" // set repo url for current context and pass credentials for auth
                           sh 'git add .'
                           sh "git commit -m\"ci: version bump\""
                           // sh "git push origin HEAD:jenkins-jobs"
                           sh "git push origin HEAD:${BRANCH_NAME}" // Use "BRANCH_NAME" Jenkins env var
                       }
                   }
               }
           }
       }
   }

```

### Prevent Bump-Pipeline Build-Bump Inifinite Loop

- Detect that commit was made from Jenkins
- Ignore trigger when commit is from Jenkins

#### Install Ignore Committer Strategy Plugin

- **NOTE**: if using Github for SCM, you must install **Github Commit Skip SCM
  Behavior** plugin instead.

1. {pipeline-name} > Branch Sources > Branch Strategies > Ignore Committer
   Strategy
2. Enter email addr of commit author(s) you want to ignore/NOT start pipeline on
   commit
