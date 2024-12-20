import times
import math
import strutils
import sequtils
import benchy
import tables
import heapqueue

let testData = """5,4
4,2
4,5
3,0
2,1
6,3
2,4
1,5
0,6
3,3
2,6
5,1
1,2
5,5
2,5
6,5
1,4
0,4
6,4
1,1
6,1
1,0
0,5
1,6
2,0""".splitLines()

let allDirs = [(-1, 0), (1, 0), (0, -1), (0, 1)]

proc `+`(a: (int, int), b: (int, int)): (int, int) =
    (a[0]+b[0], a[1]+b[1])

proc inBounds(pos: (int, int), w: int, h: int): bool =
    return pos[0] >= 0 and pos[1] >= 0 and pos[0] >= 0 and pos[0] < h and pos[1] < w

type Position = object
    score: int
    pos: (int, int)

proc `<`(a, b: Position): bool = a.score < b.score

proc part1(data: seq[string], amount, dim: int): int =
    var blockedPositions = initTable[(int, int), bool]()
    let
        w = dim
        h = dim
    for line in data:
        if blockedPositions.len == amount:
            break
        let
            a = parseInt(line.split(",")[0])
            b = parseInt(line.split(",")[1])
        blockedPositions[(a, b)] = true

    var startPos = (0, 0)
    let endPos = (h-1, w-1)
    var seen = initTable[(int, int), int]()

    var queue = initHeapQueue[Position]()
    queue.push(Position(score: 0, pos: startPos))

    while queue.len > 0:
        let currentPath = queue.pop()
        var score = currentPath.score
        let pos = currentPath.pos
        if pos == endPos:
            # echo "score: ", score
            return score
        # If there's a quicker way until here: abort, this can't be a solution
        if seen.hasKey(pos):
            if seen[pos] <= score:
                continue
        seen[pos] = score

        for dir in allDirs:
            let newPos = pos + dir
            if not blockedPositions.hasKey(newPos) and inBounds(newPos, w, h):
                queue.push(Position(score: score+1, pos: pos + dir))
    return -1
        

proc part2(data: seq[string], startAmount, dim: int): string =
    var idx = 0
    var amount = startAmount
    var lastSuccessful = amount
    var remaining = data.len - lastSuccessful

    # Find critical point with bisect
    while true:
        remaining = toInt(max(remaining / 2, 1))
        # echo "remaining:", remaining
        if part1(data, amount, dim) == -1:
            # echo "not solvable:", amount
            if lastSuccessful == amount-1:
                idx = amount-1
                break
            else:
                amount -= remaining
        else:
            # echo "still solvable:", amount
            lastSuccessful = amount
            amount += remaining
    # echo "Part 2:", data[idx]
    return data[idx]

proc main() =
    var data = strip(readFile("../inputs/day18.txt")).splitLines()

    let part1TestResult = part1(testData, 12, 7)
    doAssert part1TestResult == 22
    let part1Result = part1(data, 1024, 71)
    doAssert part1Result == 384

    let part2TestResult = part2(testData, 12, 7)
    doAssert part2TestResult == "6,1"
    let part2Result = part2(data, 1024, 71)
    doAssert part2Result == "36,10"

timeIt "day18":
    main()
