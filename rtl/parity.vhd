--------------------------------------------------------------------------------
--! Project  : crus.ecc.hamming
--! Engineer : Chase Ruskin
--! Created  : 2022-10-07
--! Entity   : parity
--! Details  :
--!     Checks the incoming `data` for parity to ensure the total number of 
--!     1-bits in the `data` are even or odd.
--!
--!     An even parity (EVEN_PARITY = TRUE) seeks to obtain an even amount of 
--!     '1's in the data. If the count is odd, then `check_bit` is set to '1'.
--!
--!     An odd parity (EVEN_PARITY = FALSE) seeks to obtain an odd amount of
--!     '1's in the data. If the count is even, then `check_bit` is set to '1'.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity parity is 
    generic (
        --! data width
        SIZE        : positive;
        --! Determine to perform even or odd parity
        EVEN_PARITY : boolean := true
    );
    port (
        data      : in  std_logic_vector(SIZE-1 downto 0);
        check_bit : out std_logic
    );
end entity parity;


architecture rtl of parity is

    -- @todo: define internal signals/components

begin

    -- @todo: describe the circuit

end architecture rtl;
