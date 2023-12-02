const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day02.txt");


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

const Game = struct {
    id: u32,
    r: u32,
    g: u32,
    b: u32,
};

const Error = error{TokenNotFound};

fn findToken(needle: u8, haystack: []const u8) i32 {
    for (0..haystack.len) |i| {
        if (haystack[i] == needle) {
            return @intCast(i);
        }
    }
    return -1;
}

fn parseLine(line: []const u8) !Game {
    var idBegin: usize = 0;
    var i: usize = 0;
    const length = line.len;
    while (i < length and line[i] != ':') {
        i += 1;
        if (line[i] == ' ') {
            idBegin = i + 1;
        }
    }

    var game: Game = .{
        .id = 0,
        .r = 0,
        .g = 0,
        .b = 0,
    };

    // grab game id
    const id = try parseInt(u32, line[idBegin..i], 10);
    game.id = id;
    // advance i to the first number
    i += 2;
    var lines = std.mem.split(u8, line[i..length], "; ");
    while (lines.next()) | cubes | {
        var cubeLines = std.mem.split(u8, cubes, ", ");
        while (cubeLines.next()) | cube | {
            // std.debug.print("\"{s}\"\n", .{cube});
            const pos = findToken(' ', cube);
            if (pos == -1) {
                return Error.TokenNotFound;
            }
            const newpos: usize = @intCast(pos);
            const value = try parseInt(u32, cube[0..newpos], 10);
            const color = cube[newpos+1..cube.len];
            if (std.mem.eql(u8, color, "red") and game.r < value) {
                game.r = value;
            } else if (std.mem.eql(u8, color, "blue") and game.b < value) {
                game.b = value;
            } else if (std.mem.eql(u8, color, "green") and game.g < value) {
                game.g = value;
            }
        }
    }
    return game;
}

pub fn main() !void {
    
}

test "test-generate-game" {
    const testline = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green";
    const testGame = try parseLine(testline);
    std.debug.print("Output: id {d} r {d} g {d} b {d}\n", .{testGame.id, testGame.r, testGame.g, testGame.b});
    try std.testing.expectEqual(std.meta.eql(testGame, Game{
        .id = 1,
        .r = 4,
        .g = 2,
        .b = 6,
    }), true);

}
