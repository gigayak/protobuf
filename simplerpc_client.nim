import
  macros,
  net,
  protobuf/protobuf,
  protobuf/simplerpc_pb,
  typetraits


# TODO: convert to Concept or something similar to Go interface
type SimpleRPCConnection* = ref object of RootObj
  socket*: Socket
  address*: string
  port*: int

proc dialSimpleRPC*(address: string, port: int): SimpleRPCConnection =
  var socket = newSocket()
  socket.connect(address, Port(port))
  # exceptions? this will raise OSError if it fails
  return SimpleRPCConnection(
    socket: socket,
    address: address,
    port: port,
  )

proc makeSimpleRPCCall[SVC, REQ, RESP](service: SVC, request: REQ): RESP =
  # Construct SimpleRPCRequest wrapper, which contains metadata
  # needed to route the request properly on the server side.
  var rpcRequest: SimpleRPCRequest = newSimpleRPCRequest()
  rpcRequest.serviceName = SVC.name
  rpcRequest.requestType = REQ.name
  rpcRequest.requestContents = request.serialize()

  # Network transmission of request.
  # Start with length of actual request, so that other side
  # knows when to process request.  Then, follow up with
  # serialized wrapped request.
  var reqBytes: string = rpcRequest.serialize()
  stderr.write("Request size is " & $(len(reqBytes)) & " bytes\n")
  service.connection.socket.send(serializeProtoVarInt(len(reqBytes)) & reqBytes)

  # Read varint length descriptor from remote side, so we
  # know how many bytes of response to read.  This is very
  # similar to the code in simplerpc_server.
  var lengthU: uint64 = uint64(0)
  var groupsAdded: int = 0
  var done: bool = false
  var currentData: string = ""
  while not done:
    if service.connection.socket.recv(currentData, 1) == 0:
      raise newException(IOError, "RPC socket closed abruptly while reading response")
    var currentGroup: uint8 = uint8(currentData[0])
    if (currentGroup and uint8(0x80)) == uint8(0):
      done = true
    lengthU = lengthU or (uint64(currentGroup and uint8(0x7F)) shl (groupsAdded*7))
    groupsAdded += 1
  var length: int = int(lengthU)

  # Read wrapped response, and then start deserialization
  # required to get return value.
  var responseBufferRaw: string = ""
  var responseBuffer: string = ""
  var bytesRead: int = 0
  var numReads: int = 0
  while bytesRead < length:
    var currentBytesRead: int = service.connection.socket.recv(responseBufferRaw, length)
    if currentBytesRead == 0:
      raise newException(IOError, "RPC socket closed abruptly while reading request")
    responseBuffer &= responseBufferRaw
    bytesRead += currentBytesRead
    numReads += 1

  var rpcResponse: SimpleRPCResponse = deserializeSimpleRPCResponse(responseBuffer)
  new(result)
  result.deserializeProto(rpcResponse.responseContents)

#proc getService*(connection: SimpleRPCConnection, serviceDesc: RPCServiceDescriptor): 

#proc prepareSimpleRPCService*(serviceDesc: RPCServiceDescriptor) =

macro getService*(connection: SimpleRPCConnection, serviceDesc: static[RPCServiceDescriptor]): untyped =
  result = newStmtList()

  # If this service has never been grabbed before, it's
  # going to lack an object definition and the per-method
  # proc definitions bound to it - so we have to autogenerate
  # those if they're missing.
  when not declared(serviceDesc.name):
    # Generate the service object type automatically.
    # This mostly just holds the connection object for us,
    # and acts as a hint for static dispatch.
    #
    # This should create:
    #   type <servicename>* = ref object
    #     connection*: SimpleRPCConnection
    #
    # That has this AST:
    #   StmtList
    #     TypeSection
    #       TypeDef
    #         Postfix
    #           Ident !"*"
    #           Ident !serviceDesc.name
    #         Empty
    #         RefTy
    #           ObjectTy
    #             Empty
    #             Empty
    #             RecList
    #               IdentDefs
    #                 Postfix
    #                   Ident !"*"
    #                   Ident !"connection"
    #                 Ident !"SimpleRPCConnection"
    #                 Empty
    result.add(
      newNimNode(nnkTypeSection).add(
        newNimNode(nnkTypeDef).add(
          postfix(ident(serviceDesc.name), "*"),
          newEmptyNode(),
          newNimNode(nnkRefTy).add(
            newNimNode(nnkObjectTy).add(
              newEmptyNode(),
              newEmptyNode(),
              newNimNode(nnkRecList).add(
                newNimNode(nnkIdentDefs).add(
                  postfix(ident("connection"), "*"),
                  ident("SimpleRPCConnection"),
                  newEmptyNode(),
                ),
              ),
            ),
          ),
        ),
      ),
    )

    # Now generate each and every method binding.
    for methodDesc in serviceDesc.methods:
      result.add(
        newNimNode(nnkProcDef).add(
          postfix(ident(methodDesc.name), "*"),
          newEmptyNode(), # unused in procs, only used in templates/macros
          newEmptyNode(), # generic type paramters ([T] and such)
          newNimNode(nnkFormalParams).add(
            ident(methodDesc.responseTypeName),
            newNimNode(nnkIdentDefs).add(
              ident("service"),
              ident(serviceDesc.name),
              newEmptyNode(),
            ),
            newNimNode(nnkIdentDefs).add(
              ident("request"),
              ident(methodDesc.requestTypeName),
              newEmptyNode()
            ),
          ),
          newEmptyNode(), # pragmas
          newEmptyNode(), # reserved
          newNimNode(nnkStmtList).add(
            newNimNode(nnkReturnStmt).add(
              newNimNode(nnkCall).add(
                newNimNode(nnkBracketExpr).add(
                  bindSym("makeSimpleRPCCall"), # use bindSym to use unexported symbol
                  ident(serviceDesc.name),
                  ident(methodDesc.requestTypeName),
                  ident(methodDesc.responseTypeName),
                ),
                ident("service"),
                ident("request"),
              ),
            ),
          ),
        ),
      )

  # Okay - at this point, the service and all of its methods
  # should exist somewhere in scope.  (It's unfortunately a
  # little weird to figure out what module they're declared in,
  # which is a shame... makes importing a service type difficult.
  # Not sure how much of a problem that will turn out to be.)
  #
  # Now, we just return an instantiation of the service as the
  # macro expression to evaluate, so that this acts like a proc
  # that returns a service object:
  #
  #  nnkCall(
  #    nnkIdent(!(serviceDesc.name)),
  #    connection,
  #  ),
  result.add(
    newNimNode(nnkObjConstr).add(
      ident(serviceDesc.name),
      newNimNode(nnkExprColonExpr).add(
        ident("connection"),
        connection,
      ),
    ),
  )

# The above macro should automatically implement the following:

#type EchoService* = ref object of RootObj
#  connection*: SimpleRPCConnection

#proc getEchoService*(connection: SimpleRPCConnection): EchoService =
#  return EchoService(connection: connection)

#proc Echo*(service: EchoService, request: EchoRequest): EchoResponse =
#  return makeSimpleRPCCall[EchoService, EchoRequest, EchoResponse](service, request)
