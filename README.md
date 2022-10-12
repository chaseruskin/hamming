# `hamming`

## Overview

A generic VHDL implementation for encoding and decoding of the error-correction hamming code.

## Testing

To test the hamming-code software model:
```
python -m unittest discover ./sim/mdl hamming.py
```

To test the `parity` entity:
```
orbit plan --clean --top parity --plugin ghdl
orbit b -- -g SIZE=9 
orbit b -- -g SIZE=4 -g EVEN_PARITY=false
```

To test the `decoder` entity:
```
orbit plan --clean --plugin ghdl --top decoder
orbit b
orbit b -- -g SIZE=4
```

To test the `hamm_enc` entity:
```
orbit plan --clean --plugin ghdl --top hamm_enc
orbit b
orbit b -- -g PARITY_BITS=4
```

To test the `hamm_dec` entity:
```
orbit plan --clean --plugin ghdl --top hamm_dec
orbit b
orbit b -- -g PARITY_BITS=6
orbit b -- -g PARITY_BITS=2
```

## Reference

- "How to send a self-correcting message (Hamming codes)" - 3Blue1Brown  
https://www.youtube.com/watch?v=X8jsijhllIA

- "Hamming code" - Wikipedia  
https://en.wikipedia.org/wiki/Hamming_code#[7,4]_Hamming_code

- "Parity bit" - Wikipedia  
https://en.wikipedia.org/wiki/Parity_bit