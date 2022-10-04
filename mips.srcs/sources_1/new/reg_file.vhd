
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity reg_file is
    Port ( enable: in STD_LOGIC;
           clk : in STD_LOGIC;
           ra1 : in STD_LOGIC_VECTOR (2 downto 0);
           ra2 : in STD_LOGIC_VECTOR (2 downto 0);
           wa : in STD_LOGIC_VECTOR (2 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           wen : in STD_LOGIC;
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0));
end reg_file;

architecture Behavioral of reg_file is

type reg_array is array (0 to 15) of std_logic_vector(15 downto 0);
signal reg_file : reg_array:=(x"0003",
                              x"0030",
                              x"0300",
                              x"3000",
                              x"0002",
                              x"0020",
                              x"0200",
                              x"2000",
                              others=>x"0000");
begin
process(clk)
begin
    if falling_edge(clk) then --scriere sincrona pe front descrescator
        if wen = '1' then
        if enable = '1' then
            reg_file(conv_integer(wa)) <= wd;
            end if;
        end if;
    end if;
end process;

rd1 <= reg_file(conv_integer(ra1)); --citire asincrona
rd2 <= reg_file(conv_integer(ra2));


end Behavioral;
