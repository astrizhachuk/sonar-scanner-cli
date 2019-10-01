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

### Пример

```yml
stages:
  - sonarqube

sonarqube:
  stage: sonarqube
  image:
    name: ${CI_REGISTRY}/devops/sonar-scanner-cli:latest
    entrypoint: [""]
  script:
    - export SONAR_SCANNER_OPTS="-Xmx6g"
    - sonar-scanner
      -D"sonar.login=${SONAR_LOGIN}"
```
