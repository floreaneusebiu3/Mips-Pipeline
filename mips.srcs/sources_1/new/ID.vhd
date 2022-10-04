
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity ID is
    Port ( enable : in STD_LOGIC;
           RegWr : in STD_LOGIC;
           instruction : in STD_LOGIC_VECTOR (15 downto 0);
           WD : in STD_LOGIC_VECTOR (15 downto 0);
           wa : in STD_LOGIC_VECTOR (2 downto 0);
           clk : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0);
           func : out STD_LOGIC_VECTOR (2 downto 0);
           ExtImm : out STD_LOGIC_VECTOR (15 downto 0);
           sa : out STD_LOGIC);
end ID;

architecture Behavioral of ID is

component reg_file is
    Port ( enable: in STD_LOGIC;
           clk : in STD_LOGIC;
           ra1 : in STD_LOGIC_VECTOR (2 downto 0);
           ra2 : in STD_LOGIC_VECTOR (2 downto 0);
           wa : in STD_LOGIC_VECTOR (2 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           wen : in STD_LOGIC;
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0));
end component;

signal out_mux : STD_LOGIC_VECTOR(2 DOWNTO 0);
begin

reg_file1: reg_file port map(enable => enable,
                           clk =>clk,
                            ra1=> instruction(12 downto 10),
                            ra2 => instruction(9 downto 7),
                            wa =>wa,
                            wd => WD,
                            wen => RegWr,
                            rd1=> rd1 , 
                            rd2 =>rd2 );
                            


EXT_UNIT: process(ExtOp, instruction)
begin
case ExtOp is
when '0' => ExtImm <= "000000000" & instruction(6 downto 0);  --fara semn
when others => --cu semn
 if instruction(6)='1' then 
     ExtImm <= "111111111" & instruction(6 downto 0);  --numar negativ
 else
     ExtImm <= "000000000" & instruction(6 downto 0);  --numar pozitiv
     end if;
   end case;
end process;

func <= instruction(2 downto 0);
sa <= instruction(3);
end Behavioral;
