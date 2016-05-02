FROM debian:stretch

RUN apt-get update && apt-get install -y build-essential \
                                      cmake \
                                      git \
                                      libboost-all-dev \
                                      libcrypto++-dev \
                                      libcrypto++6 \

                                      libcurl4-openssl-dev \
                                      libssh2-1-dev \
                                      libssl-dev \
                                      libz-dev \

                                      libedit-dev \
                                      libgmp-dev \
                                      libjsoncpp-dev \
                                      libjsonrpccpp-dev \
                                      libjsonrpccpp-tools \
                                      libleveldb-dev \
                                      libmicrohttpd-dev \
                                      libminiupnpc-dev \
                                      libncurses5-dev \
                                      libreadline-dev \
                                      opencl-headers \

                                      musl \
                                      musl-dev \
                                      musl-tools

ENV CURL curl-7.48.0
ENV PREFIX /src/built

WORKDIR /src/deps
RUN git clone https://github.com/curl/curl

RUN cd curl \
 && git checkout ${CURL} \
 && ./configure --prefix=${PREFIX} --enable-static --disable-shared \
                --disable-ldap --disable-ldaps --without-libidn \
                --disable-rtsp --without-librtmp --disable-manual \
                --disable-tls-srip --without-gnutls \
                --without-ssl --without-libssh2 --without-zlib \
 && make \
 && make install

WORKDIR /src

ENV buildbranch=develop
ADD https://api.github.com/repos/ethereum/webthree-umbrella/compare/${buildbranch}...HEAD /dev/null
RUN git clone https://github.com/ethereum/webthree-umbrella

RUN cd webthree-umbrella && \
    git checkout ${buildbranch} --force && \
    git submodule update --init --recursive

RUN mkdir -p /src/webthree-umbrella/build
WORKDIR /src/webthree-umbrella/build

ADD cmake_build.sh ./
RUN sh ./cmake_build.sh

RUN make --jobs=2 eth solc soltest lllc

RUN install -s webthree/eth/eth /usr/local/bin/
RUN install -s solidity/solc/solc /usr/local/bin/
RUN install -s solidity/lllc/lllc /usr/local/bin/
RUN install -s solidity/test/soltest /usr/local/bin/
