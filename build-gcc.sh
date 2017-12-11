#! /bin/bash

set -xe

wget https://ftp.wrz.de/pub/gnu/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.gz -O- | tar xz

cd gcc-$GCC_VERSION

contrib/download_prerequisites

mkdir objdir
cd objdir

EXTRA_CONFIGURE_FLAGS=
if [ "$ARCH" == "i386" ]; then
    EXTRA_CONFIGURE_FLAGS=" --target=i386-linux"
fi
../configure --prefix=/usr --enable-language=c,c++ --disable-multilib $EXTRA_CONFIGURE_FLAGS

make -j$(nproc) &>/dev/null &
set +x
while ps -p $! &>/dev/null; do
    echo -n .; sleep 1;
done
echo
set -x

make install

cd ../../
rm -rf gcc-$GCC_VERSION/"
