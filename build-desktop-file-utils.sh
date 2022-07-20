#! /bin/bash

set -xe

wget https://www.freedesktop.org/software/desktop-file-utils/releases/desktop-file-utils-"$DESKTOP_FILE_UTILS_VERSION".tar.xz -O - | tar xJ

cd desktop-file-utils-"$DESKTOP_FILE_UTILS_VERSION"

export CHOST="$DEBARCH"

export CFLAGS="-I/deps/include"
export CPPFLAGS="$CFLAGS"
export LDFLAGS="-L/deps/lib"

./autogen.sh --prefix=/deps --target="$CHOST" --build="x86_64-linux-gnu" --host="$CHOST"

# build and install into prefix
make all -j$(nproc)
make install

cd ..

rm -rf desktop-file-utils-"$DESKTOP_FILE_UTILS_VERSION"/
