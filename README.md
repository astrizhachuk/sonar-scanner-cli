# Sonar Scanner for GitLab CI/CD and Jenkins

Sonar Scanner для GitLab CI/CD и Jenkins.

## DOCKER HUB

`docker pull astrizhachuk/sonar-scanner-cli:latest`

## TAGS AND RESPECTIVE DOCKERFILE LINKS

* [4.6.2.2472, latest](https://github.com/astrizhachuk/sonar-scanner-cli/blob/master/Dockerfile)

* [4.3.0.2102](https://github.com/astrizhachuk/sonar-scanner-cli/blob/4.3.0.2102/Dockerfile)

* [4.0.0.1744](https://github.com/astrizhachuk/sonar-scanner-cli/blob/4.0.0.1744/Dockerfile)

## DESCRIPTION

### FROM

* adoptopenjdk:16-hotspot

### ADD

* curl
* git
* git-lfs
* openssh-client
* unzip

### ENV

* SONAR_SCANNER_VERSION="4.6.2.2472" - version of Sonar Scanner

## EXAMPLE .gitlab-ci.yml

```yml
stages:
  - sonarqube

variables:
  MAJOR: "10.3.1"
  PATH_SRC: "src/"

merge_request:
  stage: sonarqube
  image:
    name: ${CI_REGISTRY}/devops/sonar-scanner-cli:latest
    entrypoint: [""]
  variables:
    GIT_DEPTH: 0
  script:
    - keytool -cacerts -storepass changeit -noprompt -trustcacerts -importcert -alias yours.serts.local -file "$SONAR_SSL_CERTIFICATE"
    - export PROJECT_VERSION="${MAJOR}.$(grep -oPm1 "(?<=<VERSION>)[^<]+" ${PATH_SRC}VERSION)"
    - export SONAR_SCANNER_OPTS="-Xmx16g"
    - sonar-scanner
      -D"sonar.host.url=${SONAR_SERVER}"
      -D"sonar.projectVersion=${PROJECT_VERSION}"
      -D"sonar.login=${SONAR_LOGIN}"
      -D"sonar.pullrequest.key=${CI_MERGE_REQUEST_IID}"
      -D"sonar.pullrequest.branch=${CI_MERGE_REQUEST_SOURCE_BRANCH_NAME}"
      -D"sonar.pullrequest.base=${CI_MERGE_REQUEST_TARGET_BRANCH_NAME}"
  rules:
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event" && $CI_MERGE_REQUEST_TARGET_BRANCH_NAME == "master"'
  tags:
    - docker
  
push:
  stage: sonarqube
  image:
    name: ${CI_REGISTRY}/devops/sonar-scanner-cli:latest
    entrypoint: [""]
  variables:
    GIT_DEPTH: 0
  script:
    - keytool -cacerts -storepass changeit -noprompt -trustcacerts -importcert -alias yours.serts.local -file "$SONAR_SSL_CERTIFICATE"
    - export PROJECT_VERSION="${MAJOR}.$(grep -oPm1 "(?<=<VERSION>)[^<]+" ${PATH_SRC}VERSION)"
    - export SONAR_SCANNER_OPTS="-Xmx6g"
    - sonar-scanner
      -D"sonar.host.url=${SONAR_SERVER}"
      -D"sonar.projectVersion=${PROJECT_VERSION}"
      -D"sonar.branch.name=master"
      -D"sonar.login=${SONAR_LOGIN}"
  rules:
    - if: '$CI_COMMIT_TAG != null'
  tags:
    - docker
```