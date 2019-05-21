#! /bin/bash

set -xe

wget https://download.savannah.gnu.org/releases/freetype/freetype-"$FREETYPE2_VERSION".tar.bz2 -O- | tar xj

ls -al

cd freetype-"$FREETYPE2_VERSION"

export CHOST="$DEBARCH"
export CFLAGS="-I/deps/include"
export CPPFLAGS="$CFLAGS"
export LDFLAGS="-L/deps/lib"

./configure --prefix=/deps --target="$CHOST" --host="$CHOST" --enable-xlib=no

# build and install into prefix
make all -j$(nproc)
make install

cd ..

rm -rf freetype-$FREETYPE2_VERSION/
