--------------------------------------------------------------------------------
--! Project  : crus.ecc.hamming
--! Engineer : Chase Ruskin
--! Created  : 2022-10-07
--! Entity   : hamm_enc
--! Details  :
--!     Generic hamming-code encoder that takes a message `message` and packages
--!     it with corresponding parity bits into a `packet` for extended hamming
--!     code (SECDED).
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity hamm_enc is 
    generic (
        PARITY_BITS : positive
    );
    port (
        message : in  std_logic_vector((2**PARITY_BITS)-PARITY_BITS-1-1 downto 0);
        packet  : out std_logic_vector((2**PARITY_BITS)-1 downto 0)
    );
end entity hamm_enc;


architecture rtl of hamm_enc is

    -- @todo: define internal signals/components

begin

    -- @todo: describe the circuit

end architecture rtl;
