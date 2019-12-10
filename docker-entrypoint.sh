#!/bin/sh

# add conda to the path and environment
source /opt/conda/etc/profile.d/conda.sh

# run the projects
conda run -n project anaconda-project run \
  --directory /opt/project default --no-browser \
  --config /opt/project/jupyter_notebook_config.py