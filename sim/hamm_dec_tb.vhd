--------------------------------------------------------------------------------
--! Project   : crus.ecc.hamming
--! Engineer  : Chase Ruskin
--! Created   : 2022-10-10
--! Testbench : hamm_dec_tb
--! Details   :
--!     @todo: write general overview of component and its behavior
--!
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-- @note: uncomment the next 3 lines to use the toolbox package.
-- library util;
-- use util.toolbox_pkg.all;
-- use std.textio.all;

entity hamm_dec_tb is 
    generic (
        --! number of parity bits to decode (excluding 0th DED bit)
        PARITY_BITS : positive range 2 to positive'high := 4 
    );
end entity hamm_dec_tb;


architecture sim of hamm_dec_tb is
    --! unit-under-test (UUT) interface wires
    signal encoding  : std_logic_vector((2 ** PARITY_BITS)-1 downto 0);
    signal message   : std_logic_vector((2 ** PARITY_BITS)-PARITY_BITS-1-1 downto 0);
    signal corrected : std_logic;
    signal valid     : std_logic;

    --! internal testbench signals
    constant DELAY : time := 10 ns;
begin
    --! UUT instantiation
    uut : entity work.hamm_dec
    generic map (
        PARITY_BITS => PARITY_BITS
    ) port map (
        encoding  => encoding,
        message   => message,
        corrected => corrected,
        valid     => valid
    );

    --! assert the received outputs match expected model values
    bench: process
        file inputs  : text open read_mode is "inputs.dat";
        file outputs : text open read_mode is "outputs.dat";
        --! @todo: define variables for checking output ports
    begin
        -- @todo: drive UUT and check circuit behavior
        while not endfile(inputs) loop
            --! read given inputs from file

            -- @note: example syntax for toolbox package
            -- <signal> <= read_str_to_slv(inputs, <width>);

            wait for DELAY;
            --! read expected outputs from file

            -- @note: example syntax for toolbox package
            -- <signal> := read_str_to_slv(outputs, <width>);

            -- @note: example syntax for toolbox package
            -- assert <received> = <expected> report error_slv("<message>", <received>, <expected>) severity failure;
        end loop;

        -- halt the simulation
        report "Simulation complete.";
        wait;
    end process;

end architecture sim;