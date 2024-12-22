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
numericKeypad.add(('A', '0'), "<A")
numericKeypad.add(('A', '1'), "^<<A")
numericKeypad.add(('A', '2'), "^<A")
numericKeypad.add(('A', '3'), "^A")
numericKeypad.add(('A', '4'), "^^<<A")
numericKeypad.add(('A', '5'), "^^<A")
numericKeypad.add(('A', '6'), "^^A")
numericKeypad.add(('A', '7'), "^^^<<A")
numericKeypad.add(('A', '8'), "^^^<A")
numericKeypad.add(('A', '9'), "^^^A")

numericKeypad.add(('0', '1'), "^<A")
numericKeypad.add(('0', '2'), "^A")
numericKeypad.add(('0', '3'), "^>A")
numericKeypad.add(('0', '4'), "^^<A")
numericKeypad.add(('0', '5'), "^^A")
numericKeypad.add(('0', '6'), "^^>A")
numericKeypad.add(('0', '7'), "^^^<A")
numericKeypad.add(('0', '8'), "^^^A")
numericKeypad.add(('0', '9'), "^^^>A")

numericKeypad.add(('1', '2'), ">A")
numericKeypad.add(('1', '3'), ">>A")
numericKeypad.add(('1', '4'), "^A")
numericKeypad.add(('1', '5'), "^>A")
numericKeypad.add(('1', '6'), "^>>A")
numericKeypad.add(('1', '7'), "^^A")
numericKeypad.add(('1', '8'), "^^>A")
numericKeypad.add(('1', '9'), "^^>>A")

numericKeypad.add(('2', '3'), "")
numericKeypad.add(('2', '4'), "")
numericKeypad.add(('2', '5'), "")
numericKeypad.add(('2', '6'), "")
numericKeypad.add(('2', '7'), "")
numericKeypad.add(('2', '8'), "")
numericKeypad.add(('2', '9'), "")

# TODO

# Direction keypad
#     +---+---+
#     | ^ | A |
# +---+---+---+
# | < | v | > |
# +---+---+---+
var directionKeypad = initTable[(char, char), string]()
directionKeypad.add(('A', '^'), "<A")
directionKeypad.add(('A', '<'), "v<<A")
directionKeypad.add(('A', 'v'), "v<A")
directionKeypad.add(('A', '>'), "vA")

directionKeypad.add(('^', '<'), "v<A")
directionKeypad.add(('^', 'v'), "vA")
directionKeypad.add(('^', '>'), "v>A")

directionKeypad.add(('<', 'v'), ">A")
directionKeypad.add(('<', '>'), ">>A")

directionKeypad.add(('v', '>'), ">A")


var seen = initTable[char, int]()

proc expand(last: char, current: char, level: int): string =
    if level == 2:
        # use numeric keypad
        if (last, current) in numericKeypad:
            return numericKeypad[(last, current)]
        else:
            # TODO reverse?
            return numericKeypad[(current, last)]
    else:
        # use direction keypad
        var newCurrent = ""
        if (last, current) in numericKeypad:
            newCurrent = directionKeypad[(last, current)]
        else:
            newCurrent = directionKeypad[(current, last)]
        
        var newExpanded = ""
        for i in 0..newCurrent.len-1:
            if i == 0:
                newExpanded &= expand(last, newCurrent[i], level+1)
            else:
                newExpanded &= expand(newCurrent[i-1], newCurrent[i], level+1)
        return newExpanded
        

proc part1(data: seq[string]): int =
    var sequences: seq[string] = @[]
    for line in data:
        echo "Processing line: ", line
        var current = line
        var next = ""
        for i in 0..current.len-1:
            if i == 0:
                next &= expand('A', current[i], 2)
            else:
                next &= expand(current[i-1], current[i], 2)
        echo " next: ", next
        current = next
        sequences.add(current)

    var complexity = 0
    for i in 0..data.len-1:
        let numericPart = parseInt(data[i][0..^2])
        complexity += numericPart * sequences[i].len
    echo "complexity: ", complexity

    return complexity


proc part2(data: seq[string]): int =
    return 0

proc main() =
    var data = strip(readFile("../inputs/day21.txt")).splitLines()

    let part1TestResult = part1(testData)
    doAssert part1TestResult == 126384
    let part1Result = part1(data)
    doAssert part1Result == -1

    let part2TestResult = part2(testData)
    doAssert part2TestResult == -1
    let part2Result = part2(data)
    doAssert part2Result == -1

main()
#timeIt "day20":
#    main()
