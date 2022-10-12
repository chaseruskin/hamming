--------------------------------------------------------------------------------
--! Project  : crus.ecc.hamming
--! Engineer : Chase Ruskin
--! Created  : 2022-10-10
--! Entity   : hamm_dec
--! Details  :
--!     Generic hamming-code decoder that takes a block `encoding` and decodes
--!     it with corresponding parity bits into a `message` from extended 
--!     hamming code (SECDED).
--!
--!     The output port `corrected` is raised when the incoming `encoding`
--!     experienced a single-error correction. The output port `valid` is lowered
--!     if the incoming `encoding` detected a double-bit error.  
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.hamm_pkg;

entity hamm_dec is 
    generic (
        --! number of parity bits to decode (excluding 0th DED bit)
        PARITY_BITS : positive range 2 to positive'high 
    );
    port (
        encoding  : in  std_logic_vector(hamm_pkg.compute_block_size(PARITY_BITS)-1 downto 0);
        message   : out std_logic_vector(hamm_pkg.compute_data_size(PARITY_BITS)-1 downto 0);
        --! communicate single-error correction (SEC)
        corrected : out std_logic;
        --! communicate double-error detection (DED)
        valid     : out std_logic
    ); 
end entity hamm_dec;


architecture rtl of hamm_dec is

    -- @todo: define internal signals/components

begin

    -- @todo: describe the circuit

end architecture rtl;
