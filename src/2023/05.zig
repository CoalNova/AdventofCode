const std = @import("std");
const _day = @import("../day.zig");
const alc = @import("../alloc.zig");

const year = 2023;
const day = 5;
const T = i32;

const sampleOne =
    \\
;

fn partOne(input: []const u8) T { // track stage
    var stage: u8 = 0;
    // create null-terminated buffer for posix pipe behaviour
    var buffer = alc.gpa.alloc(u8, input.len + 1) catch unreachable;
    defer alc.gpa.free(buffer);
    // memcopy, but safer
    for (input, 0..) |c, i| buffer[i] = c;
    buffer[buffer.len - 1] = 0;
    // tokenize inputs
    var tokens = std.zig.Tokenizer.init(buffer[0 .. buffer.len - 1 :0]);

    // seed collections
    var seed_buffer = [_]seedT{0} ** 32;
    var seed_length: u8 = 0;

    // process collection
    var procs = [_]std.ArrayList(Proc){std.ArrayList(Proc).init(alc.gpa)} ** (titles.len);
    defer for (&procs) |*p| p.deinit();

    main_block: while (true) {
        const token = tokens.next();
        if (token.tag == .eof)
            break :main_block;
        if (token.tag == .colon)
            stage += 1;

        // stage 1: get seeds
        if (stage == 1 and token.tag == .number_literal) {
            seed_buffer[seed_length] =
                std.fmt.parseInt(
                seedT,
                input[token.loc.start..token.loc.end],
                10,
            ) catch unreachable;
            seed_length += 1;
            continue :main_block;
        }

        // stage 2+ get processes, with stage ID
        if (stage >= 2 and token.tag == .number_literal) {
            const t_1 = tokens.next();
            const t_2 = tokens.next();
            const dest = std.fmt.parseInt(seedT, input[token.loc.start..token.loc.end], 10) catch unreachable;
            const srce = std.fmt.parseInt(seedT, input[t_1.loc.start..t_1.loc.end], 10) catch unreachable;
            const rnge = std.fmt.parseInt(seedT, input[t_2.loc.start..t_2.loc.end], 10) catch unreachable;
            const proc = Proc{ .start = srce, .end = srce + rnge, .offset = dest - srce, .stage = stage };
            procs[stage].append(proc) catch unreachable;
        }
    }
    var lowest: u31 = std.math.maxInt(u31);
    // apply process to seeds, based on stage count
    for (&seed_buffer) |*seed| {
        stage_block: for (procs) |proc_stage| {
            for (proc_stage.items) |proc| {
                if (seed.* >= proc.start and seed.* <= proc.end) {
                    seed.* += proc.offset;
                    continue :stage_block;
                }
            }
        }
        if (seed.* < lowest) lowest = @intCast(seed.*);
    }

    return lowest;
}

const sampleTwo =
    \\ 
;

fn partTwo(input: []const u8) T { // track stage
    var stage: u8 = 0;
    // create null-terminated buffer for posix pipe behaviour
    var buffer = alc.gpa.alloc(u8, input.len + 1) catch unreachable;
    defer alc.gpa.free(buffer);
    // memcopy, but safer
    for (input, 0..) |c, i| buffer[i] = c;
    buffer[buffer.len - 1] = 0;
    // tokenize inputs
    var tokens = std.zig.Tokenizer.init(buffer[0 .. buffer.len - 1 :0]);

    // seed collections
    var seed_buffer = [_]seedT{0} ** 32;
    var seed_length: u8 = 0;

    // process collection
    var procs = [_]std.ArrayList(Proc){std.ArrayList(Proc).init(alc.gpa)} ** (titles.len);
    defer for (&procs) |*p| p.deinit();

    main_block: while (true) {
        const token = tokens.next();
        if (token.tag == .eof)
            break :main_block;
        if (token.tag == .colon)
            stage += 1;

        // stage 1: get seeds
        if (stage == 1 and token.tag == .number_literal) {
            seed_buffer[seed_length] =
                std.fmt.parseInt(
                seedT,
                input[token.loc.start..token.loc.end],
                10,
            ) catch unreachable;
            seed_length += 1;
            continue :main_block;
        }

        // stage 2+ get processes, with stage ID
        if (stage >= 2 and token.tag == .number_literal) {
            const t_1 = tokens.next();
            const t_2 = tokens.next();
            const dest = std.fmt.parseInt(seedT, input[token.loc.start..token.loc.end], 10) catch unreachable;
            const srce = std.fmt.parseInt(seedT, input[t_1.loc.start..t_1.loc.end], 10) catch unreachable;
            const rnge = std.fmt.parseInt(seedT, input[t_2.loc.start..t_2.loc.end], 10) catch unreachable;
            const proc = Proc{ .start = srce, .end = srce + rnge, .offset = dest - srce, .stage = stage };
            procs[stage].append(proc) catch unreachable;
        }
    }
    var lowest: i32 = std.math.maxInt(i32);
    // apply process to seeds, based on stage count
    for (0..seed_length / 2) |s_i| {
        const seed_range = @as(usize, @intCast(seed_buffer[s_i * 2 + 1]));
        const seed_base = @as(usize, @intCast(seed_buffer[s_i * 2]));
        for (0..seed_range + 1) |s_n| {
            var seed = @as(i64, @intCast(seed_base + s_n));
            stage_block: for (procs) |proc_stage| {
                for (proc_stage.items) |proc| {
                    if (seed >= proc.start and seed < proc.end) {
                        seed += proc.offset;
                        continue :stage_block;
                    }
                }
            }
            if (seed < lowest)
                lowest = @intCast(seed);
        }
    }
    return lowest;
}

const seedT = i64;

const titles = [_][]const u8{
    "start:",
    "seeds:",
    "seed-to-soil map:",
    "soil-to-fertilizer map:",
    "fertilizer-to-water map:",
    "water-to-light map:",
    "light-to-temperature map:",
    "temperature-to-humidity map:",
    "humidity-to-location map:",
};

const Proc = struct {
    start: i64,
    end: i64,
    offset: i64,
    stage: u8,
};

pub const Day = _day.Day(T, partOne, partTwo, year, day, sampleOne, sampleTwo){};
