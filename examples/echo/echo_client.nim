import
  echo_service_pb,
  protobuf/simplerpc_client

var conn: SimpleRPCConnection = dialSimpleRPC("127.0.0.1", 9888)
var svc = conn.getService(EchoServiceDescriptor)
var request: EchoRequest = newEchoRequest()
request.payload = "Test EchoService request payload"
stderr.writeLine("Sending Echo('" & request.payload & "').")
var response: EchoResponse = svc.Echo(request)
stderr.writeLine("Got: '" & response.payload & "'.")
