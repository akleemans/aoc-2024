import strutils
import sequtils
import benchy
import tables

let testData = """RRRRIICCFF
RRRRIICCCF
VVRRRCCFFF
VVRCCCJFFF
VVVVCJJCFE
VVIVCCJJEE
VVIIICJJEE
MIIIIIJJEE
MIIISIJEEE
MMMISSJEEE""".splitLines()

proc `+`(a: (int, int), b: (int, int)): (int, int) =
    (a[0]+b[0], a[1]+b[1])

proc `-`(a: (int, int), b: (int, int)): (int, int) =
    (a[0]-b[0], a[1]-b[1])

let allDirs = [(-1, 0), (1, 0), (0, -1), (0, 1)]

proc inBounds(pos: (int, int), w: int, h: int): bool =
    return pos[0] >= 0 and pos[1] >= 0 and pos[0] >= 0 and pos[0] < h and pos[1] < w

proc part1(data: seq[string]): int =
    var areas: seq[seq[(int, int)]] = @[]
    var seen = initTable[(int, int), bool]()
    let h = data.len
    let w = data[0].len
    
    # Collect areas
    for row in 0..h-1:
        for col in 0..w-1:
            let pos = (row, col)
            if not seen.hasKey(pos):
                seen[pos] = true
                var area: seq[(int, int)] = @[pos]
                var idx = 0

                while idx < area.len:
                    let currentPos = area[idx]
                    for dir in allDirs:
                        let newPos = currentPos + dir
                        if inBounds(newPos, w, h) and newPos notin area and data[row][col] == data[newPos[0]][newPos[1]]:
                            seen[newPos] = true
                            area.add(newPos)
                    idx += 1
                areas.add(area)
    
    # Calculate price
    var totalPrice = 0
    for area in areas:
        var perimeter = 0
        for pos in area:
            var posPerimeter = 0
            for dir in allDirs:
                if pos + dir notin area:
                    posPerimeter += 1
            perimeter += posPerimeter
        totalPrice += area.len * perimeter

    # echo "totalPrice: ", totalPrice
    return totalPrice

proc part2(data: seq[string]): int =
    var areas: seq[seq[(int, int)]] = @[]
    var seen = initTable[(int, int), bool]()
    let h = data.len
    let w = data[0].len
    
    # Collect areas
    for row in 0..h-1:
        for col in 0..w-1:
            let pos = (row, col)
            if not seen.hasKey(pos):
                seen[pos] = true
                var area: seq[(int, int)] = @[pos]
                var idx = 0

                while idx < area.len:
                    let currentPos = area[idx]
                    for dir in allDirs:
                        let newPos = currentPos + dir
                        if inBounds(newPos, w, h) and newPos notin area and data[row][col] == data[newPos[0]][newPos[1]]:
                            seen[newPos] = true
                            area.add(newPos)
                    idx += 1
                areas.add(area)
    
    # Calculate price
    var totalPrice = 0
    for area in areas:
        var ignored = initTable[((int, int), (int, int)), bool]()
        var sides: seq[((int, int), (int, int))] = @[]
        for pos in area:
            for dir in allDirs:
                if pos + dir notin area:
                    sides.add((pos, pos+dir))

        # Reduce sides: remove horizontally & vertically
        for side in sides:
            let (a, b) = side
            echo "side: ", side
            if ignored.hasKey(side):
                echo "already on known side: ", side
                continue
            # Same row, vertical
            if a[0] == b[0]:
                # down
                var newSide = (a + (1, 0), b + (1, 0))
                while newSide in sides:
                    ignored[newSide] = true
                    newSide = (newSide[0] + (1, 0), newSide[1] + (1, 0))
                # up
                newSide = (a - (1, 0), b - (1, 0))
                while newSide in sides:
                    ignored[newSide] = true
                    newSide = (newSide[0] - (1, 0), newSide[1] - (1, 0))
            else:
                # right
                var newSide = (a + (0, 1), b + (0, 1))
                while newSide in sides:
                    ignored[newSide] = true
                    newSide = (newSide[0] + (0, 1), newSide[1] + (0, 1))
                # left
                newSide = (a - (0, 1), b - (0, 1))
                while newSide in sides:
                    ignored[newSide] = true
                    newSide = (newSide[0] - (0, 1), newSide[1] - (0, 1))

        let areaPrice = area.len * (sides.len - ignored.len)
        echo "areaPrice:", area.len, " x ", sides.len - ignored.len, " = ", areaPrice
        totalPrice += areaPrice

    echo "totalPrice: ", totalPrice
    return totalPrice

proc main() =
    var data = strip(readFile("../inputs/day12.txt")).splitLines()

    let part1TestResult = part1(testData)
    doAssert part1TestResult == 1930
    let part1Result = part1(data)
    doAssert part1Result == 1396562

    let part2TestResult = part2(testData)
    doAssert part2TestResult == 1206
    let part2Result = part2(data)
    doAssert part2Result == 844132

main()
#timeIt "day11":
#    main()