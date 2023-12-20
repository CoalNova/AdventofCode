const std = @import("std");
const alc = @import("alloc.zig");

pub fn getInput(year: u16, day: u8, allocator: std.mem.Allocator, max_size: usize) ![]const u8 {
    var filename_buf: [128]u8 = undefined;
    const filename = try std.fmt.bufPrint(&filename_buf, "./data/{d:0>4}/{d:0>2}_input.txt", .{ year, day });
    const file = std.fs.cwd().openFile(filename, .{}) catch |err|
        {
        std.debug.print("{s} {!}\n", .{ filename, err });
        return err;
    };
    defer file.close();
    return file.readToEndAlloc(allocator, max_size);
}
