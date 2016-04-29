#!/bin/sh
cmake -DSOLIDITY=0 -DCMAKE_BUILD_TYPE=Release                                                             \
      -DEVMJIT=0 -DGUI=0 -DFATDB=0 -DETHASHCL=0 -DMINIUPNPC=1                                             \
      -DTOOLS=0 -DTESTS=0 -DETH_STATIC=1                                                                  \
                                                                                                          \
      -DCMAKE_CXX_FLAGS='-Wno-error -static'                                                              \
                                                                                                          \
      -DGMP_LIBRARY=/usr/lib/libgmp.a                                                                     \
      -DGMP_INCLUDE_DIR=/usr/include/                                                                     \
                                                                                                          \
      -DCURL_LIBRARY=/usr/lib/libcurl.a                                                                   \
      -DCURL_INCLUDE_DIR=/usr/include/                                                                    \
                                                                                                          \
      -DMHD_LIBRARY=/usr/lib/libmicrohttpd.a                                                              \
      -DMHD_INCLUDE_DIR=/usr/include                                                                      \
                                                                                                          \
      -DJSONCPP_LIBRARY=/src/built/lib/libjsoncpp.a                                                       \
      -DJSONCPP_INCLUDE_DIR=/src/built/include/                                                           \
                                                                                                          \
      -DCRYPTOPP_LIBRARY=/src/built/lib/libcryptlib.a                                                     \
      -DCRYPTOPP_INCLUDE_DIR=/src/built/include                                                           \
                                                                                                          \
      -DLEVELDB_LIBRARY=/src/built/lib/libleveldb.a                                                       \
      -DLEVELDB_INCLUDE_DIR=/src/built/include/                                                           \
                                                                                                          \
      -DMINIUPNPC_LIBRARY=/src/built/lib/libminiupnpc.a                                                   \
      -DMINIUPNPC_INCLUDE_DIR=/src/built/include/                                                         \
                                                                                                          \
      -DJSON_RPC_CPP_CLIENT_LIBRARY=/src/built/lib/libjsonrpccpp-client.a                                 \
      -DJSON_RPC_CPP_COMMON_LIBRARY=/src/built/lib/libjsonrpccpp-common.a                                 \
      -DJSON_RPC_CPP_SERVER_LIBRARY=/src/built/lib/libjsonrpccpp-server.a                                 \
      -DJSON_RPC_CPP_INCLUDE_DIR=/src/built/include                                                       \
                                                                                                          \
      -DBoost_USE_STATIC_LIBS=1                                                                           \
      -DBoost_USE_STATIC_RUNTIME=1                                                                        \
      -DBoost_FOUND=1                                                                                     \
                                                                                                          \
      -DBoost_INCLUDE_DIR=/src/boost/include/                                                             \
      -DBoost_CHRONO_LIBRARY=/src/boost/lib/libboost_chrono.a                                             \
      -DBoost_CHRONO_LIBRARIES=/src/boost/lib/libboost_chrono.a                                           \
      -DBoost_DATE_TIME_LIBRARY=/src/boost/lib/libboost_date_time.a                                       \
      -DBoost_DATE_TIME_LIBRARIES=/src/boost/lib/libboost_date_time.a                                     \
      -DBoost_FILESYSTEM_LIBRARY=/src/boost/lib/libboost_filesystem.a                                     \
      -DBoost_FILESYSTEM_LIBRARIES=/src/boost/lib/libboost_filesystem.a                                   \
      -DBoost_PROGRAM_OPTIONS_LIBRARY=/src/boost/lib/libboost_program_options.a                           \
      -DBoost_PROGRAM_OPTIONS_LIBRARIES=/src/boost/lib/libboost_program_options.a                         \
      -DBoost_RANDOM_LIBRARY=/src/boost/lib/libboost_random.a                                             \
      -DBoost_RANDOM_LIBRARIES=/src/boost/lib/libboost_random.a                                           \
      -DBoost_REGEX_LIBRARY=/src/boost/lib/libboost_regex.a                                               \
      -DBoost_REGEX_LIBRARIES=/src/boost/lib/libboost_regex.a                                             \
      -DBoost_SYSTEM_LIBRARY=/src/boost/lib/libboost_system.a                                             \
      -DBoost_SYSTEM_LIBRARIES=/src/boost/lib/libboost_system.a                                           \
      -DBoost_THREAD_LIBRARY=/src/boost/lib/libboost_thread.a                                             \
      -DBoost_THREAD_LIBRARIES=/src/boost/lib/libboost_thread.a                                           \
      -DBoost_UNIT_TEST_FRAMEWORK_LIBRARY=/src/boost/lib/libboost_unit_test_framework.a                   \
      -DBoost_UNIT_TEST_FRAMEWORK_LIBRARIES=/src/boost/lib/libboost_unit_test_framework.a                 \
      ..
