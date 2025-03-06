----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.03.2024 18:17:20
-- Design Name: 
-- Module Name: IFetch - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity IFetch is
Port (clk : in STD_LOGIC;
      reset: in std_logic;
      btn : in STD_LOGIC_vector(4 downto 0);
      PCSrc: in std_logic;
      jump: in std_logic;
      jump_adress : in STD_LOGIC_VECTOR (31 downto 0);
      branch_adress: in STD_LOGIC_VECTOR (31 downto 0);
      instruction : out STD_LOGIC_VECTOR (31 downto 0);
      PCplusPatru: out STD_LOGIC_VECTOR (31 downto 0)
      );
      
end IFetch;

architecture Behavioral of IFetch is
    signal inPC: std_logic_vector(31 downto 0);
    signal outPC:std_logic_vector(31 downto 0):=(others=>'0');
    type ROM is array (0 to 31) of STD_LOGIC_VECTOR (31 downto 0);
    signal ROM_ARRAY: ROM  :=(
    --1 --
    0=>B"000000_00000_00000_00010_00000_100000",--00001020 ADD $2,$0,$0 INITIALIZAM COUNTER-UL DE ELEMENTE VERIFICATE
    1=>B"001000_00000_00101_0000000000000100",--20050004 ADDI $5, $0, 4 INITIALIZAM POZ DE UNDE LUAM DIN MEMORIE NUMARUL DE ELEM
    2=>B"001000_00000_00011_0000000000000100",--20030004 ADDI $3, $0, 4 INITIALIZAM INDEXUL VEC DIN MEMORIE
    3=>B"000000_00000_00000_00110_00000_100000",--00003020 ADD $6, $6, $0 INITIALIZAM NR DE ELEM IMPARE GASITE
    4=>B"100011_00101_00100_0000000000000000",--8CA40000 LW $4, 0($5) LUAM NUMARUL DE ELEM DIN MEMORIE PE CARE LE VERIFICAM
    
    5=>B"000100_00010_00100_0000000000001101",--1044000d INCEPUT: beq $2, $4, FINAL COMPARAM DACA AM TERMINAT DE VERIFICAT TOATE NUMERELE
    6=>B"001000_00011_00011_0000000000000100",--20630004 ADDI $3, $3, 4 TRCEM LA URMATORUL ELEMENT
    7=>B"100000_00011_00111_0000000000000000",--80670000 LW $7, 0($3) SALVAM URM ELEMENT
    8=>B"000111_00111_00000_0000000000000010",--1CE00002 BGTZ $7, $0, POZITIV VERIFICAM DACA E POZITIV
    9=>B"001000_00010_00010_0000000000000001",--20420001 ADDI $2, $2, 1 DACA NU E, MARIM NUMARULDE ELEMENTE VERIFICATE 
 
    10=>B"000010_00000000000000000000000101",--800000005 JUMP INCEPUT SARIM LA INSTRUCTIUNEA 5
    
    11=>B"000000_00000_00111_00111_11111_000000",--00073FC0 POZITIV: SLL $7, $7, 31 FACEM SHIFTARE LA DREAPTA PT A PUNE ULTIMUL BIT CA FIIND PRIMUL
    --12=>B"001100_00110_00111_0000000000000001",--13
    12=>B"000100_0111_00000_0000000000000010",--11000002 BEQ $7, $0, NU_E_PAR VERIFICAM DACA S-A CREAT NUMARUL 00000...0 ATUNCI ACESTA ERA PAR DACA NU ERA IMPAR
    13=>B"001000_00010_00010_0000000000000001",--20420001 ADDI $2, $2, 1 DACA ERA PAR MARIM NUMARUL DE ELEMENTE VERIFICATE
    14=>B"000010_00000000000000000000000101",--80000005 JUMP INCEPUT SARIM LA INCEPUT 
    15=>B"001000_00110_00110_0000000000000001",--20C60001 NU_E_PAR: ADDI $6, $6, 1 DACA ERA IMPAR CRESTEM NUMARUL DE ELEMENTE IMPARE
    16=>B"001000_00010_00010_0000000000000001",--20420001 ADDI $2, $2, 1 MARIM NUMARUL DE ELEMENTE VERIFICATE
    17=>B"000010_00000000000000000000000101",--80000005 JUMP INCEPUT SARIM LA INCEPUT
    --20
    --18=>B"001000_00110_00110_0000000000000000",
    --others=> B"101011_00000_00101_0000000000000000"
    others=> B"101011_00000_00110_0000000000000000"--AC060000 SW $6, 0($0) SALVAM LA ADRESA ZERO DIN MEMORIE NUMARUL DE ELEMENTE IMPARE GASITE
     );
    signal DO_ROM:STD_LOGIC_VECTOR(31 downto 0);
    signal add: STD_LOGIC_VECTOR(31 downto 0);
    signal dmuxunu: std_logic_vector(31 downto 0);
    signal dmuxdoi: std_logic_vector(31 downto 0);
    signal rst: std_logic;
    
begin
    rst <= btn(1);
    process(clk, reset, rst)
    begin
        if rst = '1' then
            outPC <= X"00000000";
         else if rising_edge(clk) then
            if reset = '1' then
                outPc <=  inPC;
            end if;
        end if;
    end if;
    end process;
    DO_ROM <=ROM_Array(conv_integer(outPc(6 downto 2)));
    instruction <= DO_ROM;
    -- ALU Logic
    add <= 4 + outPC;
    PCplusPatru <= add;
    --Dmux
    process(PCsrc)
    begin
    if PCsrc = '1' then
        dmuxunu <= branch_adress;
        else
            dmuxunu <= add;
    end if;
    end process;
    
    process(jump)
    begin
    if jump = '1' then
        dmuxdoi <= jump_adress;
        else
        dmuxdoi <= dmuxunu;
    end if;
    end process;
    inPC <=dmuxdoi;
end Behavioral;
