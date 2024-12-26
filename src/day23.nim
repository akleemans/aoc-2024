import times
import math
import strutils
import sequtils
import benchy
import tables
import heapqueue
import sets
import algorithm

let testData = """kh-tc
qp-kh
de-cg
ka-co
yn-aq
qp-ub
cg-tb
vc-aq
tb-ka
wh-tc
yn-cg
kh-ub
ta-co
de-co
tc-td
tb-wq
wh-td
ta-ka
td-qp
aq-cg
wq-ub
ub-vc
de-ta
wq-aq
wq-vc
wh-yn
ka-de
kh-ta
co-tc
wh-qp
tb-vc
td-yn""".splitLines()

proc part1(data: seq[string]): int =
    var computers = initTable[string, seq[string]]()
    for line in data:
        let
            comp1Id = line.split("-")[0]
            comp2Id = line.split("-")[1]
        if comp1Id notin computers:
            computers[comp1Id] = @[]
        if comp2Id notin computers:
            computers[comp2Id] = @[]
        computers[comp1Id].add(comp2Id)
        computers[comp2Id].add(comp1Id)
    # echo "computers: ", computers

    # Check sets of computers
    var setsOfThree = initTable[string, bool]()
    for computerA in computers.keys:
        # echo "checking ", computerA
        for computerB in computers[computerA]:
            for computerC in computers[computerB]:
                if computerA in computers[computerC]:
                    if computerA.startsWith("t") or computerB.startsWith("t") or computerC.startsWith("t"):
                        var allThree: seq[string] = @[computerA, computerB, computerC]
                        allThree.sort()
                        let name = allThree.join(",")
                        setsOfThree[name] = true 

    let setsContainingT = setsOfThree.keys().toSeq().filterIt(it.contains("t"))
    # echo "result: ", setsContainingT.len
    return setsContainingT.len

proc part2(data: seq[string]): string =
    var computers = initTable[string, seq[string]]()
    for line in data:
        let
            comp1Id = line.split("-")[0]
            comp2Id = line.split("-")[1]
        if comp1Id notin computers:
            computers[comp1Id] = @[]
        if comp2Id notin computers:
            computers[comp2Id] = @[]
        computers[comp1Id].add(comp2Id)
        computers[comp2Id].add(comp1Id)

    # Greedy search based on https://en.wikipedia.org/wiki/Clique_problem#Finding_a_single_maximal_clique
    var biggestSet: seq[string]
    for computerA in computers.keys:
        var currentSet: seq[string] = @[computerA]
        for computerB in computers[computerA]:
            var allConnected = true
            for existing in currentSet:
                if computerB notin computers[existing]:
                    allConnected = false
                    break
            if allConnected:
                currentSet.add(computerB)

        if currentSet.len > biggestSet.len:
            # echo "found new biggest set:", currentSet
            biggestSet = currentSet

    biggestSet.sort()
    let password = biggestSet.join(",")
    # echo "password: ", password
    return password

proc main() =
    var data = strip(readFile("../inputs/day23.txt")).splitLines()

    let part1TestResult = part1(testData)
    doAssert part1TestResult == 7
    let part1Result = part1(data)
    doAssert part1Result == 1419

    let part2TestResult = part2(testData)
    doAssert part2TestResult == "co,de,ka,ta"
    let part2Result = part2(data)
    doAssert part2Result == "af,aq,ck,ee,fb,it,kg,of,ol,rt,sc,vk,zh"

timeIt "day23":
    main()
