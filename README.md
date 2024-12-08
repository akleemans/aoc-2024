# aoc-2024

My solutions for [Advent of Code 2024](https://adventofcode.com/2024).

This year: Learning **[Nim](https://nim-lang.org/)**!

## Execution times

Code in Nim 2.2.0.

* Testing, debugging: `nim compile --run day00.nim`
* Timing: `nim compile -d:release -d:danger day00.nim`

| Day    | Time   |
|--------|--------|
| Day 1  | 686μs  |
| Day 2  | 1.98ms |
| Day 3  | 2.24ms |
| Day 4  | 276μs  |
| Day 5  | 22.5ms |
| Day 6  | 350ms  |
| Day 7  | 2.87ms |
| Day 8  | 955μs  |
| Day 9  |        |
| Day 10 |        |
| Day 11 |        |
| Day 12 |        |

## Notes

### Day 6

First map problem, yay! Part 1 was quick, but part 2 took me much longer because I didn't properly think it through and
jumped into coding. There's an edge case (only in part 2) if you insert a blocker `0` just at a place so a right turn
isn't possible, then the guard will have to walk back from where they came from.

Guard approaching:
```
..->...#
......0.
```

Hitting the given wall, unable to turn (or turning 90°, then right again).
```
.....->#
......0.
```

Guard going back.
```
.....<-#
......0.
```

My solution is still somewhat "brute-forcy" (on the given path from part 1, try to insert a blocker `0` at any possible
place), but as it finished within a second I let it be.

### Day 7

Recursion ftw! Solving part 1 was fun and quick, and I started in reverse from the beginning.

With part 2 it took me a while to realize what
"reversing" the `||` means. After figuring out that I misunderstood the problem statement, I was able to figure it out:

```
7290: 6 8 6 15
            * (revert: divide by 15)
486: 6 8  6
        || (revert: remove last 6 from 486)
48: 6 8
     * (revert: divide by 8)
6: 6 ✅
```

