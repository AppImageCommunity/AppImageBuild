#! /bin/bash

set -xe

wget https://ftp.fau.de/debian/pool/main/f/fuse/fuse_"$FUSE_VERSION".orig.tar.gz -O- | tar xz

cd fuse-"$FUSE_VERSION"

export CHOST=arm-linux-gnueabihf
export CFLAGS="-I/deps/include"
export LDFLAGS="-I/deps/lib"
export CC="$CHOST"-gcc

./configure --prefix=/deps --target="$CHOST" --host="$CHOST" --build="$CHOST"

# build and install into prefix
make all -j$(nproc)
make install

cd ..

rm -rf fuse-"$FUSE_VERSION"/
