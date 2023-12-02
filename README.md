# Advent Of Code Zig Solutions 

Using AoC to learn Zig.

# Solutions

## Day One

### Part One

#### Problem

Find the first and last numbers in a line in char form, and form a two digit number with them. The solution is the sum of all two digit numbers.

#### Solution

Solved using ascii character/u8 math. Any character between 0 and 9 were valid characters, and character was converted by subtracting a valid character by the literal '0'.

### Part Two

#### Problem

Similar to part one, the first and last numbers in a line form a two digit number, and numbers across all lines are summed up. Textual representation of numbers are now included (e.g. onetwo = 12)

#### Solution

Created a tree to index valid word representation of numbers. Iterated through each character in a line to do a greedy tree search on all non-number characters to find the numerical representation. Used the integer parser in part one for all numerical characters. The two digit number for each line is formed in the same way, and summed up.

## Day Two

### Part One

Solved by parsing each line to get the highest number of red, green, and blue cubes across all runs, and compared the result against the limit of cubes to get a sum of game IDs.

### Part Two

Used the parser from part one and iterated through all game runs to sum up the cube powers.
