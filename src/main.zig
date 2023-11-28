const utils = @import("utils.zig");
const years = @import("years.zig");

pub fn main() !void {
    if (utils.processArgs()) |procs| {
        for (procs.items) |proc| {
            years.procYears(proc);
        }
    } else {
        try utils.printHelp();
    }
}
