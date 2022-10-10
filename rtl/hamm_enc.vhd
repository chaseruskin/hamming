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
use ieee.numeric_std.all;
library work;
library util;
use util.toolbox_pkg.all;

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
    constant EVEN_PARITY : boolean := true;
    constant DATA_BITS_SIZE  : positive := (2 ** PARITY_BITS)-PARITY_BITS-1;
    constant TOTAL_BITS_SIZE : positive := (2 ** PARITY_BITS);

    constant PARITY_LINE_SIZE : positive := TOTAL_BITS_SIZE/2;

    -- @todo: define internal signals/components


    type hamm_block is array (0 to PARITY_BITS-1) of std_logic_vector(PARITY_LINE_SIZE-1 downto 0);

    signal blocks : hamm_block;

    -- +1 parity for the zero-th check bit
    signal check_bits : std_logic_vector(PARITY_BITS downto 0);

    signal empty_block : std_logic_vector(TOTAL_BITS_SIZE-1 downto 0);
    signal full_block  : std_logic_vector(TOTAL_BITS_SIZE-1 downto 0);

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

begin


    process(message)
        variable ctr : natural;
        variable block_v : std_logic_vector(TOTAL_BITS_SIZE-1 downto 0);
    begin
        -- report "message: " & log_slv(message);
        block_v := (others => '0');
        ctr := 0;

        for ii in 0 to TOTAL_BITS_SIZE-1 loop
            -- use information bit otherwise reserve for parity bit
            -- report boolean'image(is_pow_2(ii)) & " " & integer'image(ii);
            if is_pow_2(ii) = false then
                -- report "ctr: " & integer'image(ctr);
                block_v(ii) := message(ctr);
                ctr := ctr + 1;
            end if;
        end loop;

        -- report "format: " & log_slv(block_v);
        empty_block <= block_v;

    end process;


    -- group the parities
    process(empty_block)
        variable temp_line : std_logic_vector(PARITY_LINE_SIZE-1 downto 0);
        variable index     : std_logic_vector(PARITY_BITS-1 downto 0);
    begin
        for ii in PARITY_BITS-1 downto 0 loop
            -- decode the parity bit index

            temp_line := (others => '0');

            blocks(ii) <= (others => '0');
            for jj in TOTAL_BITS_SIZE-1 downto 0 loop 
                -- report integer'image(jj);
                index := (others => '0');
                index := std_logic_vector(to_unsigned(jj, PARITY_BITS));
                -- report "dec " & log_slv(index);

                if index(ii) = '1' then 
                    -- insert new bit
                    -- report integer'image(jj);
                    temp_line := temp_line(PARITY_LINE_SIZE-2 downto 0) & empty_block(jj);
                end if;
            end loop;
            -- report integer'image(ii) & " " & log_slv(temp_line);
            blocks(ii) <= temp_line;
        end loop;

    end process;

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


    process(empty_block, check_bits)
        variable ctr : natural;
    begin
        full_block <= empty_block;
        ctr := 0;

        -- report "checks: " & log_slv(check_bits);
        for ii in 1 to TOTAL_BITS_SIZE-1 loop
            -- use information bit otherwise reserve for parity bit
            if is_pow_2(ii) = true then
                -- report "ctr: " & integer'image(ctr);
                full_block(ii) <= check_bits(ctr);
                ctr := ctr + 1;
            end if;
        end loop;
    end process;


    u_sed : entity work.parity
    generic map (
        SIZE        => TOTAL_BITS_SIZE-1,
        EVEN_PARITY => EVEN_PARITY
    ) port map (
        data      => full_block(TOTAL_BITS_SIZE-1 downto 1),
        check_bit => check_bits(PARITY_BITS)
    );

    packet <= full_block(TOTAL_BITS_SIZE-1 downto 1) & check_bits(PARITY_BITS);

end architecture rtl;
