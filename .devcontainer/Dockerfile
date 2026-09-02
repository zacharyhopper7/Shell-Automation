FROM ubuntu:22.04

# Install system dependencies
RUN apt update && apt install -y sudo \
    build-essential \
    python3 \
    python3-pip \
    curl \
    dos2unix \
    && rm -rf /var/lib/apt/lists/*
   

RUN ln -s /usr/bin/python3 /usr/bin/python

# Create a non-root user for VS Code
# RUN useradd -m vscode
# USER vscode
RUN useradd -m -s /bin/bash vscode \
    && echo 'vscode:admin' | chpasswd \
    && echo 'vscode ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER vscode


WORKDIR /home/vscode