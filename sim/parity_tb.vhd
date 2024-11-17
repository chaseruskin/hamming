-- Testbench for the `parity` module using file IO and event logging.

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.hamm_pkg.all;

library test;
use test.verb.all;

library std;
use std.textio.all;

entity parity_tb is 
    generic (
        --! data width
        SIZE: positive := 8;
        --! Determine to perform even or odd parity
        EVEN_PARITY: boolean := true
    );
end entity parity_tb;


architecture sim of parity_tb is
    -- This record is automatically @generated by Verb.
    -- It is not intended for manual editing.
    type parity_bfm is record
        data: logics(SIZE-1 downto 0);
        check_bit: logic;
    end record;

    signal bfm: parity_bfm;

    --! internal testbench signals
    constant DELAY: time := 10 ns;
    signal halt: boolean := false;

    file events: text open write_mode is "events.log";

begin

    dut : entity work.parity
    generic map (
        SIZE        => SIZE,
        EVEN_PARITY => EVEN_PARITY
    ) port map (
        data      => bfm.data,
        check_bit => bfm.check_bit
    );

    --! assert the received outputs match expected model values
    bench: process
        file inputs: text open read_mode is "inputs.txt";
        file outputs: text open read_mode is "outputs.txt";
        
        -- This procedure is automatically @generated by Verb.
        -- It is not intended for manual editing.
        procedure send(file i: text) is
            variable row: line;
        begin
            if endfile(i) = false then
                readline(i, row);
                drive(row, bfm.data);
            end if;
        end procedure;

        -- This procedure is automatically @generated by Verb.
        -- It is not intended for manual editing.
        procedure compare(file e: text; file o: text) is
            variable row: line;
            variable mdl: parity_bfm;
        begin
            if endfile(o) = false then
                readline(o, row);
                load(row, mdl.check_bit);
                assert_eq(e, bfm.check_bit, mdl.check_bit, "check_bit");
            end if;
        end procedure;

    begin
        -- drive UUT and check circuit behavior
        while not endfile(inputs) loop
            send(inputs);
            wait for DELAY;
            compare(events, outputs);
        end loop;
        complete(events, halt);
    end process;

end architecture;