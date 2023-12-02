const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day01.txt");


// Useful stdlib functions
const tokenizeAny = std.mem.tokenizeAny;
const tokenizeSeq = std.mem.tokenizeSequence;
const tokenizeSca = std.mem.tokenizeScalar;
const splitAny = std.mem.splitAny;
const splitSeq = std.mem.splitSequence;
const splitSca = std.mem.splitScalar;
const indexOf = std.mem.indexOfScalar;
const indexOfAny = std.mem.indexOfAny;
const indexOfStr = std.mem.indexOfPosLinear;
const lastIndexOf = std.mem.lastIndexOfScalar;
const lastIndexOfAny = std.mem.lastIndexOfAny;
const lastIndexOfStr = std.mem.lastIndexOfLinear;
const trim = std.mem.trim;
const sliceMin = std.mem.min;
const sliceMax = std.mem.max;

const parseInt = std.fmt.parseInt;
const parseFloat = std.fmt.parseFloat;

const print = std.debug.print;
const assert = std.debug.assert;

const sort = std.sort.block;
const asc = std.sort.asc;
const desc = std.sort.desc;

const Error = error{InvalidChar};

fn charToInt(c: u8) Error!u8 {
    return switch (c) {
        '0' ... '9' => c - '0',
        else => Error.InvalidChar
    };
}

fn parseCalibrationValue(input: []const u8) u32 {
    var sum: u32 = 0;
    var hasFoundFirst = false;
    var latestInt: u8 = 10;

    for (input) |elem| {
        if (charToInt(elem)) |parsedElem| {
            latestInt = parsedElem;
            if (!hasFoundFirst) {
                hasFoundFirst = true;
                std.debug.print("First int {d}\n", .{parsedElem});
                sum += parsedElem * 10;
            }
        } else |_| {
            if (elem == '\n') {
                sum += latestInt;
                std.debug.print("Last int {d}\n", .{latestInt});
                hasFoundFirst = false;
            }
        }
    }
    return sum;
}

pub fn main() !void {
    const input = @embedFile("data/day01.txt");
    std.debug.print("Result: {d}", .{parseCalibrationValue(input)});
}

test "test-input" {
    const input = @embedFile("data/day01test01.txt");
    const value = parseCalibrationValue(input);
    try std.testing.expectEqual(value, 142);
    std.debug.print("Output: {d}\n", .{value});
}
