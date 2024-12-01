from typing import List

test_data = '''3   4
4   3
2   5
1   3
3   9
3   3'''.split('\n')


def part1(data: List[str]):
    list_a = []
    list_b = []
    for line in data:
        a, b = line.split()
        list_a.append(int(a))
        list_b.append(int(b))
    diff = 0
    for a, b in zip(sorted(list_a), sorted(list_b)):
        diff += abs(a - b)
    return diff


def part2(data: List[str]):
    list_a = []
    list_b = []
    for line in data:
        a, b = line.split()
        list_a.append(int(a))
        list_b.append(int(b))
    similarity_score = 0
    for a in list_a:
        similarity_score += a * list_b.count(a)
    return similarity_score


def main():
    with open('../inputs/day01.txt') as read_file:
        data = [x.rstrip('\n') for x in read_file.readlines()]

    part1_test_result = part1(test_data)
    assert part1_test_result == 11, f'Part 1 test input returned {part1_test_result}'
    part1_result = part1(data)
    assert part1_result == 1388114, f'Part 1 returned {part1_result}'

    part2_test_result = part2(test_data)
    assert part2_test_result == 31, f'Part 2 test input returned {part2_test_result}'
    part2_result = part2(data)
    assert part2_result == 23529853, f'Part 2 returned {part2_result}'


if __name__ == '__main__':
    main()
