----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.04.2024 02:56:13
-- Design Name: 
-- Module Name: MEM - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MEM is
  Port (
MemWrite: in STD_LOGIC;--
ALUResIn: in STD_LOGIC_VECTOR (31 downto 0);--
WriteData: in STD_LOGIC_VECTOR (31 downto 0);
clk: in STD_LOGIC;--
En: in STD_LOGIC;--
ReadData : out STD_LOGIC_VECTOR (31 downto 0);
ALUResOut : out STD_LOGIC_VECTOR (31 downto 0));--
end MEM;

architecture Behavioral of MEM is
signal addresse: std_logic_vector(5 downto 0);
type ram_type is array (0 to 63) of std_logic_vector(31 downto 0);
signal ram : ram_type := 
(
     4  => "00000000000000000000000000000100", 
     8  => "00000000000000000000000000001001",
     12 => "10000000000000000000000001000000",
     16 => "10000000000000000000000000000011",
     20 => "00000000000000000000000000000011",
     24 => "00000000000000000000000000000111",
     others => "00000000000000000000000000000000"
);
begin

addresse <= ALUResIn(7 downto 2);
process(clk)
begin
if rising_edge(clk) then
    if en = '1' and MemWrite = '1' then
        ram(conv_integer(AluResIn)) <= WriteData;
    end if;
end if;
end process;
ReadData <= ram(conv_integer(ALUResIn));
ALUResOut <= ALUResIn;
end Behavioral;
    