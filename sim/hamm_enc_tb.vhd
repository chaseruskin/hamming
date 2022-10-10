--------------------------------------------------------------------------------
--! Project   : crus.ecc.hamming
--! Engineer  : Chase Ruskin
--! Created   : 2022-10-09
--! Testbench : hamm_enc_tb
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

entity hamm_enc_tb is 
    generic (
        PARITY_BITS : positive range 2 to positive'high := 4
    );
end entity hamm_enc_tb;


architecture sim of hamm_enc_tb is

    constant DATA_BITS_SIZE  : positive := (2 ** PARITY_BITS)-PARITY_BITS-1;
    constant TOTAL_BITS_SIZE : positive := (2 ** PARITY_BITS);
    --! unit-under-test (UUT) interface wires
    signal message : std_logic_vector(DATA_BITS_SIZE-1 downto 0);
    signal packet  : std_logic_vector(TOTAL_BITS_SIZE-1 downto 0);

    --! internal testbench signals
    constant DELAY : time := 10 ns;
begin
    --! UUT instantiation
    uut : entity work.hamm_enc
    generic map (
        PARITY_BITS => PARITY_BITS
    ) port map (
        message => message,
        packet  => packet
    );

    --! assert the received outputs match expected model values
    bench: process
        file inputs  : text open read_mode is "inputs.dat";
        file outputs : text open read_mode is "outputs.dat";

        variable packet_ideal : std_logic_vector(TOTAL_BITS_SIZE-1 downto 0);
    begin
        -- @todo: drive UUT and check circuit behavior
        while not endfile(inputs) loop
            --! read given inputs from file

            -- @note: example syntax for toolbox package
            -- <signal> <= read_str_to_slv(inputs, <width>);
            message <= read_str_to_slv(inputs, DATA_BITS_SIZE);

            wait for DELAY;
            --! read expected outputs from file

            -- @note: example syntax for toolbox package
            -- <signal> <= read_str_to_slv(outputs, <width>);
            packet_ideal := read_str_to_slv(outputs, TOTAL_BITS_SIZE);


            -- @note: example syntax for toolbox package
            assert packet = packet_ideal report error_slv("packet", packet, packet_ideal) severity failure;
        end loop;

        -- halt the simulation
        report "Simulation complete.";
        wait;
    end process;

end architecture sim;