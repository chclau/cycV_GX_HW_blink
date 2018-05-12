library ieee;
use ieee.std_logic_1164.all;

entity reset_sync is

	port 
	(
		clk			: in std_logic;
		rst_n		: in std_logic;
		rst_sync	: out std_logic
	);

end entity;

architecture rtl of reset_sync is

	signal rst_i 	: std_logic_vector(2 downto 0);
	
begin
	
	process (rst_n, clk)
	begin
		if (rst_n = '0') then
			rst_i <= (others => '1');
		elsif (rising_edge(clk)) then
			rst_i  <= rst_i(1 downto 0) & '0';
		end if;
	end process;		

	rst_sync <= rst_i(2);
		
end rtl;
