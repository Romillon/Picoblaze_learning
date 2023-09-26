
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity main is
    Port ( clk   : in STD_LOGIC;
           sw    : in STD_LOGIC_VECTOR (15 downto 0);
           leds  : out STD_LOGIC_VECTOR (15 downto 0);
           segs7 : out STD_LOGIC_VECTOR (6 downto 0);
           an    : out std_logic_vector(3 downto 0)
           );
end main;

architecture Behavioral of main is

  component kcpsm6 
    generic(                 hwbuild : std_logic_vector(7 downto 0) := X"00";
                    interrupt_vector : std_logic_vector(11 downto 0) := X"3FF";
             scratch_pad_memory_size : integer := 64);
    port (                   address : out std_logic_vector(11 downto 0);
                         instruction : in std_logic_vector(17 downto 0);
                         bram_enable : out std_logic;
                             in_port : in std_logic_vector(7 downto 0);
                            out_port : out std_logic_vector(7 downto 0);
                             port_id : out std_logic_vector(7 downto 0);
                        write_strobe : out std_logic;
                      k_write_strobe : out std_logic;
                         read_strobe : out std_logic;
                           interrupt : in std_logic;
                       interrupt_ack : out std_logic;
                               sleep : in std_logic;
                               reset : in std_logic;
                                 clk : in std_logic);
  end component;

  component seg7 is
    Port (ABCD      : in STD_LOGIC_VECTOR  (3 downto 0);
          seg       : out STD_LOGIC_VECTOR (6 downto 0);
          an        : out std_logic_vector (3 downto 0);
          an_input  : in std_logic_vector (3 downto 0);
          clk       : in std_logic);                                      --clk not used
  end component;

  component component_enabled is
    Port ( 
        enableA             : in std_logic; 
        enableB             : in std_logic; 
        input_data_A        : in  STD_LOGIC_VECTOR(7 downto 0);
        input_data_B        : in  STD_LOGIC_VECTOR(7 downto 0);
        --previous_output     : in  STD_LOGIC_VECTOR(3 downto 0);
        output_data_AN         : out std_logic_vector (3 downto 0);
        output_data_SEG7         : out std_logic_vector (3 downto 0)
        );
  end component; 



  component prog3                            
    generic(             C_FAMILY : string := "S6"; 
                C_RAM_SIZE_KWORDS : integer := 1;
             C_JTAG_LOADER_ENABLE : integer := 0);
    Port (      address : in std_logic_vector(11 downto 0);
            instruction : out std_logic_vector(17 downto 0);
                 enable : in std_logic;
                    rdl : out std_logic;                    
                    clk : in std_logic);
  end component;




signal       instr_adr : std_logic_vector(11 downto 0);
signal           instr : std_logic_vector(17 downto 0);
signal     bram_enable : std_logic;
signal         in_port : std_logic_vector(7 downto 0);
signal        out_port : std_logic_vector(7 downto 0);
signal         port_id : std_logic_vector(7 downto 0);
signal           wr_en : std_logic;
signal  k_write_strobe : std_logic;
signal     read_strobe : std_logic;
signal       interrupt : std_logic;
signal   interrupt_ack : std_logic;
signal    kcpsm6_sleep : std_logic;
signal    kcpsm6_reset : std_logic;

--
-- Some additional signals are required if your system also needs to reset KCPSM6. 
--

signal       cpu_reset : std_logic;
signal             rdl : std_logic;

--
-- When interrupt is to be used then the recommended circuit included below requires 
-- the following signal to represent the request made from your system.
--

signal     int_request : std_logic;


--signals for 7 seg : 
signal HEX1 : std_logic_vector(3 downto 0);
signal ANODE_ACTIVATE : std_logic_vector(3 downto 0);

--signals for enabled_component

signal enable_Wind : std_logic;
signal enable_Solar : std_logic;

signal input_Wind : std_logic_vector(7 downto 0);
signal input_Solar : std_logic_vector(7 downto 0);

--signal output_Wind : std_logic_vector(3 downto 0);
--signal output_Solar : std_logic_vector(3 downto 0);
signal output_Energy : std_logic_vector(3 downto 0);




begin
     processor: kcpsm6
    generic map (                 hwbuild => X"00", 
                         interrupt_vector => X"3FF",
                  scratch_pad_memory_size => 64)
    port map(      address => instr_adr,
               instruction => instr,
               bram_enable => bram_enable,
                   port_id => port_id,                             
              write_strobe => wr_en,
            k_write_strobe => open,
                  out_port => out_port,
               read_strobe => open,
                   in_port => sw (7 downto 0),            --will change after
                 interrupt => '0',
             interrupt_ack => open,
                     sleep => '0',
                     reset => rdl,
                       clk => clk);
                       
--  kcpsm6_sleep <= '0';
--  interrupt <= interrupt_ack;


Display1: seg7 
  port map (ABCD     => HEX1,
            an_input => ANODE_ACTIVATE,
            clk      => clk,
            seg      => segs7,
            an       => an);

Energy_Modules  : component_enabled
  port map (enableA           => enable_Wind,     
            input_data_A      => input_Wind,
            enableB           => enable_Solar,     
            input_data_B      => input_Solar,
            output_data_AN    => ANODE_ACTIVATE,
            output_data_SEG7  => HEX1
            );   --only one input 'cause i fear to display 2 digits



  program_rom: prog3                              --Name to match your PSM file
    generic map(             C_FAMILY => "7S",   --Family 'S6', 'V6' or '7S'
                    C_RAM_SIZE_KWORDS => 2,      --Program size '1', '2' or '4'
                 C_JTAG_LOADER_ENABLE => 1)      --Include JTAG Loader when set to '1' 
    port map(      address => instr_adr,      
               instruction => instr,
                    enable => bram_enable,
                       rdl => rdl,
                       clk => clk);


    process (clk)
    begin
        if clk'event and clk='1' then
            if wr_en ='1' then

              case port_id(2 downto 0) is    
                
                when "000" =>
                in_port <= sw (7 downto 0);


                when "001" =>
                in_port <= sw (15 downto 8);


                when "010" =>
                --in_port(0) <= push_n;         --taken from KCPSM6 User Guide    SLIDE 20
                --in_port(1) <= push_e;         --might be use later on
                --in_port(2) <= push_s;
                --in_port(3) <= push_w;
                --in_port(4) <= push_c;


                when "011" =>
                  leds(7 downto 0) <= out_port;  
                

                when "100" =>                              
                  leds(15 downto 8) <= out_port;  
                

                when "101" =>                   
                  enable_Wind  <= '1';
                  enable_Solar <= '0';              
                  input_Wind <= out_port;                
                          


                when "110" =>
                  enable_Wind  <= '0';
                  enable_Solar <= '1';
                  input_Solar <= out_port;



                when others =>
                  in_port <= "XXXXXXXX";
                  out_port <="XXXXXXXX";              


              end case;

            end if;

        end if;
    end process;


end Behavioral;
