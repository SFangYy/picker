#!/usr/bin/env python3
# File       : example_export.py
# Description: Test Adder DUT with pack export mode
#              - Python drives inputs via transaction fields
#              - DUT computes outputs
#              - Python verifies results

import sys
import os

# Ensure current directory is in path for module import
sys.path.insert(0, '.')

# Import from pack generated package
from adder_trans import DUTadder_trans
import random

class input_t:
    def __init__(self, a, b, cin):
        self.a = a
        self.b = b
        self.cin = cin

class output_t:
    def __init__(self):
        self.sum = 0
        self.cout = 0

def random_int():
    return random.randint(-(2**127), 2**127 - 1) & ((1 << 128) - 1)

def as_uint(x, nbits):
    return x & ((1 << nbits) - 1)

def main():
    dut = DUTadder_trans()
    print("Initialized DUT Adder")
    
    for c in range(11451):
        i = input_t(random_int(), random_int(), random_int() & 1)
        o_dut, o_ref = output_t(), output_t()
        
        def dut_cal():
            dut.a.value, dut.b.value, dut.cin.value = i.a, i.b, i.cin
            dut.Step(10)
            o_dut.sum = dut.sum.value
            o_dut.cout = dut.cout.value
        
        def ref_cal():
            sum = as_uint( i.a + i.b + i.cin, 128+1)
            o_ref.sum = as_uint(sum, 128)
            o_ref.cout = as_uint(sum >> 128, 1)
        
        dut_cal()
        ref_cal()
        
        assert o_dut.sum == o_ref.sum and o_dut.cout == o_ref.cout, \
            f"Mismatch at cycle {c}: DUT(sum=0x{o_dut.sum:x}, cout={o_dut.cout}) vs REF(sum=0x{o_ref.sum:x}, cout={o_ref.cout})"

    print("Test Passed, destroy DUT Adder")


if __name__ == "__main__":
    main()
