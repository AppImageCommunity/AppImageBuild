#! /bin/bash

set -xe

wget https://download.qemu.org/qemu-"$QEMU_VERSION".tar.xz -O-| tar xJ

cd qemu-"$QEMU_VERSION"

# IMPORTANT STEP
unset PKG_CONFIG_PATH

./configure --prefix=/usr

# build and install into prefix
make all -j$(nproc)
make install

cd ..

rm -rf qemu-"$QEMU_VERSION"/
