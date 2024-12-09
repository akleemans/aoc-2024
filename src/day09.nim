import math
import strutils
import benchy
import tables
import system

let testData = """2333133121414131402""".splitLines()

proc calculateChecksum(disk: seq[int]): int =
    var checksum = 0
    for i in 0..disk.len-1:
        let b = disk[i]
        if b != -1:
            checksum += i * b
    return checksum

proc part1(data: seq[string]): int =
    var disk: seq[int] = @[]
    var isFile = true
    let diskMap = data[0]
    var fileId = 0
    for i in 0..diskMap.len-1:
        let blockAmount = parseInt($diskMap[i])
        if isFile:
            for i in 0..blockAmount-1:
                disk.add(fileId)
            fileId += 1
        else:
            for i in 0..blockAmount-1:
                disk.add(-1)
        isFile = not isFile
    #echo "disk before defrag: ", disk
    
    # Defragment
    var first = 0
    var second = disk.len-1
    while true:
        # Check from end
        while disk[second] == -1 and first < second:
            second -= 1
        # Check from start
        while disk[first] != -1 and first < second:
            first += 1
        if first >= second or disk[first] != -1 or disk[second] == -1:
            break
        disk[first] = disk[second]
        disk[second] = -1

    #echo "disk after defrag: ", disk
    let checksum = calculateChecksum(disk)
    #echo "checksum: ", checksum
    return checksum

proc part2(data: seq[string]): int =
    var disk: seq[int] = @[]
    var isFile = true
    let diskMap = data[0]
    var fileId = 0
    for i in 0..diskMap.len-1:
        let blockAmount = parseInt($diskMap[i])
        if isFile:
            for i in 0..blockAmount-1:
                disk.add(fileId)
            fileId += 1
        else:
            for i in 0..blockAmount-1:
                disk.add(-1)
        isFile = not isFile
    # echo "disk befor defrag: ", disk
    
    # Defragment
    var second = disk.len
    while true:
        # Go on back in each case
        second -= 1
        # echo "second: ", second
        # Check from end
        while second > 0 and disk[second] == -1:
            second -= 1
        if second <= 0:
            break

        # Find next file
        let fileId = disk[second]
        var fileIdx = second
        while fileIdx >= 0 and disk[fileIdx] == fileId:
            fileIdx -= 1
        let fileLength = second - fileIdx
        fileIdx += 1
        # echo "found fileId: ", fileId, " with length ", fileLength

        # Seach free space
        for idx in 0..min(disk.len-1, fileIdx):
            if disk[idx] == -1:
                var idx2 = idx+1
                while idx2 < disk.len-1 and disk[idx2] == -1:
                    idx2 += 1
                # echo "free space: ", idx2 - idx

                if idx2 - idx >= fileLength:
                    for i in 0..fileLength-1:
                        disk[idx+i] = fileId
                        disk[fileIdx+i] = -1
                    # echo "placed ", fileId, " at ", idx, " disk: ", disk
                    break
        second = fileIdx

    #echo "disk after defrag: ", disk
    let checksum = calculateChecksum(disk)
    # echo "checksum: ", checksum
    return checksum

proc main() =
    var data = strip(readFile("../inputs/day09.txt")).splitLines()

    let part1TestResult = part1(testData)
    doAssert part1TestResult == 1928
    let part1Result = part1(data)
    doAssert part1Result == 6398608069280

    let part2TestResult = part2(testData)
    doAssert part2TestResult == 2858
    let part2Result = part2(data)
    doAssert part2Result == 6427437134372

timeIt "day09":
    main()
