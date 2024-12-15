import math
import strutils
import benchy
import tables
import system

let testData = """p=0,4 v=3,-3
p=6,3 v=-1,-3
p=10,3 v=-1,2
p=2,0 v=2,-1
p=0,0 v=1,3
p=3,0 v=-2,-2
p=7,6 v=-1,-3
p=3,0 v=-1,-2
p=9,3 v=2,3
p=7,3 v=-1,2
p=2,4 v=2,-3
p=9,5 v=-3,-3""".splitLines()

proc `+`(a: (int, int), b: (int, int)): (int, int) =
    (a[0]+b[0], a[1]+b[1])

proc `-`(a: (int, int), b: (int, int)): (int, int) =
    (a[0]-b[0], a[1]-b[1])

let allDirsDiag = [(-1, 0), (1, 0), (0, -1), (0, 1), (-1, -1), (1, 1), (1, -1), (-1, 1)]

proc part1(data: seq[string], w: int, h: int): int =
    var finalPositions: seq[(int, int)] = @[]
    for line in data:
        let pr = parseInt(line.split("p=")[1].split(",")[0])
        let pc = parseInt(line.split(",")[1].split(" ")[0])
        let vr = parseInt(line.split("v=")[1].split(",")[0])
        let vc = parseInt(line.split(",")[2])
        #echo "parsed p = ", (pr, pc), " and v = ", (vr, vc)
        var finalRow = (pr + vr * 100) mod w
        var finalCol = (pc + vc * 100) mod h

        if finalRow < 0:
            finalRow += w
        if finalCol < 0:
            finalCol += h
        #echo "adding ", (finalRow, finalCol)

        finalPositions.add((finalRow, finalCol))
    
    var quadrants = @[0, 0, 0, 0]
    for pos in finalPositions:
        let (row, col) = pos
        let middleRow = int(w/2)
        let middleCol = int(h/2)
        if row < middleRow and col < middleCol:
            quadrants[0] += 1
        elif row > middleRow and col < middleCol:
            quadrants[1] += 1
        elif row < middleRow and col > middleCol:
            quadrants[2] += 1
        elif row > middleRow and col > middleCol:
            quadrants[3] += 1

    #echo "quadrants: ", quadrants
    let safetyFactor = quadrants[0] * quadrants[1] * quadrants[2] * quadrants[3] 
    echo "safetyFactor: ", safetyFactor
    return safetyFactor

proc printField(positions: seq[(int, int)], w: int, h: int): void =
    #let grid: seq[seq[char]] = @[]
    for row in 0..w-1:
        for col in 0..h-1:
            if (row, col) in positions:
                stdout.write("X")
            else:
                stdout.write(".")
        stdout.write("\n")

proc part2(data: seq[string], w: int, h: int): int =
    # TODO split into parsing and calculating

    var second = 0
    while true:
        var finalPositions: seq[(int, int)] = @[]
        for line in data:
            let pr = parseInt(line.split("p=")[1].split(",")[0])
            let pc = parseInt(line.split(",")[1].split(" ")[0])
            let vr = parseInt(line.split("v=")[1].split(",")[0])
            let vc = parseInt(line.split(",")[2])
            var finalRow = (pr + vr * second) mod w
            var finalCol = (pc + vc * second) mod h
            if finalRow < 0:
                finalRow += w
            if finalCol < 0:
                finalCol += h
            finalPositions.add((finalRow, finalCol))

        var neighborCount = 0
        for pos in finalPositions:
            for dir in allDirsDiag:
                if pos + dir in finalPositions:
                    neighborCount += 1

        if neighborCount > 500:
            printField(finalPositions, w, h)
            echo "neighborCount: ", neighborCount, ", seconds: ", second
            break
            # let userInput = readLine(stdin)
        second += 1
    return -1

proc main() =
    var data = strip(readFile("../inputs/day14.txt")).splitLines()

    let part1TestResult = part1(testData, 11, 7)
    doAssert part1TestResult == 12
    let part1Result = part1(data, 101, 103)
    doAssert part1Result == 229069152

    #let part2TestResult = part2(testData, 11, 7)
    #doAssert part2TestResult == -1
    let part2Result = part2(data, 101, 103)
    doAssert part2Result == -1

main()

#timeIt "day14":
#    main()
