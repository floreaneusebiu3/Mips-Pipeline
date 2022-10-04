library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity EX is
    Port ( rd1 : in STD_LOGIC_VECTOR(15 downto 0); 
           ALUSrc : in STD_LOGIC;
           rd2: in STD_LOGIC_VECTOR(15 DOWNTO 0);
           Ext_Imm: in STD_LOGIC_VECTOR(15 DOWNTO 0);
           sa : in STD_LOGIC;
           func : in STD_LOGIC_VECTOR(2 DOWNTO 0);
           ALUOp: in STD_LOGIC_VECTOR(1 DOWNTO 0);
           Zero: out STD_LOGIC;
           ALURes : out STD_LOGIC_VECTOR(15 DOWNTO 0);
           RegDst : in STD_LOGIC;
           instruction : in STD_LOGIC_VECTOR (15 downto 0);
           out_mux : out STD_LOGIC_VECTOR(2 DOWNTO 0));
end EX;

architecture Behavioral of EX is

signal AluCtrlOut : STD_LOGIC_VECTOR(2 DOWNTO 0);
signal alu_input : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal alu_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
begin

ALU_CONTROL: process(ALUOp, func)
begin
case ALUOp is
when "00" => AluCtrlOut <= func; --RType
when "01" => AluCtrlOut <= "111"; --add function for addi, lw, sw
when "10" => AluCtrlOut <= "110"; --sub function for beq, bne
when others => AluCtrlOut <= "100"; -- or function for ori
end case;
end process;

mux_in: process(rd2, Ext_Imm, ALUSrc)
begin
if ALUSrc = '0' then
alu_input <= rd2;
else
alu_input <= Ext_Imm;
end if;
end process;

BIG_ALU: process(AluCtrlOut, alu_input, rd1, ALUOp, func, sa)
begin
  case AluCtrlOut is 
  when "111" => alu_out <= rd1 + alu_input; --add
  when "110" => alu_out <= rd1 -alu_input; --sub
  when "101" => alu_out <= std_logic_vector(shift_left(unsigned(rd1), to_integer(unsigned(alu_input)))); --shift_left
  when "011" => alu_out <= std_logic_vector(shift_right(unsigned(rd1), to_integer(unsigned(alu_input))));--shift_right
  when "001" => alu_out <= rd1 AND alu_input; --logical and
  when "100" => alu_out <= rd1 OR alu_input; --logical or
  when "000" => alu_out <= rd1 XOR alu_input; --logical xor
  when "010" => alu_out <= std_logic_vector(unsigned(rd1)) + std_logic_vector(unsigned(alu_input)); --addu
  end case;
end process;

ZeroFlag: process(alu_out)
begin
if alu_out = x"0000" then
zero <= '1';
else
zero <= '0';
end if;
end process;

MUXX1:  process(RegDst, instruction)
begin 
case RegDst is
when '0' => out_mux <= instruction(9 downto 7);
when others => out_mux <= instruction(6 downto 4);
end case;
end process;

ALURes <= alu_out;

end Behavioral;
