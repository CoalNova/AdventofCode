const std = @import("std");
const _day = @import("../day.zig");

const year = 2023;
const day = 6;
const T = i32;

const sampleOne =
    \\
;

fn partOne(input: []const u8) T {
    var tokens = std.zig.Tokenizer.init(input[0 .. input.len - 1 :0]);
    while (tokens.next().tag != .colon) {}
    var splits = tokens;
    while (splits.next().tag != .colon) {}
    var bests: i32 = 1;
    run_block: while (true) {
        const token = tokens.next();
        const split = splits.next();
        if (split.tag == .eof)
            break :run_block;
        const time =
            std.fmt.parseInt(u16, input[token.loc.start..token.loc.end], 10) catch unreachable;
        const best =
            std.fmt.parseInt(u16, input[split.loc.start..split.loc.end], 10) catch unreachable;

        const win_start: u64 = @intFromFloat(@ceil(
            @as(f64, @floatFromInt(time)) / @as(f64, 2.0) - @sqrt(
                @as(f64, @floatFromInt(time * time)) / @as(f64, 4.0) -
                    @as(f64, @floatFromInt(best)),
            ),
        ));
        const wins = time - win_start * 2 + 1;

        bests *= @as(i32, @intCast(wins));
    }
    return bests;
}

const sampleTwo =
    \\ 
;

fn partTwo(input: []const u8) T {
    const split = std.mem.indexOf(u8, input, "\n").?;
    var time: usize = 0;
    for (input[5..split]) |c| {
        if (c >= '0' and c <= '9')
            time = time * 10 + (c - '0');
    }
    var best: usize = 0;
    for (input[split + 9 ..]) |c| {
        if (c >= '0' and c <= '9') {
            best = best * 10 + (c - '0');
        }
    }
    const win_start: u64 = @intFromFloat(@ceil(
        @as(f64, @floatFromInt(time)) / @as(f64, 2.0) - @sqrt(
            @as(f64, @floatFromInt(time * time)) / @as(f64, 4.0) -
                @as(f64, @floatFromInt(best)),
        ),
    ));
    return @as(i32, @intCast(time - win_start * 2 + 1));
}

pub const Day = _day.Day(T, partOne, partTwo, year, day, sampleOne, sampleTwo){};
