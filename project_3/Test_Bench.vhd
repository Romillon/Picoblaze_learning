library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity main_tb is
end main_tb;

architecture Behavioral of main_tb is
    signal clk  std_logic = '0';
    signal sw  std_logic_vector(15 downto 0) = (others = '0'); -- Initialisation des commutateurs à zéro
    signal leds  std_logic_vector(15 downto 0);
    signal segs7  std_logic_vector(6 downto 0);
    signal an  std_logic_vector(3 downto 0);

    -- Ajoutez d'autres signaux nécessaires pour le testbench ici

begin
    -- Instanciez le module sous test
    uut entity work.main
        port map (
            clk = clk,
            sw = sw,
            leds = leds,
            segs7 = segs7,
            an = an
        );

    -- Générateur de signal d'horloge
    clk_process process
    begin
        while now  100 ms loop -- Simulation pendant 100 ms (ajustez si nécessaire)
            clk = not clk;
            wait for 5 ns; -- Période de l'horloge (ajustez en fonction de votre période d'horloge)
        end loop;
        wait;
    end process;

    -- Générateur de signaux de test
    stimulus_process process
    begin
        -- Configuration initiale
        sw = (others = '0'); -- Mettez les commutateurs dans l'état initial souhaité

        -- Ajoutez ici les instructions pour configurer les signaux de test
        -- Par exemple, pour changer l'état des commutateurs après 20 ns 
        wait for 20 ns;
        sw = 1010101010101010; -- Exemple de nouvelles valeurs des commutateurs

        wait;
    end process;

    -- Affichage des sorties dans la console (à des fins de débogage)
    display_process process
    begin
        wait for 10 ns; -- Attendez un peu pour éviter les valeurs initiales incorrectes
        while now  100 ms loop -- Simulez pendant 100 ms (ajustez si nécessaire)
            report LEDs  & to_string(leds);
            report 7-Seg  & to_string(segs7);
            report AN  & to_string(an);
            wait for 1 ms; -- Intervalle entre les affichages (ajustez si nécessaire)
        end loop;
        wait;
    end process;

end Behavioral;
