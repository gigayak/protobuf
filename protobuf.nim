import system

type
  RootProto* = ref object of RootObj

method serialize*(this: RootProto): string {.base, gcsafe.} =
  return nil


# Run-length encoding of Protocol Buffer varints in unsigned space.
#
# Description of the actual encoding is here:
#   https://developers.google.com/protocol-buffers/docs/encoding
#
# Each byte in the output has an MSB that indicates whether or not more bytes
# follow.  If the MSB is 1, expect another byte.  If the MSB is 0, end of int.
#
# Beyond that, the lowest-significance group of 7 bits precedes the next highest
# significance group.
proc serializeProtoVarint*(a: uint64): string {.inline.} =
  # Initialization of state machine... possibly redundant.
  var done: bool = false
  var iterations: int = 0
  # Copy off argument, as we'll mutate it by removing 7 bits at a time.
  var remaining: uint64 = a
  # Initialize return value to avoid segfaults.
  result = ""
  # Grab groups one-by-one - make sure to pull at least one group, since zero
  # is a valid input, and needs to produce a single 0x00 byte as output.
  while not done:
    # Trapdoor in case of bugs.
    iterations += 1
    if iterations >= 10000:
      stderr.writeLine "reached iteration limit when serializing a varint from: " & $(a)
      stderr.writeLine "remaining bits: " & $(remaining)
      var e: ref ArithmeticError
      new(e)
      e.msg = "reached iteration limit serializing a varint"
      raise e
    # Mask off lowest 7 bits.
    var currentGroup: uint8 = uint8(remaining and uint64(0x7F)) # get lowest significance 7 bits
    # Wipe the bottom 7 bits, because shr will wrap.  Then, shift.
    remaining = (remaining and not uint64(0x7F)) shr 7
    # If we see zero at this point, we'll end the encoding.  This ensures that
    # we produce at least one byte for a zero input.
    if remaining == 0:
      done = true
    # Set the MSB to 1 if we are going to produce more output.
    if not done:
      currentGroup = currentGroup or uint8(0x80)
    # Finally, spit out the accumulated data.
    result &= char(currentGroup)
  # Implicit return via result.

proc deserializeProtoVarint*(s: string, index: var int): uint64 {.inline.} =
  result = uint64(0)
  var groupsAdded: int = 0
  var done: bool = false
  while not done:
    var currentGroup: uint8 = uint8(s[index])
    if (currentGroup and uint8(0x80)) == uint8(0):
      done = true
    result = result or (uint64(currentGroup and uint8(0x7F)) shl (groupsAdded*7))
    groupsAdded += 1
    index += 1

# "ZigZag" encoding for signed integers.
#
# Description of signed integer encoding is in this section of the protobuf
# encoding documentation:
#   https://developers.google.com/protocol-buffers/docs/encoding#signed-integers
#
# To quote:
#   In other words, each value n is encoded using
#     `(n << 1) ^ (n >> 31)`
#   for `sint32`s, or
#     `(n << 1) ^ (n >> 63)`
#   for the 64-bit version.
#
#   Note that the second shift - the (n >> 31) part - is an arithmetic shift.
#   So, in other words, the result of the shift is either a number that is all
#   zero bits (if n is positive) or all one bits (if n is negative).
#
# Note that this is only used when the protobuf specification calls for a type
# labeled "sint64" or "sint32" - "int64" and "int32" will still be handled by
# their normal twos-complement encoding.
proc serializeProtoSignedVarint*(a: int32): string {.inline.} =
  if (uint32(a) and uint32(0x80000000)) > uint32(0):
    return serializeProtoVarint(uint64(not ((uint32(a) and uint32(0x7FFFFFFF)) shl 1)))
  else:
    return serializeProtoVarint(uint64(a) shl 1)
proc serializeProtoSignedVarint*(a: int64): string {.inline.} =
  if (uint64(a) and uint64(0x8000000000000000)) > uint64(0):
    return serializeProtoVarint(uint64(not ((uint64(a) and uint64(0x7FFFFFFFFFFFFFFF)) shl 1)))
  else:
    return serializeProtoVarint(uint64(a) shl 1)

# Implicit casts for intN-to-uint64 conversion when serializing.
proc serializeProtoVarint*(a: int): string {.inline.} =
  return serializeProtoVarint(uint64(a))
proc serializeProtoVarint*(a: int8): string {.inline.} =
  return serializeProtoVarint(uint64(a))
proc serializeProtoVarint*(a: int16): string {.inline.} =
  return serializeProtoVarint(uint64(a))
proc serializeProtoVarint*(a: int32): string {.inline.} =
  return serializeProtoVarint(uint64(a))
proc serializeProtoVarint*(a: int64): string {.inline.} =
  return serializeProtoVarint(uint64(a))

# Implicit casts for uintN-to-uint64 conversion when serializing.
proc serializeProtoVarint*(a: uint): string {.inline.} =
  return serializeProtoVarint(uint64(a))
proc serializeProtoVarint*(a: uint8): string {.inline.} =
  return serializeProtoVarint(uint64(a))
proc serializeProtoVarint*(a: uint16): string {.inline.} =
  return serializeProtoVarint(uint64(a))
proc serializeProtoVarint*(a: uint32): string {.inline.} =
  return serializeProtoVarint(uint64(a))

# Implicit cast for bool-to-uint64 conversion when serializing.
proc serializeProtoVarint*(a: bool): string {.inline.} =
  if a:
    return serializeProtoVarint(uint64(0x0))
  else:
    return serializeProtoVarint(uint64(0x1))

# Tagged varint serialization - i.e. with the actual tag ID attached.
const VARINT_TAG_TYPE*: uint8 = uint8(0)

proc serializeProtoVarintTag*(t: uint32, v: uint64): string {.inline.} =
  result = ""
  # Tag ID plus type share a varint when encoding.
  result &= serializeProtoVarint((t shl 3) xor (VARINT_TAG_TYPE))
  # And then add in the encoded value and we're set.
  result &= serializeProtoVarint(v)

# All of the various implicit casts we may desire:
proc serializeProtoVarintTag*(t: uint32, v: uint): string {.inline.} =
  return serializeProtoVarintTag(t, uint64(v))
proc serializeProtoVarintTag*(t: uint32, v: uint8): string {.inline.} =
  return serializeProtoVarintTag(t, uint64(v))
proc serializeProtoVarintTag*(t: uint32, v: uint16): string {.inline.} =
  return serializeProtoVarintTag(t, uint64(v))
proc serializeProtoVarintTag*(t: uint32, v: uint32): string {.inline.} =
  return serializeProtoVarintTag(t, uint64(v))
proc serializeProtoVarintTag*(t: uint32, v: int): string {.inline.} =
  return serializeProtoVarintTag(t, uint64(v))
proc serializeProtoVarintTag*(t: uint32, v: int8): string {.inline.} =
  return serializeProtoVarintTag(t, uint64(v))
proc serializeProtoVarintTag*(t: uint32, v: int16): string {.inline.} =
  return serializeProtoVarintTag(t, uint64(v))
proc serializeProtoVarintTag*(t: uint32, v: int32): string {.inline.} =
  return serializeProtoVarintTag(t, uint64(v))
proc serializeProtoVarintTag*(t: uint32, v: int64): string {.inline.} =
  return serializeProtoVarintTag(t, uint64(v))
proc serializeProtoVarintTag*(t: uint32, v: bool): string {.inline.} =
  if v:
    return serializeProtoVarintTag(t, uint64(0x1))
  else:
    return serializeProtoVarintTag(t, uint64(0x0))

# Serialize a single 32-bit fixed length sequence
#
# TODO: This does not acknowledge endianness yet.
proc serializeProtoFixed32*(v: uint32): string =
  result = ""
  result &= char(uint8((v and uint32(0xFF000000)) shr 24))
  result &= char(uint8((v and uint32(0x00FF0000)) shr 16))
  result &= char(uint8((v and uint32(0x0000FF00)) shr 8))
  result &= char(uint8((v and uint32(0x000000FF))))
proc serializeProtoFixed32*(v: float32): string =
  return serializeProtoFixed32(cast[uint32](v))
proc serializeProtoFixed32*(v: float): string =
  return serializeProtoFixed32(float32(v))
const FIXED32_TAG_TYPE*: uint8 = uint8(5)
proc serializeProtoFixed32Tag*(t: uint32, v: uint32): string =
  result = ""
  # Tag ID and type ID
  result &= serializeProtoVarint((t shl 3) xor (FIXED32_TAG_TYPE))
  # Actual value
  result &= serializeProtoFixed32(v)
# Implicit casts
proc serializeProtoFixed32Tag*(t: uint32, v: float32): string =
  return serializeProtoFixed32Tag(t, cast[uint32](v))
proc serializeProtoFixed32Tag*(t: uint32, v: float): string =
  return serializeProtoFixed32Tag(t, float32(v))

proc deserializeProtoFixed32*(a: string, index: var int): uint32 =
  if index + 4 > a.len:
    stderr.writeLine "not enough bytes available to read, fixed32 deserialization failed"
    var e: ref IOError
    new(e)
    e.msg = "not enough bytes available to read at index " & $(index) & " (" & $(a.len) & " total available, 4 more needed)"
    raise e
  result = 0
  result += uint32(a[index]) shl 24
  index += 1
  result += uint32(a[index]) shl 16
  index += 1
  result += uint32(a[index]) shl 8
  index += 1
  result += uint32(a[index])
  index += 1

# Serialize a single 64-bit fixed length sequence
#
# TODO: This does not acknowledge endianness yet.
proc serializeProtoFixed64*(v: uint64): string =
  result = ""
  result &= char(uint8((v and uint64(0xFF00000000000000)) shr 56))
  result &= char(uint8((v and uint64(0x00FF000000000000)) shr 48))
  result &= char(uint8((v and uint64(0x0000FF0000000000)) shr 40))
  result &= char(uint8((v and uint64(0x000000FF00000000)) shr 32))
  result &= char(uint8((v and uint64(0x00000000FF000000)) shr 24))
  result &= char(uint8((v and uint64(0x0000000000FF0000)) shr 16))
  result &= char(uint8((v and uint64(0x000000000000FF00)) shr 8))
  result &= char(uint8((v and uint64(0x00000000000000FF))))
proc serializeProtoFixed64*(v: float64): string =
  return serializeProtoFixed64(cast[uint64](v))
const FIXED64_TAG_TYPE*: uint8 = uint8(1)
proc serializeProtoFixed64Tag*(t: uint32, v: uint64): string =
  result = ""
  # Tag ID and type ID
  result &= serializeProtoVarint((t shl 3) xor (FIXED64_TAG_TYPE))
  # Actual value
  result &= serializeProtoFixed64(v)
# Implicit casts
proc serializeProtoFixed64Tag*(t: uint32, v: float64): string =
  return serializeProtoFixed64Tag(t, cast[uint64](v))

proc deserializeProtoFixed64*(a: string, index: var int): uint64 =
  if index + 8 > a.len:
    stderr.writeLine "not enough bytes available to read, fixed64 deserialization failed"
    var e: ref IOError
    new(e)
    e.msg = "not enough bytes available to read at index " & $(index) & " (" & $(a.len) & " total available, 8 more needed)"
    raise e
  result = 0
  result += uint64(a[index]) shl 56
  index += 1
  result += uint64(a[index]) shl 48
  index += 1
  result += uint64(a[index]) shl 40
  index += 1
  result += uint64(a[index]) shl 32
  index += 1
  result += uint64(a[index]) shl 24
  index += 1
  result += uint64(a[index]) shl 16
  index += 1
  result += uint64(a[index]) shl 8
  index += 1
  result += uint64(a[index])
  index += 1

# Tagged string / bytestring serialization.  Used for strings, bytes, embedded
# messages, packed repeated fields, and making dreams come true.
#
# This encoding is described here:
#   https://developers.google.com/protocol-buffers/docs/encoding#strings
const STRING_TAG_TYPE*: uint8 = uint8(2)
proc serializeProtoStringTag*(t: uint32, v: string): string {.inline.} =
  result = ""
  # Tag ID plus type share a varint when encoding.
  result &= serializeProtoVarint((t shl 3) xor (STRING_TAG_TYPE))
  # The above type ID indicates that a lenght varint will follow.
  result &= serializeProtoVarint(v.len)
  # And then we can just append the string.
  result &= v

proc deserializeProtoString*(a: string, index: var int): string =
  var length: int = cast[int](deserializeProtoVarint(a, index))
  if length == 0:
    return ""
  if index + length > a.len:
    stderr.writeLine "not enough bytes available to read, string deserialization failed"
    var e: ref IOError
    new(e)
    e.msg = "not enough bytes available to read at index " & $(index) & " (" & $(a.len) & " total available, " & $(length) & " more needed)"
    raise e
  result = a[index..index+length-1]
  index += length

# These allow an RPC implementation to look up details of which RPC methods
# to provide at compile time.
#
# protoc_plugin should then write code in each generated file coming from
# a .proto file with a service definition which contains compile-time objects
# of these classes.
#
# RPC implementations can then use those objects in a macro to generate code
# for their client or server code generation needs.
type
  # "object of RootObj" would cause "invalid type for const" here
  RPCMethodDescriptor* = object
    name*: string
    requestTypeName*: string
    responseTypeName*: string

  RPCServiceDescriptor* = object
    name*: string
    methods*: seq[RPCMethodDescriptor]
