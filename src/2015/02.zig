const std = @import("std");
const utils = @import("../utils.zig");
const year = 2015;
const day = 2;
const T = i32;
pub var aoc = utils.Day(T, dayOne, dayTwo, year, day){};

fn dayOne(input: []const u8) T {
    var total: i32 = 0;
    var box = std.mem.splitScalar(u8, input, '\n');
    block: while (box.next()) |sides| {
        var side = std.mem.splitScalar(u8, sides, 'x');
        const l = std.fmt.parseInt(u16, side.next().?, 10) catch continue :block;
        const w = std.fmt.parseInt(u16, side.next().?, 10) catch continue :block;
        const h = std.fmt.parseInt(u16, side.next().?, 10) catch continue :block;
        const smol = @min(l * w, l * h, w * h);

        total += smol + 2 * l * w + 2 * w * h + 2 * h * l;
    }
    return total;
}
fn dayTwo(input: []const u8) T {
    var total: i32 = 0;
    var box = std.mem.splitScalar(u8, input, '\n');
    block: while (box.next()) |sides| {
        var side = std.mem.splitScalar(u8, sides, 'x');
        var s = [_]u16{ 0, 0, 0 };
        s[0] = std.fmt.parseInt(u16, side.next().?, 10) catch continue :block;
        s[1] = std.fmt.parseInt(u16, side.next().?, 10) catch continue :block;
        s[2] = std.fmt.parseInt(u16, side.next().?, 10) catch continue :block;
        const bow = s[0] * s[1] * s[2];
        if (s[0] > s[1] and s[0] > s[2]) {
            s[0] = 0;
        } else if (s[1] > s[2]) {
            s[1] = 0;
        } else s[2] = 0;

        total += bow + s[0] * 2 + s[1] * 2 + s[2] * 2;
    }
    return total;
}
