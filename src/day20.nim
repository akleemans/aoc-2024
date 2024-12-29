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

let testData = """###############
#...#...#.....#
#.#.#.#.#.###.#
#S#...#.#.#...#
#######.#.#.###
#######.#.#...#
#######.#.###.#
###..E#...#...#
###.#######.###
#...###...#...#
#.#####.#.###.#
#.#...#.#.#...#
#.#.#.#.#.#.###
#...#...#...###
###############""".splitLines()

proc `+`(a: (int, int), b: (int, int)): (int, int) =
    (a[0]+b[0], a[1]+b[1])

proc `-`(a: (int, int), b: (int, int)): (int, int) =
    (a[0]-b[0], a[1]-b[1])

proc inBounds(pos: (int, int), w: int, h: int): bool =
    return pos[0] >= 0 and pos[1] >= 0 and pos[0] >= 0 and pos[0] < h and pos[1] < w

let allDirs = [(-1, 0), (1, 0), (0, -1), (0, 1)]

proc parseInput(data: seq[string]): seq[seq[char]] =
    var grid: seq[seq[char]] = @[]
    for line in data:
        var row: seq[char] = @[]
        for c in line:
            row.add(c)
        grid.add(row)
    return grid

proc printGrid(grid: seq[seq[char]]): void =
    for line in grid:
        for c in line:
            stdout.write(c)
        stdout.write("\n")

proc dijkstra(grid: seq[seq[char]], startPos, endPos: (int, int)): seq[(int, int)] =
    let h = grid.len
    let w = grid[0].len

    # Find best path
    var seen = initTable[(int, int), int]()
    var queue = initHeapQueue[((int, int), int)]()
    queue.push((startPos, 0))
    while queue.len > 0:
        let (pos, dist) = queue.pop()
        # If there's a quicker way until here: abort, this can't be a solution
        if pos in seen:
            continue
        seen[pos] = dist
        
        if pos == endPos:
            break

        for dir in allDirs:
            var nextPos = pos + dir
            if grid[nextPos[0]][nextPos[1]] != '#' and nextPos notin seen:
                queue.push((nextPos, dist + 1))

    # Solution found, collect path
    var solution: seq[(int, int)] = @[startPos]
    var currentPos = startPos
    var currentScore = seen[startPos]
    while true:
        if currentPos == endPos:
            break
        for dir in allDirs:
            var nextPos = currentPos + dir
            if nextPos in seen and seen[nextPos] == currentScore+1:
                solution.add(nextPos)
                currentPos = nextPos
                currentScore += 1
                break
    return solution

proc part1(data: seq[string], minTimeSave: int): int =
    var grid = parseInput(data)
    let h = grid.len
    let w = grid[0].len

    # Find start, end
    var startPos: (int, int)
    var endPos: (int, int)
    for r in 0..h-1:
        for c in 0..w-1:
            if grid[r][c] == 'S':
                startPos = (r, c)
            if grid[r][c] == 'E':
                endPos = (r, c)

    let solution = dijkstra(grid, startPos, endPos)

    # Initialize lookup table for pos > score
    var pathScoreTable = initTable[(int, int), int]()
    var count = 0
    for pos in solution:
        pathScoreTable[pos] = count
        count += 1

    # Check cheats
    var cheats: seq[int] = @[]
    for pos in solution:
        let score = pathScoreTable[pos]
        for dir in allDirs:
            var wall = pos + dir
            if grid[wall[0]][wall[1]] == '#':
                var possibleShortcut = wall+dir
                if possibleShortcut in pathScoreTable and pathScoreTable[possibleShortcut] > score+1:
                    cheats.add(pathScoreTable[possibleShortcut]-score-2)

    # Filter
    let res = cheats.filter(proc (x: int): bool = x >= minTimeSave).len
    # echo "Found ", res, " ways to save ", minTimeSave, " picoseconds"
    return res

proc dist(pos: (int, int)): int =
    return abs(pos[0]) + abs(pos[1])

proc part2(data: seq[string], minTimeSave: int): int =
    var grid = parseInput(data)
    let h = grid.len
    let w = grid[0].len

    # Find start, end
    var startPos: (int, int)
    var endPos: (int, int)
    for r in 0..h-1:
        for c in 0..w-1:
            if grid[r][c] == 'S':
                startPos = (r, c)
            if grid[r][c] == 'E':
                endPos = (r, c)

    let solution = dijkstra(grid, startPos, endPos)

    # Initialize lookup table for pos > score
    var pathScoreTable = initTable[(int, int), int]()
    var count = 0
    for pos in solution:
        pathScoreTable[pos] = count
        count += 1

    var cheatCount = 0
    for pos in solution:
        let score = pathScoreTable[pos]
        let leftUpperCorner = pos - (20, 20)
        for rowDiff in 0..41:
            for colDiff in 0..41:
                let newPos = leftUpperCorner + (rowDiff, colDiff)
                if newPos == pos or not inBounds(newPos, w, h):
                    continue
                #echo "...checking ", newPos
                let distFromPos = newPos - pos
                if dist(distFromPos) <= 20 and newPos in pathScoreTable:
                    let scoreDiff = pathScoreTable[newPos] - score - dist(distFromPos)
                    if scoreDiff >= minTimeSave:
                        # echo "found cheat of ", scoreDiff, " from ", score, " to ", pathScoreTable[newPos], " newPos: ", newPos
                        cheatCount += 1

    # echo "cheatCount: ", cheatCount
    return cheatCount

proc main() =
    var data = strip(readFile("../inputs/day20.txt")).splitLines()

    let part1TestResult = part1(testData, 10)
    doAssert part1TestResult == 10
    let part1Result = part1(data, 100)
    doAssert part1Result == 1399

    let part2TestResult = part2(testData, 70)
    doAssert part2TestResult == 41
    let part2Result = part2(data, 100)
    doAssert part2Result == 994807

timeIt "day20":
    main()
