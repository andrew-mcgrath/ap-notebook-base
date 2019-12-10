FROM continuumio/miniconda3:4.7.12-alpine

# Build Args
ARG BUILD_DATE
ARG VCS_REF
ARG BUILD_VERSION

# Labels
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.name="amcgrath/ap-trusted-notebook"
LABEL org.label-schema.description="Baseline for anaconda-project serving a notebook on 8443"
LABEL org.label-schema.vcs-url="https://github.com/andrew-mcgrath/ap-notebook-base-image"
LABEL org.label-schema.vcs-ref=$VCS_REF
LABEL org.label-schema.version=$BUILD_VERSION
LABEL org.label-schema.docker.cmd="docker run -p 8888:8888 -d amcgrath/ap-notebook-base-image"

# install anaconda project
RUN /opt/conda/bin/conda create -n project -c defaults -c conda-forge anaconda-project \
  && /opt/conda/bin/conda clean --all -y

# Grab all the code and the project
COPY --chown=anaconda:anaconda jupyter_notebook_config.py /opt/project/
COPY --chown=anaconda:anaconda docker-entrypoint.sh /

# expose the jupyter notebook default port
EXPOSE 8443

# runs anaconda project
ENTRYPOINT ["/docker-entrypoint.sh"]