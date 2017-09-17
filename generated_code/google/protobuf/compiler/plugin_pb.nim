import protobuf
import google/protobuf/descriptor_pb

type
  googleprotobufcompilerVersion* = ref object of RootProto
    major*: int32
    minor*: int32
    patch*: int32
    suffix*: string
  googleprotobufcompilerCodeGeneratorRequest* = ref object of RootProto
    file_to_generate*: seq[string]
    parameter*: string
    proto_file*: seq[googleprotobufFileDescriptorProto]
    compiler_version*: googleprotobufcompilerVersion
  googleprotobufcompilerCodeGeneratorResponseFile* = ref object of RootProto
    name*: string
    insertion_point*: string
    content*: string
  googleprotobufcompilerCodeGeneratorResponse* = ref object of RootProto
    error*: string
    file*: seq[googleprotobufcompilerCodeGeneratorResponseFile]

proc newgoogleprotobufcompilerVersion*(): googleprotobufcompilerVersion
proc deserializegoogleprotobufcompilerVersion*(a: string): googleprotobufcompilerVersion
proc newgoogleprotobufcompilerCodeGeneratorRequest*(): googleprotobufcompilerCodeGeneratorRequest
proc deserializegoogleprotobufcompilerCodeGeneratorRequest*(a: string): googleprotobufcompilerCodeGeneratorRequest
proc newgoogleprotobufcompilerCodeGeneratorResponseFile*(): googleprotobufcompilerCodeGeneratorResponseFile
proc deserializegoogleprotobufcompilerCodeGeneratorResponseFile*(a: string): googleprotobufcompilerCodeGeneratorResponseFile
proc newgoogleprotobufcompilerCodeGeneratorResponse*(): googleprotobufcompilerCodeGeneratorResponse
proc deserializegoogleprotobufcompilerCodeGeneratorResponse*(a: string): googleprotobufcompilerCodeGeneratorResponse

proc newgoogleprotobufcompilerVersion*(): googleprotobufcompilerVersion =
  new(result)
  result.major = 0
  result.minor = 0
  result.patch = 0
  result.suffix = ""

method serialize*(this: googleprotobufcompilerVersion): string =
  result = ""
  result &= serializeProtoVarintTag(uint32(1), this.major)
  result &= serializeProtoVarintTag(uint32(2), this.minor)
  result &= serializeProtoVarintTag(uint32(3), this.patch)
  result &= serializeProtoStringTag(uint32(4), this.suffix)

proc deserializegoogleprotobufcompilerVersion*(a: string): googleprotobufcompilerVersion =
  result = newgoogleprotobufcompilerVersion()
  var index: int = 0
  while index < a.len():
    var tag: uint32 = uint32(deserializeProtoVarint(a, index) and uint32(0xFFFFFFFF))
    var typeId: uint8 = tag and uint8(0x7)
    var id: uint32 = (tag and not uint32(0x7)) shr 3
    if id == uint32(1):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.major = cast[int32](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufcompilerVersion field major")
    elif id == uint32(2):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.minor = cast[int32](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufcompilerVersion field minor")
    elif id == uint32(3):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.patch = cast[int32](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufcompilerVersion field patch")
    elif id == uint32(4):
      if typeId == uint8(STRING_TAG_TYPE):
        result.suffix = cast[string](deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufcompilerVersion field suffix")

proc newgoogleprotobufcompilerCodeGeneratorRequest*(): googleprotobufcompilerCodeGeneratorRequest =
  new(result)
  result.file_to_generate = newSeq[string]()
  result.parameter = ""
  result.proto_file = newSeq[googleprotobufFileDescriptorProto]()
  result.compiler_version = newgoogleprotobufcompilerVersion()

method serialize*(this: googleprotobufcompilerCodeGeneratorRequest): string =
  result = ""
  for v in this.file_to_generate:
    result &= serializeProtoStringTag(uint32(1), v)
  result &= serializeProtoStringTag(uint32(2), this.parameter)
  for v in this.proto_file:
    result &= serializeProtoStringTag(uint32(15), v.serialize())
  result &= serializeProtoStringTag(uint32(3), this.compiler_version.serialize())

proc deserializegoogleprotobufcompilerCodeGeneratorRequest*(a: string): googleprotobufcompilerCodeGeneratorRequest =
  result = newgoogleprotobufcompilerCodeGeneratorRequest()
  var index: int = 0
  while index < a.len():
    var tag: uint32 = uint32(deserializeProtoVarint(a, index) and uint32(0xFFFFFFFF))
    var typeId: uint8 = tag and uint8(0x7)
    var id: uint32 = (tag and not uint32(0x7)) shr 3
    if id == uint32(1):
      if typeId == uint8(STRING_TAG_TYPE):
        result.file_to_generate.add(cast[string](deserializeProtoString(a, index)))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufcompilerCodeGeneratorRequest field file_to_generate")
    elif id == uint32(2):
      if typeId == uint8(STRING_TAG_TYPE):
        result.parameter = cast[string](deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufcompilerCodeGeneratorRequest field parameter")
    elif id == uint32(15):
      if typeId == uint8(STRING_TAG_TYPE):
        result.proto_file.add(deserializegoogleprotobufFileDescriptorProto(deserializeProtoString(a, index)))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufcompilerCodeGeneratorRequest field proto_file")
    elif id == uint32(3):
      if typeId == uint8(STRING_TAG_TYPE):
        result.compiler_version = deserializegoogleprotobufcompilerVersion(deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufcompilerCodeGeneratorRequest field compiler_version")

proc newgoogleprotobufcompilerCodeGeneratorResponseFile*(): googleprotobufcompilerCodeGeneratorResponseFile =
  new(result)
  result.name = ""
  result.insertion_point = ""
  result.content = ""

method serialize*(this: googleprotobufcompilerCodeGeneratorResponseFile): string =
  result = ""
  result &= serializeProtoStringTag(uint32(1), this.name)
  result &= serializeProtoStringTag(uint32(2), this.insertion_point)
  result &= serializeProtoStringTag(uint32(15), this.content)

proc deserializegoogleprotobufcompilerCodeGeneratorResponseFile*(a: string): googleprotobufcompilerCodeGeneratorResponseFile =
  result = newgoogleprotobufcompilerCodeGeneratorResponseFile()
  var index: int = 0
  while index < a.len():
    var tag: uint32 = uint32(deserializeProtoVarint(a, index) and uint32(0xFFFFFFFF))
    var typeId: uint8 = tag and uint8(0x7)
    var id: uint32 = (tag and not uint32(0x7)) shr 3
    if id == uint32(1):
      if typeId == uint8(STRING_TAG_TYPE):
        result.name = cast[string](deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufcompilerCodeGeneratorResponseFile field name")
    elif id == uint32(2):
      if typeId == uint8(STRING_TAG_TYPE):
        result.insertion_point = cast[string](deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufcompilerCodeGeneratorResponseFile field insertion_point")
    elif id == uint32(15):
      if typeId == uint8(STRING_TAG_TYPE):
        result.content = cast[string](deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufcompilerCodeGeneratorResponseFile field content")

proc newgoogleprotobufcompilerCodeGeneratorResponse*(): googleprotobufcompilerCodeGeneratorResponse =
  new(result)
  result.error = ""
  result.file = newSeq[googleprotobufcompilerCodeGeneratorResponseFile]()

method serialize*(this: googleprotobufcompilerCodeGeneratorResponse): string =
  result = ""
  result &= serializeProtoStringTag(uint32(1), this.error)
  for v in this.file:
    result &= serializeProtoStringTag(uint32(15), v.serialize())

proc deserializegoogleprotobufcompilerCodeGeneratorResponse*(a: string): googleprotobufcompilerCodeGeneratorResponse =
  result = newgoogleprotobufcompilerCodeGeneratorResponse()
  var index: int = 0
  while index < a.len():
    var tag: uint32 = uint32(deserializeProtoVarint(a, index) and uint32(0xFFFFFFFF))
    var typeId: uint8 = tag and uint8(0x7)
    var id: uint32 = (tag and not uint32(0x7)) shr 3
    if id == uint32(1):
      if typeId == uint8(STRING_TAG_TYPE):
        result.error = cast[string](deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufcompilerCodeGeneratorResponse field error")
    elif id == uint32(15):
      if typeId == uint8(STRING_TAG_TYPE):
        result.file.add(deserializegoogleprotobufcompilerCodeGeneratorResponseFile(deserializeProtoString(a, index)))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufcompilerCodeGeneratorResponse field file")

