import math
import strutils
import sequtils
import benchy

let testData = """xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))""".splitLines()
let testData2 = """xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))""".splitLines()


proc part1(data: seq[string]): int =
    var mult_result = 0
    for s in data:
        for i in 0..s.len - 5:
            if s[i..i+3] == "mul(":
                let idx = min(i + 11, s.len - 1)
                let rest = s[i+4 .. idx].split(")")[0]
                let parts = rest.split(",")
                if parts.len != 2:
                    continue
                var a = parts[0]
                var b = parts[1]
                if a.len > 3 or b.len > 3 or not a.all(isDigit) or not b.all(isDigit):
                    continue
                mult_result += parseInt(a) * parseInt(b)
    # echo "part1: ", mult_result
    return mult_result

proc part2(data: seq[string]): int =
    var mult_result = 0
    var enabled = true
    for s in data:
        for i in 0..s.len - 4:
            if s[i..i+3] == "do()":
                enabled = true
            elif i < s.len - 7 and s[i..i+6] == "don't()":
                enabled = false
            elif s[i..i+3] == "mul(":
                let idx = min(i + 11, s.len - 1)
                let rest = s[i+4 .. idx].split(")")[0]
                let parts = rest.split(",")
                if parts.len != 2:
                    continue
                var a = parts[0]
                var b = parts[1]
                if a.len > 3 or b.len > 3 or not a.all(isDigit) or not b.all(isDigit):
                    continue
                if enabled:
                    mult_result += parseInt(a) * parseInt(b)    
    # echo "part2: ", mult_result
    return mult_result

proc main() =
    var data = strip(readFile("../inputs/day03.txt")).splitLines()

    let part1TestResult = part1(testData)
    doAssert part1TestResult == 161
    let part1Result = part1(data)
    doAssert part1Result == 167650499

    let part2TestResult = part2(testData2)
    doAssert part2TestResult == 48
    let part2Result = part2(data)
    doAssert part2Result == 95846796

timeIt "day03":
    main()
