library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SSD is
    Port ( clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR(31 downto 0);
           an : out STD_LOGIC_VECTOR(7 downto 0);
           --schimba: in std_logic;
           cat : out STD_LOGIC_VECTOR(6 downto 0));
end SSD;

architecture Behavioral of SSD is

signal digit : STD_LOGIC_VECTOR(3 downto 0);
signal cnt : STD_LOGIC_VECTOR(16 downto 0) := (others => '0');
signal sel : STD_LOGIC_VECTOR(2 downto 0);

begin

    counter : process(clk) 
    begin
        if rising_edge(clk) then
            cnt <= cnt + 1;
        end if;
    end process;

    sel <= cnt(16 downto 14);

    muxCat : process(sel, digits,schimba)
    begin
    if(schimba = '0') then
        case sel is
            when "000" => an<="0111";digit <= digits(15 downto 12);
            when "001" => an<="1011";digit <= digits(11 downto 8);
            when "010" => an<="1101";digit <= digits(7 downto 4);
            when others => an<="1110";digit <= digits(3 downto 0);
         end case;
        
        else
        case sel is
            when "000" => an<="0111"; digit <= digits(31 downto 28);
            when "001" => an<="1011"; digit <= digits(27 downto 24);
            when "010" => an<="1101"; digit <= digits(23 downto 20);
            when others => an<="1110"; digit <= digits(19 downto 16);
        end case;
    end if;
    end process;

    with digit SELect
        cat <= "1000000" when "0000",   -- 0
               "1111001" when "0001",   -- 1
               "0100100" when "0010",   -- 2
               "0110000" when "0011",   -- 3
               "0011001" when "0100",   -- 4
               "0010010" when "0101",   -- 5
               "0000010" when "0110",   -- 6
               "1111000" when "0111",   -- 7
               "0000000" when "1000",   -- 8
               "0010000" when "1001",   -- 9
               "0001000" when "1010",   -- A
               "0000011" when "1011",   -- b
               "1000110" when "1100",   -- C
               "0100001" when "1101",   -- d
               "0000110" when "1110",   -- E
               "0001110" when "1111",   -- F
               (others => 'X') when others;

end Behavioral;