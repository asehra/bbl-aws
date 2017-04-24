FROM ubuntu:16.04

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y ntpdate

# AWS CLI needs the PYTHONIOENCODING environment varialbe to handle UTF-8 correctly:
ENV PYTHONIOENCODING=UTF-8

RUN apt-get install -y \
    less \
    man \
    ssh \
    python \
    python-pip \
    python-virtualenv \
    zlib1g-dev \
    libssl-dev \
    libxml2 libxml2-dev \
    build-essential patch \
    ruby-dev liblzma-dev \
    ruby \
    vim

RUN wget https://github.com/cloudfoundry/bosh-bootloader/releases/download/v3.1.0/bbl-v3.1.0_linux_x86-64 && \
      chmod +x bbl-v3.1.0_linux_x86-64 && \
      mv bbl-v3.1.0_linux_x86-64 /usr/local/bin/bbl

RUN wget https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-2.0.1-linux-amd64 && \
      chmod +x bosh-cli-2.0.1-linux-amd64 && \
      mv bosh-cli-2.0.1-linux-amd64 /usr/local/bin/bosh

RUN adduser --disabled-login --gecos '' aws
WORKDIR /home/aws

USER aws

RUN \
    mkdir aws && \
    virtualenv aws/env && \
    ./aws/env/bin/pip install awscli && \
    echo 'source $HOME/aws/env/bin/activate' >> .bashrc && \
    echo 'complete -C aws_completer aws' >> .bashrc
