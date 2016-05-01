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

ENV PREFIX /src/built

RUN mkdir -p ${PREFIX}/include ${PREFIX}/lib

RUN cd cryptopp && \
    cmake -DCRYPTOPP_LIBRARY_TYPE=STATIC \
          -DCRYPTOPP_RUNTIME_TYPE=STATIC \
          -DCRYPTOPP_BUILD_TESTS=FALSE \
          -DCMAKE_INSTALL_PREFIX=${PREFIX} \
          . && \
    make cryptlib && \
    cp -r src ${PREFIX}/include/cryptopp && \
    cp src/libcryptlib.a ${PREFIX}/lib/


## These aren't really necessary for solc, but can't build without them
## as devcore links to them.
RUN cd jsoncpp && \
    cmake -DCMAKE_INSTALL_PREFIX=${PREFIX} . && \
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
          -DCMAKE_INSTALL_PREFIX=${PREFIX}             \
          .. && \
    make install

RUN cd leveldb && \
    make && \
    cp -rv include/leveldb ${PREFIX}/include/ && \
    cp -v out-static/libleveldb.a ${PREFIX}/lib/

RUN cd miniupnp/miniupnpc && \
    make upnpc-static && \
    INSTALLPREFIX=${PREFIX} make install

WORKDIR /src

ENV buildbranch=develop
ADD https://api.github.com/repos/ethereum/webthree-umbrella/compare/${buildbranch}...HEAD /dev/null
RUN git clone https://github.com/ethereum/webthree-umbrella

RUN cd webthree-umbrella && \
    git checkout ${buildbranch} --force && \
    git submodule update --init --recursive

RUN mkdir -p /src/webthree-umbrella/build
WORKDIR /src/webthree-umbrella/build

# stop complaining about sys/poll.h
RUN sed -i -E -e 's/include <sys\/poll.h>/include <poll.h>/' /usr/include/boost/asio/detail/socket_types.hpp

COPY cmake_build.sh ./

RUN sh ./cmake_build.sh

RUN make --jobs=2 eth solc soltest lllc

RUN install -s webthree/eth/{eth,solc,soltest,lllc} /usr/local/bin/
