#!/bin/bash
cd "$(dirname "$0")"

for filename in echo_server.nim echo_client.nim echo_dumper.nim
do
  nim c \
    --path:"$PWD/../.." \
    --path:"$PWD/../../.." \
    --path:"$PWD/../../../../proto_out/modules" \
    --path:"$PWD/../../../../proto_out/modules/protobuf/examples/echo" \
    --threads:on \
    "$filename"
done
