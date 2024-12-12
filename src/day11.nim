import strutils
import sequtils
import benchy
import tables

let testData = """125 17""".splitLines()

proc part1(data: seq[string], blinks: int): int =
    var nrs = data[0].split().mapIt(parseInt(it))
    for i in 0..blinks-1:
        if blinks > 30:
            echo "blink: ", i
        var newNrs: seq[int] = @[]
        for nr in nrs:
            if nr == 0:
                newNrs.add(1)
            elif ($nr).len mod 2 == 0:
                let nrsStr = $nr
                let middle = int(nrsStr.len / 2)
                #echo "middle: ", middle
                let
                    a = nrsStr.substr(0, middle-1)
                    b = nrsStr.substr(middle, nrsStr.len-1)
                #echo "splitting ", nr, " into ", a, " and ", b
                newNrs.add(parseInt(a))
                newNrs.add(parseInt(b))
            else:
                newNrs.add(nr * 2024)
        nrs = newNrs
    # echo "stones: ", nrs.len
    return nrs.len

var cache = initTable[(int, int), int]()

proc calculateAmount(nr: int, depth: int): int =
    if cache.hasKey((nr, depth)):
        return cache[(nr, depth)]
    if depth == 0:
        return 1
    
    var res = 0
    if nr == 0:
        res = calculateAmount(1, depth-1)
    elif ($nr).len mod 2 == 0:
        let nrsStr = $nr
        let middle = int(nrsStr.len / 2)
        let
            a = nrsStr.substr(0, middle-1)
            b = nrsStr.substr(middle, nrsStr.len-1)
        res = calculateAmount(parseInt(a), depth-1) + calculateAmount(parseInt(b), depth-1)
    else:
        res = calculateAmount(nr * 2024, depth-1)
    
    cache[(nr, depth)] = res
    return res

proc part2(data: seq[string], blinks: int): int =
    var nrs = data[0].split().mapIt(parseInt(it))
    var count = 0
    for nr in nrs:
        count += calculateAmount(nr, blinks)
    return count

proc main() =
    var data = strip(readFile("../inputs/day11.txt")).splitLines()

    let part1TestResult1 = part2(testData, 6)
    doAssert part1TestResult1 == 22
    let part1TestResult2 = part2(testData, 25)
    doAssert part1TestResult2 == 55312
    let part1Result = part2(data, 25)
    doAssert part1Result == 199753

    let part2TestResult = part2(testData, 6)
    doAssert part2TestResult == 22
    let part2TestResult2 = part2(testData, 25)
    doAssert part2TestResult2 == 55312
    let part2Result = part2(data, 75)
    doAssert part2Result == 239413123020116

timeIt "day11":
    main()
