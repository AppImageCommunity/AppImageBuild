#! /bin/bash

set -xe

wget https://ftp.fau.de/debian/pool/main/z/zsync/zsync_"$ZSYNC_VERSION".orig.tar.bz2 -O- | tar xj

cd zsync-"$ZSYNC_VERSION"

export CHOST="$DEBARCH"

export CFLAGS="-I/deps/include"
export CPPFLAGS="$CFLAGS"
export LDFLAGS="-L/deps/lib"

aclocal
autoconf
automake --add-missing

./configure --prefix=/deps --target="$CHOST" --build=x86_64-linux-gnu --host="$CHOST"

# build and install into prefix
make all -j$(nproc)
make install

cd ..

rm -rf zsync-"$ZSYNC_VERSION"/
