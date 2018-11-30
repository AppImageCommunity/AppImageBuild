#! /bin/bash

set -xe

wget https://www.freedesktop.org/software/fontconfig/release/fontconfig-"$FONTCONFIG_VERSION".tar.bz2 -O- | tar xj

cd fontconfig-"$FONTCONFIG_VERSION"

export CHOST=arm-linux-gnueabihf
export CFLAGS="-I/deps/include"
export CPPFLAGS="$CFLAGS"
export LDFLAGS="-L/deps/lib"

./configure --prefix=/deps --target="$CHOST" --host="$CHOST" --enable-libxml2

# build and install into prefix
make all -j$(nproc)
make install

cd ..

rm -rf fontconfig-"$FONTCONFIG_VERSION"/
