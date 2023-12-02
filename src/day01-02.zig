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

const Node = struct {
    key: u8,
    value: u32,
    child_head: ?* Node,
    next: ?* Node,

    const Self = @This();

    pub fn init() Self {
        return .{
            .key = "",
            .value = 0,
            .child_head = null,
            .next = null,
        };
    }

    pub fn add(self: *Self, node: *Node) void {
        node.next = self.child_head;
        self.child_head = node;
    }
};


const Tree = struct {
    const Self = @This();
    head: Node,
    allocator: std.mem.Allocator,

    pub fn init(alloc: std.mem.Allocator) Self {

        return .{
            .allocator = alloc,
            .head = .{
                .key = '0',
                .value = 0,
                .child_head = null,
                .next = null,
            }
        };
    }

    pub fn addTreeItems(self: *Self, items: []const u8, value: u8) !void {
        var currNode: *Node = &self.head;

        for (items) |item| {
            std.debug.print("creating {u}\n", .{item});
            if (currNode.child_head) | child | {
                const foundNode = self.search(item, child); 
                if (foundNode) | found | {
                    std.debug.print("Found {u}\n", .{item});
                    currNode = found;
                } else {
                    const newNode = try self.allocator.create(Node);
                    newNode.key = item;
                    newNode.child_head = null;
                    newNode.next = null;
                    newNode.value = 0;
                    std.debug.print("created {u}\n", .{newNode.key});
                    currNode.add(newNode);
                    currNode = newNode;
                }
            } else {
                const newNode = try self.allocator.create(Node);
                newNode.key = item;
                newNode.child_head = null;
                newNode.next = null;
                newNode.value = 0;

                currNode.child_head = newNode;
                currNode = newNode;
                std.debug.print("Brand new child list created {u}\n", .{item});
            }
        }

        // Created last node
        currNode.value = value;

        std.debug.print("set {u} to {d}\n", .{currNode.key, currNode.value});
    }

    pub fn search(_: *Self, character: u8, node: *Node) ?*Node {
        var currNode: ?*Node = node;

        while (currNode) | current | {
            std.debug.print("Node: {u}\n", .{current.key});
            if (current.key == character) {
                std.debug.print("Found key {u}\n", .{character});
                return currNode;
            }

            currNode = current.next;
        }
        return null;
    }

    pub fn find(self: *Self, input: []const u8) ?*Node {
        var currNode: *Node = undefined;
        if (self.head.child_head) | child | {
            currNode = child;
        } else {
            return null;
        }

        for (input) | char | {
            std.debug.print("finding {u}\n", .{char});
            const foundNode = self.search(char, currNode);
            if (foundNode) | found | {
                // Found value
                if (found.value > 0) {
                    return found;
                } else if (found.child_head) | head | {
                        // Found letter
                        currNode = head;
                } else {
                    return null;
                }
            } else {
                // Did not match string
                return null;
            }
        }
        return null;
    }
};


fn charToInt(c: u8) Error!u8 {
    return switch (c) {
        '0' ... '9' => c - '0',
        else => Error.InvalidChar
    };
}

// Generated from template/template.zig.
// Run `zig build generate` to update.
// Only unmodified days will be updated.


fn parseCalibrationValue(input: []const u8, tree: *Tree) u32 {
    const length = input.len;
    std.debug.print("Length of input is {d}\n", .{length});
    var sum: u32 = 0;
    var hasFoundFirst = false;
    var latestInt: u32 = 0;

    var i: usize = 0;

    while (i < length) {
        std.debug.print("Current input is {u}\n", .{input[i]});
        if (input[i] == '\n') {
            sum += latestInt;
            std.debug.print("*****\nLast int {d}; current sum is {d}\n*****\n", .{latestInt, sum});
            hasFoundFirst = false;
            i += 1;

            continue;
        }
        var j = i;
        var currNode: *Node = undefined;
        if (tree.head.child_head) | child | {
            currNode = child;
        } else {
            return 0;
        }
        var isSearchDone = false;
        var foundNumber: u32 = 0;
        while (j < length and !isSearchDone) {
            if (charToInt(input[j])) | parsedElem | {
                std.debug.print("Found number representation of {d}\n", .{parsedElem});
                latestInt = parsedElem;
                isSearchDone = true;
                foundNumber = parsedElem;
            } else |_| {
                // Do a search for a word
                const foundNode = tree.search(input[j], currNode);
                if (foundNode) | found | {
                    if (found.value != 0) {
                        std.debug.print("Found word representation of {d}\n", .{found.value});
                        foundNumber = found.value;
                        isSearchDone = true;
                    } else if (found.child_head) | child | {
                        currNode = child;
                    } else {
                        std.debug.print("Something went very wrong\n", .{});
                    }
                } else {
                    isSearchDone = true;
                }
            }
            if (isSearchDone and foundNumber != 0) {
                if (!hasFoundFirst) {
                    hasFoundFirst = true;
                    std.debug.print("First int {d}\n", .{foundNumber});
                    sum += foundNumber * 10;
                } else {
                    std.debug.print("New latest int {d}\n", .{foundNumber});
                    latestInt = foundNumber;
                }
            }
            j += 1;
        }
        i += 1;
    }
    return sum;
}

pub fn main() !void {
    var tree = Tree.init(gpa);
    try tree.addTreeItems("one", 1);
    try tree.addTreeItems("two", 2);
    try tree.addTreeItems("three", 3);
    try tree.addTreeItems("four", 4);
    try tree.addTreeItems("five", 5);
    try tree.addTreeItems("six", 6);
    try tree.addTreeItems("seven", 7);
    try tree.addTreeItems("eight", 8);
    try tree.addTreeItems("nine", 9);
    const input = @embedFile("data/day01.txt");
    const value = parseCalibrationValue(input, &tree);
    std.debug.print("Output: {d}\n", .{value});
}

test "test-input" {
    var tree = Tree.init(gpa);
    try tree.addTreeItems("one", 1);
    try tree.addTreeItems("two", 2);
    try tree.addTreeItems("three", 3);
    try tree.addTreeItems("four", 4);
    try tree.addTreeItems("five", 5);
    try tree.addTreeItems("six", 6);
    try tree.addTreeItems("seven", 7);
    try tree.addTreeItems("eight", 8);
    try tree.addTreeItems("nine", 9);
    const input = @embedFile("data/day01test.txt");
    const value = parseCalibrationValue(input, &tree);
    try std.testing.expectEqual(value, 281);
    std.debug.print("Output: {d}\n", .{value});
}
