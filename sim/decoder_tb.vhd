--------------------------------------------------------------------------------
--! Project   : crus.ecc.hamming
--! Engineer  : Chase Ruskin
--! Created   : 2022-10-09
--! Testbench : decoder_tb
--! Details   :
--!     @todo: write general overview of component and its behavior
--!
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library work;
-- @note: uncomment the next 3 lines to use the toolbox package.
library util;
use util.toolbox_pkg.all;
use std.textio.all;

entity decoder_tb is 
    generic (
        SIZE : positive := 2
    );
end entity decoder_tb;


architecture sim of decoder_tb is
    --! unit-under-test (UUT) interface wires
    signal enc : std_logic_vector(SIZE-1 downto 0) := (others => '0');
    signal dec : std_logic_vector((2 ** SIZE)-1 downto 0);

    --! internal testbench signals
    constant DELAY : time := 10 ns;
begin
    --! UUT instantiation
    uut : entity work.decoder
    generic map (
        SIZE => SIZE
    ) port map (
        enc => enc,
        dec => dec
    );

    --! assert the received outputs match expected model values
    bench: process
        file inputs  : text open read_mode is "inputs.dat";
        file outputs : text open read_mode is "outputs.dat";
        --! @todo: define variables for checking output ports
        variable dec_ideal : std_logic_vector((2 ** SIZE)-1 downto 0);
    begin
        -- @todo: drive UUT and check circuit behavior
        while not endfile(inputs) loop
            --! read given inputs from file
            enc <= read_str_to_slv(inputs, SIZE);

            wait for DELAY;
            --! read expected outputs from file
            dec_ideal := read_str_to_slv(outputs, 2**SIZE);

            -- @note: example syntax for toolbox package
            assert dec = dec_ideal report error_slv("dec", dec, dec_ideal) severity failure;
        end loop;

        -- halt the simulation
        report "Simulation complete.";
        wait;
    end process;

end architecture sim;