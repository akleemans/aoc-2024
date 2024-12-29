import math
import strutils
import sequtils
import benchy

let testData = """7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9""".splitLines()

proc isSave(nrs: seq[string]): bool =
    var diffs: seq[int] = @[]
    for i in 1 .. nrs.len - 1:
        diffs.add(parseInt(nrs[i]) - parseInt(nrs[i - 1]))
    return (all(diffs, proc (x: int): bool = x < 0) or all(diffs, proc (x: int): bool = x > 0)) and all(diffs, proc (x: int): bool = abs(x) <= 3)

proc part1(data: seq[string]): int =
    var count = 0
    for line in data:
        if isSave(line.split()):
            count += 1
    return count

proc part2(data: seq[string]): int =
    var count = 0
    var second_try: seq[string] = @[]
    for line in data:
        if isSave(line.split()):
            count += 1
        else:
            second_try.add(line)

    # Try with removing an element
    for line in second_try:
        let orig_nrs = line.split()
        for m in 0..orig_nrs.len-1:
            var nrs = @orig_nrs
            nrs.delete(m..m)
            if is_save(nrs):
                count += 1
                break
    return count

proc main() =
    var data = strip(readFile("../inputs/day02.txt")).splitLines()

    let part1TestResult = part1(testData)
    doAssert part1TestResult == 2
    let part1Result = part1(data)
    doAssert part1Result == 421

    let part2TestResult = part2(testData)
    doAssert part2TestResult == 4
    let part2Result = part2(data)
    doAssert part2Result == 476


timeIt "day02":
    main()
