library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;


entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;
Architecture Behavioral of test_env is

component MPG 
   Port (enable: out STD_LOGIC;
          btn: in STD_LOGIC;
          clk: in STD_LOGIC);
end component ;

component SSD
   PORT( clk : in STD_LOGIC;
       digits : in STD_LOGIC_VECTOR(31 downto 0);
      -- schimba :in std_logic;
       an : out STD_LOGIC_VECTOR(3 downto 0);
       cat : out STD_LOGIC_VECTOR(6 downto 0));
end component;

component IFetch is
Port (clk : in STD_LOGIC;
      reset: in std_logic;
      btn : in STD_LOGIC_VECTOR (4 downto 0);
      PCSrc: in std_logic;
      jump: in std_logic;
      jump_adress : in STD_LOGIC_VECTOR (31 downto 0);
      branch_adress: in STD_LOGIC_VECTOR (31 downto 0);
      instruction : out STD_LOGIC_VECTOR (31 downto 0);
      PCplusPatru: out STD_LOGIC_VECTOR (31 downto 0)
      );
      
end component;

component UC is
Port(
instr : in std_logic_vector(31 downto 26);
MemtoReg: out std_logic;
MemWrite: out std_logic;
Jump: out std_logic;
Branch: out std_logic;
Branch_gt: out std_logic;
ALUSrc: out std_logic;
ALUOp: out std_logic_vector(2 downto 0);
RegWrite: out std_logic;
RegDst: out std_logic;
ExtOp: out std_logic
);
end component;

component ID is
Port (
clk: in std_logic;
en: in std_logic;
RegWrite: in std_logic;
Instr: in std_logic_vector(25 downto 0);
RegDst: in std_logic;
ExtOP: in std_logic;
RD1: out std_logic_vector(31 downto 0);
RD2: out std_logic_vector(31 downto 0);
WD: in std_logic_vector(31 downto 0);
Ext_Imm: out std_logic_vector(31 downto 0);
func : out std_logic_vector(5 downto 0);
sa : out std_logic_vector(4 downto 0)
); 
end component;

component EX is
port(RD1: in std_logic_vector(31 downto 0);
    ALUSrc: in std_logic;
    RD2: in  std_logic_vector(31 downto 0);
    Ext_Imm: in std_logic_vector(31 downto 0);
    sa: in std_logic_vector(4 downto 0);
    func: in std_logic_vector(5 downto 0);
    ALUOp: in std_logic_vector(2 downto 0);
    PCplusPatru: in std_logic_vector(31 downto 0);
    Zero: out std_logic;
    NotZero: out std_logic;
    ALURes: out std_logic_vector(31 downto 0);
    BranchAddress: out std_logic_vector(31 downto 0)
);
end component;


component MEM is
  Port (
MemWrite: in STD_LOGIC;--
ALUResIn: in STD_LOGIC_VECTOR (31 downto 0);--
WriteData: in STD_LOGIC_VECTOR (31 downto 0);
clk: in STD_LOGIC;--
En: in STD_LOGIC;--
ReadData : out STD_LOGIC_VECTOR (31 downto 0);
ALUResOut : out STD_LOGIC_VECTOR (31 downto 0));
end component;


signal jumpAddress: std_logic_vector(31 downto 0);
signal PCplusPatru: std_logic_vector(31 downto 0);
signal instruction: std_logic_vector(31 downto 0);
signal PCSrc: std_logic;
signal branch: std_logic;
signal zero: std_logic;
signal reset: std_logic;
signal jump: STD_LOGIC;
signal branch_adress: Std_logic_vector(31 downto 0);
signal rez: std_logic;
signal digits : STD_LOGIC_VECTOR(31 downto 0);
signal MemtoReg: std_logic;
signal RegWrite: std_logic;
signal MemWrite: std_logic;
signal ALUSrc: std_logic;
signal ALUOp: std_logic_vector(2 downto 0);
signal RegDst: std_logic;
signal ExtOp: std_logic;
signal RD1: std_logic_vector(31 downto 0):=(others=>'0');
signal RD2: std_logic_vector(31 downto 0):=(others=>'0');
signal WD: std_logic_vector(31 downto 0);
signal Ext_Imm: std_logic_vector(31 downto 0);
signal func : std_logic_vector(5 downto 0);
signal sa : std_logic_vector(4 downto 0); 
signal ALURes: std_logic_vector(31 downto 0);
signal ALUResOut: std_logic_vector(31 downto 0);
signal MemData: std_logic_vector(31 downto 0);
signal swit: std_logic_vector(2 downto 0);
signal not_zero: std_logic;
signal branch_gt: std_logic;
signal enable: std_logic;
begin


IFetch1: IFetch port map(
    clk => clk,
    btn => btn,---nu sunt sigurrr
    reset => enable,
    jump =>jump,
    PCSrc =>PCSrc,
    instruction => instruction,
    PCplusPatru => PCplusPatru,
    jump_adress => jumpAddress,
    branch_adress => branch_adress
);
mpg1: MPG port map
(
    btn=>btn(0),
    clk=>clk,
    enable=>enable
);

ssd1: SSD port map(
    clk => clk,
    cat => cat,
    an=> an,
  --  schimba => sw(15),
    digits => digits
);

UnitateControl: UC port map(
    instr => instruction(31 downto 26),
    MemtoReg => MemtoReg,
    MemWrite => MemWrite,
    Jump => Jump,
    Branch => Branch,
    Branch_gt => branch_gt,
    ALUSrc => ALUSrc,
    ALUOp => ALUOp,
    RegWrite => RegWrite,
    RegDst => RegDst,
    ExtOp => ExtOp
 
);
IDecode: ID port map(
    clk => clk,
    en => enable,
    RegWrite => RegWrite,
    Instr => instruction(25 downto 0),
    RegDst => RegDst,
    ExtOP => ExtOp,
    RD1 => RD1,
    RD2 =>RD2,
    WD => WD,
    Ext_Imm => Ext_Imm,
    func => func,
    sa => sa
);

UnitateExec: EX port map(
RD1 => RD1,
RD2 => RD2,
ALUSrc => ALUSrc,
Ext_Imm => Ext_Imm,
sa => sa,
func => func,
ALUOp => ALUOp,
PCplusPatru => PCplusPatru,
Zero => Zero,
Notzero => not_zero,
ALURes => ALURes,
BranchAddress => branch_adress
);

Mem1: MEM port map(
    clk => clk,
    En => enable,
    memWrite=> MemWrite,
    ALUResIn => ALURes,
    ReadData => MemData,
    ALUResOut => ALUResOut,
    WriteData => RD2
);

jumpAddress<=PCplusPatru(31 downto 28)&instruction(25 downto 0)& "00";
--pcsrc <= '0';
pcsrc <= (branch and zero) or (branch_gt and not_zero);

process(MemtoReg)
begin
     if(MemtoReg='1') then 
        WD<=MemData;
     else
         WD<=ALUresout;
     end if;   
end process;


led(15 downto 13) <="000";
led(12 downto 0)<=enable & ALUOp & RegDst & ExtOp & ALUSrc & branch & branch_gt & jump & MemWrite & MemtoReg & RegWrite;

swit<=sw(2 downto 0);

process(swit, instruction, RD1, RD2, PCplusPatru, ext_imm, ALUResout, MemData, WD)
begin
case swit is
    when "000" => digits<=instruction;
    when "001" => digits<=RD1;--instruction(25 downto 21)&X"000000"&"000";--
    --when "001" => digits<=X"000000"&"000"&instruction(25 downto 21);
    --when "010" => digits<=X"000000"&"000"&instruction(20 downto 16);
    when "010" => digits<=RD2;--instruction(20 downto 16)&X"000000"&"000";
    when "011" => digits<=PCplusPatru;
    when "100" => digits<=ext_imm;
    when "101" => digits<=ALUResout;
    when "110" => digits<=MemData;
    when others => digits<=WD;
    
  end case;

end process;

end Behavioral;