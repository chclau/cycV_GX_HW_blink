library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;

entity top is

	port 
	(
		clk_in	: in std_logic;
		reset_n	: in std_logic;
		
		pb_in	  : in std_logic;
		LEDG	  : out std_logic_vector(7 downto 0);
		LEDR	  : out std_logic_vector(9 downto 0)
	);

end entity;

architecture rtl of top is

	component pll1 is
		port (
			refclk   : in  std_logic := 'X'; -- clk
			rst      : in  std_logic := 'X'; -- reset
			outclk_0 : out std_logic;        -- clk
			locked   : out std_logic         -- export
		);
	end component pll1;

	component reset_sync is
		port 
		(
			clk			: in std_logic;
			rst_n		: in std_logic;
			rst_sync	: out std_logic
		);
	end component reset_sync;

	signal areset 	: std_logic;
	signal sysclk 	: std_logic;
	signal rst	 	  : std_logic;
	signal counter 	: unsigned(31 downto 0);
	signal pll_lck  : std_logic;
	
begin

	areset 	<= not reset_n;
	
	-- Counter to blink the LEDs and LEDs mapping
	cnt_pr : process (rst, sysclk)
	begin
		if (rst = '1') then
			counter <= (others => '0');
			LEDG    <= (others => '0');
			LEDR    <= (others => '0');
		elsif (rising_edge(sysclk)) then
			counter <= counter + 1;
			LEDG(7 downto 6) <= (others => '0');
			LEDR(9 downto 6) <= (others => '0');
			if (pb_in = '1') then
				LEDG(5 downto 1) <= std_logic_vector(counter(29 downto 25));
				LEDR(5 downto 1) <= std_logic_vector(counter(29 downto 25));
			else	
				LEDG(5 downto 1) <= std_logic_vector(counter(28 downto 24));
				LEDR(5 downto 1) <= std_logic_vector(counter(28 downto 24));
			end if;	
			LEDG(0)			 <= pll_lck;
			LEDR(0)			 <= pll_lck;
		end if;
	end process;		

  main_pll : component pll1
    port map (
      refclk	    => clk_in		,
      rst			    => areset		,  
			outclk_0	  => sysclk		,
			locked		  => pll_lck		
    );
		
	reset_sync_i : component reset_sync
    port map (
      clk	        => sysclk		,
      rst_n		    => reset_n	,  
			rst_sync	  => rst
    );

		
end rtl;
