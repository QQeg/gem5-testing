import struct
import sys
import re
import os
import math

def round_rmm(x: float) -> int:
    if x >= 0:
        return int(x + 0.5)
    else:
        return int(x - 0.5)

def entry(input_file):
    with open(input_file, 'r') as f:
        data = f.read()
    test_values = re.findall(r'NAN_BOXED\((\d+),', data)
    modify_function(test_values, sys.argv[1])

def int_to_binary(line: str) -> str:
    n = int(line.strip())
    binary = bin(n)[2:]
    return binary.zfill(32)

def binary_to_long(binary: str, fcsr: int) -> int:
    if binary[1:9] == '11111111':
        if binary[:1] == '1' and binary[9:] == '00000000000000000000000':
            return -pow(2,63) 
        else:
            return pow(2,63) - 1
    float_value = struct.unpack('!f', struct.pack('!I', int(binary, 2)))[0]
    if fcsr == 0:
        rounded_value = round(float_value)
    if fcsr == 32:
        rounded_value = math.trunc(float_value)
    if fcsr == 64:
        rounded_value = math.floor(float_value)
    if fcsr == 96:
        rounded_value = math.ceil(float_value)
    if fcsr == 128:
        rounded_value = round_rmm(float_value)
    long_value = int(rounded_value)
    if (long_value > pow(2,63) - 1):
        return pow(2,63) - 1
    if (long_value < -pow(2,63)):
        return -pow(2,63)
    return long_value

def process_file(test_value: int, fcsr: int):
    binary = int_to_binary(str(test_value))
    long_val = binary_to_long(binary, fcsr)
    return long_val

def modify_function(numbers: list, input2: str):
    with open(input2, 'r') as f:
        lines = f.readlines()
    with open(input2, 'w') as f:
        i = 0
        for line in lines:
            match = re.search(r'(TEST_FPI.*?)\s*\(\s*(.*?)\s*\)', line)
            if match:
                func_name = match.group(1)
                args = match.group(2).split(',')
                numbers[i] = process_file(numbers[i], int(args[4].strip()))
                args[5] = ' ' + str(numbers[i])
                i += 1
                new_line = re.sub(r'TEST_FPI.*?\(.*?\)', func_name + '(' + ','.join(args) + ')', line)
                f.write(new_line)
            else:
                f.write(line)

if __name__ == '__main__':
    if __name__ == '__main__':
        entry(sys.argv[1])
