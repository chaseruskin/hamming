--------------------------------------------------------------------------------
--! Project  : crus.ecc.hamming
--! Engineer : Chase Ruskin
--! Created  : 2022-10-10
--! Entity   : hamm_pkg
--! Details  :
--!     Hamming code package consisting of helper functions and constants.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package hamm_pkg is
    --! Determines if the `num` is a power of 2. 
    --!
    --! Includes values of 0 and 1.
    function is_pow_2(num: natural) return boolean;

end package hamm_pkg;


package body hamm_pkg is 

    function is_pow_2(num: natural) return boolean is
        variable temp: natural;
    begin
        temp := num;
        while temp > 2 loop 
            if temp rem 2 /= 0 and temp > 2 then
                return false;
            end if;
            temp := temp / 2;
        end loop;
        return true;
    end function;

end package body;