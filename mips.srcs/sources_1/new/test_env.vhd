library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;


architecture Behavioral of test_env is

component mpg is
    Port( clk: in std_logic;
          btn: in std_logic;
          btn_out: out std_logic);
end component;

component ssd is
    Port( clk: in std_logic;
          input: in std_logic_vector(15 downto 0);
          an: out std_logic_vector(3 downto 0);
          cat: out std_logic_vector(6 downto 0));
end component;


component Instruction_Fetch is
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           reset : in STD_LOGIC;
           PCsrc : in STD_LOGIC;
           Jump : in STD_LOGIC;
           BrAddr : in STD_LOGIC_VECTOR (15 downto 0);
           JAddr : in STD_LOGIC_VECTOR (15 downto 0);
           instruction : out STD_LOGIC_VECTOR (15 downto 0);
           PC : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component ID is
    Port ( enable: in STD_LOGIC;
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
end component;


component UC is
  Port ( instruction : in STD_LOGIC_VECTOR(2 downto 0);
         RegDst : out STD_LOGIC;
         ExtOp : out STD_LOGIC;
         ALUSrc : out STD_LOGIC;
         Branch : out STD_LOGIC;
         Jump : out STD_LOGIC;
         BNE: out STD_LOGIC;
         ALUOp : out STD_LOGIC_VECTOR(1 downto 0);
         MemWrite : out STD_LOGIC;
         MemtoReg : out STD_LOGIC;
         RegWrite : out STD_LOGIC);
end component;


COMPONENT EX is
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
end component;

component MEM is
    Port ( ALURes : in STD_LOGIC_VECTOR (15 downto 0);
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           MEMWrite : in STD_LOGIC;
           clk : in STD_LOGIC;
           MemData : out STD_LOGIC_VECTOR(15 DOWNTO 0);
           ALURes_out : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component WB is
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
end component;

--IF signals
signal BrAddr: STD_LOGIC_VECTOR(15 DOWNTO 0);
signal JAddr: STD_LOGIC_VECTOR(15 DOWNTO 0);
signal enable: STD_LOGIC;
signal resetPC: STD_LOGIC;
signal instruction : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal PC : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal PCsrc : STD_LOGIC;

--ID signals
signal RegDst: std_logic;
signal RegWrite: std_logic;
signal wd : STD_LOGIC_VECTOR (15 downto 0);
signal sa: std_logic;
signal rd1: std_logic_vector(15 downto 0);
signal rd2: std_logic_vector(15 downto 0);
signal func: std_logic_vector(2 downto 0);
signal ExtImm: std_logic_vector(15 downto 0);
signal ExtOp: std_logic;


signal digits : STD_LOGIC_VECTOR(15 DOWNTO 0);

--UC signals
signal ALUOp: std_logic_vector(1 downto 0);
signal ALUSrc: std_logic;
signal branch: std_logic;
signal jump: std_logic;
signal BNE: std_logic;
signal MemWrite: std_logic;
signal MemtoReg: std_logic;

signal Zero : std_logic;
signal enableWr : std_logic;
signal AluRes : std_logic_vector(15 downto 0);
signal MEMData : std_logic_vector(15 downto 0);

signal ALURes_out : std_logic_vector(15 downto 0);

--IF_ID_REG
signal IFID_REG : STD_LOGIC_VECTOR(31 DOWNTO 0);
alias PC_ID: STD_LOGIC_VECTOR(15 DOWNTO 0) is IFID_REG(31 DOWNTO 16);
alias instr_ID: STD_LOGIC_VECTOR(15 DOWNTO 0) is IFID_REG(15 DOWNTO 0);
alias opcode is instr_ID(15 downto 13);

--ID_EX_REG
signal IDEX_REG : STD_LOGIC_VECTOR(82 DOWNTO 0);
alias WB_EX : STD_LOGIC_VECTOR(1 DOWNTO 0) is IDEX_REG(82 downto 81);
alias M_EX : STD_LOGIC_VECTOR(2 DOWNTO 0) is IDEX_REG(80 downto 78);
alias EX_EX : STD_LOGIC_VECTOR(3 DOWNTO 0) is IDEX_REG(77 downto 74);
alias PC_EX : STD_LOGIC_VECTOR(15 DOWNTO 0) is IDEX_REG(73 downto 58);
alias RD1_EX : STD_LOGIC_VECTOR(15 DOWNTO 0) is IDEX_REG(57 downto 42);
alias RD2_EX : STD_LOGIC_VECTOR(15 DOWNTO 0) is IDEX_REG(41 downto 26);
alias Ext_EX : STD_LOGIC_VECTOR(15 DOWNTO 0) is IDEX_REG(25 downto 10);
alias func_EX : STD_LOGIC_VECTOR(2 DOWNTO 0) is IDEX_REG(9 downto 7);
alias rt_EX : STD_LOGIC_VECTOR(2 DOWNTO 0) is IDEX_REG(6 downto 4);
alias rd_EX : STD_LOGIC_VECTOR(2 DOWNTO 0) is IDEX_REG(3 downto 1);
alias sa_EX : STD_LOGIC is IDEX_REG(0);

--EX_MEM_REG
signal EXMEM_REG : std_logic_vector(56 downto 0);
alias WB_MEM: STD_LOGIC_VECTOR(1 DOWNTO 0) IS EXMEM_REG(56 DOWNTO 55);
alias M_MEM: STD_LOGIC_VECTOR(2 DOWNTO 0) IS EXMEM_REG(54 DOWNTO 52);
alias BR_MEM: STD_LOGIC_VECTOR(15 DOWNTO 0) IS EXMEM_REG(51 DOWNTO 36);
alias ZERO_MEM: STD_LOGIC IS EXMEM_REG(35);
alias ALURES_MEM: STD_LOGIC_VECTOR(15 DOWNTO 0) IS EXMEM_REG(34 DOWNTO 19);
alias RD2_MEM: STD_LOGIC_VECTOR(15 DOWNTO 0) IS EXMEM_REG(18 DOWNTO 3);
alias OUTMUX_MEM: STD_LOGIC_VECTOR(2 DOWNTO 0) IS EXMEM_REG(2 DOWNTO 0);

--MEM_WB_REG
signal MEMWB_REG: STD_LOGIC_VECTOR(36 DOWNTO 0);
alias WB_WB : STD_LOGIC_VECTOR(1 DOWNTO 0) IS MEMWB_REG(36 DOWNTO 35);
alias MEMDATA_WB : STD_LOGIC_VECTOR(15 DOWNTO 0) IS MEMWB_REG(34 DOWNTO 19);
alias ALURES_WB : STD_LOGIC_VECTOR(15 DOWNTO 0) IS MEMWB_REG(18 DOWNTO 3);
alias OUTMUX_WB : STD_LOGIC_VECTOR(2 DOWNTO 0) IS MEMWB_REG(2 DOWNTO 0);

signal out_mux_jos : STD_LOGIC_VECTOR(2 DOWNTO 0);
signal out_mux_dreapta : STD_LOGIC_VECTOR(15 DOWNTO 0);

begin

 ----------------------------------------------PIPELINE-----------------------------------------------------------------------
IF_ID_REGISTER: process(clk, ENABLE)
begin
if rising_edge(clk) AND ENABLE = '1' THEN
PC_ID <= PC;
instr_ID <= instruction;
end if;
end process;

ID_EX_REGISTER: process(clk, enable)
begin
if clk'event and clk = '1' and enable ='1' then
WB_EX <= MemtoReg & RegWrite;
M_EX <= MemWrite & Branch & BNE;
EX_EX <= AluOp & AluSrc & RegDst;
PC_EX <= PC_ID;
RD1_EX <= RD1;
RD2_EX <= RD2;
Ext_EX <= ExtImm;
func_EX <= func;
rt_EX <= instr_ID(9 downto 7);
rd_EX <= instr_ID(6 DOWNTO 4);
sa_EX <= sa;
end if;
end process;

EX_MEM_REGISTER: process(clk, enable)
begin
if rising_edge(clk) and enable = '1' then
WB_MEM <= WB_EX;
M_MEM <= M_EX;
BR_MEM <= BrAddr;
Zero_MEM <= Zero;
ALURES_MEM <= AluRes;
RD2_MEM <= RD2_EX;
outmux_MEM <= out_mux_jos;  --CEL DIN MUX
end if;
end process;

MEM_WB_REGISTER: process(clk, enable)
begin
if rising_edge(clk) and enable='1' then 
WB_WB <= WB_MEM;
MEMDATA_WB <=MemData;
AluRES_WB <= AluRes_MEM;
outmux_WB <= outmux_MEM;
end if;
end process;

 ----------------------------------------------PIPELINE-----------------------------------------------------------------------
mpg1:mpg port map(clk =>clk,btn=> btn(1), btn_out => enable);
mpg2:mpg port map(clk =>clk, btn => btn(0), btn_out=> resetPC);


instruction_fetchh: Instruction_Fetch port map( clk => clk,
           en => enable, 
           reset => resetPC,
           PCsrc => PCsrc,
           Jump => Jump,
           BrAddr => Br_MEM,
           JAddr => JAddr,
           instruction => instruction,
           PC => PC);


unitate_control1: UC port map  ( instruction => instr_id(15 downto 13),
         RegDst =>  RegDst,
         ExtOp => ExtOp,
         ALUSrc => ALUSrc,
         Branch=> Branch,
         Jump => Jump,
         BNE => BNE,
         ALUOp => ALUOp,
         MemWrite => MemWrite,
         MemtoReg => MemtoReg,
         RegWrite => RegWrite);
         
           
--wa_mux_jos: process(rt_EX, rd_EX, WB_WB)
--           begin
--                 if wb_wb(0) = '0' then
--                 out_mux_jos <= rt_EX;
--                 else
--                 out_mux_jos <= rd_EX;
--                 end if;
--           end process;
       
wd_mux_dreapta: process(WB_WB, MEMDATA_WB, ALURES_MEM)
begin
if wb_wb(1) = '0' then
out_mux_dreapta <= ALURES_MEM;
else
out_mux_dreapta <= MEMDATA_WB;
end if;
end process;       
         
instruction_decoder: ID port map( 
                      enable =>enable,
                      RegWr => WB_EX(0),
                      instruction => instr_ID, 
                      WD => out_mux_dreapta,
                      wa => outmux_wb,
                      clk => clk, 
                      ExtOp => ExtOp,
                      RD1 => rd1,
                      RD2 => rd2,
                      func => func,
                      ExtImm => ExtImm,
                      sa => sa);

Execute: EX port map( 
          rd1 => rd1_EX, 
          ALUSrc => EX_EX(1),
          rd2 => RD2_EX, 
          Ext_Imm => EXT_EX,
          sa => sa_EX, 
          func => func_EX, 
          ALUOp => EX_EX(3 DOWNTO 2),
          Zero => ZERO,
          ALURes => AluRes,
          RegDst => EX_EX(0),
          instruction => INSTRuction,
          out_mux => out_mux_jos );

     

Memory: MEM port map( ALURes => AluRes_MEM, 
                       rd2 => RD2_MEM, 
                       MEMWrite => M_MEM(1),
                       clk => clk, 
                       MemData => MemData,
                       ALURes_out => AluRes_MEM);
                       
    BrAddr <= PC_EX + Ext_EX;

WRITE_BACK: WB port map(         ALURes => ALUres_WB,
                                 MEMData => MEMData_WB,
                                 MemtoReg => WB_WB(1),
                                 wd => wd,
                                 Branch => M_MEM(1),
                                 BNE => M_MEM(0),
                                 Zero => Zero_MEM,
                                 instruction => instr_ID,
                                 PC => PC_ID,
                                 JAddr => JAddr,
                                 PCsrc => PCSrc );                      
                     

 
MUX_SSD: process(sw, instr_ID, PC_ID, rd1, rd2, ExtImm, ALURes, MEMData, wd)
 begin
     case sw(15 downto 0) is
         when "1000000000000000" => Digits <=instr_ID;   --sw(15) = '1' => etajul if/id
         when "1000000000000001" => Digits <= PC_ID;
         when "0100000000000000" => Digits <= PC_EX;
         when "0100000000000001" => Digits <= RD1_EX;
         when "0100000000000010" => Digits <= RD2_EX;
         when "0100000000000011" => Digits <= Ext_EX;
         when "0100000000000100" => Digits <= ALURES;
         when "0010000000000000" => Digits <= BR_MEM;
         when "0010000000000001" => Digits <= ALURES_MEM;
         when "0010000000000010" => Digits <= RD2_MEM;
         when "0001000000000000" => Digits <= MEMDATA_WB;
         when "0001000000000001" => Digits <= ALURES_WB;
         when others => Digits <= x"1111";
     end case;
 end process;
 
 ssd1: ssd port map(clk => clk, input =>digits, an=>an, cat =>cat );
 
  led(15) <= RegDst;          
  led(14) <= RegWrite;          
  led(13) <= ExtOp;          
  led(12) <= ALUSrc;          
  led(11) <= MemWrite;          
  led(10) <= MemtoReg;          
  led(9) <= Branch;          
  led(8) <= Bne;                   
  led(7) <= Jump; 
  led(6) <= PCSrc;    
  led(5 downto 4) <= ALUOp; 
  led(3) <= btn(2);
  led(1) <= EX_EX(1);
  led(0) <= AluSrc;

end Behavioral;
--pur si simplu nu vrea sa modifice valoarea registrilor
--problema probabil la write back
