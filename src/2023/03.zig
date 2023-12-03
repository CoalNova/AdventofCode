const std = @import("std");
const utils = @import("../utils.zig");
const year = 2023;
const day = 3;
const T = i32;
pub var aoc = utils.Day(T, dayOne, dayTwo, year, day){};

fn dayOne(input: []const u8) T {
    // get line length
    const length = for (input, 0..) |c, i| {
        if (c == '\n') break i + 1;
    } else unreachable;

    var parts_sum: i32 = 0;

    // iterate over all digits
    lookup_block: for (input, 0..) |c, i| {
        // catch based on number
        if (!std.ascii.isDigit(c))
            continue :lookup_block;

        if (i > 0 and std.ascii.isDigit(input[i - 1]))
            continue :lookup_block;

        // get current position
        const x: u16 = @intCast(i % length);
        const y: u16 = @intCast(i / length);
        // get number's digit count
        const num_len = for (input[i..], 0..) |ch, id| {
            if (!std.ascii.isDigit(ch)) break id;
        } else length - x;

        // get number
        const part = std.fmt.parseInt(
            u16,
            input[i .. i + num_len],
            10,
        ) catch unreachable;

        const start_x = if (x > 0) x - 1 else 0;
        const end_x = if (x + num_len + 1 < length) x + num_len else length;

        // first look before and after
        if (isValidChar(input[start_x + y * length])) {
            parts_sum += part;
            continue :lookup_block;
        }
        if (isValidChar(input[end_x + y * length])) {
            parts_sum += part;
            continue :lookup_block;
        }

        // for before and after, above and below do a search for something that isn't a number or '.'
        if (y > 0)
            for (input[start_x + (y - 1) * length .. end_x + (y - 1) * length + 1]) |char|
                if (isValidChar(char)) {
                    parts_sum += part;
                    continue :lookup_block;
                };
        if (y + 1 < input.len / length)
            for (input[start_x + (y + 1) * length .. end_x + (y + 1) * length + 1]) |char|
                if (isValidChar(char)) {
                    parts_sum += part;
                    continue :lookup_block;
                };
    }
    return parts_sum;
}
fn dayTwo(input: []const u8) T {
    // get line length
    const length = for (input, 0..) |c, i| {
        if (c == '\n') break i + 1;
    } else unreachable;

    var ratio_sum: i32 = 0;

    // iterate over all characters
    lookup_block: for (input, 0..) |c, i| {

        // catch based on symbol
        if (c != '*')
            continue :lookup_block;

        // get current position
        const x: u16 = @intCast(i % length);
        const y: u16 = @intCast(i / length);

        const Num = struct { start: usize = 0, end: usize = 0, val: u31 = 0 };

        var num_a = Num{};
        var num_b = Num{};

        // search kernal for numbers
        kernal_block: for (0..3) |iy| {
            for (0..3) |ix| {
                if (ix + x > 0 and ix + x - 1 < length and iy + y > 0 and iy + y - 1 <= input.len / length) {
                    const kx = ix + x - 1;
                    const ky = iy + y - 1;
                    const kc = input[kx + ky * length];
                    //std.debug.print("{c}", .{kc});
                    if (std.ascii.isDigit(kc)) {
                        var num = Num{ .start = kx, .end = kx };
                        while (num.start > 0 and
                            std.ascii.isDigit(input[num.start - 1 + ky * length]))
                            num.start -= 1;
                        while (num.end < length and
                            std.ascii.isDigit(input[num.end + ky * length]))
                            num.end += 1;

                        num.val = std.fmt.parseInt(
                            u31,
                            input[num.start + ky * length .. num.end + ky * length],
                            10,
                        ) catch unreachable;

                        if (num_a.val == 0)
                            num_a = num
                        else if (!(num.start == num_a.start and num.val == num_a.val))
                            num_b = num;
                        if (num_a.val > 0 and num_b.val > 0) break :kernal_block;
                    }
                }
            }
            //std.debug.print("\n", .{});
        }
        if (num_a.val > 0 and num_b.val > 0) {
            //std.debug.print("({}, {}) {}*{}\n", .{ x + 1, y + 1, num_a.val, num_b.val });
            ratio_sum += num_a.val * num_b.val;
        }
    }
    return ratio_sum;
}

inline fn isValidChar(c: u8) bool {
    return (!std.ascii.isDigit(c) and c != '.' and c != '\n');
}
