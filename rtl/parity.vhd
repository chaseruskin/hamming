--------------------------------------------------------------------------------
--! Project  : Hamming
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
begin  

    process(data)
        variable check_bit_i : std_logic;
    begin
        -- read each bit in data and flip based on counting '1's
        check_bit_i := data(0);
        for ii in 1 to SIZE-1 loop
            check_bit_i := check_bit_i xor data(ii);
        end loop;

        -- drive output port with result
        if EVEN_PARITY = true then 
            check_bit <= check_bit_i;
        else
            check_bit <= not check_bit_i;
        end if;
    end process;

end architecture rtl;
