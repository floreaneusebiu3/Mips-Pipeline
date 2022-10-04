library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ssd is
    Port( clk: in std_logic;
          input: in std_logic_vector(15 downto 0);
          an: out std_logic_vector(3 downto 0);
          cat: out std_logic_vector(6 downto 0));
end ssd;

architecture Behavioral of ssd is
    signal cnt : std_logic_vector(15 downto 0) := x"0000";
    signal hex : std_logic_vector(3 downto 0) := "0000";
begin
    
    process(clk)
    begin
        if rising_edge(clk) then
            cnt <= cnt+1;
        end if;
    end process;
    
    process(cnt(15 downto 14))
    begin
        case cnt(15 downto 14) is
            when "00" => an <= "1110";
            when "01" => an <= "1101";
            when "10" => an <= "1011";
            when others => an <= "0111";
         end case;
    end process;
    
    process(cnt(15 downto 14))
    begin
        case cnt(15 downto 14) is
            when "00" => hex <= input(3 downto 0);
            when "01" => hex <= input(7 downto 4);
            when "10" => hex <= input(11 downto 8);
            when others => hex <= input(15 downto 12);
        end case;
    end process; 
    
with HEX SELect
   cat<= "1111001" when "0001",   --1
         "0100100" when "0010",   --2
         "0110000" when "0011",   --3
         "0011001" when "0100",   --4
         "0010010" when "0101",   --5
         "0000010" when "0110",   --6
         "1111000" when "0111",   --7
         "0000000" when "1000",   --8
         "0010000" when "1001",   --9
         "0001000" when "1010",   --A
         "0000011" when "1011",   --b
         "1000110" when "1100",   --C
         "0100001" when "1101",   --d
         "0000110" when "1110",   --E
         "0001110" when "1111",   --F
         "1000000" when others;   --0
--    process(hex)
--    begin
--        case(hex) is 
--            when "0000" => cat <= "0000001";
--            when "0001" => cat <= "1001111";
--            when "0010" => cat <= "0010010";
--            when "0011" => cat <= "0000110";
--            when "0100" => cat <= "1001100";
--            when "0101" => cat <= "0100100";
--            when "0110" => cat <= "0100000";
--            when "0111" => cat <= "0001111";
--            when "1000" => cat <= "0000000";
--            when "1001" => cat <= "0000100";
--            when "1010" => cat <= "0001000";
--            when "1011" => cat <= "1100000";
--            when "1100" => cat <= "0110001";
--            when "1101" => cat <= "1000010";
--            when "1110" => cat <= "0110000";
--            when "1111" => cat <= "0111000";
--            when others => cat <= "1111110";
--        end case;
--    end process;
    
end Behavioral;
