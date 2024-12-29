import math
import strutils
import benchy
import tables
import sequtils

let testData = """47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47""".splitLines()

proc processInput(data: seq[string]): (Table[string, bool], seq[seq[int]]) =
    var rules = initTable[string, bool]()
    var update_start = 0
    for i in 0..data.len - 1:
        let line = data[i]
        if line.len == 0:
            update_start = i
            break
        rules[line] = true
    
    var updates: seq[seq[int]] = @[]
    for i in update_start+1..data.len-1:
        updates.add(data[i].split(",").mapIt(parseInt(it)))

    return (rules, updates)

proc isConform(update: seq[int], rules: Table[string, bool]): bool =
    for current_idx in 1 .. update.len-1:
        for previous_idx in 0 .. current_idx-1:
            let curr = update[current_idx]
            let prev = update[previous_idx]
            if rules.hasKey($curr & "|" & $prev):
                return false
    return true

proc part1(data: seq[string]): int =
    let (rules, updates) = processInput(data)
    var middlePageSum = 0
    for update in updates:
        if isConform(update, rules):
            let middle_idx = toInt((update.len - 1) / 2)
            middlePageSum += update[middle_idx]
    return middlePageSum


proc find_correct(updateOrig: seq[int], rules: Table[string, bool]): int =
    var update = @updateOrig

    var sorted = false
    while not sorted:
        sorted = true
        for current_idx in 1 .. update.len-1:
            for previous_idx in 0 .. current_idx-1:
                let curr = update[current_idx]
                let prev = update[previous_idx]
                if rules.hasKey($curr & "|" & $prev):
                    update[current_idx] = prev
                    update[previous_idx] = curr
                    sorted = false
                    break
            if not sorted:
                break
    
    let middle_idx = toInt((update.len - 1) / 2)
    return update[middle_idx]


proc part2(data: seq[string]): int =
    let (rules, updates) = processInput(data)
    var middlePageSum = 0
    for update in updates:
        if isConform(update, rules):
            continue
        else:
            middlePageSum += find_correct(update, rules)
    return middlePageSum

proc main() =
    var data = strip(readFile("../inputs/day05.txt")).splitLines()

    let part1TestResult = part1(testData)
    doAssert part1TestResult == 143
    let part1Result = part1(data)
    doAssert part1Result == 5091

    let part2TestResult = part2(testData)
    doAssert part2TestResult == 123
    let part2Result = part2(data)
    doAssert part2Result == 4681

timeIt "day05":
  main()
