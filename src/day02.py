from typing import List

test_data = '''7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9'''.split('\n')


def is_save(nrs: List[str]) -> bool:
    diffs = []
    for i in range(1, len(nrs)):
        diffs.append(int(nrs[i]) - int(nrs[i - 1]))
    return (all([x < 0 for x in diffs]) or all([x > 0 for x in diffs])) and all([abs(x) <= 3 for x in diffs])


def part1(data: List[str]):
    count = 0
    for line in data:
        if is_save(line.split()):
            count += 1
    return count


def part2(data: List[str]):
    count = 0
    second_try = []
    for line in data:
        if is_save(line.split()):
            count += 1
        else:
            second_try.append(line)

    # Try with removing an element
    for line in second_try:
        orig_nrs = line.split()
        for m in range(len(orig_nrs)):
            nrs = orig_nrs[:]
            nrs.pop(m)
            if is_save(nrs):
                count += 1
                break
    return count


def main():
    with open('../inputs/day02.txt') as read_file:
        data = [x.rstrip('\n') for x in read_file.readlines()]

    part1_test_result = part1(test_data)
    assert part1_test_result == 2, f'Part 1 test input returned {part1_test_result}'
    part1_result = part1(data)
    assert part1_result == 421, f'Part 1 returned {part1_result}'

    part2_test_result = part2(test_data)
    assert part2_test_result == 4, f'Part 2 test input returned {part2_test_result}'
    part2_result = part2(data)
    assert part2_result == 476, f'Part 2 returned {part2_result}'


if __name__ == '__main__':
    main()
