# See here for image contents:
ARG VARIANT="3.11-bullseye"
FROM mcr.microsoft.com/vscode/devcontainers/python:0-${VARIANT}

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

ENV VIRTUAL_ENV=$WORKSPACE_FOLDER/.venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install python dependencies:

RUN mkdir /tmp/config_container

COPY /requirements-dev.txt /tmp/config_container/requirements-dev.txt
COPY /requirements.txt /tmp/config_container/requirements-all.txt

RUN pip install --upgrade pip
RUN pip install -r /tmp/config_container/requirements-dev.txt
RUN pip install -r /tmp/config_container/requirements-all.txt

RUN rm -rvf /tmp/config_container
