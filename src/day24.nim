import math
import strutils
import sequtils
import benchy
import tables
import system
import heapqueue
import sets
import algorithm
import parseutils

let testData1 = """x00: 1
x01: 1
x02: 1
y00: 0
y01: 1
y02: 0

x00 AND y00 -> z00
x01 XOR y01 -> z01
x02 OR y02 -> z02""".splitLines()

let testData2 = """x00: 1
x01: 0
x02: 1
x03: 1
x04: 0
y00: 1
y01: 1
y02: 1
y03: 1
y04: 1

ntg XOR fgs -> mjb
y02 OR x01 -> tnw
kwq OR kpj -> z05
x00 OR x03 -> fst
tgd XOR rvg -> z01
vdt OR tnw -> bfw
bfw AND frj -> z10
ffh OR nrd -> bqk
y00 AND y03 -> djm
y03 OR y00 -> psh
bqk OR frj -> z08
tnw OR fst -> frj
gnj AND tgd -> z11
bfw XOR mjb -> z00
x03 OR x00 -> vdt
gnj AND wpb -> z02
x04 AND y00 -> kjc
djm OR pbm -> qhw
nrd AND vdt -> hwm
kjc AND fst -> rvg
y04 OR y02 -> fgs
y01 AND x02 -> pbm
ntg OR kjc -> kwq
psh XOR fgs -> tgd
qhw XOR tgd -> z09
pbm OR djm -> kpj
x03 XOR y03 -> ffh
x00 XOR y04 -> ntg
bfw OR bqk -> z06
nrd XOR fgs -> wpb
frj XOR qhw -> z04
bqk OR frj -> z07
y03 OR x01 -> nrd
hwm AND bqk -> z03
tgd XOR rvg -> z12
tnw OR pbm -> gnj""".splitLines()

proc getDecimal(values: Table[string, int], letter: string): int =
    

proc part1(data: seq[string]): int =
    # Find splitPoint
    var splitPoint = 0
    for i in 0..data.len-1:
        if data[i].len == 0:
            splitPoint = i
            break
    let inputsRaw = data[0..splitPoint-1]
    var values = initTable[string, int]()
    for line in inputsRaw:
        let
            name = line.split(": ")[0]
            value = parseInt(line.split(": ")[1])
        values[name] = value
    #echo "values:", values

    let rulesRaw = data[splitPoint+1..^1]
    var rules: seq[seq[string]] = @[]
    for line in rulesRaw:
        rules.add(line.split(" "))
    #echo "rules:", rules

    # Iterate
    while rules.len > 0:
        # echo "starting new round"
        var unresolvableRules: seq[seq[string]] = @[]
        for rule in rules:
            let
                varA = rule[0]
                varB = rule[2]
            #echo "working on rule: ", rule, " varA:", varA, " varB:", varB
            if varA in values and varB in values:
                # echo "resolving rule!"
                let
                    valA = values[varA]
                    valB = values[varB]
                let varC = rule[4]
                let op = rule[1]
                var r = 0
                if op == "OR":
                    r = valA or valB
                elif op == "XOR":
                    r = valA xor valB
                elif op == "AND":
                    r = valA and valB
                values[varC] = r
            else:
                #echo "not resolvable yet."
                unresolvableRules.add(rule)
            #let userInput = readLine(stdin)
        rules = unresolvableRules
    
    # Collect & parse result
    var allZ: seq[(string, int)] = @[]
    for k, v in values:
        if k.startsWith("z"):
            allZ.add((k, v))

    echo "allZ: ", allZ
    # TODO somehow sorting with a custom comparator does not work
    #allZ.sort(proc (x, y: (string, int)): bool = x[0] < y[0])
    allZ.sort()
    allZ.reverse()

    let allValues = allZ.mapIt(it[1])
    let allZStr = allValues.join("")
    var res: int
    var res2 = parseBin(allZStr, res)
    echo "result: ", res
    return res

proc part2(data: seq[string]): int =
    # Find splitPoint
    var splitPoint = 0
    for i in 0..data.len-1:
        if data[i].len == 0:
            splitPoint = i
            break
    let inputsRaw = data[0..splitPoint-1]
    var values = initTable[string, int]()
    for line in inputsRaw:
        let
            name = line.split(": ")[0]
            value = parseInt(line.split(": ")[1])
        values[name] = value
    #echo "values:", values

    let rulesRaw = data[splitPoint+1..^1]
    var rules: seq[seq[string]] = @[]
    for line in rulesRaw:
        rules.add(line.split(" "))

    # Generate graph for https://dreampuf.github.io/GraphvizOnline/
    var graphDefinition = "Digraph G {\n"
    # ntg XOR fgs -> mjb

    for rule in rules:
        graphDefinition &= rule[0] & " -> " & rule[4] & " [name = " & rule[1] & "]\n"
        graphDefinition &= rule[2] & " -> " & rule[4] & " [name = " & rule[1] & "]\n"

    graphDefinition &= "}"
    
    echo graphDefinition
    return 0

proc main() =
    var data = strip(readFile("../inputs/day24.txt")).splitLines()

    let part1TestResult1 = part1(testData1)
    doAssert part1TestResult1 == 4
    let part1TestResult2 = part1(testData2)
    doAssert part1TestResult2 == 2024
    let part1Result = part1(data)
    doAssert part1Result == 43942008931358

    #let part2TestResult = part2(testData2)
    #doAssert part2TestResult == -1
    let part2Result = part2(data)
    doAssert part2Result == -1

main()
#timeIt "day24":
#    main()
