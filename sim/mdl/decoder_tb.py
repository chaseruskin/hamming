# ------------------------------------------------------------------------------
# Project: crus.ecc.hamming
# Engineer: Chase Ruskin
# Created: 2022-10-09
# Script: decoder_tb
# Details:
#   Implements behavioral software model for HDL testbench decoder_tb.
#
#   Writes files to be used as input data and expected output data during the
#   HDL simulation.
# ------------------------------------------------------------------------------

# @note: uncomment the following lines to use custom python module for testbenches
from toolbox import toolbox as tb
import random

# --- Constants ----------------------------------------------------------------

IN_FILE_NAME  = 'inputs.dat'
OUT_FILE_NAME = 'outputs.dat'

# --- Logic --------------------------------------------------------------------

# collect generics from HDL testbench file and command-line
generics = tb.get_generics()

input_file = open(IN_FILE_NAME, 'w') 
output_file = open(OUT_FILE_NAME, 'w')

SIZE = int(generics['SIZE'])

for num in range(0, 2**SIZE):
    encoding = tb.to_bin(num, SIZE)
    # write encoding to inputs
    tb.write_bits(input_file,
        encoding)

    decoding = [0] * (2**SIZE)
    # set the index bit high as '1'
    decoding[2**SIZE-num-1] = 1
    
    # write decoding to ouputs
    decoding = tb.vec_int_to_str(decoding, big_endian=False)
    tb.write_bits(output_file,
        decoding)
    pass



# close files
input_file.close()
output_file.close()