import math
import strutils
import benchy
import tables
import system
import manu

let testData = """Button A: X+94, Y+34
Button B: X+22, Y+67
Prize: X=8400, Y=5400

Button A: X+26, Y+66
Button B: X+67, Y+21
Prize: X=12748, Y=12176

Button A: X+17, Y+86
Button B: X+84, Y+37
Prize: X=7870, Y=6450

Button A: X+69, Y+23
Button B: X+27, Y+71
Prize: X=18641, Y=10279""".splitLines()

proc part1(data: seq[string]): int =
    var totalTokens = 0
    var param_a_x = 0
    var param_a_y = 0
    var param_b_x = 0
    var param_b_y = 0
    var result_x = 0
    var result_y = 0
    
    for line in data:
        if "Button A: " in line:
            param_a_x = parseInt(line.split("X+")[1].split(',')[0])
            param_a_y = parseInt(line.split("Y+")[1])
        elif "Button B: " in line:
            param_b_x = parseInt(line.split("X+")[1].split(',')[0])
            param_b_y = parseInt(line.split("Y+")[1])
        elif "Prize: " in line:
            result_x = parseInt(line.split("X=")[1].split(',')[0])
            result_y = parseInt(line.split("Y=")[1])

            let vals = @[
                @[float(param_a_x),float(param_b_x)],
                @[float(param_a_y),float(param_b_y)]
            ]
            let A = matrix(vals)
            let b = matrix(@[float(result_x), float(result_y)], 2)

            let x = A.solve(b)
            let r = A * x - b
            let sol_a = x[0, 0]
            let sol_b = x[1, 0]

            if sol_a <= 100 and sol_b <= 100:
                let int_a = toInt(sol_a)
                let int_b = toInt(sol_b)
                if abs(float(int_a) - sol_a) > 0.001 or abs(float(int_b) - sol_b) > 0.001:
                    continue

                var tokensUsed = int_a * 3 + int_b
                totalTokens += tokensUsed

    # echo "totalTokens: ", totalTokens
    return totalTokens

proc part2(data: seq[string]): int =
    var totalTokens = 0
    var param_a_x = 0
    var param_a_y = 0
    var param_b_x = 0
    var param_b_y = 0
    var result_x = 0
    var result_y = 0
    
    for line in data:
        if "Button A: " in line:
            param_a_x = parseInt(line.split("X+")[1].split(',')[0])
            param_a_y = parseInt(line.split("Y+")[1])
        elif "Button B: " in line:
            param_b_x = parseInt(line.split("X+")[1].split(',')[0])
            param_b_y = parseInt(line.split("Y+")[1])
        elif "Prize: " in line:
            result_x = parseInt(line.split("X=")[1].split(',')[0]) + 10000000000000
            result_y = parseInt(line.split("Y=")[1]) + 10000000000000
            
            let vals = @[
                @[float(param_a_x),float(param_b_x)],
                @[float(param_a_y),float(param_b_y)]
            ]
            let A = matrix(vals)
            let b = matrix(@[float(result_x), float(result_y)], 2)

            let x = A.solve(b)
            let r = A * x - b

            let sol_a = x[0, 0]
            let sol_b = x[1, 0]

            let int_a = toInt(sol_a)
            let int_b = toInt(sol_b)
            if abs(float(int_a) - sol_a) > 0.001 or abs(float(int_b) - sol_b) > 0.001:
                continue

            var tokensUsed = int_a * 3 + int_b
            totalTokens += tokensUsed

    return totalTokens

proc main() =
    var data = strip(readFile("../inputs/day13.txt")).splitLines()

    let part1TestResult = part1(testData)
    doAssert part1TestResult == 480
    let part1Result = part1(data)
    doAssert part1Result == 28887

    let part2Result = part2(data)
    doAssert part2Result == 96979582619758

timeIt "day13":
    main()
