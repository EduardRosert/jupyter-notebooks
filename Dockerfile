# On how to use a Dockerfile for your Binder repository
# see https://mybinder.readthedocs.io/en/latest/tutorials/dockerfile.html

# base image is magics with magics python
FROM eduardrosert/magics:version-4.2.0

# Install Python run-time dependencies.
COPY requirements.txt /root/
RUN set -ex \
    && pip install -r /root/requirements.txt

ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

# Change the default start directory for Jupyter Notebook
COPY ./jupyter_notebook_config.py ${HOME}/.jupyter/jupyter_notebook_config.py

# Copy files into the user's home
COPY ./*.ipynb ${HOME}/
USER root
RUN chown -R ${NB_UID} ${HOME}

# Copy sample data to share folder
COPY ./data/* /shared/eduard/
RUN chown -R ${NB_UID} /shared/

# de-elevate privileged
USER ${NB_USER}