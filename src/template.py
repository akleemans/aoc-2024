from typing import List

test_data = ''''''.split('\n')


def part1(data: List[str]):
    return 1


def part2(data: List[str]):
    return 1


def main():
    with open('../inputs/dayXX.txt') as read_file:
        data = [x.rstrip('\n') for x in read_file.readlines()]

    part1_test_result = part1(test_data)
    assert part1_test_result == 0, f'Part 1 test input returned {part1_test_result}'
    part1_result = part1(data)
    print('Part 1:', part1_result)  # remove
    assert part1_result == 0, f'Part 1 returned {part1_result}'

    part2_test_result = part2(test_data)
    assert part2_test_result == 0, f'Part 2 test input returned {part2_test_result}'
    part2_result = part2(data)
    print('Part 2:', part2_result)  # remove
    assert part2_result == 0, f'Part 2 returned {part2_result}'


if __name__ == '__main__':
    main()
