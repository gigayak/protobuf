import protobuf
import strutils
import system
import tables
import google/protobuf/compiler/plugin_pb
import google/protobuf/descriptor_pb

# One day, it might be wiser to just have this emit a Nim
# AST directly using the macro functionality. Hopefully that
# rewrite might be somewhat straightforward... but I just
# wanted something that vaguely worked as a first cut.

# TODO: protoc is optimized to strategically flush this buffer to
# allow for streaming output computation, so reading everything in
# immediately may be a performance drain.
var input: string = readAll(stdin)
var req: googleprotobufcompilerCodeGeneratorRequest = deserializegoogleprotobufcompilerCodeGeneratorRequest(input)


proc maybeRenameReservedId(id: string): string =
  var rename: bool = false
  case id:
    of "end", "type", "method", "block":
      rename = true
    else:
      rename = false
  if rename:
    result = "m_" & id
  else:
    result = id

proc protoIdFor(t: googleprotobufFieldDescriptorProtoType): string =
  case t:
    of TYPE_DOUBLE: return "FIXED64_TAG_TYPE"
    of TYPE_FLOAT: return "FIXED32_TAG_TYPE"
    of TYPE_INT64: return "VARINT_TAG_TYPE"
    of TYPE_UINT64: return "VARINT_TAG_TYPE"
    of TYPE_INT32: return "VARINT_TAG_TYPE"
    of TYPE_FIXED64: return "FIXED64_TAG_TYPE"
    of TYPE_FIXED32: return "FIXED32_TAG_TYPE"
    of TYPE_BOOL: return "VARINT_TAG_TYPE"
    of TYPE_STRING: return "STRING_TAG_TYPE"
    of TYPE_GROUP:
      var e: ref IOError
      new(e)
      e.msg = "TYPE_GROUP not implemented"
      raise e
    of TYPE_MESSAGE: return "STRING_TAG_TYPE"
    of TYPE_BYTES: return "STRING_TAG_TYPE"
    of TYPE_UINT32: return "VARINT_TAG_TYPE"
    of TYPE_ENUM: return "VARINT_TAG_TYPE"
    of TYPE_SFIXED32: return "FIXED32_TAG_TYPE"
    of TYPE_SFIXED64: return "FIXED64_TAG_TYPE"
    of TYPE_SINT32: return "FIXED32_TAG_TYPE"
    of TYPE_SINT64: return "FIXED64_TAG_TYPE"
    else:
      var e: ref IOError
      new(e)
      e.msg = "received unknown type"
      raise e

type
  CompilerContext = ref object of RootObj
    parentContext: CompilerContext
    childContexts: TableRef[string, CompilerContext]
    name: string
    nameTable: TableRef[string, string]

proc newContext(): CompilerContext =
  new(result)
  result.parentContext = nil
  result.childContexts = newTable[string, CompilerContext]()
  result.nameTable = newTable[string, string]()
  result.name = ""

# Gets the root context, returns self if called on the root context.
method getRootContext(this: CompilerContext): CompilerContext {.base.} =
  if this.parentContext == nil:
    return this
  return this.parentContext.getRootContext()

proc `$`(this: CompilerContext): string =
  result = ""
  var ctx: CompilerContext = this
  if ctx.parentContext != nil:
    result &= $(ctx.parentContext) & "."
  result &= ctx.name

proc removeNamespace(s: string): string =
  if s.find(".") != 1:
    return s[s.rfind(".")+1..s.len()-1]
  else:
    return s

method getChildContext(this: CompilerContext, namespace: string): CompilerContext {.base.}

# This is the main reason we even have these contexts: to allow for name lookup
# and name mangling across separate packages.
method addName(this: CompilerContext, origName: string, destName: string) {.base.} =
  var ctx: CompilerContext = this
  var orig: string = origName

  # If the original name appears to be fully-qualified protobuf naming, with a
  # namespace and everything - then go ahead and look up the context that
  # corresponds to that namespace and just use the last fragment.
  if orig.find(".") != -1:
    ctx = ctx.getChildContext(orig[0..orig.rfind(".")-1])
    orig = orig[orig.rfind(".")+1..orig.len()-1]

  # Make sure we don't insert any reserved words into the generated Nim code.
  var dest: string = destName
  dest = maybeRenameReservedId(dest)

  # Debug output while we finish this plugin...
  stderr.writeLine("attempting to add name mapping from '" &
    orig & "' => '" & dest & "' to cache in context " & $(ctx))
  if ctx.nameTable.hasKey(orig):
    raise newException(KeyError, "name cache for " & $(ctx) & " already contains key " & orig)
  ctx.nameTable[orig] = dest

method addMessageName(this: CompilerContext, n: string) {.base.} =
  this.addName(n, ($this).replace(".", "") & n.replace(".", ""))

method addEnumName(this: CompilerContext, n: string) {.base.} =
  this.addName(n, ($this).replace(".", "") & n.replace(".", ""))

method addFieldName(this: CompilerContext, n: string) {.base.} =
  this.addName(n, n)

# This attempts to find a name in the local name table, or any parent name table.
method resolveName(this: CompilerContext, name: string): string {.base.} =
  var ctx: CompilerContext = this
  var n: string = name

  var allowRecursion: bool = true

  # Allow for root-relative names to be found.
  if n[0] == '.':
    allowRecursion = false
    ctx = ctx.getRootContext()
    n = n[1..n.len()-1]

  # Allow for qualified names to be found.
  if n.find(".") != -1:
    allowRecursion = false
    ctx = ctx.getChildContext(n[0..n.rfind(".")-1])
    n = n[n.rfind(".")+1..n.len()-1]

  # Just rip out the mangled name from the table - most of our work is already
  # done during the addName() call.
  if not ctx.nameTable.hasKey(n):
    # Shouldn't recurse if we're already at the root context or if we got
    # a relative path.
    if ctx.parentContext == nil or not allowRecursion:
      return ""
    else:
      return ctx.parentContext.resolveName(n)
  return ctx.nameTable[n]

# This wrapper just makes sure we throw the exception at the shallowest level of
# recursion, as otherwise every error will indicate that stuff could not be found
# in the root context.
method getName(this: CompilerContext, n: string): string {.base.} =
  if n == "":
    raise newException(KeyError, "cannot resolve a blank name (in " & $(this) & " context)")
  result = this.resolveName(n)
  if result == "":
    raise newException(KeyError, "cannot find key '" & n & "' in " & $(this) & " context")

method getChildContext(this: CompilerContext, namespace: string): CompilerContext =
  # Calling .getChildContext("") is meaningless, as you'd be descending through
  # a nameless context.  What would that context represent?  Each level of child
  # contexts is supposed to represent a new protobuf namespace - such as a
  # package name, a message type, or another element that can then contain named
  # elements within it.
  #
  # Remember that this exists primarily as a name-mangling cache, so blank names
  # don't really make sense (and these exceptions can be ripped out if they ever
  # do make sense), but... don't do that.  Why would it ever make sense?
  if namespace == nil or namespace.len() == 0:
    raise newException(KeyError, "blank or nil keys are not valid CompilerContext keys (something tried fetching '" & namespace & "' from " & $(this) & ")")

  # ".."s would mean that at some point we wind up attempting to call
  # .getChildContext(""), which would invoke the above KeyError.
  if namespace.find("..") != -1:
    raise newException(KeyError, "CompilerContext keys cannot contain blank fragments")

  # childCtx.getChildContext(".google.protobuf.compiler") should get the
  # root context and then call rootCtx.getChildContext("google.protobuf.compiler")
  # upon it, as the leading "." implies "start from root" in the protobuf
  # language.
  if namespace[0] == '.':
    if namespace.len() == 1:
      return this.getRootContext()
    else:
      return this.getRootContext().getChildContext(namespace[1..namespace.len()-1])

  # This iteratively descends into each namespace fragment provided,
  # so that .getChildContext("google.protobuf.compiler") is the same
  # as .getChildContext("google").getChildContext("protobuf")...
  var currentCtx: CompilerContext = this
  for nsFragment in namespace.split("."):
    if not currentCtx.childContexts.hasKey(nsFragment):
      var ctx: CompilerContext = newContext()
      ctx.parentContext = currentCtx
      ctx.name = nsFragment
      currentCtx.childContexts[nsFragment] = ctx
    currentCtx = currentCtx.childContexts[nsFragment]
  return currentCtx

# Fetches the Nim-language type name for the given type.
#
# The last parameter is the type name, as described by googleprotobufFieldDescriptorProto.typeName.
method nimTypeFor(this: CompilerContext, t: googleprotobufFieldDescriptorProtoType, n: string): string =
  case t:
    of TYPE_DOUBLE: return "float64"
    of TYPE_FLOAT: return "float32"
    of TYPE_INT32: return "int32"
    of TYPE_INT64: return "int64"
    of TYPE_UINT64: return "uint64"
    of TYPE_FIXED64: return "int64"
    of TYPE_FIXED32: return "int32"
    of TYPE_BOOL: return "bool"
    of TYPE_STRING: return "string"
    of TYPE_GROUP:
      var e: ref IOError
      new(e)
      e.msg = "TYPE_GROUP not implemented"
      raise e
    of TYPE_MESSAGE: return this.getName(n)
    of TYPE_BYTES: return "string"
    of TYPE_ENUM: return this.getName(n)
    of TYPE_UINT32: return "uint32"
    # TODO: ensure implementation for all S-prefixed types works
    of TYPE_SFIXED32: return "int32"
    of TYPE_SFIXED64: return "int64"
    of TYPE_SINT32: return "int32"
    of TYPE_SINT64: return "int64"
    else:
      var e: ref IOError
      new(e)
      e.msg = "received unknown type " & $(t)
      raise e

# Fetches the Nim-language default value for the given type.
#
# The last parameter is the type name, as described by googleprotobufFieldDescriptorProto.typeName.
#
# A blank indicates not to initialize defaults explicitly.
method defaultValueFor(this: CompilerContext, t: googleprotobufFieldDescriptorProtoType, n: string): string =
  case t:
    of TYPE_DOUBLE: return "0.0"
    of TYPE_FLOAT: return "0.0"
    of TYPE_INT32: return "0"
    of TYPE_INT64: return "0"
    of TYPE_UINT64: return "uint64(0)"
    of TYPE_FIXED64: return "0"
    of TYPE_FIXED32: return "0"
    of TYPE_BOOL: return "false"
    of TYPE_STRING: return "\"\""
    of TYPE_GROUP:
      var e: ref IOError
      new(e)
      e.msg = "TYPE_GROUP not implemented"
      raise e
    of TYPE_MESSAGE: return "new" & this.getName(n) & "()"
    of TYPE_BYTES: return "\"\""
    of TYPE_ENUM: return ""
    of TYPE_UINT32: return "uint32(0)"
    # TODO: ensure implementation for all S-prefixed types works
    of TYPE_SFIXED32: return "0"
    of TYPE_SFIXED64: return "0"
    of TYPE_SINT32: return "0"
    of TYPE_SINT64: return "0"
    else:
      var e: ref IOError
      new(e)
      e.msg = "received unknown type " & $(t)
      raise e


proc visitForNameCache(ctx: CompilerContext, t: googleprotobufEnumDescriptorProto) =
  ctx.addEnumName(t.name)

proc visitForNameCache(parentCtx: CompilerContext, m: googleprotobufDescriptorProto) =
  parentCtx.addMessageName(m.name)
  var ctx: CompilerContext = parentCtx.getChildContext(m.name)
  for enumType in m.enumType:
    visitForNameCache(ctx, enumType)
  for msgType in m.nestedType:
    visitForNameCache(ctx, msgType)
  for field in m.field:
    ctx.addFieldName(field.name)

proc visitForNameCache(ctx: CompilerContext, f: googleprotobufFileDescriptorProto) =
  for enumType in f.enumType:
    visitForNameCache(ctx, enumType)
  for msgType in f.messageType:
    visitForNameCache(ctx, msgType)

proc visitForFwdDecls(parentCtx: CompilerContext, m: googleprotobufDescriptorProto): string =
  var ctx: CompilerContext = parentCtx.getChildContext(m.name)
  result = ""
  for msgType in m.nestedType:
    result &= visitForFwdDecls(ctx, msgType)
  # This message's name should be stored in its parent's context, as its name
  # resides in the same context as the message's sub-context is stored in.
  var msgName: string = parentCtx.getName(m.name)
  result &= "proc new" & msgName & "*(): " & msgName & "\n"
  result &= "proc deserialize" & msgName & "*(a: string): " & msgName & "\n"

proc visitForTypeDecls(ctx: CompilerContext, e: googleprotobufEnumDescriptorProto): string =
  result = ""
  var enumName: string = ctx.getName(e.name)
  result &= "  " & enumName & "* = enum\n"
  for val in e.value:
    result &= "    " & val.name & " = " & $(val.number) & "\n"

proc visitForTypeDecls(parentCtx: CompilerContext, m: googleprotobufDescriptorProto): string =
  var ctx: CompilerContext = parentCtx.getChildContext(m.name)
  result = ""
  for enumType in m.enumType:
    result &= visitForTypeDecls(ctx, enumType)
  for msgType in m.nestedType:
    result &= visitForTypeDecls(ctx, msgType)

  var msgName: string = parentCtx.getName(m.name)
  result &= "  " & msgName & "* = ref object of RootProto\n"
  for field in m.field:
    var fieldName: string = ctx.getName(field.name)
    # "type" is a reserved word in Nim, so m_type is the automated reassignment
    var typ: string = ctx.nimTypeFor(field.m_type, field.typeName)
    if field.label == LABEL_REPEATED:
      result &= "    " & fieldName & "*: seq[" & typ & "]\n"
    else:
      result &= "    " & fieldName & "*: " & typ & "\n"

proc visitForCode(parentCtx: CompilerContext, m: googleprotobufDescriptorProto): string =
  result = ""
  var msgName: string = parentCtx.getName(m.name)
  var ctx: CompilerContext = parentCtx.getChildContext(m.name)

  # Recurse into nested types so their constructors / serializers /
  # deserializers are available to the parent equivalents.
  for msgType in m.nestedType:
    result &= visitForCode(ctx, msgType)

  # Constructor.
  result &= "proc new" & msgName & "*(): " & msgName & " =\n"
  result &= "  new(result)\n"
  for field in m.field:
    var fieldName: string = ctx.getName(field.name)
    var fieldType: string = ctx.nimTypeFor(field.m_type, field.typeName)
    var fieldDefault: string = ctx.defaultValueFor(field.m_type, field.typeName)
    if field.label == LABEL_REPEATED:
      result &= "  result." & fieldName & " = newSeq[" & fieldType & "]()\n"
    elif fieldDefault != "": # allow blank defaults to skip scalar initialization
      result &= "  result." & fieldName & " = " & fieldDefault & "\n"
  result &= "\n"

  # Serializer.
  result &= "method serialize*(this: " & msgName & "): string =\n"
  result &= "  result = \"\"\n"
  for field in m.field:
    var fieldName: string = ctx.getName(field.name)
    var fieldType: string = ctx.nimTypeFor(field.m_type, field.typeName)
    var protoId: string = protoIdFor(field.m_type)
    var serializer: string
    case protoId:
      of "VARINT_TAG_TYPE": serializer = "serializeProtoVarintTag"
      of "STRING_TAG_TYPE": serializer = "serializeProtoStringTag"
      of "FIXED32_TAG_TYPE": serializer = "serializeProtoFixed32Tag"
      of "FIXED64_TAG_TYPE": serializer = "serializeProtoFixed64Tag"
      else: raise newException(IOError, "encountered unknown proto tag type '" & protoId & "' in " & $(ctx))
    if field.label == LABEL_REPEATED:
      result &= "  for v in this." & fieldName & ":\n"
      var fieldRef: string = "v"
      if field.m_type == TYPE_MESSAGE:
        fieldRef = "v.serialize()"
      elif field.m_type == TYPE_ENUM:
        fieldRef = "v.ord()"
      result &= "    result &= " & serializer & "(uint32(" & $(field.number) & "), " & fieldRef & ")\n"
    else:
      var fieldRef: string = "this." & fieldName
      if field.m_type == TYPE_MESSAGE:
        fieldRef &= ".serialize()"
      elif field.m_type == TYPE_ENUM:
        fieldRef &= ".ord()"
      result &= "  result &= " & serializer & "(uint32(" & $(field.number) & "), " & fieldRef & ")\n"
  result &= "\n"

  # Deserializer.
  result &= "proc deserialize" & msgName & "*(a: string): " & msgName & " =\n"
  result &= "  result = new" & msgName & "()\n"
  result &= "  var index: int = 0\n"
  result &= "  while index < a.len():\n"
  result &= "    var tag: uint32 = uint32(deserializeProtoVarint(a, index) and uint32(0xFFFFFFFF))\n"
  result &= "    var typeId: uint8 = tag and uint8(0x7)\n"
  result &= "    var id: uint32 = (tag and not uint32(0x7)) shr 3\n"
  var firstEntry: bool = true
  for field in m.field:
    var fieldName: string = ctx.getName(field.name)
    var fieldType: string = ctx.nimTypeFor(field.m_type, field.typeName)
    var protoId: string = protoIdFor(field.m_type)
    result &= "    "
    if firstEntry:
      firstEntry = false
    else:
      result &= "el"
    result &= "if id == uint32(" & $(field.number) & "):\n"
    result &= "      if typeId == uint8(" & protoId & "):\n"

    # Message types require an extra layer of deserialization (to turn the
    # buffer contained in the string into its own protobuf struct), so they
    # are handled specially.
    if field.m_type == TYPE_MESSAGE:
      if field.label == LABEL_REPEATED:
        result &= "        result." & fieldName & ".add(deserialize" & fieldType & "(deserializeProtoString(a, index)))\n"
      else:
        result &= "        result." & fieldName & " = deserialize" & fieldType & "(deserializeProtoString(a, index))\n"

    # Other types largerly follow similar logic.
    else:
      var deserializerType: string
      if protoId == "VARINT_TAG_TYPE": deserializerType = "Varint"
      elif protoId == "STRING_TAG_TYPE": deserializerType = "String"
      elif protoId == "FIXED32_TAG_TYPE": deserializerType = "Fixed32"
      elif protoId == "FIXED64_TAG_TYPE": deserializerType = "Fixed64"
      else: raise newException(IOError, "unknown proto field type " & $(field.m_type))
      var deserializer: string = "deserializeProto" & deserializerType & "(a, index)"
      if field.label == LABEL_REPEATED:
        result &= "        result." & fieldName & ".add(cast[" & fieldType & "](" & deserializer & "))\n"
      else:
        result &= "        result." & fieldName & " = cast[" & fieldType & "](" & deserializer & ")\n"

      # However, there is a big gotcha for numeric types - "packed"
      # encoding exists, and our deserializer must be able to handle
      # it (even if none of our serializers necessarily produce it).
      if protoId != "STRING_TAG_TYPE" and field.label == LABEL_REPEATED:
        result &= "      # repeated numeric-type fields can be represented in a 'packed' encoding\n"
        result &= "      elif typeId == uint8(2):\n" # TODO: use a constant for this, so it's clear this is the packed encoding branch when reading generated code
        result &= "        var endPoint: int\n"
        result &= "        endPoint = cast[int](deserializeProtoVarInt(a, index))\n"
        result &= "        endPoint += index # use above varint as length\n"
        result &= "        while index < endPoint:\n"
        result &= "          result." & fieldName & ".add(cast[" & fieldType & "](" & deserializer & "))\n"

    # Of course, we should throw a fit if we can't find a valid type for this proto.
    result &= "      else:\n"
    result &= "        raise newException(IOError, \"incorrect type ID \" & $(typeId) & \" while deserializing " & msgName & " field " & fieldName & "\")\n"

  # However, no error should be thrown for unknown fields (though
  # we really should be storing them for later to be able to add them
  # to the serialized version of the proto in the "load, edit, save"
  # use case!)
  #
  # TODO: handle unknown fields correctly - currently they're just
  # removed, in violation of the protobuf spec.
  result &= "\n"

proc visitForCode(ctx: CompilerContext, f: googleprotobufFileDescriptorProto): string =
  result = ""

  # Import statements.
  result &= "import protobuf\n"
  for dep in f.dependency:
    var depName: string = dep
    if depName.rfind(".proto") != -1:
      depName = depName[0..depName.rfind(".proto")-1]
    depName &= "_pb"
    result &= "import " & depName & "\n"
  result &= "\n"

  # Type blocks.
  result &= "type\n"
  for msgType in f.messageType:
    result &= visitForTypeDecls(ctx, msgType)
  for enumType in f.enumType:
    result &= visitForTypeDecls(ctx, enumType)
  result &= "\n"

  # Forward declarations.
  for msgType in f.messageType:
    result &= visitForFwdDecls(ctx, msgType)
  result &= "\n"

  # Serializers and deserializers.
  for msgType in f.messageType:
    result &= visitForCode(ctx, msgType)

proc visitForCode(ctx: CompilerContext, req: googleprotobufcompilerCodeGeneratorRequest): googleprotobufcompilerCodeGeneratorResponse =
  result = newgoogleprotobufcompilerCodeGeneratorResponse()

  # Do one pass for each file first to fill out the name cache.  This hopefully
  # ensures that names in dependencies are all resolvable.
  for f in req.proto_file:
    var fileCtx: CompilerContext = ctx
    if f.package != nil and f.package != "":
      fileCtx = ctx.getChildContext(f.package)
    stderr.writeLine "populating name cache from proto file: " & f.name
    visitForNameCache(fileCtx, f)

  # This is the actual code generation pass - which should now hopefully have
  # full knowledge of which names do and do not correspond to actual entities
  # declared by protobuf definitions.
  for f in req.proto_file:
    var fileCtx: CompilerContext = ctx
    if f.package != nil and f.package != "":
      fileCtx = ctx.getChildContext(f.package)
    stderr.writeLine "generating code for proto file: " & f.name
    var fileProto: googleprotobufcompilerCodeGeneratorResponseFile = newgoogleprotobufcompilerCodeGeneratorResponseFile()
    fileProto.name = f.name
    if f.name.rfind(".proto") != -1:
      fileProto.name = f.name[0..f.name.rfind(".proto")-1]
    fileProto.name &= "_pb.nim"
    fileProto.content = visitForCode(fileCtx, f)
    result.file.add(fileProto)

# Convenience alias without context which initializes a brand new context.
proc visitForCode(req: googleprotobufcompilerCodeGeneratorRequest): googleprotobufcompilerCodeGeneratorResponse =
  var rootCtx: CompilerContext = newContext()
  return visitForCode(rootCtx, req)

stdout.write(visitForCode(req).serialize())
