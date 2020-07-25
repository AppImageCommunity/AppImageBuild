#! /bin/bash

set -xe

wget https://github.com/python/cpython/archive/"$PYTHON_VERSION".tar.gz -O - | tar xz

cd cpython-"$PYTHON_VERSION"

export CHOST="$DEBARCH"
./configure --prefix=/usr

# build and install into prefix
make all -j$(nproc)
make install

cd ..

rm -rf cpython-"$PYTHON_VERSION"/
