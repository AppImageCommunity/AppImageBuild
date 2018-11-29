#! /bin/bash

set -xe

find /deps

wget https://cmake.org/files/v$(echo $CMAKE_VERSION | cut -d. -f-2)/cmake-$CMAKE_VERSION.tar.gz -O- | tar xz

cd cmake-$CMAKE_VERSION

./configure --prefix=/usr --parallel=$(nproc) --no-qt-gui --system-curl

# build first version of CMake so that build can be reconfigured
make -j$(nproc) cmake
make install

# reconfigure CMake to make it a more "static" build and re-build
cmake . -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_C_STANDARD:STRING=11 \
    -DCMAKE_CXX_STANDARD:STRING=14 \
    -DCMAKE_C_FLAGS:STRING='-D_POSIX_C_SOURCE=199506L -D_POSIX_SOURCE=1 -D_SVID_SOURCE=1 -D_BSD_SOURCE=1' \
    -DCMAKE_EXE_LINKER_FLAGS:STRING='-static-libstdc++ -static-libgcc'

# build and install
make all -j$(nproc)
make install

cd ..

rm -rf cmake-$CMAKE_VERSION/
