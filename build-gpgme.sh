#! /bin/bash

set -xe

git clone https://dev.gnupg.org/source/gpgme.git -b gpgme-"$GPGME_VERSION" gpgme-"$GPGME_VERSION"

cd gpgme-"$GPGME_VERSION"

# needed for automake
export PATH=/deps/bin:"$PATH"

EXTRA_CONFIGURE_FLAGS=
if [ "$ARCH" == "i386" ]; then
    EXTRA_CONFIGURE_FLAGS=" --build=i686-linux-gnu --host=i686-linux-gnu --target=i686-linux-gnu"
elif [ "$ARCH" == "armhf" ] || [ "$ARCH" == "aarch64" ]; then
    EXTRA_CONFIGURE_FLAGS=" --host=$DEBARCH --target=$DEBARCH"
fi

[ -f autogen.sh ] && ./autogen.sh

./configure --enable-maintainer-mode --prefix=/deps $EXTRA_CONFIGURE_FLAGS

# some tests won't find libgcrypt otherwise
export LD_LIBRARY_PATH=/deps/lib:"$LD_LIBRARY_PATH"

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
rm -rf gpgme-"$GPGME_VERSION"/
