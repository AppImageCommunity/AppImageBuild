#! /bin/bash

set -xe

wget -O- https://sourceforge.net/projects/libpng/files/libpng16/"$LIBPNG_VERSION"/libpng-"$LIBPNG_VERSION".tar.xz/download | tar xJ

cd libpng-"$LIBPNG_VERSION"

export CHOST=arm-linux-gnueabihf

# https://sourceforge.net/p/libpng/bugs/227/
export CFLAGS="-I/deps/include"
export CPPFLAGS="$CFLAGS"
export LDFLAGS="-L/deps/lib"

./configure --prefix=/deps --target="$CHOST" --host="$CHOST"

# build and install into prefix
make all -j$(nproc)
make install

cd ..

rm -rf libpng-"$LIBPNG_VERSION"/
