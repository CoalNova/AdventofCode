pub const std = @import("std");
pub const alc = @import("alloc.zig");
pub const cmd = @import("command.zig");
pub const fio = @import("fileio.zig");
pub const prc = @import("process.zig");
pub const ins = std.time.Instant;
const day = @import("day.zig");

pub fn Day(
    comptime T: anytype,
    comptime _part_one: fn ([]const u8) T,
    comptime _part_two: fn ([]const u8) T,
    comptime _year: u16,
    comptime _day: u8,
    comptime _sampleOne: []const u8,
    comptime _sampleTwo: []const u8,
) type {
    return struct {
        const Self = @This();
        comptime partOne: fn ([]const u8) T = _part_one,
        comptime partTwo: fn ([]const u8) T = _part_two,
        comptime year: u16 = _year,
        comptime day: u8 = _day,
        comptime sampleOne: []const u8 = _sampleOne,
        comptime sampleTwo: []const u8 = _sampleTwo,
        pub fn proc(self: Self, p: prc.Proc) void {
            if (p._test) {
                self.test_();
            } else if (p.iters > 0) {
                self.bench(p.iters);
            } else {
                self.perform();
            }
        }

        fn perform(self: Self) void {
            const input = day.fio.getInput(
                self.year,
                self.day,
                day.alc.fba,
                day.alc.fixed_buffer_size,
            ) catch unreachable;
            defer day.alc.fba.free(input);
            const part_one = self.partOne(input);
            const part_two = self.partTwo(input);
            day.cmd.printDay(T, self.year, self.day, part_one, part_two);
        }

        fn bench(self: Self, iters: usize) void {
            day.cmd.print(
                "Advent of Code {d:0>4} Day {d:0>2} - Timings over {d} iterations\n",
                .{ self.year, self.day, iters },
            );
            const input = day.fio.getInput(
                self.year,
                self.day,
                day.alc.fba,
                day.alc.fixed_buffer_size,
            ) catch unreachable;
            defer day.alc.fba.free(input);

            day.cmd.print("    Part One:\n", .{});
            timePart(T, iters, self.partOne, input);

            day.cmd.print("    Part Two:\n", .{});
            timePart(T, iters, self.partTwo, input);
        }

        fn test_(self: Self) void {
            const part_one = self.partOne(self.sampleOne);
            const part_two = self.partTwo(self.sampleTwo);
            day.cmd.printDay(T, self.year, self.day, part_one, part_two);
        }
    };
}

inline fn timePart(comptime T: anytype, iters: usize, part: fn ([]const u8) T, input: []const u8) void {
    var min: u64 = day.std.math.maxInt(u64);
    var max: u64 = 0;
    var avg: u64 = 0;
    var out: T = undefined;
    for (0..iters) |i| {
        const then = day.ins.now() catch unreachable;
        out = part(input);
        const now = day.ins.now() catch unreachable;
        const since = now.since(then);
        if (since < min) min = since;
        if (since > max) max = since;
        avg += since;
        day.cmd.print(
            "    avg:{d:0>5} min:{d:0>5} max:{d:0>5} | {} of {} out:{}\r",
            .{ avg / (i + 1), min, max, i, iters, out },
        );
    }
    day.cmd.print(
        "    avg:{d:0>5} min:{d:0>5} max:{d:0>5} | {} of {} out:{}\n",
        .{ avg / iters, min, max, iters, iters, out },
    );
}
