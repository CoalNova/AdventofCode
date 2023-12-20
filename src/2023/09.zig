const std = @import("std");
const alc = @import("../alloc.zig");
const _day = @import("../day.zig");

const year = 2023;
const day = 9;
const T = i32;

const sampleOne =
    \\0 3 6 9 12 15
    \\1 3 6 10 15 21
    \\10 13 16 21 30 45
    \\
;

fn partOne(input: []const u8) T {
    // A solution where an array list is filled with array lists?
    // There's got to be an answer.
    var total: i32 = 0;
    var tokens = std.mem.tokenizeAny(u8, input, "\n");
    while (tokens.next()) |token| {
        var origination = std.ArrayList(i32).init(alc.gpa);
        var vals = std.mem.tokenizeAny(u8, token, " ");
        while (vals.next()) |val| {
            origination.append(std.fmt.parseInt(i32, val, 10) catch unreachable) catch unreachable;
        }
        var variances = std.ArrayList(std.ArrayList(i32)).init(alc.gpa);
        defer {
            for (variances.items) |*variant|
                variant.deinit();
            variances.deinit();
        }
        variances.append(origination) catch unreachable;
        var delta: i64 = 1;
        while (delta != 0) {
            delta = 0;
            var local = std.ArrayList(i32).init(alc.gpa);
            const working = variances.items[variances.items.len - 1];
            for (working.items[1..], 0..) |work, i| {
                const diff = work - working.items[i];
                delta += @abs(diff);
                local.append(work - working.items[i]) catch unreachable;
            }
            variances.append(local) catch unreachable;
        }

        var sum: i32 = 0;
        for (variances.items) |variant| {
            const v = variant.items[variant.items.len - 1];
            sum += v;
        }
        total += sum;
    }
    return total;
}

const sampleTwo =
    \\0 3 6 9 12 15
    \\1 3 6 10 15 21
    \\10 13 16 21 30 45
    \\
;

fn partTwo(input: []const u8) T {
    // A solution where an array list is filled with array lists?
    // There's got to be an answer.
    var total: i32 = 0;
    var tokens = std.mem.tokenizeAny(u8, input, "\n");
    while (tokens.next()) |token| {
        var origination = std.ArrayList(i32).init(alc.gpa);
        var vals = std.mem.tokenizeAny(u8, token, " ");
        while (vals.next()) |val| {
            origination.append(std.fmt.parseInt(i32, val, 10) catch unreachable) catch unreachable;
        }
        var variances = std.ArrayList(std.ArrayList(i32)).init(alc.gpa);
        defer {
            for (variances.items) |*variant|
                variant.deinit();
            variances.deinit();
        }
        variances.append(origination) catch unreachable;
        var delta: i64 = 1;
        while (delta != 0) {
            delta = 0;
            var local = std.ArrayList(i32).init(alc.gpa);
            const working = variances.items[variances.items.len - 1];
            for (working.items[1..], 0..) |work, i| {
                const diff = work - working.items[i];
                delta += @abs(diff);
                local.append(work - working.items[i]) catch unreachable;
            }
            variances.append(local) catch unreachable;
        }

        var sum: i32 = 0;
        for (0..variances.items.len) |v_i| {
            const v = variances.items[variances.items.len - (v_i + 1)].items[0];
            sum = v - sum;
        }
        total += sum;
    }
    return total;
}

pub const Day = _day.Day(T, partOne, partTwo, year, day, sampleOne, sampleTwo){};
