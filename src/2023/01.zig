const std = @import("std");
const utils = @import("../utils.zig");
const year = 2023;
const day = 1;
const T = i32;
pub var aoc = utils.Day(T, dayOne, dayTwo, year, day){};

fn dayOne(input: []const u8) T {
    //Sum of all
    var sum: i32 = 0;
    //Split inputs by line
    var splits = std.mem.splitScalar(u8, input, '\n');
    while (splits.next()) |line| {
        //if line length is valid to iterate over
        var first: u8 = 0;
        var last: u8 = 0;
        // for each numeric character in line,
        first_block: for (line) |c| {
            if (c >= 48 and c < 58) {
                first = c - 48;
                break :first_block;
            }
        }
        // for each character in line, but backwards
        last_block: for (0..line.len) |i| {
            const c = line[line.len - (i + 1)];
            if (c >= 48 and c < 58) {
                last = c - 48;
                break :last_block;
            }
        }

        // then add them to sum
        sum += first * 10 + last;
    }
    return sum;
}
fn dayTwo(input: []const u8) T {
    //Sum of all
    var sum: i32 = 0;
    //Split inputs by line
    var splits = std.mem.splitScalar(u8, input, '\n');
    while (splits.next()) |line| {
        //if line length is valid to iterate over
        if (line.len > 1) {
            var first: u8 = 0;
            var last: u8 = 0;
            //for every character in the line
            first_block: for (line, 0..) |c, i| {
                if (c >= 48 and c < 58) {
                    first = c - 48;
                    break :first_block;
                } else for (NumName, 0..) |num, j|
                    //but only if enough space is left in the line for that name
                    if (i + num.len <= line.len)
                        //and if it does equal
                        if (std.mem.eql(u8, num, line[i .. i + num.len])) {
                            //then that's our number
                            first = @as(u8, @intCast(j));
                            break :first_block;
                        };
            }
            // for every character in line.. but in reverse
            last_block: for (0..line.len) |l| {
                const i = line.len - (l + 1);
                const c = line[i];
                if (c >= 48 and c < 58) {
                    last = c - 48;
                    break :last_block;
                } else for (NumName, 0..) |num, j|
                    //but only if enough space is left in the line for that name
                    if (i + num.len <= line.len)
                        //and if it does equal
                        if (std.mem.eql(u8, num, line[i .. i + num.len])) {
                            //then that's our number
                            last = @as(u8, @intCast(j));
                            break :last_block;
                        };
            }

            sum += first * 10 + last;
        }
    }
    return sum;
}

const NumName = [_][]const u8{
    "zero",
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
};
