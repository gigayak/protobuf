import
  protobuf/simplerpc_pb,
  protobuf,
  locks,
  nativesockets, # needed for SocketHandle
  net,
  selectors,
  sharedlist,
  tables,
  threadpool, # needed for spawn()
  typetraits

type
  SimpleRPCWrappedHandler = ref object of RootObj
    handler: proc(wrappedRequestPb: SimpleRPCRequest): SimpleRPCResponse
    serviceName: string
    requestType: string
    responseType: string

  SimpleRPCHandler[REQ, RESP] = proc(requestPb: REQ): RESP

var rpcHandlers: SharedList[SimpleRPCWrappedHandler]
# rpcHandlers.init() # present in master
rpcHandlers = initSharedList[SimpleRPCWrappedHandler]() # deprecated in master, present in 0.17.2 (latest release)

proc registerRPCHandler*[REQ, RESP](serviceName: string, handler: SimpleRPCHandler[REQ, RESP]) =
  var handlerClosure = proc(wrappedRequestPb: SimpleRPCRequest): SimpleRPCResponse =
    stderr.writeLine("entering service-specific handler wrapper for " & serviceName)
    if wrappedRequestPb.requestType != REQ.name:
      raise newException(ObjectConversionError, "unexpected request type " & wrappedRequestPb.requestType & " in " & serviceName & " handler; expected " & REQ.name)
    var requestPb: REQ
    stderr.writeLine("deserializing " & wrappedRequestPb.requestType & " protobuf")
    requestPb.deserializeProto(wrappedRequestPb.requestContents)
    stderr.writeLine("calling handler to get " & RESP.name & " protobuf")
    var responsePb: RESP
    responsePb = handler(requestPb)
    var respWrapperPb: SimpleRPCResponse = newSimpleRPCResponse()
    respWrapperPb.serviceName = serviceName
    respWrapperPb.responseType = RESP.name
    stderr.writeLine("serializing " & RESP.name & " proto into SimpleRPCResponse")
    respWrapperPb.responseContents = responsePb.serialize()
    stderr.writeLine("exiting service-specific handler wrapper for " & serviceName)
    return respWrapperPb
  var handlerObj: SimpleRPCWrappedHandler
  new(handlerObj)
  handlerObj.handler = handlerClosure
  handlerObj.serviceName = serviceName
  handlerObj.requestType = REQ.name
  handlerObj.responseType = RESP.name
  rpcHandlers.add(handlerObj)

proc key(h: SimpleRPCWrappedHandler): string =
  result = h.serviceName & ":" & h.requestType

proc getRPCHandlerMap(): TableRef[string, SimpleRPCWrappedHandler] =
  result = newTable[string, SimpleRPCWrappedHandler]()
  for handler in rpcHandlers:
    var newHandler: SimpleRPCWrappedHandler
    deepCopy(newHandler, handler)
    result[newHandler.key()] = newHandler

# TODO: this entire proc needs to be rewritten using wakeClient
# code.
#
# wakeClient() code below must be merged into this in a loop
# should basically do wakeClient->inputClosure->outputClosure
# logic in a tight loop.
proc startRPCClientThread(socket: Socket, addess: string) {.thread.} =
  var handlerMap: TableRef[string, SimpleRPCWrappedHandler] = getRPCHandlerMap()
  var running: bool = true
  while running:
    # Read request protobuf from socket
    #
    # First few bytes are expected to be a varint-encoded
    # length corresponding to the length of the serialized
    # SimpleRPCRequest object.
    #
    # The main protobuf library doesn't support streaming,
    # so for the moment we have a slightly kludgy implementation
    # duplicated here.
    var lengthU: uint64 = uint64(0)
    var groupsAdded: int = 0
    var done: bool = false
    var currentData: string = ""
    while not done:
      if socket.recv(currentData, 1) == 0:
        if groupsAdded > 0:
          raise newException(IOError, "RPC socket closed abruptly while reading request")
        else:
          stderr.writeLine("client correctly closed connection between RPCs")
          socket.close()
          return
      var currentGroup: uint8 = uint8(currentData[0])
      if (currentGroup and uint8(0x80)) == uint8(0):
        done = true
      lengthU = lengthU or (uint64(currentGroup and uint8(0x7F)) shl (groupsAdded*7))
      groupsAdded += 1
    var length: int = int(lengthU)
    stderr.writeLine("reading " & $(length) & " bytes of RPC request")

    var requestBufferRaw: string = ""
    var requestBuffer: string = ""
    var bytesRead: int = 0
    var numReads: int = 0
    while bytesRead < length:
      var currentBytesRead: int = socket.recv(requestBufferRaw, length)
      if currentBytesRead == 0:
        raise newException(IOError, "RPC socket closed abruptly while reading request")
      requestBuffer &= requestBufferRaw
      bytesRead += currentBytesRead
      numReads += 1
    stderr.writeLine("finished reading " & $(bytesRead) & "bytes of RPC request in " & $(numReads) & " reads (buffer is now " & $(len(requestBuffer)) & " bytes large)")

    var requestPb: SimpleRPCRequest = deserializeSimpleRPCRequest(requestBuffer)
    stderr.writeLine("RPC request deserialized, has " & $(len(requestPb.requestContents)) & "-byte payload")

    # Generate key for this request.
    var key: string = requestPb.serviceName & ":" & requestPb.requestType
    var responsePb: SimpleRPCResponse = handlerMap[key].handler(requestPb)
    var responseBuffer: string = responsePb.serialize()

    # Send response via socket
    # Again, we prefix the message with a protobuf-encoded length
    # to ensure that the other side knows how many bytes should be
    # read off.
    socket.send(serializeProtoVarint(uint64(responseBuffer.len())) & responseBuffer)
    stderr.writeLine("response sent")


# This is the main RPC thread.
#
# It should listen for clients, but also be
# capable of waking them whenever data arrives
# for them.
#
# Currently, all RPC handler execution fully
# blocks this thread.  That's okay, since the
# initial use case is just a single UI client
# connecting - but in the future, an option may
# need to be added to spawn separate threads
# for each client, at the expense of having
# handlers execute in that thread instead of
# the main thread.
proc startRPCServerThread(port: int) {.thread.} =
  var listener: Socket = newSocket()
  listener.bindAddr(Port(port))
  listener.listen()
  var sel: Selector = newSelector()
  var listenerHandle: SocketHandle = listener.getFd()
  selectors.register(sel, listenerHandle, {EvRead}, nil)
  while true:
    for info in sel.select(-1):
      stderr.writeLine("accepting a new client")
      var sck: Socket = newSocket()
      var address: string = ""
      listener.acceptAddr(sck, address)
      spawn startRPCClientThread(sck, address)

proc startMainLoop*(port: int) =
  # Listen for new connections.
  spawn startRPCServerThread(port)
