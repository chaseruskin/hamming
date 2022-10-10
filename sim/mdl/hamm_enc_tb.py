# ------------------------------------------------------------------------------
# Project: crus.ecc.hamming
# Engineer: Chase Ruskin
# Created: 2022-10-09
# Script: hamm_enc_tb
# Details:
#   Implements behavioral software model for HDL testbench hamm_enc_tb.
#
#   Writes files to be used as input data and expected output data during the
#   HDL simulation.
# ------------------------------------------------------------------------------

# @note: uncomment the following lines to use custom python module for testbenches
from toolbox import toolbox as tb
import random
from hamming import HammingCode

# --- Constants ----------------------------------------------------------------

TESTS = 100
R_SEED = 8

IN_FILE_NAME  = 'inputs.dat'
OUT_FILE_NAME = 'outputs.dat'

# --- Logic --------------------------------------------------------------------

random.seed(R_SEED)

# collect generics from HDL testbench file and command-line
generics = tb.get_generics()

PARITY_BITS = int(generics['PARITY_BITS'])

input_file = open(IN_FILE_NAME, 'w')
output_file = open(OUT_FILE_NAME, 'w')

hc = HammingCode(PARITY_BITS)

for _ in range(0, TESTS):
    # generate a random message
    message = [random.randint(0, 1) for _ in range(0, hc.get_data_bits_len())]

    # write message to inputs
    tb.write_bits(input_file, 
        tb.vec_int_to_str(message))

    # encode the message into hamming block
    hamm_block = hc.encode(message)

    # write block to outpus
    tb.write_bits(output_file,
        tb.vec_int_to_str(hamm_block))
    pass

# close files
input_file.close()
output_file.close()