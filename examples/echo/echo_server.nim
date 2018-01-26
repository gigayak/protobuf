import
  echo_service_pb,
  simplerpc_server,
  os

proc EchoHandler(req: EchoRequest): EchoResponse =
  echo "Received request"
  result = newEchoResponse()
  result.payload = req.payload

registerRPCHandler[EchoRequest, EchoResponse]("EchoService", EchoHandler)

const port: int = 9888
echo "about to start main loop"
startMainLoop(port)
while true:
  stderr.writeLine("main thread sleeping")
  sleep(60*1000)
