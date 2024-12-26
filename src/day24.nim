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
    var allZ: seq[(string, int)] = @[]
    for k, v in values:
        if k.startsWith(letter):
            allZ.add((k, v))
    allZ.sort()
    allZ.reverse()

    let allValues = allZ.mapIt(it[1])
    let allZStr = allValues.join("")
    var res: int
    var _ = allZStr.parseBin(res)
    return res

proc calculateOutput(valuesOrig: Table[string, int], rulesOrig: seq[seq[string]]): int =
    var values = valuesOrig
    var rules = rulesOrig
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
    let res = getDecimal(values, "z")
    return res

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

    var rulesRaw = data[splitPoint+1..^1]
    rulesRaw.sort()
    var rules: seq[seq[string]] = @[]
    for line in rulesRaw:
        rules.add(line.split(" "))
    #echo "rules:", rules

    let res = calculateOutput(values, rules)
    #echo "result: ", res
    return res

proc generateGraphDefinition(rules: seq[seq[string]]) =
    var graphDefinition = "Digraph G {\n"
    for rule in rules:
        graphDefinition &= rule[0] & " -> " & rule[4] & " [label = " & rule[1] & "]\n"
        graphDefinition &= rule[2] & " -> " & rule[4] & " [label = " & rule[1] & "]\n"
    graphDefinition &= "}"
    # echo graphDefinition

proc part2(data: seq[string]): string =
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

    var rulesRaw = data[splitPoint+1..^1]
    rulesRaw.sort()
    var rules: seq[seq[string]] = @[]
    for line in rulesRaw:
        rules.add(line.split(" "))

    # Debugging 1: Generate graph for https://dreampuf.github.io/GraphvizOnline/
    generateGraphDefinition(rules)

    # Debugging 2: Current state
    let startX = getDecimal(values, "x")
    let startY = getDecimal(values, "y")
    # echo "startX: ", startX, ", startY: ", startY, ", sum:", startX + startY

    # Check rules to determine wrong wirings.
    # Adapted from from https://www.reddit.com/r/adventofcode/comments/1hla5ql/2024_day_24_part_2_a_guide_on_the_idea_behind_the/
    var wrongGates: seq[string] = @[]
    for rule in rules:
        if rule[4].startsWith("z") and rule[1] != "XOR" and rule[4] != "z45":
            #echo "z output without XOR: ", rule[4]
            wrongGates.add(rule[4])
        if not rule[4].startsWith("z") and rule[1] == "XOR":
            let bothInputs = (rule[0] & rule[2])
            if "x" notin bothInputs and "y" notin bothInputs:
                #echo "not-z output with not x/y inputs: ", rule[4]
                wrongGates.add(rule[4])
        if rule[1] == "XOR":
            let bothInputs = (rule[0] & rule[2])
            # For a XOR gate with inputs x, y, there must be another XOR gate with this gate as an input
            if "x" in bothInputs and "y" in bothInputs:
                var found = false
                for r2 in rules:
                    if r2[1] == "XOR" and (r2[0] == rule[4] or r2[2] == rule[4]):
                        found = true
                        break
                if not found and rule[4] != "z00":
                    #echo "found XOR gate with x/y without next XOR: ", rule[4]
                    wrongGates.add(rule[4])
        if rule[1] == "AND":
            let bothInputs = (rule[0] & rule[2])
            # For a AND-gate, there must be an OR-gate with this gate as an input
            if "x" in bothInputs and "y" in bothInputs:
                var found = false
                for r2 in rules:
                    if r2[1] == "OR" and (r2[0] == rule[4] or r2[2] == rule[4]):
                        found = true
                        break
                if not found and "x00" notin rule:
                    #echo "found AND gate with x/y without next OR: ", rule[4]
                    wrongGates.add(rule[4])
    wrongGates.sort()
    wrongGates = deduplicate(wrongGates, isSorted = true)
    let res = wrongGates.join(",")

    #echo "res: ", res
    return res

proc main() =
    var data = strip(readFile("../inputs/day24.txt")).splitLines()

    let part1TestResult1 = part1(testData1)
    doAssert part1TestResult1 == 4
    let part1TestResult2 = part1(testData2)
    doAssert part1TestResult2 == 2024
    let part1Result = part1(data)
    doAssert part1Result == 43942008931358

    let part2Result = part2(data)
    doAssert part2Result == "dvb,fhg,fsq,tnc,vcf,z10,z17,z39"

timeIt "day24":
    main()
