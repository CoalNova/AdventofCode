const utils = @import("../utils.zig");

pub inline fn procYear(proc: utils.Proc) void {
    if (proc.day > 25)
        return;
    if (proc.day == 0) {
        for (1..26) |d| {
            const p = utils.Proc{ .year = proc.year, .day = @intCast(d), .bench = proc.bench, .iterations = proc.iterations };
            procDay(p);
        }
    } else procDay(proc);
}

fn procDay(proc: utils.Proc) void {
    switch (proc.day) {
        1 => @import("01.zig").aoc.proc(proc),
        2 => @import("02.zig").aoc.proc(proc),
        3 => @import("03.zig").aoc.proc(proc),
        4 => @import("04.zig").aoc.proc(proc),
        5 => @import("05.zig").aoc.proc(proc),
        6 => @import("06.zig").aoc.proc(proc),
        7 => @import("07.zig").aoc.proc(proc),
        8 => @import("08.zig").aoc.proc(proc),
        9 => @import("09.zig").aoc.proc(proc),
        10 => @import("10.zig").aoc.proc(proc),
        11 => @import("11.zig").aoc.proc(proc),
        12 => @import("12.zig").aoc.proc(proc),
        13 => @import("13.zig").aoc.proc(proc),
        14 => @import("14.zig").aoc.proc(proc),
        15 => @import("15.zig").aoc.proc(proc),
        16 => @import("16.zig").aoc.proc(proc),
        17 => @import("17.zig").aoc.proc(proc),
        18 => @import("18.zig").aoc.proc(proc),
        19 => @import("19.zig").aoc.proc(proc),
        20 => @import("20.zig").aoc.proc(proc),
        21 => @import("21.zig").aoc.proc(proc),
        22 => @import("22.zig").aoc.proc(proc),
        23 => @import("23.zig").aoc.proc(proc),
        24 => @import("24.zig").aoc.proc(proc),
        25 => @import("25.zig").aoc.proc(proc),
        else => {},
    }
}
