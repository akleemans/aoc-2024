import math
import strutils
import sequtils
import benchy
import tables
import system
import heapqueue
import sets

let testData = """1
10
100
2024""".splitLines()


let testData2 = """1
2
3
2024""".splitLines()

proc mix(a, b: int): int =
    return a xor b

proc prune(a: int): int =
    return a mod 16777216

proc roundDown(i: float): int =
    return toInt(floor(i))

proc part1(data: seq[string]): int =
    var buyersNumbers = data.mapIt(parseInt(it))
    for iteration in 0..2000-1:
        for i in 0..buyersNumbers.len-1:
            var secret = buyersNumbers[i]
            # Step 1
            var res = secret * 64
            secret = prune(mix(secret, res))

            # Step 2
            res = roundDown(secret / 32)
            secret = prune(mix(secret, res))

            # Step 3
            res = secret * 2048
            secret = prune(mix(secret, res))

            buyersNumbers[i] = secret
    
    var secretSum = sum(buyersNumbers)
    # echo "secretSum: ", secretSum
    return secretSum

proc part2(data: seq[string]): int =
    var buyersNumbers = data.mapIt(parseInt(it))
    var iterationDifferences: seq[seq[(int, int)]] = @[]
    for iteration in 0..2000-1:
        var buyerChanges: seq[(int, int)] = @[]
        for i in 0..buyersNumbers.len-1:
            let secret = buyersNumbers[i]
            var res = secret * 64
            var newSecret = prune(mix(secret, res))
            res = roundDown(newSecret / 32)
            newSecret = prune(mix(newSecret, res))
            res = newSecret * 2048
            newSecret = prune(mix(newSecret, res))
            buyersNumbers[i] = newSecret

            if iteration > 0:
                let lastPrice = secret mod 10
                let newPrice = newSecret mod 10
                let oneDigitChange = newPrice - lastPrice
                buyerChanges.add((oneDigitChange, newPrice))
        iterationDifferences.add(buyerChanges)
    
    var gainsPerBuyer: seq[Table[string, int]] = @[]
    for buyerId in 0..buyersNumbers.len-1:
        # echo "checking buyer ", buyerId
        var gain = initTable[string, int]()
        for iteration in 4..2000-1:
            var diffs: seq[int] = @[]
            for i in 0..3:
                diffs.add(iterationDifferences[iteration-3+i][buyerId][0])
            let prize = iterationDifferences[iteration][buyerId][1]
            # echo "diffs:", diffs, ", with prize:", prize
            if 0 in diffs:
                continue
            let diffString = diffs.mapIt($it).join(",")
            if diffString notin gain:
                gain[diffString] = prize
        gainsPerBuyer.add(gain)


    # Find max value
    var seen = initTable[string, bool]()
    var maxKey: string
    var maxValue = -1
    for buyerId in 0..buyersNumbers.len-1:
        for key in gainsPerBuyer[buyerId].keys:
            if key in seen:
                continue
            seen[key] = true

            var currentValue = 0
            for gains in gainsPerBuyer:
                if key in gains:
                    currentValue += gains[key]
            if currentValue > maxValue:
                # echo "new best:", currentValue
                maxValue = currentValue
                maxKey = key
                
    # echo "best sequence: ", maxKey, " with value ", maxValue
    return maxValue

proc main() =
    var data = strip(readFile("../inputs/day22.txt")).splitLines()

    let part1TestResult = part1(testData)
    doAssert part1TestResult == 37327623
    let part1Result = part1(data)
    doAssert part1Result == 19241711734

    let part2TestResult = part2(testData2)
    doAssert part2TestResult == 23
    let part2Result = part2(data)
    doAssert part2Result == 2058

timeIt "day22":
    main()