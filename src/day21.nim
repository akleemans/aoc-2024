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

var numericKeypad = initTable[(char, char), string]()
numericKeypad.add(('A', 'A'), "A")
numericKeypad.add(('A', '0'), "<A")
numericKeypad.add(('A', '1'), "^<<A")
numericKeypad.add(('A', '2'), "<^A")
numericKeypad.add(('A', '3'), "^A")
numericKeypad.add(('A', '4'), "^^<<A")
numericKeypad.add(('A', '5'), "<^^A")
numericKeypad.add(('A', '6'), "^^A")
numericKeypad.add(('A', '7'), "^^^<<A")
numericKeypad.add(('A', '8'), "<^^^A")
numericKeypad.add(('A', '9'), "^^^A")

numericKeypad.add(('0', 'A'), ">A")
numericKeypad.add(('0', '0'), "A")
numericKeypad.add(('0', '1'), "^<A")
numericKeypad.add(('0', '2'), "^A")
numericKeypad.add(('0', '3'), "^>A")
numericKeypad.add(('0', '4'), "^^<A")
numericKeypad.add(('0', '5'), "^^A")
numericKeypad.add(('0', '6'), "^^>A")
numericKeypad.add(('0', '7'), "^^^<A")
numericKeypad.add(('0', '8'), "^^^A")
numericKeypad.add(('0', '9'), "^^^>A")

numericKeypad.add(('1', 'A'), ">>vA")
numericKeypad.add(('1', '1'), "A")
numericKeypad.add(('1', '2'), ">A")
numericKeypad.add(('1', '3'), ">>A")
numericKeypad.add(('1', '4'), "^A")
numericKeypad.add(('1', '5'), "^>A")
numericKeypad.add(('1', '6'), "^>>A")
numericKeypad.add(('1', '7'), "^^A")
numericKeypad.add(('1', '8'), "^^>A")
numericKeypad.add(('1', '9'), "^^>>A")

numericKeypad.add(('2', 'A'), "v>A")
numericKeypad.add(('2', '0'), "vA")
numericKeypad.add(('2', '1'), "<A")
numericKeypad.add(('2', '2'), "A")
numericKeypad.add(('2', '3'), ">A")
numericKeypad.add(('2', '4'), "<^A")
numericKeypad.add(('2', '5'), "^A")
numericKeypad.add(('2', '6'), "^>A")
numericKeypad.add(('2', '7'), "^^<A")
numericKeypad.add(('2', '8'), "^^A")
numericKeypad.add(('2', '9'), ">^^A")

numericKeypad.add(('3', 'A'), "vA")
numericKeypad.add(('3', '0'), "v<A")
numericKeypad.add(('3', '1'), "<<A")
numericKeypad.add(('3', '2'), "<A")
numericKeypad.add(('3', '3'), "A")
numericKeypad.add(('3', '4'), "<<^A")
numericKeypad.add(('3', '5'), "<^A")
numericKeypad.add(('3', '6'), "^A")
numericKeypad.add(('3', '7'), "<<^^A")
numericKeypad.add(('3', '8'), "<^^A")
numericKeypad.add(('3', '9'), "^^A")

numericKeypad.add(('4', 'A'), ">>vvA")
numericKeypad.add(('4', '0'), ">vvA")
numericKeypad.add(('4', '1'), "vA")
numericKeypad.add(('4', '2'), ">vA")
numericKeypad.add(('4', '3'), ">>vA")
numericKeypad.add(('4', '4'), "A")
numericKeypad.add(('4', '5'), ">A")
numericKeypad.add(('4', '6'), ">>A")
numericKeypad.add(('4', '7'), "^A")
numericKeypad.add(('4', '8'), "^>A")
numericKeypad.add(('4', '9'), "^>>A")

numericKeypad.add(('5', 'A'), "vv>A")
numericKeypad.add(('5', '0'), "vvA")
numericKeypad.add(('5', '1'), "v<A")
numericKeypad.add(('5', '2'), "vA")
numericKeypad.add(('5', '3'), ">vA")
numericKeypad.add(('5', '4'), "<A")
numericKeypad.add(('5', '5'), "A")
numericKeypad.add(('5', '6'), ">A")
numericKeypad.add(('5', '7'), "^<A")
numericKeypad.add(('5', '8'), "^A")
numericKeypad.add(('5', '9'), "^>A")

numericKeypad.add(('6', 'A'), "vvA")
numericKeypad.add(('6', '0'), "vv<A")
numericKeypad.add(('6', '1'), "v<<A")
numericKeypad.add(('6', '2'), "v<A")
numericKeypad.add(('6', '3'), "vA")
numericKeypad.add(('6', '4'), "<<A")
numericKeypad.add(('6', '5'), "<A")
numericKeypad.add(('6', '6'), "A")
numericKeypad.add(('6', '7'), "^<<A")
numericKeypad.add(('6', '8'), "^<A")
numericKeypad.add(('6', '9'), "^A")

numericKeypad.add(('7', 'A'), ">>vvvA")
numericKeypad.add(('7', '0'), ">vvvA")
numericKeypad.add(('7', '1'), "vvA")
numericKeypad.add(('7', '2'), "vv>A")
numericKeypad.add(('7', '3'), "vv>>A")
numericKeypad.add(('7', '4'), "vA")
numericKeypad.add(('7', '5'), "v>A")
numericKeypad.add(('7', '6'), "v>>A")
numericKeypad.add(('7', '7'), "A")
numericKeypad.add(('7', '8'), ">A")
numericKeypad.add(('7', '9'), ">>A")

numericKeypad.add(('8', 'A'), "vvv>A")
numericKeypad.add(('8', '0'), "vvvA")
numericKeypad.add(('8', '1'), "vv<A")
numericKeypad.add(('8', '2'), "vvA")
numericKeypad.add(('8', '3'), "vv>A")
numericKeypad.add(('8', '4'), "v<A")
numericKeypad.add(('8', '5'), "vA")
numericKeypad.add(('8', '6'), "v>A")
numericKeypad.add(('8', '7'), "<A")
numericKeypad.add(('8', '8'), "A")
numericKeypad.add(('8', '9'), ">A")

numericKeypad.add(('9', 'A'), "vvvA")
numericKeypad.add(('9', '0'), "vvv<A")
numericKeypad.add(('9', '1'), "vv<<A")
numericKeypad.add(('9', '2'), "vv<A")
numericKeypad.add(('9', '3'), "vvA")
numericKeypad.add(('9', '4'), "v<<A")
numericKeypad.add(('9', '5'), "v<A")
numericKeypad.add(('9', '6'), "vA")
numericKeypad.add(('9', '7'), "<<A")
numericKeypad.add(('9', '8'), "<A")
numericKeypad.add(('9', '9'), "A")

# Direction keypad
#     +---+---+
#     | ^ | A |
# +---+---+---+
# | < | v | > |
# +---+---+---+
var directionKeypad = initTable[(char, char), string]()
directionKeypad.add(('A', 'A'), "A")
directionKeypad.add(('A', '^'), "<A")
directionKeypad.add(('A', '<'), "<<vA")
directionKeypad.add(('A', 'v'), "<vA")
directionKeypad.add(('A', '>'), "vA")

directionKeypad.add(('^', 'A'), ">A")
directionKeypad.add(('^', '^'), "A")
directionKeypad.add(('^', '<'), "<vA")
directionKeypad.add(('^', 'v'), "vA")
directionKeypad.add(('^', '>'), "v>A")

directionKeypad.add(('<', 'A'), ">>^A")
directionKeypad.add(('<', '^'), ">^A")
directionKeypad.add(('<', '<'), "A")
directionKeypad.add(('<', 'v'), ">A")
directionKeypad.add(('<', '>'), ">>A")

directionKeypad.add(('v', 'A'), ">^A")
directionKeypad.add(('v', '^'), "^A")
directionKeypad.add(('v', '<'), "<A")
directionKeypad.add(('v', 'v'), "A")
directionKeypad.add(('v', '>'), ">A")

directionKeypad.add(('>', 'A'), "^A")
directionKeypad.add(('>', '^'), "<^A")
directionKeypad.add(('>', '<'), "<<A")
directionKeypad.add(('>', 'v'), "<A")
directionKeypad.add(('>', '>'), "A")

proc expandStr(last: char, current: char, level, maxLevel: int): string =
    # Choose correct keyboard
    var keypad = directionKeypad
    if level == 0:
        keypad = numericKeypad

    let newCurrent = keypad[(last, current)]

    # Base case
    if level == maxLevel:
        return newCurrent
    
    var res = ""
    for i in 0..newCurrent.len-1:
        let newlast = if i == 0: 'A' else: newCurrent[i-1]
        res &= expandStr(newlast, newCurrent[i], level+1, maxLevel)
    return res

proc part1(data: seq[string], maxLevel: int): int =
    var sequences: seq[string] = @[]
    for line in data:
        #echo "Processing line: ", line
        var res = ""
        for i in 0..line.len-1:
            let last = if i == 0: 'A' else: line[i-1]
            res &= expandStr(last, line[i], 0, maxLevel)
        #echo "result: ", res
        sequences.add(res)

    var complexity = 0
    for i in 0..data.len-1:
        let numericPart = parseInt(data[i][0..^2])
        complexity += numericPart * sequences[i].len
    #echo "complexity: ", complexity
    return complexity

var seen = initTable[((char, char), int), int]()

proc expand(last: char, current: char, level, maxLevel: int): int =
    if ((last, current), level) in seen:
        return seen[((last, current), level)]
    # Choose correct keyboard
    var keypad = directionKeypad
    if level == 0:
        keypad = numericKeypad

    let newCurrent = keypad[(last, current)]

    # Base case
    if level == maxLevel:
        return newCurrent.len
    
    var res = 0
    for i in 0..newCurrent.len-1:
        let newlast = if i == 0: 'A' else: newCurrent[i-1]
        res += expand(newlast, newCurrent[i], level+1, maxLevel)
    
    seen[((last, current), level)] = res
    return res

proc part2(data: seq[string], maxLevel: int): int =
    var lengths: seq[int] = @[]
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
    echo "complexity: ", complexity
    # Too low: 11802275924930
    # Too low: 127410528607420
    # Too low: 169411820587508
    return complexity

proc main() =
    var data = strip(readFile("../inputs/day21.txt")).splitLines()

    let part1TestResult = part1(testData, 2)
    doAssert part1TestResult == 126384
    let part1Result = part1(data, 2)
    doAssert part1Result == 164960

    # Run part2 with same data should get same results
    #let part2TestResult = part2(testData, 2)
    #doAssert part2TestResult == 126384
    #let part2TestResult2 = part2(data, 2)
    #doAssert part2TestResult2 == 164960

    let part2Result = part2(data, 25)
    doAssert part2Result == -1

main()
#timeIt "day21":
#    main()