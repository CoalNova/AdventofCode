const std = @import("std");
const alc = @import("../alloc.zig");
const _day = @import("../day.zig");

const year = 2023;
const day = 7;
const T = i32;

const sampleOne =
    \\
;

fn partOne(input: []const u8) T {
    return procHands(input, null);
}

const sampleTwo =
    \\ 
;

fn partTwo(input: []const u8) T {
    return procHands(input, 'J');
}

const Hand = struct { score: Score = .none, cards: [5]u8 = undefined, wild_card: ?u8 = null, _v: i32 = 0 };

const Score = enum(u8) {
    none,
    one_pair,
    two_pair,
    three_kind,
    full_house,
    four_kind,
    five_kind,
};

fn procHands(input: []const u8, wild_card: ?u8) T {
    //skip sentinel
    var lines = std.mem.splitScalar(u8, input[0 .. input.len - 1], '\n');
    var hands: []Hand =
        alc.gpa.alloc(Hand, std.mem.count(u8, input, "\n")) catch unreachable;
    defer alc.gpa.free(hands);
    var i: u16 = 0;
    while (lines.next()) |line| {
        if (line.len > 0) {
            const cards = line[0..5];
            hands[i] = calcHand(cards, wild_card);
            hands[i]._v = std.fmt.parseInt(i32, line[6..], 10) catch unreachable;
            i += 1;
        }
    }
    std.mem.sort(Hand, hands, {}, compareHands);
    var score: T = 0;
    for (hands, 0..) |hand, rank| {
        score += hand._v * (@as(T, @intCast(rank)) + 1);
        //if (hand.score == .two_pair)

    }
    return score;
}

fn calcHand(cards: *const [5]u8, wild_card: ?u8) Hand {
    var hand = Hand{ .wild_card = wild_card };
    @memcpy(&hand.cards, cards);
    const wilds: u8 =
        if (wild_card != null)
        @as(u8, @intCast(std.mem.count(u8, cards, &[_]u8{wild_card.?})))
    else
        0;

    block: for (cards, 0..) |card, i| {
        if (card == wild_card)
            continue :block;
        var mults: u8 = 1;
        for (cards[i + 1 ..]) |check| {
            if (check == card)
                mults += 1;
        }
        switch (mults) {
            2 => {
                if (hand._v != card) {
                    hand._v = card;
                    if (hand.score == .one_pair) {
                        hand.score = .two_pair;
                    } else if (hand.score == .three_kind) {
                        hand.score = .full_house;
                        break :block;
                    } else hand.score = .one_pair;
                }
            },
            3 => {
                if (hand._v != card) {
                    hand._v = card;
                    if (hand.score == .one_pair) {
                        hand.score = .full_house;
                        break :block;
                    }
                    hand.score = .three_kind;
                }
            },
            4 => {
                if (hand._v != card) {
                    hand._v = card;
                    hand.score = .four_kind;
                    break :block;
                }
            },
            5 => {
                if (hand._v != card) {
                    hand._v = card;
                    hand.score = .five_kind;
                    break :block;
                }
            },
            else => {},
        }
    }
    switch (hand.score) {
        .one_pair => {
            switch (wilds) {
                1 => hand.score = .three_kind,
                2 => hand.score = .four_kind,
                3 => hand.score = .five_kind,
                else => hand.score = .one_pair,
            }
        },
        .two_pair => {
            switch (wilds) {
                1 => hand.score = .full_house,
                else => hand.score = .two_pair,
            }
        },
        .three_kind => {
            switch (wilds) {
                1 => hand.score = .four_kind,
                2 => hand.score = .five_kind,
                else => hand.score = .three_kind,
            }
        },
        .four_kind => {
            switch (wilds) {
                1 => hand.score = .five_kind,
                else => hand.score = .four_kind,
            }
        },
        .full_house => hand.score = .full_house,
        .five_kind => hand.score = .five_kind,
        else => {
            switch (wilds) {
                0 => hand.score = .none,
                1 => hand.score = .one_pair,
                2 => hand.score = .three_kind,
                3 => hand.score = .four_kind,
                else => hand.score = .five_kind,
            }
        },
    }
    return hand;
}

fn compareHands(context: void, left: Hand, right: Hand) bool {
    _ = context;
    if (left.score == right.score) {
        rank_block: for (0..left.cards.len) |i| {
            if (left.cards[i] == right.cards[i])
                continue :rank_block;
            return getPower(left.cards[i], left.wild_card) <
                getPower(right.cards[i], right.wild_card);
        }
    }
    return @intFromEnum(left.score) < @intFromEnum(right.score);
}

inline fn getPower(face_value: u8, wild_card: ?u8) u8 {
    if (wild_card != null)
        if (wild_card == face_value)
            return 0;
    return switch (face_value) {
        '2' => 1,
        '3' => 2,
        '4' => 3,
        '5' => 4,
        '6' => 5,
        '7' => 6,
        '8' => 7,
        '9' => 8,
        'T' => 9,
        'J' => 10,
        'Q' => 11,
        'K' => 12,
        'A' => 13,
        else => 0,
    };
}

pub const Day = _day.Day(T, partOne, partTwo, year, day, sampleOne, sampleTwo){};
