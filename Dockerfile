FROM debian:stretch

RUN apt-get update && apt-get install -y build-essential \
                                      cmake \
                                      git \
                                      libboost-all-dev \
                                      libcrypto++-dev \
                                      libcrypto++6 \

                                      libcurl4-openssl-dev \
                                      libssh2-dev \
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
                                      opencl-headers

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

ADD cmake_build.sh ./
RUN sh ./cmake_build.sh

RUN make --jobs=2 eth solc soltest lllc

RUN install -s webthree/eth/eth /usr/local/bin/
RUN install -s solidity/solc/solc /usr/local/bin/
RUN install -s solidity/lllc/lllc /usr/local/bin/
RUN install -s solidity/test/soltest /usr/local/bin/
