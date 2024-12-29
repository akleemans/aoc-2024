import math
import strutils
import sequtils
import benchy
import tables
import system
import heapqueue
import sets

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

type Path = object
    score: int
    pos: (int, int)
    path: seq[((int, int), int)] = @[]


proc `<`(a, b: Path): bool = a.score < b.score

proc part1(data: seq[string], minTimeSave: int): int =
    var grid = parseInput(data)
    let h = grid.len
    let w = grid[0].len

    # Find start, end
    var startPos = (-1, -1)
    var endPos  = (-1, -1)
    for r in 0..h-1:
        for c in 0..w-1:
            if grid[r][c] == 'S':
                startPos = (r, c)
            if grid[r][c] == 'E':
                endPos = (r, c)

    # Find best path
    var solution: seq[((int, int), int)] = @[]
    var seen = initTable[(int, int), int]()
    var queue = initHeapQueue[Path]()
    queue.push(Path(score: 0, pos: startPos, path: @[(startPos, 0)]))
    while queue.len > 0:
        let currentPath = queue.pop()
        var score = currentPath.score
        let pos = currentPath.pos
        if pos == endPos:
            solution = currentPath.path
            break

        # If there's a quicker way until here: abort, this can't be a solution
        if pos in seen:
            continue
        seen[pos] = score
        
        score += 1
        for dir in allDirs:
            var path = currentPath.path
            var nextPos = pos + dir
            if grid[nextPos[0]][nextPos[1]] != '#' and nextPos notin seen:
                path.add((nextPos, score))
                queue.push(Path(score: score, pos: nextPos, path: path))
    # echo "found best solution with length ", solution[^1][1]

    # Check cheats
    var pathScoreTable = initTable[(int, int), int]()
    for (pos, score) in solution:
        pathScoreTable[pos] = score

    var cheats: seq[int] = @[]
    for (pos, score) in solution:
        for dir in allDirs:
            var wall = pos + dir
            if grid[wall[0]][wall[1]] == '#':
                var possibleShortcut = wall+dir
                if possibleShortcut in pathScoreTable and pathScoreTable[possibleShortcut] > score+1:
                    cheats.add(pathScoreTable[possibleShortcut]-score-2)

    # Filter
    # echo "all cheats: ", cheats
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
    var startPos = (-1, -1)
    var endPos  = (-1, -1)
    for r in 0..h-1:
        for c in 0..w-1:
            if grid[r][c] == 'S':
                startPos = (r, c)
            if grid[r][c] == 'E':
                endPos = (r, c)

    # Find best path
    var solution: seq[((int, int), int)] = @[]
    var seen = initTable[(int, int), int]()
    var queue = initHeapQueue[Path]()
    queue.push(Path(score: 0, pos: startPos, path: @[(startPos, 0)]))
    while queue.len > 0:
        let currentPath = queue.pop()
        var score = currentPath.score
        let pos = currentPath.pos
        if pos == endPos:
            solution = currentPath.path
            break

        # If there's a quicker way until here: abort, this can't be a solution
        if pos in seen:
            continue
        seen[pos] = score
        
        score += 1
        for dir in allDirs:
            var path = currentPath.path
            var nextPos = pos + dir
            if grid[nextPos[0]][nextPos[1]] != '#' and nextPos notin seen:
                path.add((nextPos, score))
                queue.push(Path(score: score, pos: nextPos, path: path))
    # echo "found best solution with length ", solution[^1][1]

    # Check cheats
    var pathScoreTable = initTable[(int, int), int]()
    for (pos, score) in solution:
        pathScoreTable[pos] = score

    var cheatCount = 0
    for (pos, score) in solution:
        # echo "pos: ", pos
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
