require "../src/protobuf"
require "perf_tools/mem_prof"


class MyMessage
  include Protobuf::Message
  contract do
    required :number, :int32,  1
    required :chars,  :string, 2
    required :raw,    :bytes,  3
    required :bool,   :bool,   4
    required :float,  :float,  5
  end
end

ITERS = 100_000

io = MyMessage.new(
  number: 12345,
  chars: "hello",
  raw: "world".to_slice,
  bool: true,
  float: 1.2345_f32
).to_protobuf

string_pool = StringPool.new(32)

messages = ITERS.times.map do
  MyMessage.from_protobuf(io.rewind)
end

puts messages.size

PerfTools::MemProf.pretty_log_allocations(STDOUT)