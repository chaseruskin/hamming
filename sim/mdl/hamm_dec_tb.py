# ------------------------------------------------------------------------------
# Project: Hamming
# Engineer: Chase Ruskin
# Created: 2022-10-11
# Script: hamm_dec_tb
# Details:
#   Implements behavioral software model for HDL testbench hamm_dec_tb.
#
#   Writes files to be used as input data and expected output data during the
#   HDL simulation.
# ------------------------------------------------------------------------------

import random
import hamming
from hamming import HammingCode
# @note: uncomment the following line to use custom python module for testbenches
from toolbox import toolbox as tb


# --- Constants ----------------------------------------------------------------

TESTS = 100
R_SEED = 9

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
    # generate random message
    message = [random.randint(0, 1) for _ in range(0, hc.get_data_bits_len())]
    # encode the random message
    encoding = hc.encode(message)
    # transmit the encoded message
    packet = hamming.send(encoding, noise=random.randint(0, 4), spots=[])
    # write packet to input file
    tb.write_bits(input_file,
        tb.vec_int_to_str(packet)
    )
    # decode the message and control signals
    decoding, corrected, valid = hc.decode(packet)
    # write the outputs to file
    tb.write_bits(output_file,
        tb.vec_int_to_str(decoding),
        int(corrected),
        int(valid))
    pass

# close files
input_file.close()
output_file.close()