const std = @import("std");
const utils = @import("utils.zig");

pub const Years = struct {};

pub inline fn procYears(proc: utils.Proc) void {
    switch (proc.year) {
        2015 => @import("2015/year.zig").procYear(proc),
        2016 => @import("2016/year.zig").procYear(proc),
        2017 => @import("2017/year.zig").procYear(proc),
        2018 => @import("2018/year.zig").procYear(proc),
        2019 => @import("2019/year.zig").procYear(proc),
        2020 => @import("2020/year.zig").procYear(proc),
        2021 => @import("2021/year.zig").procYear(proc),
        2022 => @import("2022/year.zig").procYear(proc),
        2023 => @import("2023/year.zig").procYear(proc),
        else => {},
    }
}
