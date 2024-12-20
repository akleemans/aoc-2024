import times
import math
import strutils
import sequtils
import benchy
import tables
import heapqueue

let testData = """r, wr, b, g, bwu, rb, gb, br

brwrr
bggr
gbbr
rrbgbr
ubwu
bwurrg
brgr
bbrgwb""".splitLines()

proc isPossible(design: string, patterns: seq[string], cache: var Table[string, bool]): bool =
    if design == "":
        return true
    if cache.hasKey(design):
        return cache[design]

    var possibleNextPatterns: seq[bool] = @[]
    for pattern in patterns:
        if design.startsWith(pattern):
            var newDesign = $design
            newDesign.removePrefix(pattern)
            possibleNextPatterns.add(isPossible(newDesign, patterns, cache))
    if any(possibleNextPatterns, proc (x: bool): bool = x):
        cache[design] = true
        return true
    else:
        cache[design] = false
        return false

proc part1(data: seq[string]): int =
    let patterns = data[0].split(", ")
    let designs = data[2..^1]

    var possibleCount = 0
    var cache = initTable[string, bool]()
    for design in designs:
        if isPossible(design, patterns, cache):
            possibleCount += 1
    # echo "possibleCount: ", possibleCount
    return possibleCount
        

proc isPossible2(design: string, patterns: seq[string], cache: var Table[string, int]): int =
    if design == "":
        return 1
    if cache.hasKey(design):
        return cache[design]

    var possibleNextPatterns: seq[int] = @[]
    for pattern in patterns:
        if design.startsWith(pattern):
            var newDesign = $design
            newDesign.removePrefix(pattern)
            possibleNextPatterns.add(isPossible2(newDesign, patterns, cache))
    let s = sum(possibleNextPatterns)
    cache[design] = s
    return s

proc part2(data: seq[string]): int =
    let patterns = data[0].split(", ")
    let designs = data[2..^1]

    var possibleWays = 0
    var cache = initTable[string, int]()
    for design in designs:
        possibleWays += isPossible2(design, patterns, cache)
    # echo "possibleCount: ", possibleWays
    return possibleWays

proc main() =
    var data = strip(readFile("../inputs/day19.txt")).splitLines()

    let part1TestResult = part1(testData)
    assert part1TestResult == 6
    let part1Result = part1(data)
    assert part1Result == 336

    let part2TestResult = part2(testData)
    assert part2TestResult == 16
    let part2Result = part2(data)
    assert part2Result == 758890600222015

timeIt "day19":
    main()
