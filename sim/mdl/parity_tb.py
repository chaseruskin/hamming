# ------------------------------------------------------------------------------
# Project: crus.ecc.hamming
# Engineer: Chase Ruskin
# Created: 2022-10-07
# Script: parity_tb
# Details:
#   Implements behavioral software model for HDL testbench parity_tb.
#
#   Writes files to be used as input data and expected output data during the
#   HDL simulation.
# ------------------------------------------------------------------------------

# @note: uncomment the following line to use custom python module for testbenches
from toolbox import toolbox as tb
import random
import hamming

# --- Constants ----------------------------------------------------------------

TESTS = 100
R_SEED = 8

IN_FILE_NAME  = 'inputs.dat'
OUT_FILE_NAME = 'outputs.dat'

# --- Logic --------------------------------------------------------------------

random.seed(R_SEED)

# collect generics from HDL testbench file and command-line
generics = tb.get_generics()

SIZE = int(generics['SIZE'])
EVEN_PARITY  = tb.interp_vhdl_bool(generics['EVEN_PARITY'])

input_file = open(IN_FILE_NAME, 'w')
output_file = open(OUT_FILE_NAME, 'w')

# track distribution of even and odd numbers
odd_ctr = 0
even_ctr = 0
for _ in range(0, TESTS):
    # generate random data
    message = random.randint(0, (2**SIZE)-1)
    # recompute message if already fair amount of odd and even numbers
    while (message % 2 == 0 and even_ctr >= TESTS/2) or (message % 2 == 1 and odd_ctr >= TESTS/2):
        message = random.randint(0, (2**SIZE)-1)
    if message % 2 == 0:
        even_ctr += 1
    else:
        odd_ctr += 1

    bits = tb.to_bin(message, SIZE)
    # write input data
    tb.write_bits(input_file, 
        bits)

    bits = [int(b) for b in list(bits)]
    # compute parity bit
    check_bit = hamming.set_parity_bit(list(bits), use_even=EVEN_PARITY)
    # write expected output data
    tb.write_bits(output_file,
        check_bit)
    pass

# close files
input_file.close()
output_file.close()