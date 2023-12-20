const std = @import("std");
const alloc = @import("alloc.zig");
const proc = @import("process.zig");
const main = @import("main.zig");

pub fn parseArgs() !?std.ArrayList(proc.Proc) {
    const args = std.process.argsAlloc(alloc.gpa) catch |err| {
        std.log.err("Args Processing Error: {!}", .{err});
        return null;
    };
    defer std.process.argsFree(alloc.gpa, args);

    if (args.len < 2) {
        printHelp();
        return null;
    }

    var procs = std.ArrayList(proc.Proc).init(alloc.gpa);

    for (args[1..]) |arg| {
        if (arg.len > 3) {
            print("{s}\n", .{arg});

            if (std.mem.eql(u8, "-p", arg[0..2])) {
                // perform
                var tokens = std.mem.tokenizeAny(u8, arg, "-p,");
                year_block: while (tokens.next()) |token| {
                    const year = std.fmt.parseInt(u16, token.ptr[0..token.len], 10) catch continue :year_block;
                    try procs.append(.{ .year = year });
                }
            }
            if (std.mem.eql(u8, "-d", arg[0..2])) {
                // benchmark
                var tokens = std.mem.tokenizeAny(u8, arg, "-d,");
                const year = if (tokens.next()) |token| try std.fmt.parseInt(u16, token.ptr[0..token.len], 10) else 0;
                day_block: while (tokens.next()) |token| {
                    const day = std.fmt.parseInt(u8, token.ptr[0..token.len], 10) catch continue :day_block;
                    try procs.append(.{ .year = year, .day = day });
                }
            }
            if (std.mem.eql(u8, "-b", arg[0..2])) {
                // benchmark
                var tokens = std.mem.tokenizeAny(u8, arg, "-b,");
                const year = if (tokens.next()) |token| try std.fmt.parseInt(u16, token.ptr[0..token.len], 10) else 0;
                const day = if (tokens.next()) |token| try std.fmt.parseInt(u8, token.ptr[0..token.len], 10) else 0;
                const iters = if (tokens.next()) |token| try std.fmt.parseInt(usize, token.ptr[0..token.len], 10) else 0;
                try procs.append(.{ .year = year, .day = day, .iters = iters });
            }

            if (std.mem.eql(u8, "-t", arg[0..2])) {
                // benchmark
                var tokens = std.mem.tokenizeAny(u8, arg, "-t,");
                const year = if (tokens.next()) |token| try std.fmt.parseInt(u16, token.ptr[0..token.len], 10) else 0;
                day_block: while (tokens.next()) |token| {
                    const day = std.fmt.parseInt(u8, token.ptr[0..token.len], 10) catch continue :day_block;
                    try procs.append(.{ .year = year, .day = day, ._test = true });
                }
            }
        }

        if (std.mem.eql(u8, "-v", arg[0..2]) or std.mem.eql(u8, "--V", arg[0..3])) {
            print("adventofcode {s}\n", .{main.version});
            procs.deinit();
            return null;
        }

        if (std.mem.eql(u8, "-h", arg[0..2]) or std.mem.eql(u8, "--H", arg[0..3])) {
            printHelp();
            procs.deinit();
            return null;
        }
    }
    return procs;
}

pub fn printHelp() void {
    buffout.print("{s}", .{help_string}) catch unreachable;
    buffw.flush() catch unreachable;
}

const stdout_file = std.io.getStdOut().writer();
var buffw = std.io.bufferedWriter(stdout_file);
const buffout = buffw.writer();

pub fn print(comptime words: []const u8, meaning: anytype) void {
    buffout.print(words, meaning) catch unreachable;
    buffw.flush() catch unreachable;
}

pub inline fn printDay(comptime T: anytype, year: u16, day: u8, part_one: T, part_two: T) void {
    print(
        "Advent of Code {d:0.4} Day {d:0>2}\n\tPart One: {any}\n\tPart Two: {any}\n",
        .{ year, day, part_one, part_two },
    );
}

pub fn getFilename(year: u16, day: u8, allocator: std.mem.Allocator) ![]const u8 {
    return try std.fmt.allocPrint(allocator, "./data/{}/{d:0>2}_input.txt", .{ year, day });
}

const help_string =
    \\
    \\
    \\          (===)\\ \
    \\         (=====)\\ \
    \\        /// /   \\\ \
    \\       /// /     \\\ \
    \\      (===========)\\ \
    \\     (=============)\\ \
    \\    /// /           \\\ \
    \\   /// /             \\\ \
    \\  /// /               \\\ \dvent of Code
    \\                          - written in Zig
    \\
    \\
    \\  Usage: adventofcode(.exe) [?YEAR] [OPTIONS...]
    \\
    \\    -v
    \\    --Version
    \\          Prints the program version and quits
    \\
    \\    -h
    \\    --Help
    \\          Prints this page and quits
    \\
    \\    -p[YEAR,..]
    \\          Performs the parts for the provided year(s)
    \\
    \\    -d[YEAR,DAY,...]
    \\          Performs the provided day(s) for the provided year
    \\    
    \\    -b[YEAR,DAY,ITERATIONS]
    \\          Benchmarks the provided day, for the provided year, 
    \\          over the provided iterations
    \\  
    \\    -t[YEAR,DAY]
    \\          Tests the provided day, using the sample data
    \\
;
