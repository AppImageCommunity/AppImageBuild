#! /bin/bash

set -xe

git clone -n https://github.com/freedesktop/xdg-desktop-file-utils.git desktop-file-utils-"$DESKTOP_FILE_UTILS_VERSION"

cd desktop-file-utils-"$DESKTOP_FILE_UTILS_VERSION"

# this workaround is needed since we use a commit hash at the moment to support 1.5 type desktop entries
git checkout "$DESKTOP_FILE_UTILS_VERSION"

export CHOST="$DEBARCH"

flags="-no-pie -static"

export CFLAGS="-I/deps/include $flags"
export CPPFLAGS="$CFLAGS $flags"
export LDFLAGS="-L/deps/lib $flags"

./autogen.sh --prefix=/deps --target="$CHOST" --build="x86_64-linux-gnu" --host="$CHOST"

# build and install into prefix
make all -j$(nproc)
make install

cd ..

rm -rf desktop-file-utils-"$DESKTOP_FILE_UTILS_VERSION"/
