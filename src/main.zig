const utils = @import("utils.zig");
const aoc15 = @import("2015/year.zig");

pub fn main() !void {
    aoc15.performYear();
    try utils.out.print("\n", .{});
    aoc15.benchYear(3000);

    try utils.writer.flush(); // don't forget to wash your hands!
}
