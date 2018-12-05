#! /bin/bash

set -xe

wget https://ftp.fau.de/debian/pool/main/c/cairo/cairo_"$CAIRO_VERSION".orig.tar.xz -O- | tar xJ

cd cairo-"$CAIRO_VERSION"

export CHOST="$DEBARCH"
export CFLAGS="-I/deps/include"
export CPPFLAGS="$CFLAGS"
export LDFLAGS="-L/deps/lib"

./configure --prefix=/deps --target="$CHOST" --host="$CHOST" --enable-xlib=no

# build and install into prefix
make all -j$(nproc)
make install

cd ..

rm -rf cairo-$CAIRO_VERSION/
