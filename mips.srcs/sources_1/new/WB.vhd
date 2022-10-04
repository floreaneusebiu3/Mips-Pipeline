library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity WB is
    Port ( ALURes : in STD_LOGIC_VECTOR (15 downto 0);
          MEMData : in STD_LOGIC_VECTOR(15 DOWNTO 0);
          MemtoReg : in STD_LOGIC;
          wd : out std_logic_vector(15 downto 0);
          Branch : in std_logic;
          BNE : in std_logic;
          Zero : in std_logic;
          instruction : in STD_LOGIC_VECTOR(15 DOWNTO 0);
          PC : in STD_LOGIC_VECTOR(15 DOWNTO 0);
          JAddr : out STD_LOGIC_VECTOR(15 DOWNTO 0);
          PCsrc : out STD_LOGIC );
end WB;

architecture Behavioral of WB is

begin
 process(ALURes, MEMData, MemtoReg)
 begin
 if MemtoReg = '1' then
 wd <= MEMData;
 else
 wd <= ALURes;
 end if;
 end process;
 
 PCsrc <=  (Zero AND Branch) or (Zero AND BNE); 
 JAddr <= PC(15 DOWNTO 13) & instruction(12 downto 0);
-- BrAddr <= PC + ExtImm;
end Behavioral;
