const std = @import("std");
const cmd = @import("command.zig");

var general_porpoise_alligator = std.heap.GeneralPurposeAllocator(.{}){};
pub const gpa = general_porpoise_alligator.allocator();

pub const fixed_buffer_size = 1 << 20;
var _fixed_buffer: [fixed_buffer_size]u8 = undefined;
var _f = std.heap.FixedBufferAllocator.init(&_fixed_buffer);
pub const fba = _f.allocator();
