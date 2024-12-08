# aoc-2024

My solutions for [Advent of Code 2024](https://adventofcode.com/2024).

This year: Learning **[Nim](https://nim-lang.org/)**!

## Execution times

Code in Nim 2.2.0.

* Testing, debugging: `nim compile --run day01.nim`
* Timing: `nim compile -d:release -d:danger day01.nim`

| Day    | Time   |
|--------|--------|
| Day 1  | 686μs  |
| Day 2  | 1.98ms |
| Day 3  | 2.24ms |
| Day 4  | 276μs  |
| Day 5  | 22.5ms |
| Day 6  | 914ms  |
| Day 7  | 2.87ms |
| Day 8  | 955μs  |
| Day 9  |        |
| Day 10 |        |
| Day 11 |        |
| Day 12 |        |

## Notes

### Day 6

Map. Slow part 2?

### Day 7

Recursion ftw! Solving part 1 was fun and quick (starting in reverse), with part 2 it took me a while to realize what 
"reversing" the `||` means. After figuring out that I misunderstood the problem statement, I was able to figure it out:

```
7290: 6 8 6 15
            *
486: 6 8  6
        ||
48: 6 8
     *
6: 6 ✅
```

