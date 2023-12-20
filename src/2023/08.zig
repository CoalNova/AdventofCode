const std = @import("std");
const alc = @import("../alloc.zig");
const _day = @import("../day.zig");

const year = 2023;
const day = 8;
const T = i32;

const sampleOne =
    \\
;

fn partOne(input: []const u8) T {
    const get = getOps(input, alc.gpa);
    const instruction = get.i;
    var ops = get.o;
    defer ops.deinit();

    var op = ops.get("AAA").?;
    // if overflow occurs, we went too far
    var index: u31 = 0;
    seek_block: while (true) : (index += 1) {
        const dir = instruction.?[index % instruction.?.len];
        switch (dir) {
            'L' => op = ops.get(op.left.?).?,
            'R' => op = ops.get(op.right.?).?,
            else => unreachable,
        }
        if (std.mem.eql(u8, op.label.?, "ZZZ"))
            break :seek_block;
    }

    return index + 1;
}

const sampleTwo =
    \\ 
;

fn partTwo(input: []const u8) T {
    const get = getOps(input, alc.gpa);
    const instruction = get.i;
    const cons = get.n;
    var ops = get.o;
    defer ops.deinit();

    var con_ops = alc.gpa.alloc(OP, cons) catch unreachable;
    var operator = ops.iterator();
    var tempdex: u8 = 0;

    std.debug.print("{}\n", .{cons});
    while (operator.next()) |o| {
        if (o.value_ptr.label.?[2] == 'A') {
            con_ops[tempdex] = o.value_ptr.*;
            std.debug.print("{s} ", .{o.value_ptr.*.label.?});
            std.debug.print("{s} ", .{con_ops[tempdex].label.?});
            tempdex += 1;
        }
    }
    std.debug.print("\n", .{});

    // if overflow occurs, we went too far
    var index: u64 = 0;
    var bitfield: usize = 0;
    var times = [_]u64{0} ** 16;
    seek_block: while (true) : (index += 1) {
        const dir = instruction.?[index % instruction.?.len];
        // until I can simd correctly
        for (0..cons) |c| {
            switch (dir) {
                'L' => con_ops[c] = ops.get(con_ops[c].left.?).?,
                'R' => con_ops[c] = ops.get(con_ops[c].right.?).?,
                else => unreachable,
            }
            //std.debug.print("{s} - ", .{con_ops[c].label.?});
            if (con_ops[c].label.?[2] == 'Z') {
                std.debug.print("{} is {}\n", .{ c, index });
                times[c] = @intCast(index);
                bitfield += @as(u31, 1) << @intCast(c);
            }
        }
        //std.debug.print("\n", .{});
        const muh = ((@as(u31, 1) << @intCast(tempdex)) - 1);

        if (bitfield & muh == muh)
            break :seek_block;
    }
    var duple: [16]u64 = undefined;
    @memcpy(&duple, &times);

    while (true) {
        const matches = for (1..tempdex) |t| {
            if (duple[0] != duple[t]) break false;
        } else true;
        if (matches) return @as(u31, @intCast(duple[0]));
        const max = @max(
            duple[0],
            duple[1],
            duple[2],
            duple[3],
            duple[4],
            duple[5],
        );
        for (0..tempdex) |t| {
            while (duple[t] < max)
                duple[t] += times[t];
        }
        std.debug.print("{any}", .{duple[0..tempdex]});
        std.debug.print("\n", .{});
        return @as(i32, @intCast(index + 1));
    }
}

const OP = struct {
    label: ?[]const u8 = null,
    left: ?[]const u8 = null,
    right: ?[]const u8 = null,
};

fn getOps(input: []const u8, allocator: std.mem.Allocator) struct {
    i: ?[]const u8,
    n: u16,
    o: std.hash_map.StringHashMap(OP),
} {
    var tokens = std.mem.tokenizeAny(u8, input, "(,)=\n ");
    var instruction: ?[]const u8 = null;
    var ops = std.hash_map.StringHashMap(OP).init(allocator);
    var num_a_s: u16 = 0;

    var op: OP = .{};
    building_block: while (tokens.next()) |token| {
        if (instruction == null) {
            instruction = token.ptr[0..token.len];
            continue :building_block;
        }
        if (op.label == null) {
            op.label = token.ptr[0..token.len];
            if (token.ptr[2] == 'A')
                num_a_s += 1;
            continue :building_block;
        }
        if (op.left == null) {
            op.left = token.ptr[0..token.len];
            continue :building_block;
        }
        if (op.right == null) {
            op.right = token.ptr[0..token.len];
            ops.put(op.label.?, op) catch unreachable;
            op = .{};
            continue :building_block;
        }
    }
    return .{ .i = instruction, .n = num_a_s, .o = ops };
}

pub const Day = _day.Day(T, partOne, partTwo, year, day, sampleOne, sampleTwo){};
