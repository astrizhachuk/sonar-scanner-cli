# Sonar Scanner for GitLab CI/CD

Sonar Scanner для GitLab CI/CD.

## FROM

* openjdk:11-jre-slim

## ADD

* curl
* unzip
* git

## ENV

* SONAR_SCANNER_VERSION="4.0.0.1744" - версия Sonar Scanner

### Пример .gitlab-ci.yml

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
      -D"sonar.login=${SONAR_LOGIN}"
  only:
    refs:
      - develop
  tags:
    - docker
  when: manual
```
