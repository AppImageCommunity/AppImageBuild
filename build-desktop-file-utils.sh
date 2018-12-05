#! /bin/bash

set -xe

git clone https://gitlab.freedesktop.org/gstreamer/desktop-file-utils.git -b "$DESKTOP_FILE_UTILS_VERSION" desktop-file-utils-"$DESKTOP_FILE_UTILS_VERSION"

cd desktop-file-utils-"$DESKTOP_FILE_UTILS_VERSION"

export CHOST="$DEBARCH"

export CFLAGS="-I/deps/include"
export CPPFLAGS="$CFLAGS"
export LDFLAGS="-L/deps/lib"

./autogen.sh
./configure --prefix=/deps --target="$CHOST" --host="$CHOST"

# build and install into prefix
make all -j$(nproc)
make install

cd ..

rm -rf desktop-file-utils-"$DESKTOP_FILE_UTILS_VERSION"/
