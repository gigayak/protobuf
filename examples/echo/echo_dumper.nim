import
  echo_service_pb

var requestBuffer: string = readAll(stdin)

var request: EchoRequest = deserializeEchoRequest(requestBuffer)
stderr.writeLine("Payload is:")
stdout.write(request.payload)
