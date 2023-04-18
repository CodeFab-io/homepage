FROM mcr.microsoft.com/devcontainers/javascript-node:16

# Configuring Elm version
ARG ELM_VERSION=latest-0.19.1
ARG ELM_FORMAT_VERSION=latest-0.19.1

# Install terraform
# https://www.hashicorp.com/official-packaging-guide
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt update \
    && apt install gpg \
    && wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    && gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list \
    && apt update \
    && apt install terraform

# Install aws-cli
RUN apt-get -y install --no-install-recommends awscli

# Install vite
RUN yarn global add vite elm@${ELM_VERSION} elm-format@${ELM_FORMAT_VERSION}