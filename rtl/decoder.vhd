--------------------------------------------------------------------------------
--! Project  : crus.ecc.hamming
--! Engineer : Chase Ruskin
--! Created  : 2022-10-09
--! Entity   : decoder
--! Details  :
--!     @todo: write general overview of component and its behavior
--!
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder is 
    generic (
        SIZE : positive
    );
    port (
        enc : in  std_logic_vector(SIZE-1 downto 0);
        dec : out std_logic_vector((2**SIZE)-1 downto 0)
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
