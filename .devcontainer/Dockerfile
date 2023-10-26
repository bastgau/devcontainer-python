ARG VARIANT="3.11"
FROM mcr.microsoft.com/azure-functions/python:4-python${VARIANT}-core-tools

WORKDIR /workspaces/app
ARG WORKSPACE_FOLDER="/workspaces/app"

# Install program dependencies:

RUN mkdir /tmp/config_container

COPY /.devcontainer/install-deps.sh /tmp/config_container/install-deps.sh
RUN chmod +x /tmp/config_container/install-deps.sh
RUN /tmp/config_container/install-deps.sh

RUN rm -rvf /tmp/config_container

# Create virtual environment:

VOLUME $WORKSPACE_FOLDER/.venv

# Fix issue with pylint and other linters:

ENV PYTHONPATH=$WORKSPACE_FOLDER/src
ENV SOURCE_PATH=$WORKSPACE_FOLDER/src

ENV UNIT_TESTING_PATH=$WORKSPACE_FOLDER/tests

ENV WORKSPACE_PATH=$WORKSPACE_FOLDER
