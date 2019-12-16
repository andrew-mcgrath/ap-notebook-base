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

The `anaconda-project` file must include two commands 

1. `default` for running the notebook itself
1. `trust` so that the notebook can run as a trusted notebook

Example `anaconda-project` file

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

The `anaconda-project` docker file will need to include the following in order to serve up desired content

```dockerfile
FROM amcgrath/ap-notebook-base

# Copy the notebook and supporting libraries
# Make use of a .dockerignore file to filter unnecessary content
COPY --chown=anaconda:anaconda . /opt/project/

# install all of the dependencies for the project
RUN /opt/conda/bin/conda run -n project anaconda-project prepare --directory /opt/project \
  && /opt/conda/bin/conda clean --all -y

# trust the notebook
RUN /opt/conda/bin/conda run -n project anaconda-project run \
  --directory /opt/project trust
```

The above example is an excerpt from the [dockerfile][ap-trusted-notebook-dockerfile] in 
[andrew-mcgrath/ap-trusted-notebook][ap-trusted-notebook]. 

# Build Locally

To build the container image, simply execute a standard docker build command.

```bash
export IMAGE_NAME="amcgrath/ap-baseline"
docker build \
  --build-arg VCS_REF=$(git rev-parse --short HEAD) \
  --build-arg BUILD_DATE=$(date -u +”%Y-%m-%dT%H:%M:%SZ”) \
  --build-arg BUILD_VERSION=$(git describe --tags --dirty) \
  -t $IMAGE_NAME .
```

[ap-trusted-notebook]: https://github.com/andrew-mcgrath/ap-trusted-notebook
[ap-trusted-notebook-dockerfile]: https://github.com/andrew-mcgrath/ap-trusted-notebook/blob/master/Dockerfile