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
| Day 9  | 169ms  |
| Day 10 | 1.66ms |
| Day 11 | 7μs    |
| Day 12 | 27.4ms |
| Day 13 | 1.07s  |
| Day 14 |        |
| Day 15 |        |
| Day 16 | 78.7ms |
| Day 17 |        |
| Day 18 |        |

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

### Day 9

Defragmentation of a disk, what a fun challenge. With a simple list (Nim: `sequence`) of integers (representing
fileIds), I could keep track of which file was placed where.

With looping around a bit (and getting rid of _off by one_-errors), it was possible fairly easy to check if the length
of a file would allow it to be placed somewhere else.

## Day 10

Again a map problem today, hooray! Reading through it, it felt familiar, maybe reminding me a bit
of [2023 Day 23](https://adventofcode.com/2023/day/23).
I first thought of using recursion, but after looking at the actual input decided to use a simple queue, so to start
exploring at `0`s and expanding the possible paths by processing queue items. This turned out to be a very good
preparation for part 2 which only required slight changes.

## Day 11

Expanding stones - part 1 was implemented quickly with just following the rules, but it became clear soon enough that
this approach would not work for part 2 (even with a compiled language). After thinking it through some more I gave
Memoization a try, which worked surprisingly well.

# Day 13

Cheat day! Today when reading the problem my mind immediately jumped to equation solving, so I used
Python/[SymPy](https://www.sympy.org/en/index.html), ignoring the "cheapest" condition. The first solution for each
equation was already the right one, and I only found out afterwards that all "vectors" were linearly independent, so I
got lucky.

## Day 16

Again a map problem, but a very fun one. Finding the shortest path quickly reminded me of last year and I started early
with a Priority Queue, with a [heapqueue](https://nim-lang.org/docs/heapqueue.html) implementation in Nim.

As it was still running to slowly, I started skipping paths in the queue that were on positions (with direction) that we
already processed, which worked out nicely.
Unfortunately this was not usable for Part 2, so I had to use another lookup. Starting with the whole path didn't work (
or make sense), but keeping the lowest score for a given position+direction was the key. (If a path leading up to the
position had a higher score, it could not be a solution.)
