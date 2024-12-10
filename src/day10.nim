import math
import strutils
import benchy
import tables
import system

let testData = """89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732""".splitLines()

proc `+`(a: (int, int), b: (int, int)): (int, int) =
    (a[0]+b[0], a[1]+b[1])

proc `-`(a: (int, int), b: (int, int)): (int, int) =
    (a[0]-b[0], a[1]-b[1])

proc inBounds(pos: (int, int), w: int, h: int): bool =
    return pos[0] >= 0 and pos[1] >= 0 and pos[0] >= 0 and pos[0] < h and pos[1] < w

let allDirs = [(-1, 0), (1, 0), (0, -1), (0, 1)]

proc part1(data: seq[string]): int =
    var uniqueLocations = newSeq[(int, int)]()
    let h = data.len
    let w = data[0].len
    var startPositions: seq[(int, int)] = @[]

    # Get starting points
    for row in 0..h-1:
        for col in 0..w-1:
            if data[row][col] == '0':
                startPositions.add((row, col))

    var trailheadSum = 0
    for startPos in startPositions:
        #echo "starting at ", startPos
        var queue: seq[((int, int), int)] = @[(startPos, 0)]
        var reachableTops: seq[(int, int)] = @[]
        while queue.len > 0:
            let entry = queue.pop()
            let pos = entry[0]
            let value = entry[1]
            # Try all dirs:
            for d in allDirs:
                let newPos = (pos[0], pos[1]) + d
                if inBounds(newPos, w, h) and parseInt($data[newPos[0]][newPos[1]]) == value + 1:
                    if value + 1 == 9:
                        if newPos notin reachableTops:
                            reachableTops.add(newPos)
                    else:
                        queue.add((newPos, value + 1))
            #echo "queue: ", queue
        #echo "reachableTops: ", reachableTops
        trailheadSum += reachableTops.len


    #echo "trailheadSum: ", trailheadSum
    return trailheadSum

proc part2(data: seq[string]): int =
    var uniqueLocations = newSeq[(int, int)]()
    let h = data.len
    let w = data[0].len
    var startPositions: seq[(int, int)] = @[]

    # Get starting points
    for row in 0..h-1:
        for col in 0..w-1:
            if data[row][col] == '0':
                startPositions.add((row, col))

    var trailheadRatingSum = 0
    for startPos in startPositions:
        #echo "starting at ", startPos
        var queue: seq[seq[(int, int)]] = @[@[startPos]]
        var pathsToReachTop: seq[seq[(int, int)]] = @[]
        while queue.len > 0:
            let path = queue.pop()
            let pos = path[^1]
            let lastValue = parseInt($data[pos[0]][pos[1]])
            # Try all dirs:
            for d in allDirs:
                let newPos = (pos[0], pos[1]) + d
                if inBounds(newPos, w, h) and parseInt($data[newPos[0]][newPos[1]]) == lastValue + 1:
                    var newPath = path[0..^1]
                    newPath.add(newPos)
                    if lastValue + 1 == 9:
                        if newPath notin pathsToReachTop:
                            pathsToReachTop.add(newPath)
                    else:
                        queue.add(newPath)
        #echo "pathsToReachTop: ", pathsToReachTop
        trailheadRatingSum += pathsToReachTop.len

    #echo "trailheadRatingSum: ", trailheadRatingSum
    return trailheadRatingSum

proc main() =
    var data = strip(readFile("../inputs/day10.txt")).splitLines()

    let part1TestResult = part1(testData)
    doAssert part1TestResult == 36
    let part1Result = part1(data)
    doAssert part1Result == 517

    let part2TestResult = part2(testData)
    doAssert part2TestResult == 81
    let part2Result = part2(data)
    doAssert part2Result == 1116

timeIt "day10":
    main()
