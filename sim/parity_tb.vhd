--------------------------------------------------------------------------------
--! Project   : crus.ecc.hamming
--! Engineer  : Chase Ruskin
--! Created   : 2022-10-07
--! Testbench : parity_tb
--! Details   :
--!     @todo: write general overview of component and its behavior
--!
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library work;
-- @note: uncomment the next 3 lines to use the toolbox package
library util;
use std.textio.all;
use util.toolbox_pkg.all;

entity parity_tb is 
    generic (
        --! data width
        SIZE        : positive := 8;
        --! Determine to perform even or odd parity
        EVEN_PARITY : boolean := true
    );
end entity parity_tb;


architecture sim of parity_tb is
    --! unit-under-test (UUT) interface wires
    signal data      : std_logic_vector(SIZE-1 downto 0);
    signal check_bit : std_logic;

    --! internal testbench signals
    constant DELAY: time := 10 ns;
begin
    --! UUT instantiation
    uut : entity work.parity
    generic map (
        SIZE        => SIZE,
        EVEN_PARITY => EVEN_PARITY
    ) port map (
        data      => data,
        check_bit => check_bit
    );

    --! assert the received outputs match expected model values
    bench: process
        file inputs  : text open read_mode is "inputs.dat";
        file outputs : text open read_mode is "outputs.dat";

        variable exp_check_bit : std_logic;
    begin
        -- drive UUT and check circuit behavior
        while not endfile(inputs) loop
            --! read given inputs from file
            data <= read_str_to_slv(inputs, SIZE);

            wait for DELAY;
            --! read expected outputs from file
            exp_check_bit := read_str_to_sl(outputs);

            assert check_bit = exp_check_bit report error_sl("check_bit", check_bit, exp_check_bit) severity failure;
        end loop;

        -- halt the simulation
        report "Simulation complete.";
        wait;
    end process;

end architecture sim;