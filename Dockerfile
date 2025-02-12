# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

ARG BASE_IMAGE=mcr.microsoft.com/deployment-environments/runners/core
ARG IMAGE_VERSION=latest
ARG CUSTOM_IMAGE_VERSION=unknown

FROM ${BASE_IMAGE}:${IMAGE_VERSION}
WORKDIR /

ARG IMAGE_VERSION
ENV BASE_IMAGE_VERSION=latest

ARG CUSTOM_IMAGE_VERSION
ENV CUSTOM_IMAGE_VERSION=$CUSTOM_IMAGE_VERSION

# Metadata as defined at http://label-schema.org
ARG BUILD_DATE

# install terraform
RUN wget -O terraform.zip https://releases.hashicorp.com/terraform/1.7.4/terraform_1.7.4_linux_amd64.zip
RUN unzip terraform.zip && rm terraform.zip
RUN mv terraform /usr/bin/terraform

# install git/curl
RUN apk add git curl

# suppress warnings (temporary solution until we can snap to Azure Linux)
RUN az config set core.only_show_errors=true

# Grab all .sh files from scripts, copy to
# root scripts, replace line-endings and make them all executable
COPY scripts/* /scripts/
RUN find /scripts/ -type f -iname "*.sh" -exec dos2unix '{}' '+'
RUN find /scripts/ -type f -iname "*.sh" -exec chmod +x {} \;
