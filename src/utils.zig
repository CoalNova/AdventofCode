const std = @import("std");
const utils = @import("utils.zig");
const version = "0.1.0";

// writer parts
const stdout_file = std.io.getStdOut().writer();
pub var writer = std.io.bufferedWriter(stdout_file);
pub const out = writer.writer();

// allocator
var general_purpose_allocator = std.heap.GeneralPurposeAllocator(.{}){};
/// General Purpose Allocator
pub const gpa = general_purpose_allocator.allocator();
const fixed_buffer_size = 1 << 20;
var fixed_buffer: [fixed_buffer_size]u8 = undefined;
var fixed_buffer_allocator = std.heap.FixedBufferAllocator.init(&fixed_buffer);
/// Fixed Buffer Allocator, 1MB in size on stack
pub const fba = fixed_buffer_allocator.allocator();

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
    return file.readToEndAlloc(allocator, fixed_buffer_size);
}

pub const Proc = struct { year: u16, day: u8 = 0, bench: bool = false, iterations: usize = 0 };
pub fn processArgs() ?std.ArrayList(Proc) {
    const args = std.process.argsAlloc(gpa) catch |err| {
        std.log.err("Args Processing Error: {!}", .{err});
        return null;
    };
    defer std.process.argsFree(gpa, args);

    if (args.len < 2)
        return null;

    var procs = std.ArrayList(Proc).init(gpa);

    //abuse the error system
    first_block: {
        const first_arg = std.fmt.parseInt(u16, args[1], 10) catch break :first_block;
        procs.append(Proc{ .year = first_arg }) catch |err| {
            std.log.err("Error when appending first argument: {!} ", .{err});
            return null;
        };
    }

    arg_block: for (args[1..]) |arg| {
        if (std.mem.eql(u8, arg[0..2], "--")) {
            switch (arg[2]) {
                'h', 'H' => return null,
                'v', 'V' => {
                    out.print("Version: {s}\n", .{version}) catch unreachable;
                    writer.flush() catch unreachable;
                    procs.resize(0) catch unreachable;
                    return procs;
                },
                'y' => {
                    var splits = std.mem.splitScalar(u8, arg[3..], ',');
                    while (splits.next()) |split| {
                        const year = std.fmt.parseInt(u16, split, 10) catch continue :arg_block;
                        procs.append(Proc{ .year = year }) catch |err| {
                            std.log.err("Error when appending first argument: {!} ", .{err});
                            return null;
                        };
                    }
                },
                'b' => {
                    var splits = std.mem.splitScalar(u8, arg[3..], ',');
                    const year = std.fmt.parseInt(
                        u16,
                        if (splits.next()) |s| s else continue :arg_block,
                        10,
                    ) catch continue :arg_block;
                    const iter = std.fmt.parseInt(
                        usize,
                        if (splits.next()) |s| s else continue :arg_block,
                        10,
                    ) catch continue :arg_block;
                    procs.append(Proc{ .year = year, .bench = true, .iterations = iter }) catch |err| {
                        std.log.err("Error when appending first argument: {!} ", .{err});
                        return null;
                    };
                },
                'd' => {
                    var splits = std.mem.splitScalar(u8, arg[3..], ',');
                    const year = std.fmt.parseInt(
                        u16,
                        if (splits.next()) |s| s else continue :arg_block,
                        10,
                    ) catch continue :arg_block;
                    const day = std.fmt.parseInt(
                        u8,
                        if (splits.next()) |s| s else continue :arg_block,
                        10,
                    ) catch continue :arg_block;
                    procs.append(Proc{ .year = year, .day = day }) catch |err| {
                        std.log.err("Error when appending first argument: {!} ", .{err});
                        return null;
                    };
                },
                't' => {
                    var splits = std.mem.splitScalar(u8, arg[3..], ',');
                    const year = std.fmt.parseInt(
                        u16,
                        if (splits.next()) |s| s else continue :arg_block,
                        10,
                    ) catch continue :arg_block;
                    const day = std.fmt.parseInt(
                        u8,
                        if (splits.next()) |s| s else continue :arg_block,
                        10,
                    ) catch continue :arg_block;
                    const iter = std.fmt.parseInt(
                        usize,
                        if (splits.next()) |s| s else continue :arg_block,
                        10,
                    ) catch continue :arg_block;
                    procs.append(
                        Proc{ .year = year, .day = day, .bench = true, .iterations = iter },
                    ) catch |err| {
                        std.log.err("Error when appending first argument: {!} ", .{err});
                        return null;
                    };
                },
                else => {},
            }
        }
    }

    return procs;
}

pub fn printHelp() !void {
    try utils.out.print(
        \\Advent of Code - Written in Zig
        \\ USEAGE: aoc [?YEAR] [OPTIONS] 
        \\
        \\    YEAR:    
        \\      Numeric year for AoC prompts (does not accept BC) 
        \\
        \\    OPTIONS:            
        \\    --y[YEAR,YEAR...]
        \\        Prints AoC result for each year supplied
        \\      
        \\    --b[YEAR,ITERATIONS]
        \\        Prints timings of operations, over supplied iterations
        \\
        \\    --d[YEAR,DAY]
        \\        Prints result of operations for 
        \\
        \\    --t[YEAR,DAY,ITERATIONS]
        \\        Prints operation timings for specified day
        \\
        \\    --Help
        \\    --h
        \\        Prints this page and exits
        \\
        \\    --Version
        \\    --v
        \\        Prints version and exits
        \\
        \\
    , .{});
    try utils.writer.flush();
}

/// The Day template, for handling days of varying return types
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
            const input = utils.loadFile(utils.fba, self._year, self._day) catch return;
            defer utils.fba.free(input);
            const res_1 = self._part1(input);
            const res_2 = self._part2(input);
            utils.out.print(
                "Advent of Code {d:0>4}, Day {d:0>2}\n\tPart One: {}\n\tPart Two: {}\n",
                .{ self._year, self._day, res_1, res_2 },
            ) catch unreachable;
        }
        pub fn benchMark(self: *Self, iterations: usize) void {
            const input = utils.loadFile(utils.fba, self._year, self._day) catch return;
            defer utils.fba.free(input);
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
                \\    Part One - avg: {d:0>5} ns min: {d:0>5} ns max: {d:0>5} ns
                \\    Part Two - avg: {d:0>5} ns min: {d:0>5} ns max: {d:0>5} ns
                \\
            ,
                .{ self._year, self._day, iterations, avg_1, min_1, max_1, avg_2, min_2, max_2 },
            ) catch unreachable;
        }
        pub fn proc(self: *Self, _p: utils.Proc) void {
            switch (_p.bench) {
                true => self.benchMark(_p.iterations),
                false => self.perform(),
            }
            utils.writer.flush() catch unreachable;
        }
    };
}
