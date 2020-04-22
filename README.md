# Sonar Scanner for GitLab CI/CD and Jenkins

Sonar Scanner для GitLab CI/CD и Jenkins.

## DOCKER HUB

`docker pull astrizhachuk/sonar-scanner-cli:latest`

## FROM

* adoptopenjdk:14-hotspot

## ADD

* curl
* git
* openssh-client
* unzip

## ENV

* SONAR_SCANNER_VERSION="4.3.0.2102" - version of Sonar Scanner

### EXAMPLE .gitlab-ci.yml

```yml
stages:
  - sonarqube

variables:
  MAJOR: "10.3.1"
  PATH_SRC: "src/"
  
sonarqube:
  stage: sonarqube
  image:
    name: ${CI_REGISTRY}/devops/sonar-scanner-cli:latest
    entrypoint: [""]
  script:
    - export PROJECT_VERSION="${MAJOR}.$(grep -oPm1 "(?<=<VERSION>)[^<]+" ${PATH_SRC}VERSION)"
    - export SONAR_SCANNER_OPTS="-Xmx6g"
    - sonar-scanner
      -D"sonar.projectVersion=${PROJECT_VERSION}"
      -D"sonar.branch.name=${CI_COMMIT_REF_NAME}"
      -D"sonar.branch.target=develop"
      -D"sonar.login=${SONAR_LOGIN}"
  only:
     refs:
       - develop
       - /^feature\/.*$/
  tags:
    - docker
  when: manual
```
