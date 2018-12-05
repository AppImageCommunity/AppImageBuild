#! /bin/bash

set -xe

wget https://ftp.fau.de/debian/pool/main/f/fuse/fuse_"$FUSE_VERSION".orig.tar.gz -O- | tar xz

cd fuse-"$FUSE_VERSION"

export CHOST="$DEBARCH"
export CFLAGS="-I/deps/include"
export LDFLAGS="-I/deps/lib"
export CC="$CHOST"-gcc

cat > fix-build-aarch64.patch <<\EOF
--- a/include/fuse_kernel.h
+++ b/include/fuse_kernel.h
@@ -88,12 +88,7 @@
 #ifndef _LINUX_FUSE_H
 #define _LINUX_FUSE_H
 
-#include <sys/types.h>
-#define __u64 uint64_t
-#define __s64 int64_t
-#define __u32 uint32_t
-#define __s32 int32_t
-#define __u16 uint16_t
+#include <linux/types.h>
 
 /*
  * Version negotiation:
EOF

patch -p1 < fix-build-aarch64.patch

./configure --prefix=/deps --target="$CHOST" --host="$CHOST" --build="$CHOST"

#find -type f -exec sed -i 's|#define __s64 int64_t||g' '{}' \;

# build and install into prefix
make all -j$(nproc)
make install

cd ..

rm -rf fuse-"$FUSE_VERSION"/
