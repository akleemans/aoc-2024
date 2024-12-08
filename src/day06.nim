import math
import strutils
import benchy
import tables
import sequtils
import sets

let testData = """....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...""".splitLines()

proc inBounds(pos: (int, int), w: int, h: int): bool =
    return pos[0] >= 0 and pos[1] >= 0 and pos[0] >= 0 and pos[0] < h and pos[1] < w

proc `+`(a: (int, int), b: (int, int)): (int, int) =
    (a[0]+b[0], a[1]+b[1])

proc rotate(dir: (int, int)): (int, int) =
    if dir == (1, 0): # down
        return (0, -1)
    elif dir == (-1, 0): # up
        return (0, 1)
    elif dir == (0, 1): # right
        return (1, 0)
    else: # left
        return (-1, 0)

proc part1(data: seq[string]): int =
    let w = data[0].len
    let h = data.len
    var startPos = (0, 0)
    for row in 0..h-1:
        for col in 0..w-1:
            if data[row][col] == '^':
                startPos = (row, col)

    var visited: seq[(int, int)] = @[startPos]
    var currentDir = (-1, 0) # starting upwards
    var currentPos = startPos
    while true:
        # Check next pos
        let nextPos = currentPos + currentDir
        if not inBounds(nextPos, w, h):
            break

        # Check if obstacle
        if data[nextPos[0]][nextPos[1]] == '#':
            currentDir = rotate(currentDir)
            currentPos = currentPos + currentDir
        else:
            currentPos = nextPos

        # Add to visited
        if currentPos notin visited:
            visited.add(currentPos)

    # echo "visited: ", visited.len
    return visited.len

proc part2(data: seq[string]): int =
    let w = data[0].len
    let h = data.len
    var startPos = (0, 0)
    for row in 0..h-1:
        for col in 0..w-1:
            if data[row][col] == '^':
                startPos = (row, col)

    var visited: seq[(int, int)] = @[startPos]
    var currentDir = (-1, 0) # starting upwards
    var currentPos = startPos
    while true:
        # Check next pos
        let nextPos = currentPos + currentDir
        if not inBounds(nextPos, w, h):
            break

        # Check if obstacle
        if data[nextPos[0]][nextPos[1]] == '#':
            currentDir = rotate(currentDir)
            currentPos = currentPos + currentDir
        else:
            currentPos = nextPos

        # Add to visited
        if currentPos notin visited:
            visited.add(currentPos)

    var count = 0
    for blockerPos in visited:
        var visited2: seq[((int, int), (int, int))] = @[]
        currentDir = (-1, 0) # starting upwards
        currentPos = startPos
        while true:
            # Check next pos
            let nextPos = currentPos + currentDir
            if not inBounds(nextPos, w, h):
                break

            # Check if obstacle
            if data[nextPos[0]][nextPos[1]] == '#' or nextPos == blockerPos:
                visited2.add((currentPos, currentDir))
                let nextTryPos = currentPos + rotate(currentDir)
                if data[nextTryPos[0]][nextTryPos[1]] == '#' or nextTryPos == blockerPos:
                    currentDir = rotate(rotate(currentDir))
                else:
                    currentDir = rotate(currentDir)
                    currentPos = currentPos + currentDir
            else:
                currentPos = nextPos

            # Add to visited
            if (currentPos, currentDir) in visited2:
                count += 1
                break

    # echo "count: ", count
    return count


proc main() =
    var data = strip(readFile("../inputs/day06.txt")).splitLines()

    let part1TestResult = part1(testData)
    doAssert part1TestResult == 41
    let part1Result = part1(data)
    doAssert part1Result == 4964

    let part2TestResult = part2(testData)
    doAssert part2TestResult == 6
    let part2Result = part2(data)
    doAssert part2Result == 1740

timeIt "day06":
    main()
