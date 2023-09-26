

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity component_enabled is
    Port ( 
        enableA             : in std_logic; 
        enableB             : in std_logic; 
        input_data_A        : in  STD_LOGIC_VECTOR(7 downto 0);
        input_data_B        : in  STD_LOGIC_VECTOR(7 downto 0);
        --previous_output     : in  STD_LOGIC_VECTOR(3 downto 0);
        output_data_AN         : out std_logic_vector (3 downto 0);
        output_data_SEG7         : out std_logic_vector (3 downto 0)
        );
end component_enabled;

architecture Behavioral of component_enabled is

begin

    process (enableA,enableB,input_data_A,input_data_B)
    begin
        if enableA ='1' then
            output_data_AN <= input_data_A (7 downto 4);
            output_data_SEG7 <= input_data_A (3 downto 0);
 --           for i in 0 to 7 loop
 --               output_data(i) <= previous_output(i) or input_data_A(i);
 --           end loop;
            
        elsif enableB='1' then
            output_data_AN <= input_data_B (7 downto 4);
            output_data_SEG7 <= input_data_B (3 downto 0);
 --           for i in 0 to 7 loop
 --               output_data(i) <= previous_output(i) or input_data_B(i);
 --           end loop;
        end if;
    end process;

    
        

end Behavioral;
