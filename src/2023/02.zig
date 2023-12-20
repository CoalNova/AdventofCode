const std = @import("std");
const _day = @import("../day.zig");

const year = 2023;
const day = 2;
const T = i32;

const sampleOne =
    \\Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    \\Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    \\Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    \\Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    \\Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    \\
;

fn partOne(input: []const u8) T {
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

const sampleTwo =
    \\Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    \\Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    \\Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    \\Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    \\Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    \\
;

fn partTwo(input: []const u8) T {
    var max_mins: i32 = 0;
    var lines = std.mem.splitScalar(u8, input, '\n');
    // for each line in inputs
    while (lines.next()) |line| {
        // split lines
        var blobs = std.mem.splitScalar(u8, line, ' ');
        // max colors
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
                            //add to max colors
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

pub const Day = _day.Day(T, partOne, partTwo, year, day, sampleOne, sampleTwo){};
