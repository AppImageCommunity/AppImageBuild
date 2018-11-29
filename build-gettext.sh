#! /bin/bash

set -xe

wget https://ftp.gnu.org/gnu/gettext/gettext-"$GETTEXT_VERSION".tar.gz -O- | tar xz

cd gettext-"$GETTEXT_VERSION"

export CHOST=arm-linux-gnueabihf
./configure --prefix=/deps --host="$CHOST" --target="$CHOST"

# build and install into prefix
make all -j$(nproc)
make install

cd ..

rm -rf gettext-"$GETTEXT_VERSION"/
