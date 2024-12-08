import math
import algorithm
import strutils
import benchy
import tables
import sequtils
import system

let testData = """190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20""".splitLines()

proc isPossible(currentTestValue: int, nrs: seq[int]): bool =
    if nrs.len == 0:
        return currentTestValue == 1

    let nextNr = nrs[0]
    if currentTestValue mod nextNr == 0:
        let nextTestValue = int(currentTestValue / nextNr)
        if isPossible(nextTestValue, nrs[1..^1]):
            return true
    return isPossible(currentTestValue-nextNr, nrs[1..^1])

proc isPossibleWithConcat(currentTestValue: int, nrs: seq[int]): bool =
    if nrs.len == 0  or currentTestValue <= 0:
        return currentTestValue == 1

    let nextNr = nrs[0]
    if currentTestValue mod nextNr == 0:
        let nextTestValue = int(currentTestValue / nextNr)
        if isPossibleWithConcat(nextTestValue, nrs[1..^1]):
            return true
    
    # Reverse concat
    if nrs.len >= 2:
        if ($currentTestValue).endsWith($nextNr) and currentTestValue > nextNr:
            var currentTestValueStr = $currentTestValue
            currentTestValueStr.removeSuffix($nextNr)
            let nextTestValue = parseInt(currentTestValueStr)
            if isPossibleWithConcat(nextTestValue, nrs[1..^1]):
                return true

    # Addition
    return isPossibleWithConcat(currentTestValue-nextNr, nrs[1..^1])

proc part1(data: seq[string]): int =
    var calibrationResult = 0
    for line in data:
        let parts = line.split(": ")
        let testValue = parseInt(parts[0])
        let nrs = parts[1].split(" ").mapIt(parseInt(it))
        let reverseNrs = nrs.reversed
        if isPossible(testValue, reverseNrs):
            calibrationResult += testValue
    
    return calibrationResult

proc part2(data: seq[string]): int =
    var calibrationResult = 0
    for line in data:
        let parts = line.split(": ")
        let testValue = parseInt(parts[0])
        let nrs = parts[1].split(" ").mapIt(parseInt(it))
        let reverseNrs = nrs.reversed
        if isPossibleWithConcat(testValue, reverseNrs):
            calibrationResult += testValue

    # echo "calibrationResult: ", calibrationResult
    return calibrationResult

proc main() =
    var data = strip(readFile("../inputs/day07.txt")).splitLines()

    let part1TestResult = part1(testData)
    doAssert part1TestResult == 3749
    let part1Result = part1(data)
    doAssert part1Result == 21572148763543

    let part2TestResult = part2(testData)
    doAssert part2TestResult == 11387
    let part2Result = part2(data)
    doAssert part2Result == 581941094529163

timeIt "day07":
    main()
