library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_processor is end entity;
architecture test of tb_processor is
  type rom_t is array (0 to 15) of std_logic_vector(7 downto 0);
  constant rom : rom_t := (0 => x"12", 1 => x"22", 2 => x"90", 3 => x"F0", others => x"F0");
  signal clk : std_logic := '0';
  signal reset : std_logic := '1';
  signal instruction : std_logic_vector(7 downto 0);
  signal address : std_logic_vector(3 downto 0);
  signal accumulator, output_data : std_logic_vector(7 downto 0);
  signal output_valid, halted : std_logic;
begin
  clk <= not clk after 5 ns;
  instruction <= rom(to_integer(unsigned(address)));
  dut: entity work.processor
    port map(clk, reset, instruction, address, accumulator, output_data, output_valid, halted);
  process
  begin
    wait for 12 ns;
    reset <= '0';
    wait until output_valid = '1';
    assert output_data = x"04" report "incorrect output" severity failure;
    wait until halted = '1';
    assert accumulator = x"04" report "incorrect accumulator" severity failure;
    report "processor test passed";
    wait;
  end process;
end architecture;

