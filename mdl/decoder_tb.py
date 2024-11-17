from verb import context
from verb.model import *

class Decoder:

    def __init__(self, size: int):
        self.size = size

        self.enc = Signal(size)
        self.dec = Signal(2**size)

    def setup(self):
        self.enc.sample()

    def eval(self):
        i = self.enc.get(int)
        self.dec.set(0)
        self.dec[i] = '1'


def main():
    mdl = Decoder(context.generic('SIZE', int))

    with vectors('inputs.txt', 'i') as inputs, vectors('outputs.txt', 'o') as outputs:
        for _ in range(1000):
            mdl.setup()
            inputs.push(mdl)
            mdl.eval()
            outputs.push(mdl)


if __name__ == '__main__':
    main()
