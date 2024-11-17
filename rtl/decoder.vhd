--------------------------------------------------------------------------------
--! Project  : Hamming
--! Engineer : Chase Ruskin
--! Created  : 2022-10-09
--! Entity   : decoder
--! Details  :
--!     Generic decoder takes a binary encoding of length `SIZE` and returns a 
--!     vector of length 2**`SIZE` with the indexed bit set to '1'.
--!
--!     An example is using a 2-bit encoding to output a 4-bit decoding: 
--!         00 -> 0001, 
--!         01 -> 0010, 
--!         10 -> 0100, 
--!         11 -> 1000.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.hamm_pkg.all;

entity decoder is 
    generic (
        SIZE : positive
    );
    port (
        enc : in  logics(SIZE-1 downto 0);
        dec : out logics((2**SIZE)-1 downto 0)
    );
end entity decoder;


architecture rtl of decoder is
begin

    process(enc)
    begin
        dec <= (others => '0');
        -- set the bit at index 'enc' high
        dec(to_integer(unsigned(enc))) <= '1';
    end process;

end architecture rtl;
