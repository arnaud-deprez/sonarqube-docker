# Sonarqube image

This is based on the [official SonarQube image](https://github.com/SonarSource/docker-sonarqube) but it's compatible with Openshift permission policy.

## Deployment on Openshift

For example, if you want to deploy the version 6.7-alpine on Openshift in a cicd project, you can run:

```sh
oc project cicd
version=6.7-alpine
# Build the new image based on the imported image
oc new-build https://github.com/arnaud-deprez/sonarqube-docker.git \
    --strategy=docker \
    --to=sonarqube-ocp:6.7-alpine \
    --name=sonarqube-ocp
# Create the SonarQube deployment with PostgreSQL
oc new-app -f https://raw.githubusercontent.com/arnaud-deprez/sonarqube-docker/master/openshift/sonarqube-postgresql-template.yml --param=SONARQUBE_VERSION=${version}
```
