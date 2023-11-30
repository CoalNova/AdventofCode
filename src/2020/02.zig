const std = @import("std");
const utils = @import("../utils.zig");
const year = 2020;
const day = 2;
const T = i32;
pub var aoc = utils.Day(T, dayOne, dayTwo, year, day){};

fn dayOne(input: []const u8) T {
    var sum: i32 = 0;
    var splits = std.mem.splitScalar(u8, input, '\n');
    var buff: [32]u8 = undefined;
    block: while (splits.next()) |split| {
        for (split, 0..) |c, i| buff[i] = c;
        buff[split.len] = 0;
        var nizer = std.zig.Tokenizer.init(buff[0..split.len :0]);
        var token = nizer.next();
        if (token.tag != .number_literal) continue :block;
        const l_bounds = std.fmt.parseInt(
            i32,
            split[token.loc.start..token.loc.end],
            10,
        ) catch continue :block;
        token = nizer.next();
        token = nizer.next();
        const u_bounds = std.fmt.parseInt(
            i32,
            split[token.loc.start..token.loc.end],
            10,
        ) catch continue :block;
        token = nizer.next();
        const char = split[token.loc.start];
        token = nizer.next();
        token = nizer.next();
        var quant: u8 = 0;
        for (split[token.loc.start..token.loc.end]) |c| {
            if (c == char)
                quant += 1;
        }
        if (quant >= l_bounds and quant <= u_bounds)
            sum += 1;
    }

    return sum;
}
fn dayTwo(input: []const u8) T {
    var sum: i32 = 0;
    var splits = std.mem.splitScalar(u8, input, '\n');
    var buff: [32]u8 = undefined;
    block: while (splits.next()) |split| {
        for (split, 0..) |c, i| buff[i] = c;
        buff[split.len] = 0;
        var nizer = std.zig.Tokenizer.init(buff[0..split.len :0]);
        var token = nizer.next();
        if (token.tag != .number_literal) continue :block;
        const l_bounds = std.fmt.parseInt(
            i32,
            split[token.loc.start..token.loc.end],
            10,
        ) catch continue :block;
        token = nizer.next();
        token = nizer.next();
        const u_bounds = std.fmt.parseInt(
            i32,
            split[token.loc.start..token.loc.end],
            10,
        ) catch continue :block;
        token = nizer.next();
        const char = split[token.loc.start];
        token = nizer.next();
        token = nizer.next();
        const char_a = split[token.loc.start + @as(usize, @intCast(l_bounds)) - 1];
        const char_b = split[token.loc.start + @as(usize, @intCast(u_bounds)) - 1];
        if ((char_a == char or char_b == char) and char_a != char_b)
            sum += 1;
    }

    return sum;
}
