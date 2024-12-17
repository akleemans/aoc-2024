import math
from typing import List
import time

test_data = '''Register A: 729
Register B: 0
Register C: 0

Program: 0,1,5,4,3,0'''.split('\n')


def getComboOperand(operand: int, a: int, b: int, c: int):
    if operand <= 3:
        return operand
    elif operand == 4:
        return a
    elif operand == 5:
        return b
    elif operand == 6:
        return c
    else:
        raise Exception("Invalid combo operand:" + str(operand))

def run_program(a: int, b: int, c: int, program: List[int]) -> List[int]:
    p = 0
    output = []
    while True:
        if p >= len(program)-1:
            break
        opcode = program[p]
        operand = program[p+1]
        comboOperand = getComboOperand(operand, a, b, c)
        # print("opcode: ", opcode, ", operand: ", operand)

        if opcode == 0: # adv
            a = math.floor(a / 2**comboOperand)
        elif opcode == 1: # bxl
            b = b ^ operand
        elif opcode == 2: # bst
            b = comboOperand % 8
        elif opcode == 3: # jnz
            if a != 0:
                p = operand - 2
        elif opcode == 4: # bxc
            b = b^c
        elif opcode == 5: # out
            output.append(comboOperand % 8)
        elif opcode == 6: # bdv
            b = math.floor(a / 2**comboOperand)
        elif opcode == 7: # cdv
            c = math.floor(a / 2**comboOperand)
        else:
            raise Exception("Invalid opcode: " + str(opcode))
        p += 2
    return output

def parse_input(data: List[str]):
    a, b, c = 0, 0, 0
    program = ""

    for line in data:
        if "Register A: " in line:
            a = int(line.split("Register A: ")[1])
        elif "Register B: " in line:
            b = int(line.split("Register B: ")[1])
        elif "Register C: " in line:
            c = int(line.split("Register C: ")[1])
        elif "Program: " in line:
            program = [int(x) for x in line.split("Program: ")[1].split(",")]
    # print("parsed a=", a, ", b=", b, ", c=", c, ", program:", program)
    return a, b, c, program

def part1(data: List[str]) -> str:
    a, b, c, program = parse_input(data)
    output = run_program(a, b, c, program)
    outputStr = ','.join([str(x) for x in output])
    return outputStr

def part2(data: List[str]) -> int:
    _, b, c, program = parse_input(data)
    print('program:', program)
    # a = 35184372088832
    # a = 10084372088832
    a = 0
    last_a = 1
    corrects = 1
    while True:
        result = run_program(a, 0, 0, program)
        if result == program:
            break
        if result[-corrects:] == program[-corrects:]:
            print(corrects, 'corrects', 'a =', a, 'returned', result, 'ratio:', a / last_a)
            last_a = a
            a *= 8
            corrects += 1
        a += 1
        #if len(result) >= len(program):
        #    break
    return a

def main():
    start = time.time()
    with open('../inputs/day17.txt') as read_file:
        data = [x.rstrip('\n') for x in read_file.readlines()]

    part1_test_result = part1(test_data)
    assert part1_test_result == "4,6,3,5,6,3,5,2,1,0", f'Part 1 test input returned {part1_test_result}'
    part1_result = part1(data)
    assert part1_result == "7,5,4,3,4,5,3,4,6", f'Part 1 returned {part1_result}'

    part2_result = part2(data)
    assert part2_result == 164278899142333, f'Part 2 returned {part2_result}'

    print("Time:", time.time() - start, "s")


if __name__ == '__main__':
    main()
