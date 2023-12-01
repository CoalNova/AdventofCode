const std = @import("std");
const utils = @import("../utils.zig");
const year = 2023;
const day = 1;
const T = i32;
pub var aoc = utils.Day(T, dayOne, dayTwo, year, day){};

fn dayOne(input: []const u8) T {
    // sum of all
    var sum: i32 = 0;
    // split inputs by line
    var splits = std.mem.splitScalar(u8, input, '\n');
    while (splits.next()) |line| {
        var first: u8 = 0;
        var last: u8 = 0;
        // for each element in line
        f_block: for (0..line.len) |i|
            // if character is valid, assign and break
            if (line[i] >= 48 and line[i] < 58) {
                first = line[i] - 48;
                break :f_block;
            };
        // do it again, but in reverse
        l_block: for (0..line.len) |i|
            if (line[line.len - (i + 1)] >= 48 and line[line.len - (i + 1)] < 58) {
                last = line[line.len - (i + 1)] - 48;
                break :l_block;
            };

        // then add them to sum
        sum += first * 10 + last;
    }
    return sum;
}

fn dayTwo(input: []const u8) T {
    // sum of all
    var sum: i32 = 0;
    // split inputs by line
    var splits = std.mem.splitScalar(u8, input, '\n');
    while (splits.next()) |line| {
        var first: u8 = 0;
        var last: u8 = 0;
        // for every character in the line
        f_block: for (0..line.len) |i|
            // if is valid character, assign and break
            if (isNumForMe(line, i)) |n| {
                first = n;
                break :f_block;
            };
        // do it again, but in reverse
        l_block: for (0..line.len) |i|
            if (isNumForMe(line, line.len - (i + 1))) |n| {
                last = n;
                break :l_block;
            };
        // then add to sum
        sum += first * 10 + last;
    }

    return sum;
}

///Checks the position in the supplied buffer, to see if it's a number
///Returns the number as an integral value, or null if invalid
inline fn isNumForMe(buff: []const u8, i: usize) ?u8 {
    var c: ?u8 = null;
    if (buff[i] >= 48 and buff[i] < 58)
        c = buff[i] - 48
    else for (NumName, 0..) |name, num|
        if (i + name.len <= buff.len)
            if (std.mem.eql(u8, name, buff[i .. i + name.len])) {
                return @as(u8, @intCast(num));
            };
    return c;
}

/// A collection of all single digit number names, in order of index
const NumName = [_][]const u8{
    "zero",
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
};
