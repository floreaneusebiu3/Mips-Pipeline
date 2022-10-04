library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Instruction_Fetch is
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           reset : in STD_LOGIC;
           PCsrc : in STD_LOGIC;
           Jump : in STD_LOGIC;
           BrAddr : in STD_LOGIC_VECTOR (15 downto 0);
           JAddr : in STD_LOGIC_VECTOR (15 downto 0);
           instruction : out STD_LOGIC_VECTOR (15 downto 0);
           PC : out STD_LOGIC_VECTOR (15 downto 0));
end Instruction_Fetch;

architecture Behavioral of Instruction_Fetch is

type romType is array(0 to 255) of std_logic_vector(15 downto 0);
--MEMORIE ROM CU 256 sloturi a cate 16 biti fiecare
--a=0 , b=1, c=0;  suma=a=0;
--suma+=b;
--while c != 10 
--   {
--     c = a + b;
--     a=b;
--     b=c;
--     s+=c;
--   } 
--FIBBONACI:a1=0 a2=1 a3=1 a4=2 a5=3 a6=5 s=12
--SUMA PRIMILOR 6 TERMENI
--signal ROM: romType:=(
--b"000_000_000_000_0_000", --0 xor $0 $0 $0   => $0=0 a                 0000
--b"000_101_101_101_0_000",   --1 xor $5 $5 $5   => $5=0 auxiliar        16D0 
--b"000_001_001_001_0_000", --2 xor $1 $1 $1   => &1=0                   0490
--b"100_101_001_0000001",   --3 addi &5 $1 1    => $1=1 b                9481
--b"000_010_010_010_0_000", --4 xor $2 $2 $2    => $2=0 c                0920
--b"000_011_011_011_0_000", --5 xor $3 $3 $3   => $3=0 suma              0DB0
--b"000_101_001_011_0_111", --6 add $5 $1 $3   => $3=0+1( a+b )          14B7
--b"000_100_100_100_0_000", --7 xor $4 $4 $4  => $4=0                    1240
--b"100_101_100_0001100",   --8 addi  $5 $4 12  => $4=0+12 = 12          960C
--b"010_011_100_0000110",   --9 beq $3 $4  8 pozitii                     4E05
--b"000_001_000_010_0_111", --10 add $1 $0 $2 c=b+a;                     0427 *
--b"000_101_001_000_0_111", --11 add $5 $1 $0 $0=$1 => a=b               1487
--b"000_101_010_001_0_111", --12 add $5 $2 $1   => b=c                   1517
--b"000_010_011_011_0_111", --13 add $2 $3 $3   => s+=c                  09B7
--b"111_0000000001001"  ,    --17 jump 9                                 E009
--b"110_000_011_0000000",    --18 sw offset($0) $3                       C180
--b"001_000_011_0000000",    --19 lw ofsset($0) $3                       2180
--others => x"0"
--);


signal ROM: romType:=(
b"000_101_101_101_0_000", --0 xor $5 $5 $5   => $5=0 auxiliar        16D0
b"000_001_001_001_0_000", --1 xor $1 $1 $1   => &1=0                 0490
b"100_101_101_0000000",   --2 NOOP                                     9680
b"100_101_101_0000000",   --3 NOOP                                     9680
b"100_101_001_0000001",   --4 addi &1 $5 1    => $1=1 b              9481
b"000_011_011_011_0_000", --5 xor $3 $3 $3   => $3=0 suma            0DB0
b"000_010_010_010_0_000", --6 xor $2 $2 $2    => $2=0 c              0920
b"000_100_100_100_0_000", --7 xor $4 $4 $4  => $4=0                  1240
b"000_101_001_011_0_111", --8 add $3 $5 $1   => $3=0+1( a+b )        14B7
b"100_101_100_0001100",   --9 addi  $4 $5 12  => $4=0+12 = 12        960C
b"100_101_101_0000000",   --10 NOOP                                     9680
b"100_101_101_0000000",   --11 NOOP                                     9680
b"010_011_100_0001001",   --12 beq $3 $4  9 pozitii                   4E09
b"100_101_101_0000000",   --13 NOOP                                    9680
b"100_101_101_0000000",   --14 NOOP                                    9680
b"100_101_101_0000000",   --15 NOOP                                    9680
b"000_001_000_010_0_111",  --16 add $2 &1 &0 c=b+a;                   0427 *
b"000_101_001_000_0_111",  --17 add $0 $5 $1 $0=$1 => a=b             1487
b"100_101_101_0000000",    --18 NOOP                                    9680
b"000_101_010_001_0_111",   --19 add $1 $5 $2   => b=c                 1517
b"000_010_011_011_0_111", --20 add $3 $2 $3  => s+=c                 09B7
b"111_0000000001100"  ,    --21 jump 12                              E00A
b"100_101_101_0000000", --22 NOOP                                    9680
b"110_000_011_0000000",    --23 sw offset($0) $3                     C180
b"001_000_011_0000000",    --24 lw ofsset($0) $3                     2180
others => x"0"
);

signal next_instruction: STD_LOGIC_VECTOR(15 downto 0);
signal addr: STD_LOGIC_VECTOR(15 downto 0);
signal jumpOut: STD_LOGIC_VECTOR(15 DOWNTO 0);
signal BranchOut : STD_LOGIC_VECTOR(15 DOWNTO 0);
--sa nu suprascriu intr un registru datele din alt registru
--fara x=x+1

begin


nextInstr: next_instruction <= addr + 1;

ProgramCounter: process(clk)
begin
if clk'event and clk='1' then
if reset = '1' then
addr <= x"0000";
elsif en='1' then 
addr <= jumpOut;
end if;
end if;
end process; 

Branch_Mux: process(next_instruction, BrAddr, PCsrc)
begin 
case PCsrc is
when '0' => BranchOut <= next_instruction;
when others => BranchOut <= BrAddr;
end case;
end process;

Jump_Mux: process(BranchOut, JAddr, Jump)
begin
case Jump is
when '0' => jumpOut <= BranchOut;
when others => jumpOut <= JAddr;
end case;
end process;

instruction <= ROM(conv_integer(Addr));
PC <= Addr;
end Behavioral;
