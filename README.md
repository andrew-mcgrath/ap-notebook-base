[![Docker Automated](https://img.shields.io/docker/cloud/automated/amcgrath/ap-notebook-base)](https://hub.docker.com/r/amcgrath/ap-notebook-base) 
[![Docker Builds](https://img.shields.io/docker/cloud/build/amcgrath/ap-notebook-base)](https://hub.docker.com/r/amcgrath/ap-notebook-base/builds)
![Github License](https://img.shields.io/github/license/andrew-mcgrath/ap-notebook-base)
![Github Release](https://img.shields.io/github/v/release/andrew-mcgrath/ap-notebook-base)

# Purpose

This project was created to prove if an `anaconda-project` could be used to serve up a trusted `jupyter` notebook via
a docker container. 

This container should be used as the base from which `anaconda-project` files will serve up trusted notebooks 
on a local workstation or to a remote orchestration service such as `kubernetes` or the AWS Elastic Container Service 
(ECS).

The notebook will be reachable on port `8443` over `https`.

# Usage

## Anaconda Project File

```yaml
# ...
commands:
  default:
    notebook: notebook.ipynb
    env_spec: default
  trust:
    unix: jupyter trust notebook.ipynb
    env_spec: default
# ...
```

## Anaconda Project Dockerfile

## Docker

The container delivers a base image to publish a trusted jupyter notebook via `anaconda-project`, exposed via https, 
on port 8443.

### Build Locally

To build the container image, simply execute a standard docker build command.

```bash
export IMAGE_NAME="amcgrath/ap-baseline"
docker build \
  --build-arg VCS_REF=$(git rev-parse --short HEAD) \
  --build-arg BUILD_DATE=$(date -u +”%Y-%m-%dT%H:%M:%SZ”) \
  --build-arg BUILD_VERSION=$(git describe --tags --dirty) \
  -t $IMAGE_NAME .
```