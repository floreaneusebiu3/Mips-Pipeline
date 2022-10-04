library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MEM is
    Port ( ALURes : in STD_LOGIC_VECTOR (15 downto 0);
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           MEMWrite : in STD_LOGIC;
           clk : in STD_LOGIC;
           MemData : out STD_LOGIC_VECTOR(15 DOWNTO 0);
           ALURes_out : out STD_LOGIC_VECTOR (15 downto 0));
end MEM;

architecture Behavioral of MEM is
type reg_array is array (0 to 31) of std_logic_vector(15 downto 0);
signal memory : reg_array:=(
                              others=>x"0000");
begin
process(clk, ALURes)
begin
MemData <= memory( conv_integer(ALURes(4 downto 0))); --citirea 
if rising_edge(clk)
then 
if MEMWrite = '1' then 
memory( conv_integer(ALURes(4 downto 0))) <= rd2;
end if;
end if;
end process;

ALURes_out <= ALURes;

end Behavioral;
