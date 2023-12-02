# Advent Of Code Zig Solutions 

Using AoC to learn Zig.

# Solutions

## Day One

### Part One

Solved using ascii character/u8 math. Any character between 0 and 9 were valid characters, and character was converted by subtracting a valid character by the literal '0'.

### Part Two

Created a clumsy tree to index valid word representation of numbers and did a greedy tree search on all non-number characters.

## Day Two

### Part One

Solved by parsing each line to get the highest number of red, green, and blue cubes across all runs, and compared the result against the limit of cubes to get a sum of game IDs.

### Part Two

Used the parser from part one and iterated through all game runs to sum up the cube powers.
