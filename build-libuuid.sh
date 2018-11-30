#! /bin/bash

set -xe

wget https://sourceforge.net/projects/libuuid/files/libuuid-"$LIBUUID_VERSION".tar.gz/download -O- | tar xz

cd libuuid-"$LIBUUID_VERSION"

export CHOST=arm-linux-gnueabihf
export CFLAGS="-I/deps/include"
export CPPFLAGS="$CFLAGS"
export LDFLAGS="-L/deps/lib"

./configure --prefix=/deps --target="$CHOST" --host="$CHOST"

# build and install into prefix
make all -j$(nproc)
make install

cd ..

rm -rf libuuid-"$LIBUUID_VERSION"/
