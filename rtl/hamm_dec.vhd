--------------------------------------------------------------------------------
--! Project  : Hamming
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
use ieee.numeric_std.all;

library work;
use work.hamm_pkg.all;

entity hamm_dec is 
    generic (
        --! number of parity bits to decode (excluding 0th DED bit)
        PARITY_BITS : positive range 2 to positive'high 
    );
    port (
        encoding  : in  std_logic_vector(compute_block_size(PARITY_BITS)-1 downto 0);
        message   : out std_logic_vector(compute_data_size(PARITY_BITS)-1 downto 0);
        --! flag single-error correction (SEC)
        corrected : out std_logic;
        --! flag double-error detection (DED)
        valid     : out std_logic
    ); 
end entity hamm_dec;


architecture rtl of hamm_dec is
    constant EVEN_PARITY : boolean := true;

    constant TOTAL_BITS_SIZE  : positive := hamm_pkg.compute_block_size(PARITY_BITS);
    constant PARITY_LINE_SIZE : positive := TOTAL_BITS_SIZE/2;

    -- compare against the `err_address`
    constant ZEROS : std_logic_vector(PARITY_BITS-1 downto 0) := (others => '0');

    type hamm_block is array (0 to PARITY_BITS-1) of std_logic_vector(PARITY_LINE_SIZE-1 downto 0);

    signal dec_block : hamm_block;

    -- flag for detecting an error in the entire hamming-code block
    signal err_detected : std_logic;
    -- address pinpointing the erroneous bit in the hamming-code block
    signal err_address  : std_logic_vector(PARITY_BITS-1 downto 0);

    -- the encoding after any bit manipulation/correction
    signal encoding_mod : std_logic_vector(TOTAL_BITS_SIZE-1 downto 0);

begin

    --! divide the entire hamming-code block into parity subset groups
    process(encoding)
        variable temp_line : std_logic_vector(PARITY_LINE_SIZE-1 downto 0);
        variable index     : std_logic_vector(PARITY_BITS-1 downto 0);
    begin
        for ii in PARITY_BITS-1 downto 0 loop
            temp_line := (others => '0');
            for jj in TOTAL_BITS_SIZE-1 downto 0 loop 
                -- decode the parity bit index
                index := (others => '0');
                index := std_logic_vector(to_unsigned(jj, PARITY_BITS));

                if index(ii) = '1' then 
                    -- insert new bit
                    temp_line := temp_line(PARITY_LINE_SIZE-2 downto 0) & encoding(jj);
                end if;
            end loop;
            -- drive the ii'th vector in the block as this parity's subset of bits
            dec_block(ii) <= temp_line;
        end loop;
    end process;

    --! instantiate parity checkers for the subset of bits to evaluate
    gen_check_bits: for ii in 0 to PARITY_BITS-1 generate
        u_par : entity work.parity
        generic map (
            SIZE        => TOTAL_BITS_SIZE/2,
            EVEN_PARITY => EVEN_PARITY
        ) port map (
            data      => dec_block(ii),
            check_bit => err_address(ii)
        );
    end generate gen_check_bits;

    --! computes the extra parity bit (0th bit) for double-error detection
    u_ded : entity work.parity
    generic map (
        SIZE        => TOTAL_BITS_SIZE,
        EVEN_PARITY => EVEN_PARITY
    ) port map (
        data      => encoding(TOTAL_BITS_SIZE-1 downto 0),
        check_bit => err_detected
    );

    --! perform bit-error correction
    process(encoding, err_detected, err_address)
    begin
        -- by default, perform no manipulation on the received encoding
        encoding_mod <= encoding;
        -- flip the bit at detected address
        if err_detected = '1' then
            encoding_mod(to_integer(unsigned(err_address))) <= not encoding(to_integer(unsigned(err_address)));
        end if;
    end process;

    --! remove the parity bits to reveal the information bits
    process(encoding_mod)
        variable ctr : natural;
    begin
        message <= (others => '0');
        ctr := 0;
        for ii in 0 to TOTAL_BITS_SIZE-1 loop
            -- take only information bits (non-powers of 2) from encoding
            if hamm_pkg.is_pow_2(ii) = false then
                message(ctr) <= encoding_mod(ii);
                ctr := ctr + 1;
            end if;
        end loop;
    end process;

    -- logic for determining when a single-bit error occurred
    corrected <= err_detected;

    -- logic for determining when a double-bit error occurred
    valid <= '0' when (err_address /= ZEROS and err_detected = '0') else
             '1';

end architecture rtl;
