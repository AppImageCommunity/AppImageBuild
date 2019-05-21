#! /bin/bash

set -xe

wget https://sourceware.org/pub/libffi/libffi-"$LIBFFI_VERSION".tar.gz -O- | tar xz

cd libffi-"$LIBFFI_VERSION"

./configure --prefix=/deps --host="$DEBARCH"

# build and install into prefix
make all -j$(nproc)
make install

cd ..

rm -rf libffi-"$LIBFFI_VERSION"/
