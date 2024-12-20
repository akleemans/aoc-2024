import math
import strutils
import benchy
import tables
import system

let testData = """##########
#..O..O.O#
#......O.#
#.OO..O.O#
#..O@..O.#
#O#..O...#
#O..O..O.#
#.OO.O.OO#
#....O...#
##########

<vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
<<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
>^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
<><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^""".splitLines()

proc `+`(a: (int, int), b: (int, int)): (int, int) =
    (a[0]+b[0], a[1]+b[1])

proc `-`(a: (int, int), b: (int, int)): (int, int) =
    (a[0]-b[0], a[1]-b[1])

let allDirs = [(-1, 0), (1, 0), (0, -1), (0, 1)]
let dirMap = {'^': (-1, 0), 'v': (1, 0), '>': (0, 1), '<': (0, -1)}.toTable

proc parseInput(data: seq[string]): (seq[seq[char]], string) =
    var grid: seq[seq[char]] = @[]
    var moves = ""
    var parsingGrid = true
    for line in data:
        if line.len == 0:
            parsingGrid = false

        if parsingGrid:
            var row: seq[char] = @[]
            for c in line:
                row.add(c)
            grid.add(row)
        else:
            moves = moves & line
    return (grid, moves)

proc printGrid(grid: seq[seq[char]]): void =
    for line in grid:
        for c in line:
            stdout.write(c)
        stdout.write("\n")

proc printGrid(grid: seq[seq[char]], pos: (int, int)): void =
    for row in 0..grid.len-1:
        for col in 0..grid[0].len-1:
            if (row, col) == pos:
                stdout.write('@')
            else:
                stdout.write(grid[row][col])
        stdout.write("\n")

proc getGpsSum(grid: seq[seq[char]]): int =
    var gpsSum = 0
    var rowCount = 0
    for row in grid:
        var colCount = 0
        for c in row:
            if c == 'O' or c == '[':
                gpsSum += rowCount+colCount
            colCount += 1
        rowCount += 100
    return gpsSum


proc part1(data: seq[string]): int =
    var (grid, moves) = parseInput(data)
    let h = grid.len
    let w = grid[0].len
    # printGrid(grid)
    var start = (-1, -1)
    # Start position
    for r in 0..grid.len-1:
        for c in 0..grid[0].len-1:
            if grid[r][c] == '@':
                grid[r][c] = '.'
                start = (r, c)
                break
        if start != (-1, -1):
            break

    # Move boxes
    var pos = start
    for move in moves:
        var dir = dirMap[move]
        var newPos = pos + dir

        # Wall
        if grid[newPos[0]][newPos[1]] == '#':
            continue
        # Empty
        elif grid[newPos[0]][newPos[1]] == '.':
            pos = newPos
        # Box
        else:
            var afterBox = newPos
            while grid[afterBox[0]][afterBox[1]] == 'O':
                afterBox = afterBox + dir
            # Check if free
            if grid[afterBox[0]][afterBox[1]] == '.':
                grid[newPos[0]][newPos[1]] = '.'
                grid[afterBox[0]][afterBox[1]] = 'O'
                pos = newPos

    let gpsSum = getGpsSum(grid)
    # echo "gpsSum: ", gpsSum
    return gpsSum

proc parseInput2(data: seq[string]): (seq[seq[char]], string) =
    var grid: seq[seq[char]] = @[]
    var moves = ""
    var parsingGrid = true
    for line in data:
        if line.len == 0:
            parsingGrid = false
        if parsingGrid:
            var row: seq[char] = @[]
            for c in line:
                if c == 'O':
                    row.add('[')
                    row.add(']')
                elif c == '@':
                    row.add('@')
                    row.add('.')
                else:
                    # '#' or '
                    row.add(c)
                    row.add(c)
            grid.add(row)
        else:
            moves = moves & line
    return (grid, moves)

proc part2(data: seq[string]): int =
    var (grid, moves) = parseInput2(data)
    let h = grid.len
    let w = grid[0].len

    var start = (-1, -1)
    # Start position
    for r in 0..grid.len-1:
        for c in 0..grid[0].len-1:
            if grid[r][c] == '@':
                grid[r][c] = '.'
                start = (r, c)
                break
        if start != (-1, -1):
            break

    # Move boxes
    var pos = start
    for move in moves:
        # Print grid for current state
        #echo "move: ", move, ", pos: ", pos, ", map: "
        #printGrid(grid, pos)
        #let temp = readLine(stdin)

        # Nexr move
        var dir = dirMap[move]
        var newPos = pos + dir

        # Wall
        if grid[newPos[0]][newPos[1]] == '#':
            continue
        # Empty
        elif grid[newPos[0]][newPos[1]] == '.':
            pos = newPos
        # Box
        else:
            # left, right
            if dir == (0, -1) or dir == (0, 1):
                #echo "Checking left/right boxes"
                #printGrid(grid)
                var afterBox = newPos
                while grid[afterBox[0]][afterBox[1]] == '[' or grid[afterBox[0]][afterBox[1]] == ']':
                    afterBox = afterBox + dir

                # Check if free
                if grid[afterBox[0]][afterBox[1]] == '.':
                    # printGrid(grid)
                    var lastPos = afterBox
                    var secondToLast = afterBox - dir
                    # Subsequently move one char by one
                    #echo "moving boxes horizontally"
                    while lastPos != newPos:
                        # echo "moving:", grid[secondToLast[0]][secondToLast[1]]
                        grid[lastPos[0]][lastPos[1]] = grid[secondToLast[0]][secondToLast[1]]
                        secondToLast = secondToLast - dir
                        lastPos = lastPos - dir

                    #echo "...finished"
                    grid[newPos[0]][newPos[1]] = '.'
                    pos = newPos
                    #echo "After moving:"
                    #printGrid(grid)
                    #let i = readLine(stdin)
            else:
                #echo "Checking up/down boxes"
                #printGrid(grid)
                # Stack of boxes (marked by their starting coordinate)
                var boxStack: seq[(int, int)] = @[]
                var testPos = newPos
                if grid[testPos[0]][testPos[1]] == '[':
                    boxStack.add(testPos)
                else:
                    boxStack.add(testPos - (0, 1))
                # Move through stack and check if boxes movable
                var possible = true
                var idx = 0
                while idx <= boxStack.len-1:
                    let nextPos = boxStack[idx] + dir
                    if grid[nextPos[0]][nextPos[1]] == '#' or grid[nextPos[0]][nextPos[1]+1] == '#':
                        possible = false
                        break
                    if grid[nextPos[0]][nextPos[1]] == '[':
                        boxStack.add(nextPos)
                    else:
                        # Possible two boxes above
                        if grid[nextPos[0]][nextPos[1]] == ']':
                            boxStack.add(nextPos - (0, 1))
                        if grid[nextPos[0]][nextPos[1]+1] == '[':
                            boxStack.add(nextPos + (0, 1))
                    idx += 1
                #echo "boxStack: ", boxStack, ", possible: ", possible

                if not possible:
                    continue

                # Move back through stack and move boxes
                idx = boxStack.len-1
                while idx >= 0:
                    let currentPos = boxStack[idx]
                    grid[currentPos[0]][currentPos[1]] = '.'
                    grid[currentPos[0]][currentPos[1]+1] = '.'
                    
                    let futurePos = currentPos + dir
                    grid[futurePos[0]][futurePos[1]] = '['
                    grid[futurePos[0]][futurePos[1]+1] = ']'
                    idx -= 1

                pos = newPos

                #echo "After moving:"
                #printGrid(grid)
                #let temp = readLine(stdin)

    let gpsSum = getGpsSum(grid)
    # echo "gpsSum: ", gpsSum
    return gpsSum

proc main() =
    var data = strip(readFile("../inputs/day15.txt")).splitLines()

    let part1TestResult = part1(testData)
    doAssert part1TestResult == 10092
    let part1Result = part1(data)
    doAssert part1Result == 1446158

    let part2TestResult = part2(testData)
    doAssert part2TestResult == 9021
    let part2Result = part2(data)
    doAssert part2Result == 1446175

timeIt "day15":
    main()
