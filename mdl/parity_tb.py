# ------------------------------------------------------------------------------
# Project: Hamming
# Engineer: Chase Ruskin
# Created: 2022-10-07
# Script: parity_tb
# Details:
#   Implements behavioral software model for HDL testbench parity_tb.
#
#   Writes files to be used as input data and expected output data during the
#   HDL simulation.
# ------------------------------------------------------------------------------

import verity as vy
from verity.coverage import Coverage, Covergroup, Coverpoint
from verity.model import SuperBfm, Signal, Mode, InputFile, OutputFile
import random
import hamming

# --- Constants ----------------------------------------------------------------

# define the randomness seed
R_SEED = vy.get_seed(0)

# collect generics from command-line and HDL testbench
GENS = vy.get_generics()

WIDTH = vy.from_vhdl_int(GENS['SIZE'])
EVEN_PARITY = vy.from_vhdl_bool(GENS['EVEN_PARITY'])

MAX_SIMS = 10_000

# define the bus functional model
class Bfm(SuperBfm):
    entity = 'parity'

    def __init__(self):
        self.data = Signal(Mode.INPUT, WIDTH)

        self.check_bit = Signal(Mode.OUTPUT)
        pass


    def model(self, *args):
        self.check_bit.set(0)
        # cast into a `List[int]` type
        vec = [int(x) for x in self.data.as_logic()]
        if hamming.set_parity_bit(vec, use_even=EVEN_PARITY) == True:
            self.check_bit.set(1)
        return self
    pass

# --- Logic --------------------------------------------------------------------

vy.parse_args(bfm=Bfm())

random.seed(R_SEED)

# create empty test vector files
i_file = InputFile()
o_file = OutputFile()

# generate test cases until total coverage is met or we reached max count
for _ in range(0, MAX_SIMS):
    # create a new input to enter through the algorithm
    txn = Bfm().rand()
    i_file.write(txn)
    o_file.write(txn.model())
    pass