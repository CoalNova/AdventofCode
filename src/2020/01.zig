const std = @import("std");
const utils = @import("../utils.zig");
const year = 2020;
const day = 1;
const T = i32;
pub var aoc = utils.Day(T, dayOne, dayTwo, year, day){};

fn dayOne(input: []const u8) T {
    var splits = std.mem.splitScalar(u8, input, '\n');
    block: while (splits.next()) |split| {
        const a = std.fmt.parseInt(i32, split, 10) catch continue :block;
        var copies = splits;
        while (copies.next()) |copy| {
            const b = std.fmt.parseInt(i32, copy, 10) catch continue :block;
            if (a + b == 2020)
                return a * b;
        }
    }
    return 0;
}
fn dayTwo(input: []const u8) T {
    var firsts = std.mem.splitScalar(u8, input, '\n');
    var nums = std.ArrayList(i32).init(utils.gpa);
    defer nums.deinit();
    block: while (firsts.next()) |first| {
        const a = std.fmt.parseInt(i32, first, 10) catch continue :block;
        nums.append(a) catch continue :block;
    }
    // Standard iterator copying stopped working (don't know why)
    for (nums.items, 0..) |a, i| {
        for (nums.items[i..], 0..) |b, j| {
            for (nums.items[j..]) |c| {
                if (a + b + c == 2020)
                    return a * b * c;
            }
        }
    }

    return 0;
}
