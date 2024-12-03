from typing import List

test_data = '''xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))'''.split('\n')
test_data2 = '''xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))'''.split('\n')


def part1(data: List[str]):
    result = 0
    for s in data:
        for i in range(len(s) - 4):
            if s[i:].startswith('mul('):
                rest = s[i + 4:].split(')')[0]
                parts = rest.split(',')
                if len(parts) != 2:
                    continue
                a, b = parts
                if len(a) > 3 or len(b) > 3 or not a.isdigit() or not b.isdigit():
                    continue
                result += int(a) * int(b)
    return result


def part2(data: List[str]):
    result = 0
    enabled = True
    for s in data:
        for i in range(len(s) - 4):
            if s[i:].startswith('do()'):
                enabled = True
            elif s[i:].startswith("don't()"):
                enabled = False
            elif s[i:].startswith('mul('):
                rest = s[i + 4:].split(')')[0]
                parts = rest.split(',')
                if len(parts) != 2:
                    continue
                a, b = parts
                if len(a) > 3 or len(b) > 3 or not a.isdigit() or not b.isdigit():
                    continue
                if enabled:
                    result += int(a) * int(b)
    return result


def main():
    with open('../inputs/day03.txt') as read_file:
        data = [x.rstrip('\n') for x in read_file.readlines()]

    part1_test_result = part1(test_data)
    assert part1_test_result == 161, f'Part 1 test input returned {part1_test_result}'
    part1_result = part1(data)
    assert part1_result == 167650499, f'Part 1 returned {part1_result}'

    part2_test_result = part2(test_data2)
    assert part2_test_result == 48, f'Part 2 test input returned {part2_test_result}'
    part2_result = part2(data)
    assert part2_result == 95846796, f'Part 2 returned {part2_result}'


if __name__ == '__main__':
    main()
