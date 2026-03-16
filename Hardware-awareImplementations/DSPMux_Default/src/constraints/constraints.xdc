# Unused, as in the end we use the clk_wiz.
#create_clock -period 5.050 -name clk -waveform {0.000 2.525} [get_ports I_clock]


set_input_delay  -clock [get_clocks -of_objects [get_pins clk_wiz*/inst/mmcm_adv_inst/CLKOUT0]] -min  3.500 [get_ports {I_inst* rst}]
set_input_delay  -clock [get_clocks -of_objects [get_pins clk_wiz*/inst/mmcm_adv_inst/CLKOUT0]] -max  1.000 [get_ports {I_inst* rst}]
set_output_delay -clock [get_clocks -of_objects [get_pins clk_wiz*/inst/mmcm_adv_inst/CLKOUT0]] -min -1.000 [get_ports {O_result* O_exception O_ok O_nook O_heartbeat}]
set_output_delay -clock [get_clocks -of_objects [get_pins clk_wiz*/inst/mmcm_adv_inst/CLKOUT0]] -max -4.000 [get_ports {O_result* O_exception O_ok O_nook O_heartbeat}]


set_property IOSTANDARD LVCMOS18 [get_ports [list rst]]
set_property IOSTANDARD LVCMOS18 [get_ports [list O_exception]]
set_property IOSTANDARD LVCMOS18 [get_ports [list O_ok]]
set_property IOSTANDARD LVCMOS18 [get_ports [list O_nook]]
set_property IOSTANDARD LVCMOS18 [get_ports [list O_heartbeat]]

set_property PACKAGE_PIN J15 [get_ports rst]
set_property PACKAGE_PIN J13 [get_ports O_exception]
set_property PACKAGE_PIN K15 [get_ports O_ok]
set_property PACKAGE_PIN H17 [get_ports O_nook]
set_property PACKAGE_PIN N14 [get_ports O_heartbeat]


create_pblock toplevel_tb
resize_pblock toplevel_tb -add SLICE_X36Y91:SLICE_X45Y120
add_cells_to_pblock toplevel_tb [get_cells {*address*}]
add_cells_to_pblock toplevel_tb [get_cells {dec_inst*}]
add_cells_to_pblock toplevel_tb [get_cells {FSM*}]
add_cells_to_pblock toplevel_tb [get_cells {ok_aux*}]
add_cells_to_pblock toplevel_tb [get_cells {hbeat*}]