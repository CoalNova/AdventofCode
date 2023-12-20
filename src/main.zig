const std = @import("std");
const prc = @import("process.zig");
const cmd = @import("command.zig");
const lst = @import("list.zig");

pub const version = "0.0.1";

pub fn main() !void {
    if (try cmd.parseArgs()) |procs| {
        for (procs.items) |proc| {
            cmd.print("day:{} year:{} bench:{} sample:{}\n", proc);
            if (proc.day == 0) {
                var p = proc;
                for (0..25) |d| {
                    p.day = @intCast(d + 1);
                    lst.proc(p);
                }
            } else lst.proc(proc);
        }
    }
}
