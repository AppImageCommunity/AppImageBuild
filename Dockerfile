FROM centos:6.9

RUN yum install -y gcc gcc-c++ wget make gnupg zip git subversion glib2-devel automake libtool patch zlib-devel cairo-devel openssl-devel libstdc++

ARG GCC_VERSION=5.3.0
RUN wget -nv https://ftp.wrz.de/pub/gnu/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.gz && \
    tar xfv gcc-$GCC_VERSION.tar.gz && \
    cd gcc-$GCC_VERSION && \
    contrib/download_prerequisites && \
    mkdir objdir && \
    cd objdir && \
    ../configure --prefix=/usr --enable-language=c,c++ --disable-multilib && \
    make -j$(nproc) && \
    yum erase -y gcc gcc-c++ && \
    make install && \
    cd ../../ && \
    rm -rf gcc-$GCC_VERSION/ gcc-$GCC_VERSION.tar.gz

#ARG CURL_VERSION=7.57.0
#RUN wget -nv https://github.com/curl/curl/releases/download/curl-$(echo $CURL_VERSION | tr . _)/curl-$CURL_VERSION.tar.gz && \
#    tar xfv curl-$CURL_VERSION.tar.gz && \
#    cd curl-$CURL_VERSION && \
#    ./configure --prefix=/usr --disable-ftp --disable-ldap --disable-telnet --disable-dict --disable-tftp --disable-imap --disable-pop3 --disable-smtp && \
#    make -j$(nproc) && \
#    make install && \
#    cd .. && \
#    rm -rf curl-$CURL_VERSION/ curl-$CURL_VERSION.tar.gz

RUN bash -xc "yum install -y curl-devel"

ARG CMAKE_VERSION=3.10.0
# note: cmake binary is copied to circumvent permission problems when building second time
RUN bash -x -c "wget -nv https://cmake.org/files/v$(echo $CMAKE_VERSION | cut -d. -f-2)/cmake-$CMAKE_VERSION.tar.gz && \
    tar xfv cmake-$CMAKE_VERSION.tar.gz && \
    cd cmake-$CMAKE_VERSION && \
    ./configure --prefix=/usr --parallel=$(nproc) --no-qt-gui --system-curl && \
    make -j$(nproc) cmake && \
    make install && \
    cmake . -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_C_STANDARD:STRING=11 -DCMAKE_CXX_STANDARD:STRING=14 -DCMAKE_C_FLAGS:STRING='-D_POSIX_C_SOURCE=199506L -D_POSIX_SOURCE=1 -D_SVID_SOURCE=1 -D_BSD_SOURCE=1' -DCMAKE_EXE_LINKER_FLAGS:STRING='-static-libstdc++ -static-libgcc' && \
    make all -j$(nproc) && \
    make install && \
    cd .. && \
    rm -rf cmake-$CMAKE_VERSION/ cmake-$CMAKE_VERSION.tar.gz"

ARG AUTOCONF_VERSION=2.69
RUN bash -xc "wget -nv https://ftp.gnu.org/gnu/autoconf/autoconf-$AUTOCONF_VERSION.tar.gz && \
    tar xfv autoconf-$AUTOCONF_VERSION.tar.gz && \
    cd autoconf-$AUTOCONF_VERSION && \
    ./configure --prefix=/usr && \
    make -j$(nproc) && \
    make install && \
    cd .. && \
    rm -rf autoconf-$AUTOCONF_VERSION/ autoconf-$AUTOCONF_VERSION.tar.gz"

ARG AUTOMAKE_VERSION=1.15
RUN bash -xc "wget -nv https://ftp.gnu.org/gnu/automake/automake-$AUTOMAKE_VERSION.tar.gz && \
    tar xfv automake-$AUTOMAKE_VERSION.tar.gz && \
    cd automake-$AUTOMAKE_VERSION && \
    ./configure --prefix=/usr && \
    make all -j$(nproc) && \
    make install && \
    cd .. && \
    rm -rf automake-$AUTOMAKE_VERSION/ automake-$AUTOMAKE_VERSION.tar.gz"

RUN bash -xc "yum install -y fuse-devel"
