import math
import strutils
import benchy
import tables
import system
import heapqueue

let testData = """###############
#.......#....E#
#.#.###.#.###.#
#.....#.#...#.#
#.###.#####.#.#
#.#.#.......#.#
#.#.#####.###.#
#...........#.#
###.#.#####.#.#
#...#.....#.#.#
#.#.#.###.#.#.#
#.....#...#.#.#
#.###.#.#.#.#.#
#S..#.....#...#
###############""".splitLines()

proc `+`(a: (int, int), b: (int, int)): (int, int) =
    (a[0]+b[0], a[1]+b[1])

proc `-`(a: (int, int), b: (int, int)): (int, int) =
    (a[0]-b[0], a[1]-b[1])

let allDirs = [(-1, 0), (1, 0), (0, -1), (0, 1)]
let turnLeftMap = {(-1, 0): (0, -1), (1, 0): (0, 1), (0, -1): (1, 0), (0, 1): (-1, 0)}.toTable
let turnRightMap = {(-1, 0): (0, 1), (1, 0): (0, -1), (0, -1): (-1, 0), (0, 1): (1, 0)}.toTable

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
    # path: seq[char]
    pos: (int, int)
    dir: (int, int)


proc `<`(a, b: Path): bool = a.score < b.score

proc part1(data: seq[string]): int =
    var grid = parseInput(data)
    let h = grid.len
    let w = grid[0].len
    # printGrid(grid)
    var start = (h-2, 1)
    var seen = initTable[((int, int), (int, int)), bool]()

    var queue = initHeapQueue[Path]()
    queue.push(Path(score: 0, pos: start, dir: (0, 1)))
    queue.push(Path(score: 1000, pos: start, dir: (-1, 0)))

    while queue.len > 0:
        let currentPath = queue.pop()
        echo "currentPath: ", currentPath
        var score = currentPath.score
        let pos = currentPath.pos
        let dir = currentPath.dir
        if seen.hasKey((pos, dir)):
            continue
        else:
            seen[(pos, dir)] = true

        var currentPos = pos + dir
        score += 1
        while grid[currentPos[0]][currentPos[1]] != '#':
            # echo "currentPos: ", currentPos, " dir: ", dir
            if currentPos == (1, w-2):
                echo "found end! score: ", score
                return score
            elif currentPos == start:
                break
            #if grid[currentPos[0]][currentPos[1]] == 'E':
            #    return score
            #elif grid[currentPos[0]][currentPos[1]] == 'S':
            #    continue

            # Check left/right
            let turnLeft = turnLeftMap[dir]
            let leftPos = currentPos + turnLeft
            if grid[leftPos[0]][leftPos[1]] != '#':
                queue.push(Path(score: score+1000, pos: currentPos, dir: turnLeft))

            let turnRight = turnRightMap[dir]
            let rightPos = currentPos + turnRight
            if grid[rightPos[0]][rightPos[1]] != '#':
                queue.push(Path(score: score+1000, pos: currentPos, dir: turnRight))
            # Walk forward
            currentPos = currentPos + dir
            score += 1

        # Hit wall, add possible turns
        let turnLeft = turnLeftMap[dir]
        let leftPos = currentPos + turnLeft
        if grid[leftPos[0]][leftPos[1]] != '#':
            queue.push(Path(score: score+1000, pos: currentPos, dir: turnLeft))

        let turnRight = turnRightMap[dir]
        let rightPos = currentPos + turnRight
        if grid[rightPos[0]][rightPos[1]] != '#':
            queue.push(Path(score: score+1000, pos: currentPos, dir: turnRight))

    echo "error, queue empty :("
    return -1

proc part2(data: seq[string]): int =
    return -1


proc main() =
    var data = strip(readFile("../inputs/day16.txt")).splitLines()

    let part1TestResult = part1(testData)
    doAssert part1TestResult == 7036
    let part1Result = part1(data)
    doAssert part1Result == 66404

    let part2TestResult = part2(testData)
    doAssert part2TestResult == -1
    let part2Result = part2(data)
    doAssert part2Result == -1

main()

#timeIt "day16":
#    main()
