import math
import strutils
import benchy
import tables
import system

let testData = """............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............""".splitLines()

proc `+`(a: (int, int), b: (int, int)): (int, int) =
    (a[0]+b[0], a[1]+b[1])

proc `-`(a: (int, int), b: (int, int)): (int, int) =
    (a[0]-b[0], a[1]-b[1])

proc inBounds(pos: (int, int), w: int, h: int): bool =
    return pos[0] >= 0 and pos[1] >= 0 and pos[0] >= 0 and pos[0] < h and pos[1] < w

proc part1(data: seq[string]): int =
    var uniqueLocations = newSeq[(int, int)]()
    let h = data.len
    let w = data[0].len
    var antennaFrequencies = initTable[char, seq[(int, int)]]()
    # Gather locations by frequency
    for row in 0..h-1:
        for col in 0..w-1:
            let a = data[row][col]
            if a != '.':
                if not antennaFrequencies.hasKey(a):
                    antennaFrequencies[a] = @[]
                antennaFrequencies[a].add((row, col))

    for k, v in antennaFrequencies.mpairs:
        for pos1 in v:
            for pos2 in v:
                if pos1 != pos2:
                    let newPos = pos1 + (pos1 - pos2)
                    if inBounds(newPos, w, h) and newPos notin uniqueLocations:
                        uniqueLocations.add(newPos)

    # echo "Found uniqueLocations: ", uniqueLocations.len
    return uniqueLocations.len

proc part2(data: seq[string]): int =
    var uniqueLocations = newSeq[(int, int)]()
    let h = data.len
    let w = data[0].len
    var antennaFrequencies = initTable[char, seq[(int, int)]]()
    # Gather locations by frequency
    for row in 0..h-1:
        for col in 0..w-1:
            let a = data[row][col]
            if a != '.':
                if not antennaFrequencies.hasKey(a):
                    antennaFrequencies[a] = @[]
                antennaFrequencies[a].add((row, col))

    for k, v in antennaFrequencies.mpairs:
        for pos1 in v:
            for pos2 in v:
                if pos1 != pos2:
                    let diff = (pos1 - pos2)
                    var newPos = pos1
                    while inBounds(newPos, w, h):
                        if newPos notin uniqueLocations:
                            uniqueLocations.add(newPos)
                        newPos = newPos + diff           

    # echo "Found uniqueLocations: ", uniqueLocations.len
    return uniqueLocations.len

proc main() =
    var data = strip(readFile("../inputs/day08.txt")).splitLines()

    let part1TestResult = part1(testData)
    doAssert part1TestResult == 14
    let part1Result = part1(data)
    doAssert part1Result == 305

    let part2TestResult = part2(testData)
    doAssert part2TestResult == 34
    let part2Result = part2(data)
    doAssert part2Result == 1150

timeIt "day08":
    main()
