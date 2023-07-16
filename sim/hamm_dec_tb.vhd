--------------------------------------------------------------------------------
--! Project   : Hamming
--! Engineer  : Chase Ruskin
--! Created   : 2022-10-10
--! Testbench : hamm_dec_tb
--! Details   :
--!     @todo: write general overview of component and its behavior
--!
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.hamm_pkg;
-- @note: uncomment the next 3 lines to use the toolbox package.
library core;
use core.testkit.all;
use std.textio.all;

entity hamm_dec_tb is 
    generic (
        --! number of parity bits to decode (excluding 0th DED bit)
        PARITY_BITS : positive range 2 to positive'high := 4 
    );
end entity hamm_dec_tb;


architecture sim of hamm_dec_tb is
    constant DATA_SIZE  : positive := hamm_pkg.compute_data_size(PARITY_BITS);
    constant BLOCK_SIZE : positive := hamm_pkg.compute_block_size(PARITY_BITS);

    --! unit-under-test (UUT) interface wires
    signal encoding  : std_logic_vector(BLOCK_SIZE-1 downto 0) := (others => '0');
    signal message   : std_logic_vector(DATA_SIZE-1 downto 0);
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
        --! define variables for checking output ports
        variable corrected_e : std_logic;
        variable valid_e     : std_logic;
        variable message_e   : std_logic_vector(DATA_SIZE-1 downto 0);
    begin
        -- @todo: drive UUT and check circuit behavior
        while not endfile(inputs) loop
            --! read given inputs from file

            -- @note: example syntax for toolbox package
            encoding <= read_str_to_slv(inputs, BLOCK_SIZE);

            wait for DELAY;
            --! read expected outputs from file
            message_e := read_str_to_slv(outputs, DATA_SIZE);
            corrected_e := read_str_to_sl(outputs);
            valid_e := read_str_to_sl(outputs);

            --! assert received outputs match expected outputs
            assert message = message_e report error_slv("message", message, message_e) severity failure;
            assert corrected = corrected_e report error_sl("corrected", corrected, corrected_e) severity failure;
            assert valid = valid_e report error_sl("valid", valid, valid_e) severity failure;
        end loop;

        -- halt the simulation
        report "Simulation complete.";
        wait;
    end process;

end architecture sim;