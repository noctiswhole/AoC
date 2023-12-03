const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const Error = error{
    ScalarNotFound  
};

const data = @embedFile("data/day03.txt");
const testInput = @embedFile("data/day03test.txt");

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

const ParseIntError = error{InvalidChar};

fn characterToInt(character: u8) !u8 {
    return switch (character) {
        '0' ... '9' => character - '0',
        else => ParseIntError.InvalidChar
    };
}

pub fn main() !void {

    
}

pub fn calculateRowWidth(input: []const u8) !usize {
    const width = indexOf(u8, input, '\n');
    if (width) | w | {
        return w;
    } else {
        return Error.ScalarNotFound;
    }
}

fn isValidSymbol(character: u8) bool {
    return switch (character) {
        '.', '\n', '0' ... '9' => false,
        else => true
    };
}

test "test-row-width" {
    try std.testing.expectEqual(try calculateRowWidth(testInput), 10);
    try std.testing.expectError(Error.ScalarNotFound, calculateRowWidth("asdf"));
}


