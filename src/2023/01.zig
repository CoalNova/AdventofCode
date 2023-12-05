const std = @import("std");
const utils = @import("../utils.zig");
const year = 2023;
const day = 1;
const T = i32;
pub var aoc = utils.Day(T, dayOne, dayTwo, year, day){};

fn dayOne(input: []const u8) T {
    // sum of all
    var sum: i32 = 0;
    var first: u8 = 0;
    var last: u8 = 0;
    // split inputs by line
    block: for (input) |c| {
        if (c >= 48 and c < 58) {
            last = c - 48;
            if (first == 0)
                first = c - 48;
            continue :block;
        }
        if (c == '\n') {
            sum += first * 10 + last;
            first = 0;
            last = 0;
        }
    }
    return sum;
}

fn dayTwo(input: []const u8) T {
    // sum of all
    var sum: i32 = 0;
    var first: u8 = 0;
    var last: u8 = 0;
    var pre: usize = 0;
    // split inputs by line
    for (input, 0..) |c, i| {
        if (c == '\n') {
            f_block: for (0..i - pre) |j| {
                if (isNumForMe(input, pre + j)) |n| {
                    first = n;
                    break :f_block;
                }
            }
            l_block: for (0..i - pre) |j| {
                if (isNumForMe(input, i - j)) |n| {
                    last = n;
                    break :l_block;
                }
            }
            pre = i;
            sum += first * 10 + last;
            first = 0;
            last = 0;
        }
    }
    return sum;
}

///Checks the position in the supplied buffer, to see if it's a number
///Returns the number as an integral value, or null if invalid
inline fn isNumForMe(input: []const u8, i: usize) ?u8 {
    if (input[i] >= 48 and input[i] < 58)
        return input[i] - 48;
    switch (input[i]) {
        'o' => {
            if (std.mem.eql(u8, "one", input[i .. i + 3])) {
                return 1;
            }
        },
        't' => {
            if (std.mem.eql(u8, "two", input[i .. i + 3])) {
                return 2;
            }
            if (std.mem.eql(u8, "three", input[i .. i + 5])) {
                return 3;
            }
        },
        'f' => {
            if (std.mem.eql(u8, "four", input[i .. i + 4])) {
                return 4;
            }
            if (std.mem.eql(u8, "five", input[i .. i + 4])) {
                return 5;
            }
        },
        's' => {
            if (std.mem.eql(u8, "six", input[i .. i + 3])) {
                return 6;
            }
            if (std.mem.eql(u8, "seven", input[i .. i + 5])) {
                return 7;
            }
        },
        'e' => {
            if (std.mem.eql(u8, "eight", input[i .. i + 5])) {
                return 8;
            }
        },
        'n' => {
            if (std.mem.eql(u8, "nine", input[i .. i + 4])) {
                return 9;
            }
        },
        else => {
            return null;
        },
    }
    return null;
}
