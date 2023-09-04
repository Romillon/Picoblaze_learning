
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
    Port (ABCD : in STD_LOGIC_VECTOR  (3 downto 0);
          seg  : out STD_LOGIC_VECTOR (6 downto 0);
          --an   : out std_logic_vector (3 downto 0);
          --an_input
          clk  : in std_logic);                                      --clk not used
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
--signal HEX2 : std_logic_vector(3 downto 0);
--signal HEX3 : std_logic_vector(3 downto 0);
--signal HEX4 : std_logic_vector(3 downto 0);



begin
     processor: kcpsm6
    generic map (                 hwbuild => X"00", 
                         interrupt_vector => X"3FF",
                  scratch_pad_memory_size => 64)
    port map(      address => instr_adr,
               instruction => instr,
               bram_enable => bram_enable,
                   port_id => port_id,                              --la je dois changer le truc parce que j'ai le port pour les leds de droite et celles de guahce.
              write_strobe => wr_en,
            k_write_strobe => open,
                  out_port => out_port,
               read_strobe => open,
                   in_port => sw (7 downto 0),
                 interrupt => '0',
             interrupt_ack => open,
                     sleep => '0',
                     reset => rdl,
                       clk => clk);
                       
--  kcpsm6_sleep <= '0';
--  interrupt <= interrupt_ack;


Display1: seg7 
  port map ( ABCD => HEX1,
  clk => clk,
            seg => segs7);

--Display2: seg7 
  --port map ( ABCD => HEX2,
  --          seg => segs7 (13 downto 7));

--Display3: seg7 
  --port map ( ABCD => HEX3,
  --          seg => segs7 (20 downto 14));

--Display4: seg7 
--  port map ( ABCD => HEX4,
--          seg => segs7 (27 downto 21));



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

                if port_id ="00000000" then
                  leds(7 downto 0) <= out_port;  
                end if;

                if port_id ="00000001" then                                 --port_id = 1
                  leds(15 downto 8) <= out_port;  
                end if;

                if port_id = "00000010" then                                --port_id = 2
                  HEX1(3 downto 0) <= out_port(3 downto 0);  
                  an <= out_port(7 downto 4);
                  end if;

--                if port_id(0) ='3' then
 --                 HEX1(7 downto 4) <= out_port; 
   --               an <= 0b01; 
     --           end if;

       --         if port_id(0) ='4' then
         --         HEX1(11 downto 8) <= out_port;  
           --       an <= 0b10;
             --     end if;

           --     if port_id(0) ='5' then
             --     HEX1(15 downto 12) <= out_port;  
               --   an <= 0b11;
                 --end if;
                
            end if;

        end if;
    end process;


end Behavioral;
