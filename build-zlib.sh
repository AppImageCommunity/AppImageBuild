#! /bin/bash

set -xe

wget https://zlib.net/zlib-"$ZLIB_VERSION".tar.gz -O- | tar xz

cd zlib-"$ZLIB_VERSION"

export CHOST=arm-linux-gnueabihf
./configure --prefix=/deps

# build and install into prefix
make all -j$(nproc)
make install

cd ..

rm -rf zlib-$ZLIB_VERSION/
