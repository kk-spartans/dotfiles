# syntax=docker/dockerfile:1

FROM ubuntu:24.04

# Install basic dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    wget \
    zsh \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /root

# Copy dotfiles
COPY . .

# Default command
CMD ["/bin/bash"]
