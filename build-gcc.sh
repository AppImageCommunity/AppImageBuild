#! /bin/bash

set -xe

wget https://ftp.wrz.de/pub/gnu/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.gz -O- | tar xz

cd gcc-$GCC_VERSION

contrib/download_prerequisites

mkdir objdir
cd objdir

EXTRA_CONFIGURE_FLAGS=" --libdir=/usr/lib64"
if [ "$ARCH" == "i386" ]; then
    EXTRA_CONFIGURE_FLAGS=" --build=i686-linux-gnu --host=i686-linux-gnu --target=i686-linux-gnu"
fi
../configure --prefix=/usr --enable-language=c,c++ --disable-multilib $EXTRA_CONFIGURE_FLAGS

set +x
echo "+ make -j$(nproc)" 1>&2

if [ -z $VERBOSE ]; then
    make -j$(nproc) 2>&1 | while read line; do
        echo -n .
    done
    echo
else
    make -j$(nproc)
fi
set -x

make install

cd ../../
rm -rf gcc-$GCC_VERSION/
