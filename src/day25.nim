import math
import strutils
import sequtils
import benchy
import tables
import system
import heapqueue
import sets
import algorithm
import parseutils

let testData = """#####
.####
.####
.####
.#.#.
.#...
.....

#####
##.##
.#.##
...##
...#.
...#.
.....

.....
#....
#....
#...#
#.#.#
#.###
#####

.....
.....
#.#..
###..
###.#
###.#
#####

.....
.....
.....
#....
#.#..
#.#.#
#####""".splitLines()

proc match(key: seq[int], lock: seq[int]): bool = 
    for i in 0..key.len-1:
        let k = key[i]
        let l = lock[i]
        let highestKey = 5-l
        if k > highestKey:
            return false
    return true

proc part1(data: seq[string]): int =
    var keys: seq[seq[int]] = @[]
    var locks: seq[seq[int]] = @[]
    var isKey = false
    var current: seq[int] = @[-1, -1, -1, -1, -1]

    for idx in 0..data.len-1:
        let line = data[idx]
        if line.len == 0:
            if isKey:
                keys.add(current)
            else:
                locks.add(current)
            current = @[-1, -1, -1, -1, -1]
            continue

        if idx mod 8 == 0:
            if line == "#####":
                isKey = false
            else:
                isKey = true

        for i in 0..line.len-1:
            if line[i] == '#':
                current[i] += 1
    # Add last key
    if isKey:
        keys.add(current)
    else:
        locks.add(current)
    #echo "locks: ", locks
    #echo "keys: ", keys
        
    var count = 0
    for i in 0..locks.len-1:
        let lock: seq[int] = locks[i]
        for key in keys:
            if match(key, lock):
                count += 1
    # echo "count: ", count
    return count

proc main() =
    var data = strip(readFile("../inputs/day25.txt")).splitLines()

    let part1TestResult = part1(testData)
    doAssert part1TestResult == 3
    let part1Result = part1(data)
    doAssert part1Result == 3287

timeIt "day25":
    main()
