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

fn solve(input: []const u8) !u32 {
    const length = input.len;
    // account for newline character too
    const width = try calculateRowWidth(input) + 1;
    var foundInt: u32 = 0;
    var hasSymbol = false;
    var sum: u32 = 0;

    for (0..length) | i |{
        if (characterToInt(input[i])) | n | {
            // shift numbers one position and append n to found integer
            foundInt = foundInt * 10 + n;
            if (!hasSymbol) {
                hasSymbol = hasNeighboringSymbol(input, width, i);
            }
        } else |_| {
            // Found an integer's end, so we add it to the sum if it meets the rules and reset vars
            if (foundInt > 0) {
                if (hasSymbol == true) {
                    sum += foundInt;
                }
                hasSymbol = false;
                foundInt = 0;
            }
        }
    }
    return sum;
}

fn hasNeighboringSymbol(input: []const u8, lineWidth: usize, position: usize) bool {
    const length = input.len;
    const linePos = position % lineWidth;

    const checkLeft = linePos > 1;
    const checkRight = linePos < lineWidth - 1;
    const checkUp = position > lineWidth;
    const checkDown = position < (length - lineWidth);

    // Check left positions if we're not on the left most side on the grid
    if (checkLeft) {
        const leftPosition = position - 1;
        if (
            (isValidSymbol(input[leftPosition])) or
            (checkUp and isValidSymbol(input[leftPosition - lineWidth])) or
            (checkDown and isValidSymbol(input[leftPosition + lineWidth]))
        ) {
            return true;
        }
    }
    // Check right positions if we're not on the right most side on the grid
    if (checkRight) {
        const rightPosition = position + 1;
        if (
            (isValidSymbol(input[rightPosition])) or
            (checkUp and isValidSymbol(input[rightPosition - lineWidth])) or
            (checkDown and isValidSymbol(input[rightPosition + lineWidth]))
        ) {
            return true;
        }
    }

    // Check center positions
    if ((checkUp and isValidSymbol(input[position - lineWidth])) 
        or (checkDown and isValidSymbol(input[position + lineWidth])))
    {
        return true;
    }

    return false;
}

fn isValidSymbol(character: u8) bool {
    return switch (character) {
        '.', '\n', '0' ... '9' => false,
        else => true
    };
}

test "test-input" {
    const sum = try solve(testInput);
    try std.testing.expectEqual(sum, 4361);
}

test "test-row-width" {
    try std.testing.expectEqual(try calculateRowWidth(testInput), 10);
    try std.testing.expectError(Error.ScalarNotFound, calculateRowWidth("asdf"));
}


