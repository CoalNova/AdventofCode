pub var day01 = @import("01.zig").aoc;
pub var day02 = @import("02.zig").aoc;
pub var day03 = @import("03.zig").aoc;

pub fn performYear() void {
    day01.perform();
    day02.perform();
    day03.perform();
}

pub fn benchYear(iterations: usize) void {
    day01.benchMark(iterations);
    day02.benchMark(iterations);
    day03.benchMark(iterations);
}
