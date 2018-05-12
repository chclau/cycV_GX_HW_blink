# Constrain clock ports
create_clock -period 50MHz [get_ports clk_in]

# Automatically apply a generate clock on the output of phase-locked loops (PLLs)
derive_pll_clocks
derive_clock_uncertainty

# Constrain the input I/O path
set_false_path -from [get_ports {reset_n}] 
set_false_path -from [get_ports {pb_in}] 

# Constrain the output I/O path
set_false_path -from * -to [get_ports { LEDG[*] }]
set_false_path -from * -to [get_ports { LEDR[*] }]
