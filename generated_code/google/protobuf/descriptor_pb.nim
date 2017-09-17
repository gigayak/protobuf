import protobuf

type
  googleprotobufFileDescriptorSet* = ref object of RootProto
    file*: seq[googleprotobufFileDescriptorProto]
  googleprotobufFileDescriptorProto* = ref object of RootProto
    name*: string
    package*: string
    dependency*: seq[string]
    public_dependency*: seq[int32]
    weak_dependency*: seq[int32]
    message_type*: seq[googleprotobufDescriptorProto]
    enum_type*: seq[googleprotobufEnumDescriptorProto]
    service*: seq[googleprotobufServiceDescriptorProto]
    extension*: seq[googleprotobufFieldDescriptorProto]
    options*: googleprotobufFileOptions
    source_code_info*: googleprotobufSourceCodeInfo
    syntax*: string
  googleprotobufDescriptorProtoExtensionRange* = ref object of RootProto
    start*: int32
    m_end*: int32
  googleprotobufDescriptorProtoReservedRange* = ref object of RootProto
    start*: int32
    m_end*: int32
  googleprotobufDescriptorProto* = ref object of RootProto
    name*: string
    field*: seq[googleprotobufFieldDescriptorProto]
    extension*: seq[googleprotobufFieldDescriptorProto]
    nested_type*: seq[googleprotobufDescriptorProto]
    enum_type*: seq[googleprotobufEnumDescriptorProto]
    extension_range*: seq[googleprotobufDescriptorProtoExtensionRange]
    oneof_decl*: seq[googleprotobufOneofDescriptorProto]
    options*: googleprotobufMessageOptions
    reserved_range*: seq[googleprotobufDescriptorProtoReservedRange]
    reserved_name*: seq[string]
  googleprotobufFieldDescriptorProtoType* = enum
    TYPE_DOUBLE = 1
    TYPE_FLOAT = 2
    TYPE_INT64 = 3
    TYPE_UINT64 = 4
    TYPE_INT32 = 5
    TYPE_FIXED64 = 6
    TYPE_FIXED32 = 7
    TYPE_BOOL = 8
    TYPE_STRING = 9
    TYPE_GROUP = 10
    TYPE_MESSAGE = 11
    TYPE_BYTES = 12
    TYPE_UINT32 = 13
    TYPE_ENUM = 14
    TYPE_SFIXED32 = 15
    TYPE_SFIXED64 = 16
    TYPE_SINT32 = 17
    TYPE_SINT64 = 18
  googleprotobufFieldDescriptorProtoLabel* = enum
    LABEL_OPTIONAL = 1
    LABEL_REQUIRED = 2
    LABEL_REPEATED = 3
  googleprotobufFieldDescriptorProto* = ref object of RootProto
    name*: string
    number*: int32
    label*: googleprotobufFieldDescriptorProtoLabel
    m_type*: googleprotobufFieldDescriptorProtoType
    type_name*: string
    extendee*: string
    default_value*: string
    oneof_index*: int32
    json_name*: string
    options*: googleprotobufFieldOptions
  googleprotobufOneofDescriptorProto* = ref object of RootProto
    name*: string
    options*: googleprotobufOneofOptions
  googleprotobufEnumDescriptorProto* = ref object of RootProto
    name*: string
    value*: seq[googleprotobufEnumValueDescriptorProto]
    options*: googleprotobufEnumOptions
  googleprotobufEnumValueDescriptorProto* = ref object of RootProto
    name*: string
    number*: int32
    options*: googleprotobufEnumValueOptions
  googleprotobufServiceDescriptorProto* = ref object of RootProto
    name*: string
    m_method*: seq[googleprotobufMethodDescriptorProto]
    options*: googleprotobufServiceOptions
  googleprotobufMethodDescriptorProto* = ref object of RootProto
    name*: string
    input_type*: string
    output_type*: string
    options*: googleprotobufMethodOptions
    client_streaming*: bool
    server_streaming*: bool
  googleprotobufFileOptionsOptimizeMode* = enum
    SPEED = 1
    CODE_SIZE = 2
    LITE_RUNTIME = 3
  googleprotobufFileOptions* = ref object of RootProto
    java_package*: string
    java_outer_classname*: string
    java_multiple_files*: bool
    java_generate_equals_and_hash*: bool
    java_string_check_utf8*: bool
    optimize_for*: googleprotobufFileOptionsOptimizeMode
    go_package*: string
    cc_generic_services*: bool
    java_generic_services*: bool
    py_generic_services*: bool
    deprecated*: bool
    cc_enable_arenas*: bool
    objc_class_prefix*: string
    csharp_namespace*: string
    swift_prefix*: string
    php_class_prefix*: string
    uninterpreted_option*: seq[googleprotobufUninterpretedOption]
  googleprotobufMessageOptions* = ref object of RootProto
    message_set_wire_format*: bool
    no_standard_descriptor_accessor*: bool
    deprecated*: bool
    map_entry*: bool
    uninterpreted_option*: seq[googleprotobufUninterpretedOption]
  googleprotobufFieldOptionsCType* = enum
    STRING = 0
    CORD = 1
    STRING_PIECE = 2
  googleprotobufFieldOptionsJSType* = enum
    JS_NORMAL = 0
    JS_STRING = 1
    JS_NUMBER = 2
  googleprotobufFieldOptions* = ref object of RootProto
    ctype*: googleprotobufFieldOptionsCType
    packed*: bool
    jstype*: googleprotobufFieldOptionsJSType
    lazy*: bool
    deprecated*: bool
    weak*: bool
    uninterpreted_option*: seq[googleprotobufUninterpretedOption]
  googleprotobufOneofOptions* = ref object of RootProto
    uninterpreted_option*: seq[googleprotobufUninterpretedOption]
  googleprotobufEnumOptions* = ref object of RootProto
    allow_alias*: bool
    deprecated*: bool
    uninterpreted_option*: seq[googleprotobufUninterpretedOption]
  googleprotobufEnumValueOptions* = ref object of RootProto
    deprecated*: bool
    uninterpreted_option*: seq[googleprotobufUninterpretedOption]
  googleprotobufServiceOptions* = ref object of RootProto
    deprecated*: bool
    uninterpreted_option*: seq[googleprotobufUninterpretedOption]
  googleprotobufMethodOptionsIdempotencyLevel* = enum
    IDEMPOTENCY_UNKNOWN = 0
    NO_SIDE_EFFECTS = 1
    IDEMPOTENT = 2
  googleprotobufMethodOptions* = ref object of RootProto
    deprecated*: bool
    idempotency_level*: googleprotobufMethodOptionsIdempotencyLevel
    uninterpreted_option*: seq[googleprotobufUninterpretedOption]
  googleprotobufUninterpretedOptionNamePart* = ref object of RootProto
    name_part*: string
    is_extension*: bool
  googleprotobufUninterpretedOption* = ref object of RootProto
    name*: seq[googleprotobufUninterpretedOptionNamePart]
    identifier_value*: string
    positive_int_value*: uint64
    negative_int_value*: int64
    double_value*: float64
    string_value*: string
    aggregate_value*: string
  googleprotobufSourceCodeInfoLocation* = ref object of RootProto
    path*: seq[int32]
    span*: seq[int32]
    leading_comments*: string
    trailing_comments*: string
    leading_detached_comments*: seq[string]
  googleprotobufSourceCodeInfo* = ref object of RootProto
    location*: seq[googleprotobufSourceCodeInfoLocation]
  googleprotobufGeneratedCodeInfoAnnotation* = ref object of RootProto
    path*: seq[int32]
    source_file*: string
    begin*: int32
    m_end*: int32
  googleprotobufGeneratedCodeInfo* = ref object of RootProto
    annotation*: seq[googleprotobufGeneratedCodeInfoAnnotation]

proc newgoogleprotobufFileDescriptorSet*(): googleprotobufFileDescriptorSet
proc deserializegoogleprotobufFileDescriptorSet*(a: string): googleprotobufFileDescriptorSet
proc newgoogleprotobufFileDescriptorProto*(): googleprotobufFileDescriptorProto
proc deserializegoogleprotobufFileDescriptorProto*(a: string): googleprotobufFileDescriptorProto
proc newgoogleprotobufDescriptorProtoExtensionRange*(): googleprotobufDescriptorProtoExtensionRange
proc deserializegoogleprotobufDescriptorProtoExtensionRange*(a: string): googleprotobufDescriptorProtoExtensionRange
proc newgoogleprotobufDescriptorProtoReservedRange*(): googleprotobufDescriptorProtoReservedRange
proc deserializegoogleprotobufDescriptorProtoReservedRange*(a: string): googleprotobufDescriptorProtoReservedRange
proc newgoogleprotobufDescriptorProto*(): googleprotobufDescriptorProto
proc deserializegoogleprotobufDescriptorProto*(a: string): googleprotobufDescriptorProto
proc newgoogleprotobufFieldDescriptorProto*(): googleprotobufFieldDescriptorProto
proc deserializegoogleprotobufFieldDescriptorProto*(a: string): googleprotobufFieldDescriptorProto
proc newgoogleprotobufOneofDescriptorProto*(): googleprotobufOneofDescriptorProto
proc deserializegoogleprotobufOneofDescriptorProto*(a: string): googleprotobufOneofDescriptorProto
proc newgoogleprotobufEnumDescriptorProto*(): googleprotobufEnumDescriptorProto
proc deserializegoogleprotobufEnumDescriptorProto*(a: string): googleprotobufEnumDescriptorProto
proc newgoogleprotobufEnumValueDescriptorProto*(): googleprotobufEnumValueDescriptorProto
proc deserializegoogleprotobufEnumValueDescriptorProto*(a: string): googleprotobufEnumValueDescriptorProto
proc newgoogleprotobufServiceDescriptorProto*(): googleprotobufServiceDescriptorProto
proc deserializegoogleprotobufServiceDescriptorProto*(a: string): googleprotobufServiceDescriptorProto
proc newgoogleprotobufMethodDescriptorProto*(): googleprotobufMethodDescriptorProto
proc deserializegoogleprotobufMethodDescriptorProto*(a: string): googleprotobufMethodDescriptorProto
proc newgoogleprotobufFileOptions*(): googleprotobufFileOptions
proc deserializegoogleprotobufFileOptions*(a: string): googleprotobufFileOptions
proc newgoogleprotobufMessageOptions*(): googleprotobufMessageOptions
proc deserializegoogleprotobufMessageOptions*(a: string): googleprotobufMessageOptions
proc newgoogleprotobufFieldOptions*(): googleprotobufFieldOptions
proc deserializegoogleprotobufFieldOptions*(a: string): googleprotobufFieldOptions
proc newgoogleprotobufOneofOptions*(): googleprotobufOneofOptions
proc deserializegoogleprotobufOneofOptions*(a: string): googleprotobufOneofOptions
proc newgoogleprotobufEnumOptions*(): googleprotobufEnumOptions
proc deserializegoogleprotobufEnumOptions*(a: string): googleprotobufEnumOptions
proc newgoogleprotobufEnumValueOptions*(): googleprotobufEnumValueOptions
proc deserializegoogleprotobufEnumValueOptions*(a: string): googleprotobufEnumValueOptions
proc newgoogleprotobufServiceOptions*(): googleprotobufServiceOptions
proc deserializegoogleprotobufServiceOptions*(a: string): googleprotobufServiceOptions
proc newgoogleprotobufMethodOptions*(): googleprotobufMethodOptions
proc deserializegoogleprotobufMethodOptions*(a: string): googleprotobufMethodOptions
proc newgoogleprotobufUninterpretedOptionNamePart*(): googleprotobufUninterpretedOptionNamePart
proc deserializegoogleprotobufUninterpretedOptionNamePart*(a: string): googleprotobufUninterpretedOptionNamePart
proc newgoogleprotobufUninterpretedOption*(): googleprotobufUninterpretedOption
proc deserializegoogleprotobufUninterpretedOption*(a: string): googleprotobufUninterpretedOption
proc newgoogleprotobufSourceCodeInfoLocation*(): googleprotobufSourceCodeInfoLocation
proc deserializegoogleprotobufSourceCodeInfoLocation*(a: string): googleprotobufSourceCodeInfoLocation
proc newgoogleprotobufSourceCodeInfo*(): googleprotobufSourceCodeInfo
proc deserializegoogleprotobufSourceCodeInfo*(a: string): googleprotobufSourceCodeInfo
proc newgoogleprotobufGeneratedCodeInfoAnnotation*(): googleprotobufGeneratedCodeInfoAnnotation
proc deserializegoogleprotobufGeneratedCodeInfoAnnotation*(a: string): googleprotobufGeneratedCodeInfoAnnotation
proc newgoogleprotobufGeneratedCodeInfo*(): googleprotobufGeneratedCodeInfo
proc deserializegoogleprotobufGeneratedCodeInfo*(a: string): googleprotobufGeneratedCodeInfo

proc newgoogleprotobufFileDescriptorSet*(): googleprotobufFileDescriptorSet =
  new(result)
  result.file = newSeq[googleprotobufFileDescriptorProto]()

method serialize*(this: googleprotobufFileDescriptorSet): string =
  result = ""
  for v in this.file:
    result &= serializeProtoStringTag(uint32(1), v.serialize())

proc deserializegoogleprotobufFileDescriptorSet*(a: string): googleprotobufFileDescriptorSet =
  result = newgoogleprotobufFileDescriptorSet()
  var index: int = 0
  while index < a.len():
    var tag: uint32 = uint32(deserializeProtoVarint(a, index) and uint32(0xFFFFFFFF))
    var typeId: uint8 = tag and uint8(0x7)
    var id: uint32 = (tag and not uint32(0x7)) shr 3
    if id == uint32(1):
      if typeId == uint8(STRING_TAG_TYPE):
        result.file.add(deserializegoogleprotobufFileDescriptorProto(deserializeProtoString(a, index)))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFileDescriptorSet field file")

proc newgoogleprotobufFileDescriptorProto*(): googleprotobufFileDescriptorProto =
  new(result)
  result.name = ""
  result.package = ""
  result.dependency = newSeq[string]()
  result.public_dependency = newSeq[int32]()
  result.weak_dependency = newSeq[int32]()
  result.message_type = newSeq[googleprotobufDescriptorProto]()
  result.enum_type = newSeq[googleprotobufEnumDescriptorProto]()
  result.service = newSeq[googleprotobufServiceDescriptorProto]()
  result.extension = newSeq[googleprotobufFieldDescriptorProto]()
  result.options = newgoogleprotobufFileOptions()
  result.source_code_info = newgoogleprotobufSourceCodeInfo()
  result.syntax = ""

method serialize*(this: googleprotobufFileDescriptorProto): string =
  result = ""
  result &= serializeProtoStringTag(uint32(1), this.name)
  result &= serializeProtoStringTag(uint32(2), this.package)
  for v in this.dependency:
    result &= serializeProtoStringTag(uint32(3), v)
  for v in this.public_dependency:
    result &= serializeProtoVarintTag(uint32(10), v)
  for v in this.weak_dependency:
    result &= serializeProtoVarintTag(uint32(11), v)
  for v in this.message_type:
    result &= serializeProtoStringTag(uint32(4), v.serialize())
  for v in this.enum_type:
    result &= serializeProtoStringTag(uint32(5), v.serialize())
  for v in this.service:
    result &= serializeProtoStringTag(uint32(6), v.serialize())
  for v in this.extension:
    result &= serializeProtoStringTag(uint32(7), v.serialize())
  result &= serializeProtoStringTag(uint32(8), this.options.serialize())
  result &= serializeProtoStringTag(uint32(9), this.source_code_info.serialize())
  result &= serializeProtoStringTag(uint32(12), this.syntax)

proc deserializegoogleprotobufFileDescriptorProto*(a: string): googleprotobufFileDescriptorProto =
  result = newgoogleprotobufFileDescriptorProto()
  var index: int = 0
  while index < a.len():
    var tag: uint32 = uint32(deserializeProtoVarint(a, index) and uint32(0xFFFFFFFF))
    var typeId: uint8 = tag and uint8(0x7)
    var id: uint32 = (tag and not uint32(0x7)) shr 3
    if id == uint32(1):
      if typeId == uint8(STRING_TAG_TYPE):
        result.name = cast[string](deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFileDescriptorProto field name")
    elif id == uint32(2):
      if typeId == uint8(STRING_TAG_TYPE):
        result.package = cast[string](deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFileDescriptorProto field package")
    elif id == uint32(3):
      if typeId == uint8(STRING_TAG_TYPE):
        result.dependency.add(cast[string](deserializeProtoString(a, index)))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFileDescriptorProto field dependency")
    elif id == uint32(10):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.public_dependency.add(cast[int32](deserializeProtoVarint(a, index)))
      # repeated numeric-type fields can be represented in a 'packed' encoding
      elif typeId == uint8(2):
        var endPoint: int
        endPoint = cast[int](deserializeProtoVarInt(a, index))
        endPoint += index # use above varint as length
        while index < endPoint:
          result.public_dependency.add(cast[int32](deserializeProtoVarint(a, index)))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFileDescriptorProto field public_dependency")
    elif id == uint32(11):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.weak_dependency.add(cast[int32](deserializeProtoVarint(a, index)))
      # repeated numeric-type fields can be represented in a 'packed' encoding
      elif typeId == uint8(2):
        var endPoint: int
        endPoint = cast[int](deserializeProtoVarInt(a, index))
        endPoint += index # use above varint as length
        while index < endPoint:
          result.weak_dependency.add(cast[int32](deserializeProtoVarint(a, index)))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFileDescriptorProto field weak_dependency")
    elif id == uint32(4):
      if typeId == uint8(STRING_TAG_TYPE):
        result.message_type.add(deserializegoogleprotobufDescriptorProto(deserializeProtoString(a, index)))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFileDescriptorProto field message_type")
    elif id == uint32(5):
      if typeId == uint8(STRING_TAG_TYPE):
        result.enum_type.add(deserializegoogleprotobufEnumDescriptorProto(deserializeProtoString(a, index)))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFileDescriptorProto field enum_type")
    elif id == uint32(6):
      if typeId == uint8(STRING_TAG_TYPE):
        result.service.add(deserializegoogleprotobufServiceDescriptorProto(deserializeProtoString(a, index)))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFileDescriptorProto field service")
    elif id == uint32(7):
      if typeId == uint8(STRING_TAG_TYPE):
        result.extension.add(deserializegoogleprotobufFieldDescriptorProto(deserializeProtoString(a, index)))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFileDescriptorProto field extension")
    elif id == uint32(8):
      if typeId == uint8(STRING_TAG_TYPE):
        result.options = deserializegoogleprotobufFileOptions(deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFileDescriptorProto field options")
    elif id == uint32(9):
      if typeId == uint8(STRING_TAG_TYPE):
        result.source_code_info = deserializegoogleprotobufSourceCodeInfo(deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFileDescriptorProto field source_code_info")
    elif id == uint32(12):
      if typeId == uint8(STRING_TAG_TYPE):
        result.syntax = cast[string](deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFileDescriptorProto field syntax")

proc newgoogleprotobufDescriptorProtoExtensionRange*(): googleprotobufDescriptorProtoExtensionRange =
  new(result)
  result.start = 0
  result.m_end = 0

method serialize*(this: googleprotobufDescriptorProtoExtensionRange): string =
  result = ""
  result &= serializeProtoVarintTag(uint32(1), this.start)
  result &= serializeProtoVarintTag(uint32(2), this.m_end)

proc deserializegoogleprotobufDescriptorProtoExtensionRange*(a: string): googleprotobufDescriptorProtoExtensionRange =
  result = newgoogleprotobufDescriptorProtoExtensionRange()
  var index: int = 0
  while index < a.len():
    var tag: uint32 = uint32(deserializeProtoVarint(a, index) and uint32(0xFFFFFFFF))
    var typeId: uint8 = tag and uint8(0x7)
    var id: uint32 = (tag and not uint32(0x7)) shr 3
    if id == uint32(1):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.start = cast[int32](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufDescriptorProtoExtensionRange field start")
    elif id == uint32(2):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.m_end = cast[int32](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufDescriptorProtoExtensionRange field m_end")

proc newgoogleprotobufDescriptorProtoReservedRange*(): googleprotobufDescriptorProtoReservedRange =
  new(result)
  result.start = 0
  result.m_end = 0

method serialize*(this: googleprotobufDescriptorProtoReservedRange): string =
  result = ""
  result &= serializeProtoVarintTag(uint32(1), this.start)
  result &= serializeProtoVarintTag(uint32(2), this.m_end)

proc deserializegoogleprotobufDescriptorProtoReservedRange*(a: string): googleprotobufDescriptorProtoReservedRange =
  result = newgoogleprotobufDescriptorProtoReservedRange()
  var index: int = 0
  while index < a.len():
    var tag: uint32 = uint32(deserializeProtoVarint(a, index) and uint32(0xFFFFFFFF))
    var typeId: uint8 = tag and uint8(0x7)
    var id: uint32 = (tag and not uint32(0x7)) shr 3
    if id == uint32(1):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.start = cast[int32](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufDescriptorProtoReservedRange field start")
    elif id == uint32(2):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.m_end = cast[int32](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufDescriptorProtoReservedRange field m_end")

proc newgoogleprotobufDescriptorProto*(): googleprotobufDescriptorProto =
  new(result)
  result.name = ""
  result.field = newSeq[googleprotobufFieldDescriptorProto]()
  result.extension = newSeq[googleprotobufFieldDescriptorProto]()
  result.nested_type = newSeq[googleprotobufDescriptorProto]()
  result.enum_type = newSeq[googleprotobufEnumDescriptorProto]()
  result.extension_range = newSeq[googleprotobufDescriptorProtoExtensionRange]()
  result.oneof_decl = newSeq[googleprotobufOneofDescriptorProto]()
  result.options = newgoogleprotobufMessageOptions()
  result.reserved_range = newSeq[googleprotobufDescriptorProtoReservedRange]()
  result.reserved_name = newSeq[string]()

method serialize*(this: googleprotobufDescriptorProto): string =
  result = ""
  result &= serializeProtoStringTag(uint32(1), this.name)
  for v in this.field:
    result &= serializeProtoStringTag(uint32(2), v.serialize())
  for v in this.extension:
    result &= serializeProtoStringTag(uint32(6), v.serialize())
  for v in this.nested_type:
    result &= serializeProtoStringTag(uint32(3), v.serialize())
  for v in this.enum_type:
    result &= serializeProtoStringTag(uint32(4), v.serialize())
  for v in this.extension_range:
    result &= serializeProtoStringTag(uint32(5), v.serialize())
  for v in this.oneof_decl:
    result &= serializeProtoStringTag(uint32(8), v.serialize())
  result &= serializeProtoStringTag(uint32(7), this.options.serialize())
  for v in this.reserved_range:
    result &= serializeProtoStringTag(uint32(9), v.serialize())
  for v in this.reserved_name:
    result &= serializeProtoStringTag(uint32(10), v)

proc deserializegoogleprotobufDescriptorProto*(a: string): googleprotobufDescriptorProto =
  result = newgoogleprotobufDescriptorProto()
  var index: int = 0
  while index < a.len():
    var tag: uint32 = uint32(deserializeProtoVarint(a, index) and uint32(0xFFFFFFFF))
    var typeId: uint8 = tag and uint8(0x7)
    var id: uint32 = (tag and not uint32(0x7)) shr 3
    if id == uint32(1):
      if typeId == uint8(STRING_TAG_TYPE):
        result.name = cast[string](deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufDescriptorProto field name")
    elif id == uint32(2):
      if typeId == uint8(STRING_TAG_TYPE):
        result.field.add(deserializegoogleprotobufFieldDescriptorProto(deserializeProtoString(a, index)))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufDescriptorProto field field")
    elif id == uint32(6):
      if typeId == uint8(STRING_TAG_TYPE):
        result.extension.add(deserializegoogleprotobufFieldDescriptorProto(deserializeProtoString(a, index)))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufDescriptorProto field extension")
    elif id == uint32(3):
      if typeId == uint8(STRING_TAG_TYPE):
        result.nested_type.add(deserializegoogleprotobufDescriptorProto(deserializeProtoString(a, index)))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufDescriptorProto field nested_type")
    elif id == uint32(4):
      if typeId == uint8(STRING_TAG_TYPE):
        result.enum_type.add(deserializegoogleprotobufEnumDescriptorProto(deserializeProtoString(a, index)))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufDescriptorProto field enum_type")
    elif id == uint32(5):
      if typeId == uint8(STRING_TAG_TYPE):
        result.extension_range.add(deserializegoogleprotobufDescriptorProtoExtensionRange(deserializeProtoString(a, index)))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufDescriptorProto field extension_range")
    elif id == uint32(8):
      if typeId == uint8(STRING_TAG_TYPE):
        result.oneof_decl.add(deserializegoogleprotobufOneofDescriptorProto(deserializeProtoString(a, index)))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufDescriptorProto field oneof_decl")
    elif id == uint32(7):
      if typeId == uint8(STRING_TAG_TYPE):
        result.options = deserializegoogleprotobufMessageOptions(deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufDescriptorProto field options")
    elif id == uint32(9):
      if typeId == uint8(STRING_TAG_TYPE):
        result.reserved_range.add(deserializegoogleprotobufDescriptorProtoReservedRange(deserializeProtoString(a, index)))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufDescriptorProto field reserved_range")
    elif id == uint32(10):
      if typeId == uint8(STRING_TAG_TYPE):
        result.reserved_name.add(cast[string](deserializeProtoString(a, index)))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufDescriptorProto field reserved_name")

proc newgoogleprotobufFieldDescriptorProto*(): googleprotobufFieldDescriptorProto =
  new(result)
  result.name = ""
  result.number = 0
  result.type_name = ""
  result.extendee = ""
  result.default_value = ""
  result.oneof_index = 0
  result.json_name = ""
  result.options = newgoogleprotobufFieldOptions()

method serialize*(this: googleprotobufFieldDescriptorProto): string =
  result = ""
  result &= serializeProtoStringTag(uint32(1), this.name)
  result &= serializeProtoVarintTag(uint32(3), this.number)
  result &= serializeProtoVarintTag(uint32(4), this.label.ord())
  result &= serializeProtoVarintTag(uint32(5), this.m_type.ord())
  result &= serializeProtoStringTag(uint32(6), this.type_name)
  result &= serializeProtoStringTag(uint32(2), this.extendee)
  result &= serializeProtoStringTag(uint32(7), this.default_value)
  result &= serializeProtoVarintTag(uint32(9), this.oneof_index)
  result &= serializeProtoStringTag(uint32(10), this.json_name)
  result &= serializeProtoStringTag(uint32(8), this.options.serialize())

proc deserializegoogleprotobufFieldDescriptorProto*(a: string): googleprotobufFieldDescriptorProto =
  result = newgoogleprotobufFieldDescriptorProto()
  var index: int = 0
  while index < a.len():
    var tag: uint32 = uint32(deserializeProtoVarint(a, index) and uint32(0xFFFFFFFF))
    var typeId: uint8 = tag and uint8(0x7)
    var id: uint32 = (tag and not uint32(0x7)) shr 3
    if id == uint32(1):
      if typeId == uint8(STRING_TAG_TYPE):
        result.name = cast[string](deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFieldDescriptorProto field name")
    elif id == uint32(3):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.number = cast[int32](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFieldDescriptorProto field number")
    elif id == uint32(4):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.label = cast[googleprotobufFieldDescriptorProtoLabel](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFieldDescriptorProto field label")
    elif id == uint32(5):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.m_type = cast[googleprotobufFieldDescriptorProtoType](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFieldDescriptorProto field m_type")
    elif id == uint32(6):
      if typeId == uint8(STRING_TAG_TYPE):
        result.type_name = cast[string](deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFieldDescriptorProto field type_name")
    elif id == uint32(2):
      if typeId == uint8(STRING_TAG_TYPE):
        result.extendee = cast[string](deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFieldDescriptorProto field extendee")
    elif id == uint32(7):
      if typeId == uint8(STRING_TAG_TYPE):
        result.default_value = cast[string](deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFieldDescriptorProto field default_value")
    elif id == uint32(9):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.oneof_index = cast[int32](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFieldDescriptorProto field oneof_index")
    elif id == uint32(10):
      if typeId == uint8(STRING_TAG_TYPE):
        result.json_name = cast[string](deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFieldDescriptorProto field json_name")
    elif id == uint32(8):
      if typeId == uint8(STRING_TAG_TYPE):
        result.options = deserializegoogleprotobufFieldOptions(deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFieldDescriptorProto field options")

proc newgoogleprotobufOneofDescriptorProto*(): googleprotobufOneofDescriptorProto =
  new(result)
  result.name = ""
  result.options = newgoogleprotobufOneofOptions()

method serialize*(this: googleprotobufOneofDescriptorProto): string =
  result = ""
  result &= serializeProtoStringTag(uint32(1), this.name)
  result &= serializeProtoStringTag(uint32(2), this.options.serialize())

proc deserializegoogleprotobufOneofDescriptorProto*(a: string): googleprotobufOneofDescriptorProto =
  result = newgoogleprotobufOneofDescriptorProto()
  var index: int = 0
  while index < a.len():
    var tag: uint32 = uint32(deserializeProtoVarint(a, index) and uint32(0xFFFFFFFF))
    var typeId: uint8 = tag and uint8(0x7)
    var id: uint32 = (tag and not uint32(0x7)) shr 3
    if id == uint32(1):
      if typeId == uint8(STRING_TAG_TYPE):
        result.name = cast[string](deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufOneofDescriptorProto field name")
    elif id == uint32(2):
      if typeId == uint8(STRING_TAG_TYPE):
        result.options = deserializegoogleprotobufOneofOptions(deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufOneofDescriptorProto field options")

proc newgoogleprotobufEnumDescriptorProto*(): googleprotobufEnumDescriptorProto =
  new(result)
  result.name = ""
  result.value = newSeq[googleprotobufEnumValueDescriptorProto]()
  result.options = newgoogleprotobufEnumOptions()

method serialize*(this: googleprotobufEnumDescriptorProto): string =
  result = ""
  result &= serializeProtoStringTag(uint32(1), this.name)
  for v in this.value:
    result &= serializeProtoStringTag(uint32(2), v.serialize())
  result &= serializeProtoStringTag(uint32(3), this.options.serialize())

proc deserializegoogleprotobufEnumDescriptorProto*(a: string): googleprotobufEnumDescriptorProto =
  result = newgoogleprotobufEnumDescriptorProto()
  var index: int = 0
  while index < a.len():
    var tag: uint32 = uint32(deserializeProtoVarint(a, index) and uint32(0xFFFFFFFF))
    var typeId: uint8 = tag and uint8(0x7)
    var id: uint32 = (tag and not uint32(0x7)) shr 3
    if id == uint32(1):
      if typeId == uint8(STRING_TAG_TYPE):
        result.name = cast[string](deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufEnumDescriptorProto field name")
    elif id == uint32(2):
      if typeId == uint8(STRING_TAG_TYPE):
        result.value.add(deserializegoogleprotobufEnumValueDescriptorProto(deserializeProtoString(a, index)))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufEnumDescriptorProto field value")
    elif id == uint32(3):
      if typeId == uint8(STRING_TAG_TYPE):
        result.options = deserializegoogleprotobufEnumOptions(deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufEnumDescriptorProto field options")

proc newgoogleprotobufEnumValueDescriptorProto*(): googleprotobufEnumValueDescriptorProto =
  new(result)
  result.name = ""
  result.number = 0
  result.options = newgoogleprotobufEnumValueOptions()

method serialize*(this: googleprotobufEnumValueDescriptorProto): string =
  result = ""
  result &= serializeProtoStringTag(uint32(1), this.name)
  result &= serializeProtoVarintTag(uint32(2), this.number)
  result &= serializeProtoStringTag(uint32(3), this.options.serialize())

proc deserializegoogleprotobufEnumValueDescriptorProto*(a: string): googleprotobufEnumValueDescriptorProto =
  result = newgoogleprotobufEnumValueDescriptorProto()
  var index: int = 0
  while index < a.len():
    var tag: uint32 = uint32(deserializeProtoVarint(a, index) and uint32(0xFFFFFFFF))
    var typeId: uint8 = tag and uint8(0x7)
    var id: uint32 = (tag and not uint32(0x7)) shr 3
    if id == uint32(1):
      if typeId == uint8(STRING_TAG_TYPE):
        result.name = cast[string](deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufEnumValueDescriptorProto field name")
    elif id == uint32(2):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.number = cast[int32](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufEnumValueDescriptorProto field number")
    elif id == uint32(3):
      if typeId == uint8(STRING_TAG_TYPE):
        result.options = deserializegoogleprotobufEnumValueOptions(deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufEnumValueDescriptorProto field options")

proc newgoogleprotobufServiceDescriptorProto*(): googleprotobufServiceDescriptorProto =
  new(result)
  result.name = ""
  result.m_method = newSeq[googleprotobufMethodDescriptorProto]()
  result.options = newgoogleprotobufServiceOptions()

method serialize*(this: googleprotobufServiceDescriptorProto): string =
  result = ""
  result &= serializeProtoStringTag(uint32(1), this.name)
  for v in this.m_method:
    result &= serializeProtoStringTag(uint32(2), v.serialize())
  result &= serializeProtoStringTag(uint32(3), this.options.serialize())

proc deserializegoogleprotobufServiceDescriptorProto*(a: string): googleprotobufServiceDescriptorProto =
  result = newgoogleprotobufServiceDescriptorProto()
  var index: int = 0
  while index < a.len():
    var tag: uint32 = uint32(deserializeProtoVarint(a, index) and uint32(0xFFFFFFFF))
    var typeId: uint8 = tag and uint8(0x7)
    var id: uint32 = (tag and not uint32(0x7)) shr 3
    if id == uint32(1):
      if typeId == uint8(STRING_TAG_TYPE):
        result.name = cast[string](deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufServiceDescriptorProto field name")
    elif id == uint32(2):
      if typeId == uint8(STRING_TAG_TYPE):
        result.m_method.add(deserializegoogleprotobufMethodDescriptorProto(deserializeProtoString(a, index)))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufServiceDescriptorProto field m_method")
    elif id == uint32(3):
      if typeId == uint8(STRING_TAG_TYPE):
        result.options = deserializegoogleprotobufServiceOptions(deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufServiceDescriptorProto field options")

proc newgoogleprotobufMethodDescriptorProto*(): googleprotobufMethodDescriptorProto =
  new(result)
  result.name = ""
  result.input_type = ""
  result.output_type = ""
  result.options = newgoogleprotobufMethodOptions()
  result.client_streaming = false
  result.server_streaming = false

method serialize*(this: googleprotobufMethodDescriptorProto): string =
  result = ""
  result &= serializeProtoStringTag(uint32(1), this.name)
  result &= serializeProtoStringTag(uint32(2), this.input_type)
  result &= serializeProtoStringTag(uint32(3), this.output_type)
  result &= serializeProtoStringTag(uint32(4), this.options.serialize())
  result &= serializeProtoVarintTag(uint32(5), this.client_streaming)
  result &= serializeProtoVarintTag(uint32(6), this.server_streaming)

proc deserializegoogleprotobufMethodDescriptorProto*(a: string): googleprotobufMethodDescriptorProto =
  result = newgoogleprotobufMethodDescriptorProto()
  var index: int = 0
  while index < a.len():
    var tag: uint32 = uint32(deserializeProtoVarint(a, index) and uint32(0xFFFFFFFF))
    var typeId: uint8 = tag and uint8(0x7)
    var id: uint32 = (tag and not uint32(0x7)) shr 3
    if id == uint32(1):
      if typeId == uint8(STRING_TAG_TYPE):
        result.name = cast[string](deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufMethodDescriptorProto field name")
    elif id == uint32(2):
      if typeId == uint8(STRING_TAG_TYPE):
        result.input_type = cast[string](deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufMethodDescriptorProto field input_type")
    elif id == uint32(3):
      if typeId == uint8(STRING_TAG_TYPE):
        result.output_type = cast[string](deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufMethodDescriptorProto field output_type")
    elif id == uint32(4):
      if typeId == uint8(STRING_TAG_TYPE):
        result.options = deserializegoogleprotobufMethodOptions(deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufMethodDescriptorProto field options")
    elif id == uint32(5):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.client_streaming = cast[bool](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufMethodDescriptorProto field client_streaming")
    elif id == uint32(6):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.server_streaming = cast[bool](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufMethodDescriptorProto field server_streaming")

proc newgoogleprotobufFileOptions*(): googleprotobufFileOptions =
  new(result)
  result.java_package = ""
  result.java_outer_classname = ""
  result.java_multiple_files = false
  result.java_generate_equals_and_hash = false
  result.java_string_check_utf8 = false
  result.go_package = ""
  result.cc_generic_services = false
  result.java_generic_services = false
  result.py_generic_services = false
  result.deprecated = false
  result.cc_enable_arenas = false
  result.objc_class_prefix = ""
  result.csharp_namespace = ""
  result.swift_prefix = ""
  result.php_class_prefix = ""
  result.uninterpreted_option = newSeq[googleprotobufUninterpretedOption]()

method serialize*(this: googleprotobufFileOptions): string =
  result = ""
  result &= serializeProtoStringTag(uint32(1), this.java_package)
  result &= serializeProtoStringTag(uint32(8), this.java_outer_classname)
  result &= serializeProtoVarintTag(uint32(10), this.java_multiple_files)
  result &= serializeProtoVarintTag(uint32(20), this.java_generate_equals_and_hash)
  result &= serializeProtoVarintTag(uint32(27), this.java_string_check_utf8)
  result &= serializeProtoVarintTag(uint32(9), this.optimize_for.ord())
  result &= serializeProtoStringTag(uint32(11), this.go_package)
  result &= serializeProtoVarintTag(uint32(16), this.cc_generic_services)
  result &= serializeProtoVarintTag(uint32(17), this.java_generic_services)
  result &= serializeProtoVarintTag(uint32(18), this.py_generic_services)
  result &= serializeProtoVarintTag(uint32(23), this.deprecated)
  result &= serializeProtoVarintTag(uint32(31), this.cc_enable_arenas)
  result &= serializeProtoStringTag(uint32(36), this.objc_class_prefix)
  result &= serializeProtoStringTag(uint32(37), this.csharp_namespace)
  result &= serializeProtoStringTag(uint32(39), this.swift_prefix)
  result &= serializeProtoStringTag(uint32(40), this.php_class_prefix)
  for v in this.uninterpreted_option:
    result &= serializeProtoStringTag(uint32(999), v.serialize())

proc deserializegoogleprotobufFileOptions*(a: string): googleprotobufFileOptions =
  result = newgoogleprotobufFileOptions()
  var index: int = 0
  while index < a.len():
    var tag: uint32 = uint32(deserializeProtoVarint(a, index) and uint32(0xFFFFFFFF))
    var typeId: uint8 = tag and uint8(0x7)
    var id: uint32 = (tag and not uint32(0x7)) shr 3
    if id == uint32(1):
      if typeId == uint8(STRING_TAG_TYPE):
        result.java_package = cast[string](deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFileOptions field java_package")
    elif id == uint32(8):
      if typeId == uint8(STRING_TAG_TYPE):
        result.java_outer_classname = cast[string](deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFileOptions field java_outer_classname")
    elif id == uint32(10):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.java_multiple_files = cast[bool](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFileOptions field java_multiple_files")
    elif id == uint32(20):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.java_generate_equals_and_hash = cast[bool](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFileOptions field java_generate_equals_and_hash")
    elif id == uint32(27):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.java_string_check_utf8 = cast[bool](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFileOptions field java_string_check_utf8")
    elif id == uint32(9):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.optimize_for = cast[googleprotobufFileOptionsOptimizeMode](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFileOptions field optimize_for")
    elif id == uint32(11):
      if typeId == uint8(STRING_TAG_TYPE):
        result.go_package = cast[string](deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFileOptions field go_package")
    elif id == uint32(16):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.cc_generic_services = cast[bool](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFileOptions field cc_generic_services")
    elif id == uint32(17):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.java_generic_services = cast[bool](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFileOptions field java_generic_services")
    elif id == uint32(18):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.py_generic_services = cast[bool](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFileOptions field py_generic_services")
    elif id == uint32(23):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.deprecated = cast[bool](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFileOptions field deprecated")
    elif id == uint32(31):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.cc_enable_arenas = cast[bool](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFileOptions field cc_enable_arenas")
    elif id == uint32(36):
      if typeId == uint8(STRING_TAG_TYPE):
        result.objc_class_prefix = cast[string](deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFileOptions field objc_class_prefix")
    elif id == uint32(37):
      if typeId == uint8(STRING_TAG_TYPE):
        result.csharp_namespace = cast[string](deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFileOptions field csharp_namespace")
    elif id == uint32(39):
      if typeId == uint8(STRING_TAG_TYPE):
        result.swift_prefix = cast[string](deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFileOptions field swift_prefix")
    elif id == uint32(40):
      if typeId == uint8(STRING_TAG_TYPE):
        result.php_class_prefix = cast[string](deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFileOptions field php_class_prefix")
    elif id == uint32(999):
      if typeId == uint8(STRING_TAG_TYPE):
        result.uninterpreted_option.add(deserializegoogleprotobufUninterpretedOption(deserializeProtoString(a, index)))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFileOptions field uninterpreted_option")

proc newgoogleprotobufMessageOptions*(): googleprotobufMessageOptions =
  new(result)
  result.message_set_wire_format = false
  result.no_standard_descriptor_accessor = false
  result.deprecated = false
  result.map_entry = false
  result.uninterpreted_option = newSeq[googleprotobufUninterpretedOption]()

method serialize*(this: googleprotobufMessageOptions): string =
  result = ""
  result &= serializeProtoVarintTag(uint32(1), this.message_set_wire_format)
  result &= serializeProtoVarintTag(uint32(2), this.no_standard_descriptor_accessor)
  result &= serializeProtoVarintTag(uint32(3), this.deprecated)
  result &= serializeProtoVarintTag(uint32(7), this.map_entry)
  for v in this.uninterpreted_option:
    result &= serializeProtoStringTag(uint32(999), v.serialize())

proc deserializegoogleprotobufMessageOptions*(a: string): googleprotobufMessageOptions =
  result = newgoogleprotobufMessageOptions()
  var index: int = 0
  while index < a.len():
    var tag: uint32 = uint32(deserializeProtoVarint(a, index) and uint32(0xFFFFFFFF))
    var typeId: uint8 = tag and uint8(0x7)
    var id: uint32 = (tag and not uint32(0x7)) shr 3
    if id == uint32(1):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.message_set_wire_format = cast[bool](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufMessageOptions field message_set_wire_format")
    elif id == uint32(2):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.no_standard_descriptor_accessor = cast[bool](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufMessageOptions field no_standard_descriptor_accessor")
    elif id == uint32(3):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.deprecated = cast[bool](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufMessageOptions field deprecated")
    elif id == uint32(7):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.map_entry = cast[bool](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufMessageOptions field map_entry")
    elif id == uint32(999):
      if typeId == uint8(STRING_TAG_TYPE):
        result.uninterpreted_option.add(deserializegoogleprotobufUninterpretedOption(deserializeProtoString(a, index)))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufMessageOptions field uninterpreted_option")

proc newgoogleprotobufFieldOptions*(): googleprotobufFieldOptions =
  new(result)
  result.packed = false
  result.lazy = false
  result.deprecated = false
  result.weak = false
  result.uninterpreted_option = newSeq[googleprotobufUninterpretedOption]()

method serialize*(this: googleprotobufFieldOptions): string =
  result = ""
  result &= serializeProtoVarintTag(uint32(1), this.ctype.ord())
  result &= serializeProtoVarintTag(uint32(2), this.packed)
  result &= serializeProtoVarintTag(uint32(6), this.jstype.ord())
  result &= serializeProtoVarintTag(uint32(5), this.lazy)
  result &= serializeProtoVarintTag(uint32(3), this.deprecated)
  result &= serializeProtoVarintTag(uint32(10), this.weak)
  for v in this.uninterpreted_option:
    result &= serializeProtoStringTag(uint32(999), v.serialize())

proc deserializegoogleprotobufFieldOptions*(a: string): googleprotobufFieldOptions =
  result = newgoogleprotobufFieldOptions()
  var index: int = 0
  while index < a.len():
    var tag: uint32 = uint32(deserializeProtoVarint(a, index) and uint32(0xFFFFFFFF))
    var typeId: uint8 = tag and uint8(0x7)
    var id: uint32 = (tag and not uint32(0x7)) shr 3
    if id == uint32(1):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.ctype = cast[googleprotobufFieldOptionsCType](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFieldOptions field ctype")
    elif id == uint32(2):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.packed = cast[bool](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFieldOptions field packed")
    elif id == uint32(6):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.jstype = cast[googleprotobufFieldOptionsJSType](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFieldOptions field jstype")
    elif id == uint32(5):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.lazy = cast[bool](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFieldOptions field lazy")
    elif id == uint32(3):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.deprecated = cast[bool](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFieldOptions field deprecated")
    elif id == uint32(10):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.weak = cast[bool](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFieldOptions field weak")
    elif id == uint32(999):
      if typeId == uint8(STRING_TAG_TYPE):
        result.uninterpreted_option.add(deserializegoogleprotobufUninterpretedOption(deserializeProtoString(a, index)))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufFieldOptions field uninterpreted_option")

proc newgoogleprotobufOneofOptions*(): googleprotobufOneofOptions =
  new(result)
  result.uninterpreted_option = newSeq[googleprotobufUninterpretedOption]()

method serialize*(this: googleprotobufOneofOptions): string =
  result = ""
  for v in this.uninterpreted_option:
    result &= serializeProtoStringTag(uint32(999), v.serialize())

proc deserializegoogleprotobufOneofOptions*(a: string): googleprotobufOneofOptions =
  result = newgoogleprotobufOneofOptions()
  var index: int = 0
  while index < a.len():
    var tag: uint32 = uint32(deserializeProtoVarint(a, index) and uint32(0xFFFFFFFF))
    var typeId: uint8 = tag and uint8(0x7)
    var id: uint32 = (tag and not uint32(0x7)) shr 3
    if id == uint32(999):
      if typeId == uint8(STRING_TAG_TYPE):
        result.uninterpreted_option.add(deserializegoogleprotobufUninterpretedOption(deserializeProtoString(a, index)))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufOneofOptions field uninterpreted_option")

proc newgoogleprotobufEnumOptions*(): googleprotobufEnumOptions =
  new(result)
  result.allow_alias = false
  result.deprecated = false
  result.uninterpreted_option = newSeq[googleprotobufUninterpretedOption]()

method serialize*(this: googleprotobufEnumOptions): string =
  result = ""
  result &= serializeProtoVarintTag(uint32(2), this.allow_alias)
  result &= serializeProtoVarintTag(uint32(3), this.deprecated)
  for v in this.uninterpreted_option:
    result &= serializeProtoStringTag(uint32(999), v.serialize())

proc deserializegoogleprotobufEnumOptions*(a: string): googleprotobufEnumOptions =
  result = newgoogleprotobufEnumOptions()
  var index: int = 0
  while index < a.len():
    var tag: uint32 = uint32(deserializeProtoVarint(a, index) and uint32(0xFFFFFFFF))
    var typeId: uint8 = tag and uint8(0x7)
    var id: uint32 = (tag and not uint32(0x7)) shr 3
    if id == uint32(2):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.allow_alias = cast[bool](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufEnumOptions field allow_alias")
    elif id == uint32(3):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.deprecated = cast[bool](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufEnumOptions field deprecated")
    elif id == uint32(999):
      if typeId == uint8(STRING_TAG_TYPE):
        result.uninterpreted_option.add(deserializegoogleprotobufUninterpretedOption(deserializeProtoString(a, index)))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufEnumOptions field uninterpreted_option")

proc newgoogleprotobufEnumValueOptions*(): googleprotobufEnumValueOptions =
  new(result)
  result.deprecated = false
  result.uninterpreted_option = newSeq[googleprotobufUninterpretedOption]()

method serialize*(this: googleprotobufEnumValueOptions): string =
  result = ""
  result &= serializeProtoVarintTag(uint32(1), this.deprecated)
  for v in this.uninterpreted_option:
    result &= serializeProtoStringTag(uint32(999), v.serialize())

proc deserializegoogleprotobufEnumValueOptions*(a: string): googleprotobufEnumValueOptions =
  result = newgoogleprotobufEnumValueOptions()
  var index: int = 0
  while index < a.len():
    var tag: uint32 = uint32(deserializeProtoVarint(a, index) and uint32(0xFFFFFFFF))
    var typeId: uint8 = tag and uint8(0x7)
    var id: uint32 = (tag and not uint32(0x7)) shr 3
    if id == uint32(1):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.deprecated = cast[bool](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufEnumValueOptions field deprecated")
    elif id == uint32(999):
      if typeId == uint8(STRING_TAG_TYPE):
        result.uninterpreted_option.add(deserializegoogleprotobufUninterpretedOption(deserializeProtoString(a, index)))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufEnumValueOptions field uninterpreted_option")

proc newgoogleprotobufServiceOptions*(): googleprotobufServiceOptions =
  new(result)
  result.deprecated = false
  result.uninterpreted_option = newSeq[googleprotobufUninterpretedOption]()

method serialize*(this: googleprotobufServiceOptions): string =
  result = ""
  result &= serializeProtoVarintTag(uint32(33), this.deprecated)
  for v in this.uninterpreted_option:
    result &= serializeProtoStringTag(uint32(999), v.serialize())

proc deserializegoogleprotobufServiceOptions*(a: string): googleprotobufServiceOptions =
  result = newgoogleprotobufServiceOptions()
  var index: int = 0
  while index < a.len():
    var tag: uint32 = uint32(deserializeProtoVarint(a, index) and uint32(0xFFFFFFFF))
    var typeId: uint8 = tag and uint8(0x7)
    var id: uint32 = (tag and not uint32(0x7)) shr 3
    if id == uint32(33):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.deprecated = cast[bool](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufServiceOptions field deprecated")
    elif id == uint32(999):
      if typeId == uint8(STRING_TAG_TYPE):
        result.uninterpreted_option.add(deserializegoogleprotobufUninterpretedOption(deserializeProtoString(a, index)))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufServiceOptions field uninterpreted_option")

proc newgoogleprotobufMethodOptions*(): googleprotobufMethodOptions =
  new(result)
  result.deprecated = false
  result.uninterpreted_option = newSeq[googleprotobufUninterpretedOption]()

method serialize*(this: googleprotobufMethodOptions): string =
  result = ""
  result &= serializeProtoVarintTag(uint32(33), this.deprecated)
  result &= serializeProtoVarintTag(uint32(34), this.idempotency_level.ord())
  for v in this.uninterpreted_option:
    result &= serializeProtoStringTag(uint32(999), v.serialize())

proc deserializegoogleprotobufMethodOptions*(a: string): googleprotobufMethodOptions =
  result = newgoogleprotobufMethodOptions()
  var index: int = 0
  while index < a.len():
    var tag: uint32 = uint32(deserializeProtoVarint(a, index) and uint32(0xFFFFFFFF))
    var typeId: uint8 = tag and uint8(0x7)
    var id: uint32 = (tag and not uint32(0x7)) shr 3
    if id == uint32(33):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.deprecated = cast[bool](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufMethodOptions field deprecated")
    elif id == uint32(34):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.idempotency_level = cast[googleprotobufMethodOptionsIdempotencyLevel](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufMethodOptions field idempotency_level")
    elif id == uint32(999):
      if typeId == uint8(STRING_TAG_TYPE):
        result.uninterpreted_option.add(deserializegoogleprotobufUninterpretedOption(deserializeProtoString(a, index)))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufMethodOptions field uninterpreted_option")

proc newgoogleprotobufUninterpretedOptionNamePart*(): googleprotobufUninterpretedOptionNamePart =
  new(result)
  result.name_part = ""
  result.is_extension = false

method serialize*(this: googleprotobufUninterpretedOptionNamePart): string =
  result = ""
  result &= serializeProtoStringTag(uint32(1), this.name_part)
  result &= serializeProtoVarintTag(uint32(2), this.is_extension)

proc deserializegoogleprotobufUninterpretedOptionNamePart*(a: string): googleprotobufUninterpretedOptionNamePart =
  result = newgoogleprotobufUninterpretedOptionNamePart()
  var index: int = 0
  while index < a.len():
    var tag: uint32 = uint32(deserializeProtoVarint(a, index) and uint32(0xFFFFFFFF))
    var typeId: uint8 = tag and uint8(0x7)
    var id: uint32 = (tag and not uint32(0x7)) shr 3
    if id == uint32(1):
      if typeId == uint8(STRING_TAG_TYPE):
        result.name_part = cast[string](deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufUninterpretedOptionNamePart field name_part")
    elif id == uint32(2):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.is_extension = cast[bool](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufUninterpretedOptionNamePart field is_extension")

proc newgoogleprotobufUninterpretedOption*(): googleprotobufUninterpretedOption =
  new(result)
  result.name = newSeq[googleprotobufUninterpretedOptionNamePart]()
  result.identifier_value = ""
  result.positive_int_value = uint64(0)
  result.negative_int_value = 0
  result.double_value = 0.0
  result.string_value = ""
  result.aggregate_value = ""

method serialize*(this: googleprotobufUninterpretedOption): string =
  result = ""
  for v in this.name:
    result &= serializeProtoStringTag(uint32(2), v.serialize())
  result &= serializeProtoStringTag(uint32(3), this.identifier_value)
  result &= serializeProtoVarintTag(uint32(4), this.positive_int_value)
  result &= serializeProtoVarintTag(uint32(5), this.negative_int_value)
  result &= serializeProtoFixed64Tag(uint32(6), this.double_value)
  result &= serializeProtoStringTag(uint32(7), this.string_value)
  result &= serializeProtoStringTag(uint32(8), this.aggregate_value)

proc deserializegoogleprotobufUninterpretedOption*(a: string): googleprotobufUninterpretedOption =
  result = newgoogleprotobufUninterpretedOption()
  var index: int = 0
  while index < a.len():
    var tag: uint32 = uint32(deserializeProtoVarint(a, index) and uint32(0xFFFFFFFF))
    var typeId: uint8 = tag and uint8(0x7)
    var id: uint32 = (tag and not uint32(0x7)) shr 3
    if id == uint32(2):
      if typeId == uint8(STRING_TAG_TYPE):
        result.name.add(deserializegoogleprotobufUninterpretedOptionNamePart(deserializeProtoString(a, index)))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufUninterpretedOption field name")
    elif id == uint32(3):
      if typeId == uint8(STRING_TAG_TYPE):
        result.identifier_value = cast[string](deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufUninterpretedOption field identifier_value")
    elif id == uint32(4):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.positive_int_value = cast[uint64](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufUninterpretedOption field positive_int_value")
    elif id == uint32(5):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.negative_int_value = cast[int64](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufUninterpretedOption field negative_int_value")
    elif id == uint32(6):
      if typeId == uint8(FIXED64_TAG_TYPE):
        result.double_value = cast[float64](deserializeProtoFixed64(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufUninterpretedOption field double_value")
    elif id == uint32(7):
      if typeId == uint8(STRING_TAG_TYPE):
        result.string_value = cast[string](deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufUninterpretedOption field string_value")
    elif id == uint32(8):
      if typeId == uint8(STRING_TAG_TYPE):
        result.aggregate_value = cast[string](deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufUninterpretedOption field aggregate_value")

proc newgoogleprotobufSourceCodeInfoLocation*(): googleprotobufSourceCodeInfoLocation =
  new(result)
  result.path = newSeq[int32]()
  result.span = newSeq[int32]()
  result.leading_comments = ""
  result.trailing_comments = ""
  result.leading_detached_comments = newSeq[string]()

method serialize*(this: googleprotobufSourceCodeInfoLocation): string =
  result = ""
  for v in this.path:
    result &= serializeProtoVarintTag(uint32(1), v)
  for v in this.span:
    result &= serializeProtoVarintTag(uint32(2), v)
  result &= serializeProtoStringTag(uint32(3), this.leading_comments)
  result &= serializeProtoStringTag(uint32(4), this.trailing_comments)
  for v in this.leading_detached_comments:
    result &= serializeProtoStringTag(uint32(6), v)

proc deserializegoogleprotobufSourceCodeInfoLocation*(a: string): googleprotobufSourceCodeInfoLocation =
  result = newgoogleprotobufSourceCodeInfoLocation()
  var index: int = 0
  while index < a.len():
    var tag: uint32 = uint32(deserializeProtoVarint(a, index) and uint32(0xFFFFFFFF))
    var typeId: uint8 = tag and uint8(0x7)
    var id: uint32 = (tag and not uint32(0x7)) shr 3
    if id == uint32(1):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.path.add(cast[int32](deserializeProtoVarint(a, index)))
      # repeated numeric-type fields can be represented in a 'packed' encoding
      elif typeId == uint8(2):
        var endPoint: int
        endPoint = cast[int](deserializeProtoVarInt(a, index))
        endPoint += index # use above varint as length
        while index < endPoint:
          result.path.add(cast[int32](deserializeProtoVarint(a, index)))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufSourceCodeInfoLocation field path")
    elif id == uint32(2):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.span.add(cast[int32](deserializeProtoVarint(a, index)))
      # repeated numeric-type fields can be represented in a 'packed' encoding
      elif typeId == uint8(2):
        var endPoint: int
        endPoint = cast[int](deserializeProtoVarInt(a, index))
        endPoint += index # use above varint as length
        while index < endPoint:
          result.span.add(cast[int32](deserializeProtoVarint(a, index)))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufSourceCodeInfoLocation field span")
    elif id == uint32(3):
      if typeId == uint8(STRING_TAG_TYPE):
        result.leading_comments = cast[string](deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufSourceCodeInfoLocation field leading_comments")
    elif id == uint32(4):
      if typeId == uint8(STRING_TAG_TYPE):
        result.trailing_comments = cast[string](deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufSourceCodeInfoLocation field trailing_comments")
    elif id == uint32(6):
      if typeId == uint8(STRING_TAG_TYPE):
        result.leading_detached_comments.add(cast[string](deserializeProtoString(a, index)))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufSourceCodeInfoLocation field leading_detached_comments")

proc newgoogleprotobufSourceCodeInfo*(): googleprotobufSourceCodeInfo =
  new(result)
  result.location = newSeq[googleprotobufSourceCodeInfoLocation]()

method serialize*(this: googleprotobufSourceCodeInfo): string =
  result = ""
  for v in this.location:
    result &= serializeProtoStringTag(uint32(1), v.serialize())

proc deserializegoogleprotobufSourceCodeInfo*(a: string): googleprotobufSourceCodeInfo =
  result = newgoogleprotobufSourceCodeInfo()
  var index: int = 0
  while index < a.len():
    var tag: uint32 = uint32(deserializeProtoVarint(a, index) and uint32(0xFFFFFFFF))
    var typeId: uint8 = tag and uint8(0x7)
    var id: uint32 = (tag and not uint32(0x7)) shr 3
    if id == uint32(1):
      if typeId == uint8(STRING_TAG_TYPE):
        result.location.add(deserializegoogleprotobufSourceCodeInfoLocation(deserializeProtoString(a, index)))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufSourceCodeInfo field location")

proc newgoogleprotobufGeneratedCodeInfoAnnotation*(): googleprotobufGeneratedCodeInfoAnnotation =
  new(result)
  result.path = newSeq[int32]()
  result.source_file = ""
  result.begin = 0
  result.m_end = 0

method serialize*(this: googleprotobufGeneratedCodeInfoAnnotation): string =
  result = ""
  for v in this.path:
    result &= serializeProtoVarintTag(uint32(1), v)
  result &= serializeProtoStringTag(uint32(2), this.source_file)
  result &= serializeProtoVarintTag(uint32(3), this.begin)
  result &= serializeProtoVarintTag(uint32(4), this.m_end)

proc deserializegoogleprotobufGeneratedCodeInfoAnnotation*(a: string): googleprotobufGeneratedCodeInfoAnnotation =
  result = newgoogleprotobufGeneratedCodeInfoAnnotation()
  var index: int = 0
  while index < a.len():
    var tag: uint32 = uint32(deserializeProtoVarint(a, index) and uint32(0xFFFFFFFF))
    var typeId: uint8 = tag and uint8(0x7)
    var id: uint32 = (tag and not uint32(0x7)) shr 3
    if id == uint32(1):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.path.add(cast[int32](deserializeProtoVarint(a, index)))
      # repeated numeric-type fields can be represented in a 'packed' encoding
      elif typeId == uint8(2):
        var endPoint: int
        endPoint = cast[int](deserializeProtoVarInt(a, index))
        endPoint += index # use above varint as length
        while index < endPoint:
          result.path.add(cast[int32](deserializeProtoVarint(a, index)))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufGeneratedCodeInfoAnnotation field path")
    elif id == uint32(2):
      if typeId == uint8(STRING_TAG_TYPE):
        result.source_file = cast[string](deserializeProtoString(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufGeneratedCodeInfoAnnotation field source_file")
    elif id == uint32(3):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.begin = cast[int32](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufGeneratedCodeInfoAnnotation field begin")
    elif id == uint32(4):
      if typeId == uint8(VARINT_TAG_TYPE):
        result.m_end = cast[int32](deserializeProtoVarint(a, index))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufGeneratedCodeInfoAnnotation field m_end")

proc newgoogleprotobufGeneratedCodeInfo*(): googleprotobufGeneratedCodeInfo =
  new(result)
  result.annotation = newSeq[googleprotobufGeneratedCodeInfoAnnotation]()

method serialize*(this: googleprotobufGeneratedCodeInfo): string =
  result = ""
  for v in this.annotation:
    result &= serializeProtoStringTag(uint32(1), v.serialize())

proc deserializegoogleprotobufGeneratedCodeInfo*(a: string): googleprotobufGeneratedCodeInfo =
  result = newgoogleprotobufGeneratedCodeInfo()
  var index: int = 0
  while index < a.len():
    var tag: uint32 = uint32(deserializeProtoVarint(a, index) and uint32(0xFFFFFFFF))
    var typeId: uint8 = tag and uint8(0x7)
    var id: uint32 = (tag and not uint32(0x7)) shr 3
    if id == uint32(1):
      if typeId == uint8(STRING_TAG_TYPE):
        result.annotation.add(deserializegoogleprotobufGeneratedCodeInfoAnnotation(deserializeProtoString(a, index)))
      else:
        raise newException(IOError, "incorrect type ID " & $(typeId) & " while deserializing googleprotobufGeneratedCodeInfo field annotation")

