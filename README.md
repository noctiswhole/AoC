# Advent Of Code Zig Solutions 

Using AoC to learn Zig.

# Table of Contents

1. [Day One](#day-one)
2. [Day Two](#day-two)

# Solutions

## Day One

### Part One

[day01.zig](src/day01.zig)

#### Problem

Find the first and last numbers in a line in char form, and form a two digit number with them. The solution is the sum of all two digit numbers.

#### Solution

Solved using ascii character/u8 math. Any character between 0 and 9 were valid characters, and character was converted by subtracting a valid character by the literal '0'.

### Part Two

[day01-02.zig](src/day01-02.zig)

#### Problem

Similar to part one, the first and last numbers in a line form a two digit number, and numbers across all lines are summed up. Textual representation of numbers are now included (e.g. onetwo = 12)

#### Solution

Created a tree to index valid word representation of numbers. Iterated through each character in a line to do a greedy tree search on all non-number characters to find the numerical representation. Used the integer parser in part one for all numerical characters. The two digit number for each line is formed in the same way, and summed up.

## Day Two

### Part One

[day02.zig](src/day02.zig)

#### Problem

Each line contains an ID and red, green, blue (rgb) values. Limits to red, green, blue are defined. The solution is the sum of IDs for all lines that are inside the defined limits.

#### Solution

Solved by parsing each line to get the highest number of red, green, and blue cubes across all runs, and compared the result against the limit of cubes to get a sum of game IDs.

### Part Two

[day02.zig](src/day02.zig)

#### Problem

Solution is each largest value of RGB multiplied together in each line, and summed together. 

#### Solution

Used the parser from part one and iterated through all game runs to sum up the cube powers.
