

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity UC is
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
end UC;

architecture Behavioral of UC is

  begin
    process(instruction)
    begin
        RegDst <= '0';
        ExtOp <= '0'; 
        ALUSrc <= '0'; 
        Branch <= '0';
        Jump <= '0';
        BNE<='0';
        MemWrite <= '0';
        MemtoReg <= '0'; 
        RegWrite <= '0';
        ALUOp <= "00";
        case instruction is 
            when "000" => -- Instructi de tip R
                RegDst <= '1';
                RegWrite <= '1';
                ALUOp <= "00";
            when "100" => -- ADDI
                ExtOp <= '1';
                ALUSrc <= '1';
                RegWrite <= '1';
                ALUOp <= "01";
            when "001" => -- LW
                ExtOp <= '1';
                ALUSrc <= '1';
                MemtoReg <= '1';
                RegWrite <= '1';
                ALUOp <= "01";
            when "110" => -- SW
                ExtOp <= '1';
                ALUSrc <= '1';
                MemWrite <= '1';
                ALUOp <= "01";
            when "010" => -- BEQ
                ExtOp <= '1';
                Branch <= '1';
                ALUOp <= "10"; --scadere
            when "101" => -- BNE
                ExtOp <= '1';
                BNE<='1';
                ALUOp <= "10"; --scadere
            when "011" => -- ORI
                ALUSrc <= '1';
                RegWrite <= '1';
                ALUOp <= "11"; --OR
            when "111" => -- 111 J
                Jump <= '1';
            when others => 
                  RegDst <= '0';
                  ExtOp <= '0'; 
                  ALUSrc <= '0'; 
                  Branch <= '0';
                  Jump <= '0';
                  BNE<='0';
                  MemWrite <= '0';
                  MemtoReg <= '0'; 
                  RegWrite <= '0';
                  ALUOp <= "00";
        end case;
    end process;	
    	
end Behavioral;