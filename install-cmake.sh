#! /bin/bash

set -e
set -x

case "$ARCH" in
    arm64*|aarch64)
       cmake_arch=arm64v8
       ;;
    arm32*|armhf)
       cmake_arch=arm32v7
       ;;
    i?86)
       cmake_arch=i386
       ;;
    *)
       cmake_arch="$ARCH"
       ;;
esac

case "$DIST" in
    "xenial"|"bionic")
        cmake_dist="ubuntu_$DIST"
        ;;
    *)
        cmake_dist="$DIST"
        ;;
esac

wget https://artifacts.assassinate-you.net/prebuilt-cmake/cmake-v3.19.1-"$cmake_dist"-"$cmake_arch".tar.gz -O- | \
    tar xz --strip-components=1 -C/usr/local
