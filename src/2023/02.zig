const std = @import("std");
const utils = @import("../utils.zig");
const year = 2023;
const day = 2;
const T = i32;
pub var aoc = utils.Day(T, dayOne, dayTwo, year, day){};

fn dayOne(input: []const u8) T {
    var games: i32 = 0;
    var lines = std.mem.splitScalar(u8, input, '\n');
    // for each line in inputs
    while (lines.next()) |line| {
        // split lines
        var blobs = std.mem.splitScalar(u8, line, ' ');
        var game: u16 = 0;
        var count: u16 = 0;
        // check for game
        // probably don't need this, but it's explicitly added for a reason?
        game_block: while (blobs.next()) |blob| {
            if (blob.len > 0)
                if (blob[blob.len - 1] == ':') {
                    game = std.fmt.parseInt(u16, blob[0 .. blob.len - 1], 10) catch unreachable;
                    break :game_block;
                };
        }
        // check for values
        score_block: {
            // for each blob
            while (blobs.next()) |blob| {
                // if it's a number, then it's a count
                if (std.ascii.isDigit(blob[0]))
                    count = std.fmt.parseInt(u16, blob, 10) catch unreachable
                else for (MaxColors) |color|
                    if (blob.len >= color.name.len)
                        // the blob may contain a trailing comma, ignore it
                        if (std.mem.eql(u8, color.name, blob[0..color.name.len]))
                            if (count > color.val) break :score_block;
            }
            games += game;
        }
    }
    return games;
}
fn dayTwo(input: []const u8) T {
    var max_mins: i32 = 0;
    var lines = std.mem.splitScalar(u8, input, '\n');
    // for each line in inputs
    while (lines.next()) |line| {
        // split lines
        var blobs = std.mem.splitScalar(u8, line, ' ');
        var max_rgbs = [_]u16{ 0, 0, 0 };
        var count: u16 = 0;
        // check for game
        // probably don't need this, but it's explicitly added for a reason?
        game_block: while (blobs.next()) |blob|
            if (blob.len > 0)
                if (blob[blob.len - 1] == ':')
                    break :game_block;

        // check for values for each blob
        while (blobs.next()) |blob| {
            if (std.ascii.isDigit(blob[0]))
                count = std.fmt.parseInt(u16, blob, 10) catch unreachable
            else for (MaxColors, 0..) |color, i|
                if (blob.len >= color.name.len)
                    if (std.mem.eql(u8, color.name, blob[0..color.name.len]))
                        if (count > max_rgbs[i]) {
                            max_rgbs[i] = count;
                        };
        }
        max_mins += max_rgbs[0] * max_rgbs[1] * max_rgbs[2];
    }

    return max_mins;
}

// 12 red cubes, 13 green cubes, and 14 blue cubes
const MaxColors = [_]struct { name: []const u8, val: u16 }{
    .{ .name = "red", .val = 12 },
    .{ .name = "green", .val = 13 },
    .{ .name = "blue", .val = 14 },
};
