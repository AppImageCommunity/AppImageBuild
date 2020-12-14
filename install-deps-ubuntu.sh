#! /bin/bash

set -e
set -x

apt-get update

packages=(
    libfuse-dev
    desktop-file-utils
    ca-certificates
    gcc
    g++
    make
    build-essential
    git
    automake
    autoconf
    libtool
    patch
    wget
    vim-common
    desktop-file-utils
    pkg-config
    libarchive-dev
    librsvg2-dev
    librsvg2-bin
    liblzma-dev
    cmake
    libssl-dev
    zsync
    fuse
)

apt-get install -y "${packages[@]}"
