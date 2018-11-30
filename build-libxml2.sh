#! /bin/bash

set -xe

git clone https://gitlab.gnome.org/GNOME/libxml2/ --recursive --depth=10 -b v"$LIBXML2_VERSION" libxml2-"$LIBXML2_VERSION"

cd libxml2-"$LIBXML2_VERSION"

export CHOST=arm-linux-gnueabihf
export CFLAGS="-I/deps/include"
export CPPFLAGS="$CFLAGS"
export LDFLAGS="-L/deps/lib"

./autogen.sh
./configure --prefix=/deps --target="$CHOST" --host="$CHOST"

# build and install into prefix
make all -j$(nproc)
make install

cd ..

rm -rf libxml2-"$LIBXML2_VERSION"
