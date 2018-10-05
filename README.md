# Sonarqube image [![Build Status](https://travis-ci.com/arnaud-deprez/sonarqube-docker.svg?branch=master)](https://travis-ci.com/arnaud-deprez/sonarqube-docker)

This is based on the [official SonarQube image](https://github.com/SonarSource/docker-sonarqube) but it's compatible with Openshift permission policy.

## Setup With Helm (recommended)

[Helm](https://docs.helm.sh) (aka The package manager for Kubernetes) is the recommended way to setup the `cicd` infrastructure and so `jenkins`.
To install `helm cli` and `tiller` on `Openshift`, please follow the guideline [here](https://github.com/arnaud-deprez/cicd-openshift/blob/master/README.md).

Once it is done, you can run the following: 

```sh
namespace=cicd
oc new-project $namespace
# configure builds
helm template --name sonarqube --set nameOverride=sonarqube charts/openshift-build | oc apply -f -
# trigger builds
oc start-build sonarqube-docker
# deploy
helm template --name sonarqube -f charts/openshift-build/values.yaml --set ingress.enabled=true --set ingress.hosts={"<ingress_hostname>"} charts/sonarqube | oc apply -f -
```

For example, with `minishift` you can setup the hostname with:

```sh
helm template --name sonarqube -f charts/openshift-build/values.yaml --set ingress.enabled=true --set ingress.hosts={sonarqube-cicd.$(minishift ip).nip.io} charts/sonarqube | oc apply -f -
```

## Setup with openshift templates

For example, if you want to deploy the version 7.1-alpine on Openshift in a cicd project, you can run:

```sh
oc project cicd
version=7.1-alpine
# Build the new image based on the imported image
oc new-build https://github.com/arnaud-deprez/sonarqube-docker.git \
    --strategy=docker \
    --to=sonarqube-ocp:$version \
    --name=sonarqube-ocp
# Create the SonarQube deployment with PostgreSQL
oc new-app -f https://raw.githubusercontent.com/arnaud-deprez/sonarqube-docker/master/openshift/sonarqube-postgresql-template.yml -p SONARQUBE_VERSION=${version} -p POSTGRESQL_PASSWORD=sonar
```
