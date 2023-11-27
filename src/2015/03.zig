const std = @import("std");
const utils = @import("../utils.zig");
const year = 2015;
const day = 3;
const T = i32;
pub var aoc = utils.Day(T, dayOne, dayTwo, year, day){};

fn dayOne(input: []const u8) T {
    var houses = std.ArrayList(House).init(utils.gpa);
    defer houses.deinit();
    var house: House = .{ .x = 0, .y = 0 };
    houses.append(house) catch unreachable;
    for (input) |c| {
        switch (c) {
            '>' => house.x += 1,
            '<' => house.x -= 1,
            '^' => house.y += 1,
            'v' => house.y -= 1,
            else => {},
        }
        if (!contains(house, houses))
            houses.append(house) catch unreachable;
    }

    return @as(i32, @intCast(houses.items.len));
}
fn dayTwo(input: []const u8) T {
    var houses = std.ArrayList(House).init(utils.gpa);
    defer houses.deinit();
    var house: House = .{ .x = 0, .y = 0 };
    var robohouse: House = .{ .x = 0, .y = 0 };
    houses.append(house) catch unreachable;
    var index: usize = 0;
    while (index < input.len) : (index += 2) {
        switch (input[index]) {
            '>' => house.x += 1,
            '<' => house.x -= 1,
            '^' => house.y += 1,
            'v' => house.y -= 1,
            else => {},
        }
        if (!contains(house, houses))
            houses.append(house) catch unreachable;
        switch (input[index + 1]) {
            '>' => robohouse.x += 1,
            '<' => robohouse.x -= 1,
            '^' => robohouse.y += 1,
            'v' => robohouse.y -= 1,
            else => {},
        }
        if (!contains(robohouse, houses))
            houses.append(robohouse) catch unreachable;
    }

    return @as(i32, @intCast(houses.items.len));
}

const House = struct { x: i32, y: i32 };
inline fn contains(house: House, houses: std.ArrayList(House)) bool {
    var here: bool = false;
    found_block: for (houses.items) |h|
        if (h.x == house.x and h.y == house.y) {
            here = true;
            break :found_block;
        };
    return here;
}
