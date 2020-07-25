#! /bin/bash

set -xe

wget https://ftp.pcre.org/pub/pcre/pcre-"$PCRE_VERSION".tar.bz2 -O- | tar xj

cd pcre-$PCRE_VERSION

# required to make the compiler happy
export CFLAGS="$CFLAGS -Wno-error"

EXTRA_CONFIGURE_FLAGS=
if [ "$ARCH" == "i386" ]; then
    EXTRA_CONFIGURE_FLAGS=" --build=i686-linux-gnu --host=i686-linux-gnu --target=i686-linux-gnu"
elif [ "$ARCH" == "armhf" ] || [ "$ARCH" == "aarch64" ]; then
    EXTRA_CONFIGURE_FLAGS=" --host=$DEBARCH --target=$DEBARCH"

    # https://askubuntu.com/a/338670
    export PATH=/deps/bin:"$PATH"
fi

#[ -f autogen.sh ] && ./autogen.sh

./configure --prefix=/deps --enable-utf --enable-unicode-properties $EXTRA_CONFIGURE_FLAGS

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
rm -rf pcre-$PCRE_VERSION/
