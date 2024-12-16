from typing import List
import time
from sympy import solve
from sympy.abc import a, b

test_data = '''Button A: X+94, Y+34
Button B: X+22, Y+67
Prize: X=8400, Y=5400

Button A: X+26, Y+66
Button B: X+67, Y+21
Prize: X=12748, Y=12176

Button A: X+17, Y+86
Button B: X+84, Y+37
Prize: X=7870, Y=6450

Button A: X+69, Y+23
Button B: X+27, Y+71
Prize: X=18641, Y=10279'''.split('\n')


def part1(data: List[str]):
    total_tokens = 0
    param_a_x = 0
    param_a_y = 0
    param_b_x = 0
    param_b_y = 0
    for line in data:
        if 'Button A: ' in line:
            param_a_x = int(line.split('X+')[1].split(',')[0])
            param_a_y = int(line.split('Y+')[1])
        elif 'Button B: ' in line:
            param_b_x = int(line.split('X+')[1].split(',')[0])
            param_b_y = int(line.split('Y+')[1])
        elif 'Prize: ' in line:
            result_x = int(line.split('X=')[1].split(',')[0])
            result_y = int(line.split('Y=')[1])

            solutions = solve([
                a * param_a_x + b * param_b_x - result_x,
                a * param_a_y + b * param_b_y - result_y,
            ], a, b)
            sol_a = solutions[a]
            sol_b = solutions[b]

            if not sol_a.is_integer or not sol_b.is_integer:
                # print('solution has non-integers:', sol_a, sol_b)
                continue
            if sol_a <= 100 and sol_b <= 100:
                tokens_used = sol_a * 3 + sol_b
                # print('solution:', sol_a, sol_b)
                # print('tokens_used:', tokens_used)
                total_tokens += tokens_used
    return total_tokens


def part2(data: List[str]):
    total_tokens = 0
    param_a_x = 0
    param_a_y = 0
    param_b_x = 0
    param_b_y = 0
    for line in data:
        if 'Button A: ' in line:
            param_a_x = int(line.split('X+')[1].split(',')[0])
            param_a_y = int(line.split('Y+')[1])
        elif 'Button B: ' in line:
            param_b_x = int(line.split('X+')[1].split(',')[0])
            param_b_y = int(line.split('Y+')[1])
        elif 'Prize: ' in line:
            result_x = int(line.split('X=')[1].split(',')[0]) + 10000000000000
            result_y = int(line.split('Y=')[1]) + 10000000000000

            solutions = solve([
                a * param_a_x + b * param_b_x - result_x,
                a * param_a_y + b * param_b_y - result_y,
            ], a, b)
            sol_a = solutions[a]
            sol_b = solutions[b]

            if not sol_a.is_integer or not sol_b.is_integer:
                continue
            tokens_used = sol_a * 3 + sol_b
            total_tokens += tokens_used

    return total_tokens


def main():
    start = time.time()
    with open('../inputs/day13.txt') as read_file:
        data = [x.rstrip('\n') for x in read_file.readlines()]

    part1_test_result = part1(test_data)
    assert part1_test_result == 480, f'Part 1 test input returned {part1_test_result}'
    part1_result = part1(data)
    assert part1_result == 28887, f'Part 1 returned {part1_result}'

    part2_result = part2(data)
    assert part2_result == 96979582619758, f'Part 2 returned {part2_result}'
    print("Time:", time.time() - start, "s")


if __name__ == '__main__':
    main()
