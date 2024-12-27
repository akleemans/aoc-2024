import math
import strutils
import sequtils
import benchy
import tables
import system
import heapqueue
import sets

let testData = """029A
980A
179A
456A
379A""".splitLines()

# Numeric keypad
# +---+---+---+
# | 7 | 8 | 9 |
# +---+---+---+
# | 4 | 5 | 6 |
# +---+---+---+
# | 1 | 2 | 3 |
# +---+---+---+
#     | 0 | A |
#     +---+---+

var numericKeypad = initTable[(char, char), seq[string]]()
numericKeypad.add(('A', '0'), @["<A"])
numericKeypad.add(('A', '1'), @["^<<A", "<^<A"])
numericKeypad.add(('A', '2'), @["<^A", "^<A"])
numericKeypad.add(('A', '3'), @["^A"])
numericKeypad.add(('A', '4'), @["^^<<A", "<^<^A", "<^^<A", "^<<^A"])
numericKeypad.add(('A', '5'), @["<^^A", "^^<A", "^<^A"])
numericKeypad.add(('A', '8'), @["<^^^A", "^^^<A", "^<^^A", "^^<^A"])
numericKeypad.add(('A', '9'), @["^^^A"])

numericKeypad.add(('0', 'A'), @[">A"])
numericKeypad.add(('0', '2'), @["^A"])
numericKeypad.add(('0', '5'), @["^^A"])
numericKeypad.add(('1', '4'), @["^A"])
numericKeypad.add(('1', '7'), @["^^A"])
numericKeypad.add(('2', 'A'), @["v>A", ">vA"])
numericKeypad.add(('2', '4'), @["<^A", "^<A"])
numericKeypad.add(('2', '9'), @[">^^A", "^^>A", "^>^A"])
numericKeypad.add(('3', '7'), @["<<^^A", "^^<<A", "<^<^A", "^<^<A", "^<<^A", "<^^<A"])

numericKeypad.add(('4', '0'), @[">vvA", "v>vA"])
numericKeypad.add(('4', '5'), @[">A"])
numericKeypad.add(('4', '6'), @[">>A"])
numericKeypad.add(('4', '9'), @["^>>A", ">>^A", ">^>A"])

numericKeypad.add(('5', 'A'), @["vv>A", ">vvA", "v>vA"])
numericKeypad.add(('5', '4'), @["<A"])
numericKeypad.add(('5', '6'), @[">A"])
numericKeypad.add(('5', '8'), @["^A"])

numericKeypad.add(('6', 'A'), @["vvA"])
numericKeypad.add(('7', '9'), @[">>A"])

numericKeypad.add(('8', '0'), @["vvvA"])
numericKeypad.add(('8', '2'), @["vvA"])


numericKeypad.add(('9', 'A'), @["vvvA"])
numericKeypad.add(('9', '8'), @["<A"])


# Direction keypad
#     +---+---+
#     | ^ | A |
# +---+---+---+
# | < | v | > |
# +---+---+---+
var directionKeypad = initTable[(char, char), seq[string]]()
directionKeypad.add(('A', 'A'), @["A"])
directionKeypad.add(('A', '^'), @["<A"])
directionKeypad.add(('A', '<'), @["v<<A", "<v<A"])
directionKeypad.add(('A', 'v'), @["<vA", "v<A"])
directionKeypad.add(('A', '>'), @["vA"])

directionKeypad.add(('^', 'A'), @[">A"])
directionKeypad.add(('^', '^'), @["A"])
directionKeypad.add(('^', '<'), @["v<A"])
directionKeypad.add(('^', 'v'), @["vA"])
directionKeypad.add(('^', '>'), @["v>A", ">vA"])

directionKeypad.add(('<', 'A'), @[">>^A", ">^>A"])
directionKeypad.add(('<', '^'), @[">^A"])
directionKeypad.add(('<', '<'), @["A"])
directionKeypad.add(('<', 'v'), @[">A"])
directionKeypad.add(('<', '>'), @[">>A"])

directionKeypad.add(('v', 'A'), @[">^A", "^>A"])
directionKeypad.add(('v', '^'), @["^A"])
directionKeypad.add(('v', '<'), @["<A"])
directionKeypad.add(('v', 'v'), @["A"])
directionKeypad.add(('v', '>'), @[">A"])

directionKeypad.add(('>', 'A'), @["^A"])
directionKeypad.add(('>', '^'), @["<^A", "^<A"])
directionKeypad.add(('>', '<'), @["<<A"])
directionKeypad.add(('>', 'v'), @["<A"])
directionKeypad.add(('>', '>'), @["A"])

var seen = initTable[((char, char), int), int]()

proc expand(last: char, current: char, level, maxLevel: int): int =
    if ((last, current), level) in seen:
        return seen[((last, current), level)]

    # Choose correct keyboard
    let keypad = if level == 0: numericKeypad else: directionKeypad
    let newCurrent = keypad[(last, current)]

    # Base case
    if level == maxLevel:
        return newCurrent[0].len
    
    var results: seq[int] = @[]
    for nC in newCurrent:
        var res = 0
        for i in 0..nC.len-1:
            let newlast = if i == 0: 'A' else: nC[i-1]
            res += expand(newlast, nC[i], level+1, maxLevel)
        results.add(res)
    
    #echo "expand with", (last, current, level)
    #echo "results: ", results
    #let a = readLine(stdin)
    let minRes = min(results)
    seen[((last, current), level)] = minRes
    return minRes

proc bothParts(data: seq[string], maxLevel: int): int =
    var lengths: seq[int] = @[]
    seen = initTable[((char, char), int), int]()
    for line in data:
        # echo "Processing line: ", line
        var res = 0
        for i in 0..line.len-1:
            let last = if i == 0: 'A' else: line[i-1]
            res += expand(last, line[i], 0, maxLevel)
        lengths.add(res)

    var complexity = 0
    for i in 0..data.len-1:
        let numericPart = parseInt(data[i][0..^2])
        complexity += numericPart * lengths[i]
    # echo "complexity: ", complexity
    return complexity

proc main() =
    var data = strip(readFile("../inputs/day21.txt")).splitLines()

    let part2TestResult = bothParts(testData, 2)
    doAssert part2TestResult == 126384
    let part2TestResult2 = bothParts(data, 2)
    doAssert part2TestResult2 == 164960

    let part2Result = bothParts(data, 25)
    doAssert part2Result == 205620604017764

timeIt "day21":
    main()
