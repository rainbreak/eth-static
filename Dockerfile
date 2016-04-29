FROM alpine:3.3

# We can static link to these with -static if we want
RUN apk --no-cache --update add --virtual dependencies \
            libgcc \
            libstdc++
RUN apk --no-cache --update add --virtual build-dependencies \
            bash \
            cmake \
            curl-dev \
            git \
            gcc \
            g++ \
            linux-headers \
            make \
            perl \
            python \
            scons\

            boost-dev \
            gmp-dev\
            libmicrohttpd-dev \
            openssl-dev


RUN mkdir -p /src/deps

WORKDIR /src/deps

RUN git clone https://github.com/mmoss/cryptopp.git
RUN git clone https://github.com/open-source-parsers/jsoncpp.git
RUN git clone https://github.com/cinemast/libjson-rpc-cpp
RUN git clone https://github.com/google/leveldb
RUN git clone https://github.com/miniupnp/miniupnp

RUN mkdir -p /src/built/include /src/built/lib

RUN cd cryptopp && \
    cmake -DCRYPTOPP_LIBRARY_TYPE=STATIC \
          -DCRYPTOPP_RUNTIME_TYPE=STATIC \
          -DCRYPTOPP_BUILD_TESTS=FALSE \
          -DCMAKE_INSTALL_PREFIX=/src/built/ \
          . && \
    make cryptlib && \
    cp -r src /src/built/include/cryptopp && \
    cp src/libcryptlib.a /src/built/lib/


## These aren't really necessary for solc, but can't build without them
## as devcore links to them.
RUN cd jsoncpp && \
    cmake -DCMAKE_INSTALL_PREFIX=/src/built/ . && \
    make jsoncpp_lib_static && \
    make install

RUN mkdir -p libjson-rpc-cpp/build && \
    sed -e 's/^#include <string>/#include <string.h>/' libjson-rpc-cpp/src/jsonrpccpp/server/connectors/unixdomainsocketserver.cpp -i && \
    cd libjson-rpc-cpp/build && \
    cmake -DJSONCPP_LIBRARY=../../jsoncpp/src/lib_json/libjsoncpp.a \
          -DJSONCPP_INCLUDE_DIR=../../jsoncpp/include/ \
          -DBUILD_STATIC_LIBS=YES                      \
          -DBUILD_SHARED_LIBS=NO                       \
          -DCOMPILE_TESTS=NO                           \
          -DCOMPILE_EXAMPLES=NO                        \
          -DCOMPILE_STUBGEN=NO                         \
          -DCMAKE_INSTALL_PREFIX=/src/built/           \
          .. && \
    make install

RUN cd leveldb && \
    make && \
    cp -rv include/leveldb /src/built/include/ && \
    cp -v out-static/libleveldb.a /src/built/lib/

RUN cd miniupnp/miniupnpc && \
    make upnpc-static && \
    INSTALLPREFIX=/src/built/ make install

# make sure that boost links statically
RUN mkdir -p /src/boost/lib /src/boost/include/boost
RUN cp /usr/lib/libboost*.a /src/boost/lib/
RUN cp -r /usr/include/boost /src/boost/include/
RUN apk del boost-dev

WORKDIR /src

RUN git clone https://github.com/rainbeam/webthree-umbrella

RUN cd webthree-umbrella && \
    git checkout static-linking --force && \
    git submodule update --init

RUN mkdir -p /src/webthree-umbrella/build
WORKDIR /src/webthree-umbrella/build

COPY cmake_build.sh ./

RUN sh ./cmake_build.sh

RUN sed -e 's/^#if defined(__linux__)/#if defined(__ignoreme__)/' -i ../libweb3core/libdevcore/Log.cpp

RUN make --jobs=2 eth

RUN cp webthree/eth/eth /usr/local/bin/
