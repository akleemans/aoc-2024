import math
import strutils
import algorithm
import sequtils
import benchy

let testData = """3   4
4   3
2   5
1   3
3   9
3   3""".splitLines()

proc part1(data: seq[string]): int =
    var list_a: seq[int] = @[]
    var list_b: seq[int] = @[]
    for line in data:
        let parts = splitWhitespace(line)
        list_a.add(parseInt(parts[0]))
        list_b.add(parseInt(parts[1]))
    list_a.sort()
    list_b.sort()

    var diff = 0
    for i in 0 .. list_a.len - 1:
        diff += abs(list_a[i] - list_b[i])
    return diff

proc part2(data: seq[string]): int =
    var list_a: seq[int] = @[]
    var list_b: seq[int] = @[]
    for line in data:
        let parts = splitWhitespace(line)
        list_a.add(parseInt(parts[0]))
        list_b.add(parseInt(parts[1]))
    list_a.sort()
    list_b.sort()

    var similarity_score = 0
    for a in list_a:
        similarity_score += a * count(list_b, a)
    return similarity_score

proc main() =
    var data = strip(readFile("../inputs/day01.txt")).splitLines()

    let part1RestResult = part1(testData)
    doAssert part1RestResult == 11
    let part1Result = part1(data)
    doAssert part1Result == 1388114

    let part2TestResult = part2(testData)
    doAssert part2TestResult == 31
    let part2Result = part2(data)
    doAssert part2Result == 23529853

timeIt "day02":
    main()
