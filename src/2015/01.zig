const utils = @import("../utils.zig");
const year = 2015;
const day = 1;
const T = i32;
pub var aoc = utils.Day(T, dayOne, dayTwo, year, day){};

fn dayOne(input: []const u8) T {
    var height: T = 0;
    for (input) |c|
        height += switch (c) {
            ')' => -1,
            '(' => 1,
            else => 0,
        };
    return height;
}
fn dayTwo(input: []const u8) T {
    var height: i32 = 0;
    for (input, 0..) |c, i| {
        height += switch (c) {
            ')' => -1,
            '(' => 1,
            else => 0,
        };
        if (height < 0) return @as(i32, @intCast(i)) + 1;
    }
    return -1;
}
