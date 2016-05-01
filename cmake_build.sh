#!/bin/sh
cmake -DCMAKE_BUILD_TYPE=Release \
      -DEVMJIT=0 -DGUI=0 -DFATDB=0 -DETHASHCL=0 -DMINIUPNPC=1 \
      -DTOOLS=0 \
      -DTESTS=0 \
      -DSOLIDITY=0 \
      \
      -DSTATIC_LINKING=1 \
      \
      -DJSONCPP_LIBRARY=/src/built/lib/libjsoncpp.a \
      -DJSONCPP_INCLUDE_DIR=/src/built/include/ \
      \
      -DCRYPTOPP_LIBRARY=/src/built/lib/libcryptlib.a \
      -DCRYPTOPP_INCLUDE_DIR=/src/built/include/ \
      \
      -DLEVELDB_LIBRARY=/src/built/lib/libleveldb.a \
      -DLEVELDB_INCLUDE_DIR=/src/built/include/ \
      \
      -DMINIUPNPC_LIBRARY=/src/built/lib/libminiupnpc.a \
      -DMINIUPNPC_INCLUDE_DIR=/src/built/include/ \
      \
      -DJSON_RPC_CPP_CLIENT_LIBRARY=/src/built/lib/libjsonrpccpp-client.a \
      -DJSON_RPC_CPP_COMMON_LIBRARY=/src/built/lib/libjsonrpccpp-common.a \
      -DJSON_RPC_CPP_SERVER_LIBRARY=/src/built/lib/libjsonrpccpp-server.a \
      -DJSON_RPC_CPP_INCLUDE_DIR=/src/built/include/ \
      ..
