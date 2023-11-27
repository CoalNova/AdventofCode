const std = @import("std");
const utils = @import("utils.zig");

// writer parts
const stdout_file = std.io.getStdOut().writer();
pub var writer = std.io.bufferedWriter(stdout_file);
pub const out = writer.writer();

// allocator
var general_purpose_allocator = std.heap.GeneralPurposeAllocator(.{}){};
pub const gpa = general_purpose_allocator.allocator();
var fixed_buffer: [1 << 20]u8 = undefined;
var fixed_buffer_allocator = std.heap.FixedBufferAllocator.init(&fixed_buffer);
pub const fba = fixed_buffer_allocator.allocator();

pub fn Day(
    comptime T: anytype,
    comptime part_one: fn ([]const u8) T,
    comptime part_two: fn ([]const u8) T,
    comptime year: u16,
    comptime day: u8,
) type {
    return struct {
        const Self = @This();
        comptime _part1: fn ([]const u8) T = part_one,
        comptime _part2: fn ([]const u8) T = part_two,
        comptime _year: u16 = year,
        comptime _day: u8 = day,
        pub fn perform(self: *Self) void {
            const input = loadFile(fba, self._year, self._day) catch unreachable;
            defer fba.free(input);
            const res_1 = self._part1(input);
            const res_2 = self._part2(input);
            utils.out.print(
                "Advent of Code {d:0>4}, Day {d:0>2}\n\tPart One: {}\n\tPart Two: {}\n",
                .{ self._year, self._day, res_1, res_2 },
            ) catch unreachable;
        }
        pub fn benchMark(self: *Self, iterations: usize) void {
            const input = loadFile(fba, self._year, self._day) catch unreachable;
            defer fba.free(input);
            var min_1: u64 = std.math.maxInt(u64);
            var max_1: u64 = 0;
            var avg_1: u64 = 0;
            var min_2: u64 = std.math.maxInt(u64);
            var max_2: u64 = 0;
            var avg_2: u64 = 0;

            for (iterations) |_| {
                const then_1 = std.time.Instant.now() catch unreachable;
                _ = self._part1(input);
                const now_1 = std.time.Instant.now() catch unreachable;
                const since_1 = now_1.since(then_1);

                const then_2 = std.time.Instant.now() catch unreachable;
                _ = self._part2(input);
                const now_2 = std.time.Instant.now() catch unreachable;
                const since_2 = now_2.since(then_2);

                if (since_1 > max_1) max_1 = since_1;
                if (since_1 < min_1) min_1 = since_1;
                if (since_2 > max_2) max_2 = since_2;
                if (since_2 < min_2) min_2 = since_2;
                avg_1 +|= since_1;
                avg_2 +|= since_2;
            }
            avg_1 /= iterations;
            avg_2 /= iterations;
            utils.out.print(
                \\Advent of Code {d:0>4}, Day {d:0>2} - Timings over {d} iterations
                \\    Part One - avg: {d:0>5} ns min: {d:0>5} ns max: {d:0>5} ns"
                \\    Part Two - avg: {d:0>5} ns min: {d:0>5} ns max: {d:0>5} ns"
                \\
            ,
                .{ self._year, self._day, iterations, avg_1, min_1, max_1, avg_2, min_2, max_2 },
            ) catch unreachable;
        }
    };
}

/// Returns buffer for input file.
/// Example file layouts
/// ./data/2015/01_input.txt
/// ./data/2022/11_sample.txt
pub fn loadFile(
    allocator: std.mem.Allocator,
    year: u16,
    day: u8,
) ![]const u8 {
    const filename = try std.fmt.allocPrint(
        allocator,
        //BC is unsupported
        "./data/{d:0>4}/{d:0>2}_input.txt",
        .{ year, day },
    );
    const file = try std.fs.cwd().openFile(filename, .{});
    allocator.free(filename);
    return file.readToEndAlloc(allocator, 1 << 20);
}
