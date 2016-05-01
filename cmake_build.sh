#!/bin/sh
cmake -DCMAKE_BUILD_TYPE=Release \
      -DEVMJIT=0 -DGUI=0 -DFATDB=0 -DETHASHCL=0 -DMINIUPNPC=1 \
      -DTOOLS=0 \
      -DTESTS=0 \
      -DSOLIDITY=0 \
      \
      -DSTATIC_LINKING=1 \
      -DCMAKE_PREFIX_PATH=/src/built/ \
      ..
