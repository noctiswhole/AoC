# Advent Of Code Zig Solutions 

Using AoC to learn Zig.

# Solutions

## Day One

### Part One

Solved using ascii character/u8 math. Any character between 0 and 9 were valid characters, and character was converted by subtracting a valid character by the literal '0'.

### Part Two

Created a clumsy tree to index valid word representation of numbers and did a greedy tree search on all non-number characters.

