# Publish Artifact to a Repository

## Create Nexus User
1. Users > Create local user
2. Enter user information:
    - ID
    - First name
    - Last name
    - Email
    - Password
    - Status
    - Roles
3. Create new role with least permissions:
    - Roles > Create Role
        - Role ID
        - Role Name
        **Admin** permissions should be for admin users (backups, installing plugins, etc.). Downloaders/uploaders should use **View** permissions.
    - Create Role

4. Add new role to user. Delete previously-assigned admin role.

## Exercise: Publish an NPM Package to Nexus

1. Create `base-64` encoded string of nexus repo user and password:
`echo -n 'admin:admin123' | openssl base64`

2. Create `.npmrc` file in project root:
`.npmrc`:
```
init-author-name = <author-name>
init-author-email = <author-email>
email=<author-email>
always-auth=true
_auth=<base-64-string>
```

3. `npm adduser --registry=http://<nexus-repo-url>`

4. Enter nexus username and password when prompted

5. From node project root:
`npm pack`

6. `npm publish`

## Exercise: Upload a JAR file to Nexus repo from Gradle/Maven

- Maven/Gradle commands exist for pushing to remote repo
- Must configure both tools to connect to Nexus (with Nexus repo URL &credentials)
- Avoid giving admin credentials for connection; create NEW NEXUS USER with upload permissions



### Configure Gradle with Nexus credentials
`build.gradle`
 ```
    plugins {
        id 'java'
        id 'org.springframework.boot' version '2.2.2.RELEASE'
        id 'io.spring.dependency-management' version '1.0.8.RELEASE'
    }

    group 'com.example'
    version '1.0-SNAPSHOT'

    sourceCompatibility = 1.8

    // Add plugin
    apply plugin: 'maven-publish'

    publishing {
        publications { // JAR file configuration
            maven(MavenPublication) {
                artifact("build/libs/my-app-$version" + ".jar") {
                    extension: "jar"
                }
            }
        }

        repositories { // Nexus repository configuration
            maven {
                name 'nexus'
                url "http://{your nexus ip}:{your nexus port}//repository/  {repository name}
                allowInsecureProtocol=true // if your nexus is using HTTP
                credentials {
                    username project.repoUser // Nexus user username
                    password project.repoPassword // Nexus user password: NOTE:     create values in property file to avoid checking in to SCM
                }
            }
        }
    }

    repositories {
        mavenCentral()
    }

    dependencies {
        implementation 'org.springframework.boot:spring-boot-starter-web'
        compile group: 'net.logstash.logback', name: 'logstash-logback-encoder',    version: '5.2'
        compile group: 'mysql', name: 'mysql-connector-java', version: '8.0.22'
        testCompile group: 'junit', name: 'junit', version: '4.12'
    }

 ```
`gradle.properties`

```
repoUser=<username>
repoPassword=<password>
```
 `settings.gradle`
 ```
    rootProject.name="<jarfile-name>"
 ```

### Upload Gradle project

1. Build JAR file:
    - ./gradlew build

2. Upload to Nexus:
    - cd <project-root>
    - ./gradlew publish

### Configure Maven with Nexus credentials

1. Configure upload configuration:
    - Artifact & repo address
    - Upload credentials for nexus

`pom.xml`

```
    <build>
        <pluginManagement>
            <plugins>
                <plugin>
                    <groupId>org.apache.maven.plugins</groupId>
                    <artifactId>maven-deploy-plugin</artifactId>
                    <version>2.8.2</version>
                </plugin>
            </plugins>
        </pluginManagement>
         <plugins>
                <plugin>
                    <groupId>org.apache.maven.plugins</groupId>
                    <artifactId>maven-deploy-plugin</artifactId>
                </plugin>
            </plugins>
    </build>

    <distributionManagement>
        <snapshotRepository>
            <id>{nexus-repository-id}</id>
            <url>{nexus-repository-url}</url>
        </snapshotRepository>
    </distributionManagement>
```

`.m2`

```
    cd ~/.m2
    touch settings.xml
    nano settings.xml

    # Insert:
    <settings>
        <servers>
            <server>
                <id>{nexus-repository-id}</id>
                <username>{nexus-username}</username>
                <password>{nexus-user-password}</password>
            </server>
        </servers>
    </settings>
```
2. Build and upload artifact:

```
mvn package

mvn deploy
```