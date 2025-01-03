import math
import strutils
import benchy

let testData = """MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX""".splitLines()

proc part1(data: seq[string]): int =
    let h = data.len
    let w = data[0].len
    var count = 0
    for row in 0..h-1:
        for col in 0..w-1:
            # →←
            if col <= w-4 and data[row][col] == 'X' and data[row][col+1] == 'M' and data[row][col+2] == 'A' and data[row][col+3] == 'S':
                count += 1
            elif col <= w-4 and data[row][col] == 'S' and data[row][col+1] == 'A' and data[row][col+2] == 'M' and data[row][col+3] == 'X':
                count += 1
            # ↓↑
            if row <= h-4 and data[row][col] == 'X' and data[row+1][col] == 'M' and data[row+2][col] == 'A' and data[row+3][col] == 'S':
                count += 1
            elif row <= h-4 and data[row][col] == 'S' and data[row+1][col] == 'A' and data[row+2][col] == 'M' and data[row+3][col] == 'X':
                count += 1
            # ↘↖
            if row <= h-4 and col <= w-4 and data[row][col] == 'X' and data[row+1][col+1] == 'M' and data[row+2][col+2] == 'A' and data[row+3][col+3] == 'S':
                count += 1
            elif row <= h-4 and col <= w-4 and data[row][col] == 'S' and data[row+1][col+1] == 'A' and data[row+2][col+2] == 'M' and data[row+3][col+3] == 'X':
                count += 1
            # ↗↙
            if row >= 3 and col <= w-4 and data[row][col] == 'X' and data[row-1][col+1] == 'M' and data[row-2][col+2] == 'A' and data[row-3][col+3] == 'S':
                count += 1
            elif row >= 3 and col <= w-4 and data[row][col] == 'S' and data[row-1][col+1] == 'A' and data[row-2][col+2] == 'M' and data[row-3][col+3] == 'X':
                count += 1
    # echo "count: ", count
    return count

proc part2(data: seq[string]): int =
    let h = data.len
    let w = data[0].len
    var count = 0
    for row in 1..h-2:
        for col in 1..w-2:
            if data[row][col] == 'A' and ((data[row-1][col-1] == 'M' and data[row+1][col+1] == 'S' or data[row-1][col-1] == 'S' and data[row+1][col+1] == 'M') and (data[row-1][col+1] == 'M' and data[row+1][col-1] == 'S' or data[row-1][col+1] == 'S' and data[row+1][col-1] == 'M')):
                count += 1
    # echo "count: ", count
    return count

proc main() =
    var data = strip(readFile("../inputs/day04.txt")).splitLines()

    let part1TestResult = part1(testData)
    doAssert part1TestResult == 18
    let part1Result = part1(data)
    doAssert part1Result == 2504

    let part2TestResult = part2(testData)
    doAssert part2TestResult == 9
    let part2Result = part2(data)
    doAssert part2Result == 1923

timeIt "day04":
  main()
