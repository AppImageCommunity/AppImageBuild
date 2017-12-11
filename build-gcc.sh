#! /bin/bash

set -xe

yum install -y gcc gcc-c++

wget https://ftp.wrz.de/pub/gnu/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.gz -O- | tar xz

cd gcc-$GCC_VERSION

contrib/download_prerequisites

mkdir objdir
cd objdir

../configure --prefix=/usr --enable-language=c,c++ --disable-multilib

make -j$(nproc) &>/dev/null &
set +x
while ps -p $! &>/dev/null; do
    echo -n .; sleep 1;
done
echo
set -x

yum erase -y gcc gcc-c++

make install

cd ../../
rm -rf gcc-$GCC_VERSION/"
