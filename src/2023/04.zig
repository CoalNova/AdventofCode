const std = @import("std");
const utils = @import("../utils.zig");
const year = 2023;
const day = 4;
const T = i32;
pub var aoc = utils.Day(T, dayOne, dayTwo, year, day){};

fn dayOne(input: []const u8) T {
    var lines = std.mem.splitScalar(u8, input, '\n');
    while (lines.next()) |line| {
        //matches
        for (line) |c| {
            _ = c;
        }
    }
    return 0;
}

//Tweedilly Pomf
fn dayTwo(input: []const u8) T {
    _ = input;
    return 0;
}
