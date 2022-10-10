--------------------------------------------------------------------------------
--! Project  : crus.ecc.hamming
--! Engineer : Chase Ruskin
--! Created  : 2022-10-07
--! Entity   : hamm_enc
--! Details  :
--!     Generic hamming-code encoder that takes a message `message` and packages
--!     it with corresponding parity bits into a `packet` for extended hamming
--!     code (SECDED).
--!
--!     Implemented in purely combinational logic.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;

entity hamm_enc is 
    generic (
        PARITY_BITS : positive
    );
    port (
        message  : in  std_logic_vector((2**PARITY_BITS)-PARITY_BITS-1-1 downto 0);
        encoding : out std_logic_vector((2**PARITY_BITS)-1 downto 0)
    );
end entity hamm_enc;


architecture rtl of hamm_enc is
    --! Determines if the `num` is a power of 2. Includes values of 0 and 1.
    function is_pow_2(num: natural) return boolean is
        variable temp: natural;
    begin
        if num = 0 or num = 1  then
            return true;
        elsif num rem 2 /= 0 then
            return false;
        else
            temp := num;
            while temp > 2 loop 
                temp := temp / 2;
                if temp rem 2 /= 0 and temp > 2 then
                    return false;
                end if;
            end loop;
            return true;
        end if;
    end function;

    constant EVEN_PARITY : boolean := true;

    constant DATA_BITS_SIZE   : positive := (2 ** PARITY_BITS)-PARITY_BITS-1;
    constant TOTAL_BITS_SIZE  : positive := (2 ** PARITY_BITS);
    constant PARITY_LINE_SIZE : positive := TOTAL_BITS_SIZE/2;

    type hamm_block is array (0 to PARITY_BITS-1) of std_logic_vector(PARITY_LINE_SIZE-1 downto 0);

    signal blocks : hamm_block;

    -- +1 parity for the zero-th check bit
    signal check_bits : std_logic_vector(PARITY_BITS-1+1 downto 0);

    signal empty_block : std_logic_vector(TOTAL_BITS_SIZE-1 downto 0);
    signal full_block  : std_logic_vector(TOTAL_BITS_SIZE-1 downto 0);

begin
    --! formats the incoming message into a clean hamming-code block with parity
    --! bits cleared.
    process(message)
        variable ctr : natural;
        variable block_v : std_logic_vector(TOTAL_BITS_SIZE-1 downto 0);
    begin
        block_v := (others => '0');
        ctr := 0;
        for ii in 0 to TOTAL_BITS_SIZE-1 loop
            -- use information bit otherwise reserve for parity bit
            if is_pow_2(ii) = false then
                block_v(ii) := message(ctr);
                ctr := ctr + 1;
            end if;
        end loop;
        empty_block <= block_v;
    end process;

    --! divide the entire hamming-code block into parity subset groups
    process(empty_block)
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
                    temp_line := temp_line(PARITY_LINE_SIZE-2 downto 0) & empty_block(jj);
                end if;
            end loop;
            blocks(ii) <= temp_line;
        end loop;
    end process;

    --! instantiate parity checkers for the subset of bits to evaluate
    gen_check_bits: for ii in 0 to PARITY_BITS-1 generate
        uX : entity work.parity
        generic map (
            SIZE        => TOTAL_BITS_SIZE/2,
            EVEN_PARITY => EVEN_PARITY
        ) port map (
            data      => blocks(ii),
            check_bit => check_bits(ii)
        );
    end generate gen_check_bits;

    --! fill the hamming-code block with computed parity bits
    process(empty_block, check_bits)
        variable ctr : natural;
    begin
        full_block <= empty_block;
        ctr := 0;

        for ii in 1 to TOTAL_BITS_SIZE-1 loop
            -- use information bit otherwise reserve for parity bit
            if is_pow_2(ii) = true then
                full_block(ii) <= check_bits(ctr);
                ctr := ctr + 1;
            end if;
        end loop;
    end process;

    --! compute the extra parity bit for double-error detection
    u_sed : entity work.parity
    generic map (
        SIZE        => TOTAL_BITS_SIZE-1,
        EVEN_PARITY => EVEN_PARITY
    ) port map (
        data      => full_block(TOTAL_BITS_SIZE-1 downto 1),
        check_bit => check_bits(PARITY_BITS)
    );

    -- drive the output with the hamming-code block and the 0th parity bit 
    encoding <= full_block(TOTAL_BITS_SIZE-1 downto 1) & check_bits(PARITY_BITS);

end architecture rtl;
