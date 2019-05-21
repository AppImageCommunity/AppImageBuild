#! /bin/bash

set -xe

wget https://ftp.fau.de/debian/pool/main/p/pixman/pixman_"$PIXMAN_VERSION".orig.tar.gz -O- | tar xz

cd pixman-"$PIXMAN_VERSION"

export CHOST="$DEBARCH"
export CFLAGS="-I/deps/include"
export LDFLAGS="-I/deps/lib"
export CC="$CHOST"-gcc

./configure --prefix=/deps --target="$CHOST" --host="$CHOST" --build="$CHOST"

# build and install into prefix
make all -j$(nproc)
make install

cd ..

rm -rf pixman-$PIXMAN_VERSION/
