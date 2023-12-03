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
    const sum = try solve(data);
    std.debug.print("Solution: {d}", .{sum});
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
    foundInt = 0;
    var hasSymbol = false;
    hasSymbol = false;
    var sum: u32 = 0;
    sum = 0;

    for (0..length) | i |{
        if (input[i] == '*') {
            sum += try calculateNeighboringNumbers(input, width, i);
        }
    }
    return sum;
}

// Iterate through input and calculate ratios for any where there's a '*' character
fn calculateNeighboringNumbers(input: []const u8, lineWidth: usize, position: usize) !u32 {
    const length = input.len;
    const linePos = position % lineWidth;
    const lineNum: usize = position / lineWidth;

    const checkUp = position > lineWidth;
    const checkDown = position < (length - lineWidth);


    var totalNumbers: u32 = 0;
    var ratio: u32= 0;

    if (checkUp) {
        // get total values for line above
        const lineStart = (lineNum - 1) * lineWidth;
        const lineEnd = lineNum * lineWidth;
        const line = input[lineStart .. lineEnd];
        const result = try findNumbers(line, linePos);

        totalNumbers += result[0];
        ratio = result[1];
    }

    if (checkDown) {
        // get total values for line below
        const lineStart = (lineNum + 1) * lineWidth;
        const lineEnd = (lineNum + 2) * lineWidth;
        const line = input[lineStart .. lineEnd];
        const result = try findNumbers(line, linePos);
        if (result[0] != 0) {
            ratio = @max(result[1] * ratio, result[1]);
        }
        totalNumbers += result[0];
    }

    // get total values for current line
    const lineStart = lineNum * lineWidth;
    const lineEnd = (lineNum + 1) * lineWidth;
    const line = input[lineStart .. lineEnd];
    const result = try findNumbers(line, linePos);
    if (result[0] != 0) {
        totalNumbers += result[0];
        ratio = @max(result[1] * ratio, result[1]);
    }

    if (totalNumbers != 2) {
        return 0;
    } else {
        return ratio;
    }
}

// Returns the number of matches, and the product of the numbers, for a given line
fn findNumbers(line: []const u8, position: usize) ![2]u32 {
    const length = line.len;
    const checkLeft = position > 0;
    const checkRight = position < length - 1;
    var total: u32 = 0;
    var found: u32 = 0;

    // we need to find the start and end of the numbers in the string
    if (isValidDigit(line[position])) {
        // if the center character is a number, there can only be one total number
        const numberStart = walkLeft(line, position);
        const numberEnd = walkRight(line, position);
        const numberToParse = line[numberStart..(numberEnd+1)];
        total = try parseInt(u32, numberToParse, 10);
        found += 1;
    } else {
        // find number bordering on the left
        if (checkLeft and isValidDigit(line[position - 1])) {
            const numberStart = walkLeft(line, position - 1);
            const numberToParse = line[numberStart..position];
            total = try parseInt(u32, numberToParse, 10);
            found += 1;
        }
        // find number bordering on the right
        if (checkRight and isValidDigit(line[position + 1])) {
            const numberEnd = walkRight(line, position + 1);
            const numberToParse = line[(position + 1)..(numberEnd + 1)];
            const parsedNumber = try parseInt(u32, numberToParse, 10);
            total = @max(total * parsedNumber, parsedNumber);
            found += 1;
        }
    }
    return .{found, total};
}

// move cursor left until we find the beginning of a number
fn walkLeft(input: []const u8, position: usize) usize {
    var i = position;
    while (i >= 0 and isValidDigit(input[i])) {
        if (i == 0) {
            return 0;
        }
        i -= 1;
    }

    return i + 1;
}

// move cursor right until we find the end of a number
fn walkRight(input: []const u8, position: usize) usize {
    var i = position;
    const length = input.len;
    while (i < length and isValidDigit(input[i])) {
        i += 1;
    }

    return i - 1;
}

fn isValidDigit(character: u8) bool {
    return switch (character) {
        '0' ... '9' => true,
        else => false
    };
}

test "test-find-number-row" {
    const totals = try findNumbers("5*111", 1);
    
    try std.testing.expectEqual(std.meta.eql(totals, .{2, 555}), true);
}

test "test-input" {
    const sum = try solve(testInput);
    try std.testing.expectEqual(sum, 467835);
}

test "test-row-width" {
    try std.testing.expectEqual(try calculateRowWidth(testInput), 10);
    try std.testing.expectError(Error.ScalarNotFound, calculateRowWidth("asdf"));
}

