library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processor is
  port (
    clk, reset : in std_logic;
    instruction : in std_logic_vector(7 downto 0);
    address : out std_logic_vector(3 downto 0);
    accumulator : out std_logic_vector(7 downto 0);
    output_data : out std_logic_vector(7 downto 0);
    output_valid, halted : out std_logic
  );
end entity;

architecture rtl of processor is
  type state_t is (fetch, execute, stopped);
  signal state : state_t := fetch;
  signal pc : unsigned(3 downto 0) := (others => '0');
  signal a : unsigned(7 downto 0) := (others => '0');
  signal ir : std_logic_vector(7 downto 0) := (others => '0');
  signal result_data : std_logic_vector(7 downto 0) := (others => '0');
  signal valid : std_logic := '0';
begin
  address <= std_logic_vector(pc);
  accumulator <= std_logic_vector(a);
  output_data <= result_data;
  output_valid <= valid;
  halted <= '1' when state = stopped else '0';

  process(clk)
    variable imm : unsigned(7 downto 0);
  begin
    if rising_edge(clk) then
      if reset = '1' then
        state <= fetch;
        pc <= (others => '0');
        a <= (others => '0');
        ir <= (others => '0');
        result_data <= (others => '0');
        valid <= '0';
      else
        valid <= '0';
        case state is
          when fetch =>
            ir <= instruction;
            state <= execute;
          when execute =>
            imm := resize(unsigned(ir(3 downto 0)), 8);
            pc <= pc + 1;
            state <= fetch;
            case ir(7 downto 4) is
              when x"0" => null;
              when x"1" => a <= imm;
              when x"2" => a <= a + imm;
              when x"3" => a <= a - imm;
              when x"4" => a <= a and imm;
              when x"5" => a <= a or imm;
              when x"6" => a <= a xor imm;
              when x"7" => pc <= unsigned(ir(3 downto 0));
              when x"8" =>
                if a = 0 then pc <= unsigned(ir(3 downto 0)); end if;
              when x"9" =>
                result_data <= std_logic_vector(a);
                valid <= '1';
              when x"F" => state <= stopped;
              when others => state <= stopped;
            end case;
          when stopped => null;
        end case;
      end if;
    end if;
  end process;
end architecture;

