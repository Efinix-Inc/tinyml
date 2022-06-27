# PLL Constraints
#################
create_clock -period 10.00 i_hbramClk_fb
create_clock -waveform {1.250 3.750} -period 5.00 i_hbramClk90
create_clock -period 5.00 i_hbramClk_cal
create_clock -period 5.00 i_hbramClk
create_clock -period 40.00 i_fb_clk
create_clock -period 3.33 i_systemClk
create_clock -period 10.00 i_peripheralClk
create_clock -period 100 jtag_inst1_TCK

set_clock_groups -exclusive -group {i_systemClk} -group {i_hbramClk} -group {i_peripheralClk} -group {jtag_inst1_TCK}

# GPIO Constraints
####################

# LVDS RX GPIO Constraints
############################

# LVDS Rx Constraints
####################

# LVDS Tx Constraints
####################

# MIPI RX Lane Constraints
############################

# MIPI TX Lane Constraints
############################

# DDR Constraints
#####################
set_output_delay -clock_fall -clock i_hbramClk90 -reference_pin [get_ports {i_hbramClk90~CLKOUT~75~322}] -max 0.263 [get_ports {hbc_ck_n_LO hbc_ck_n_HI}]
set_output_delay -clock_fall -clock i_hbramClk90 -reference_pin [get_ports {i_hbramClk90~CLKOUT~75~322}] -min 0.140 [get_ports {hbc_ck_n_LO hbc_ck_n_HI}]
set_output_delay -clock_fall -clock i_hbramClk90 -reference_pin [get_ports {i_hbramClk90~CLKOUT~74~322}] -max 0.263 [get_ports {hbc_ck_p_LO hbc_ck_p_HI}]
set_output_delay -clock_fall -clock i_hbramClk90 -reference_pin [get_ports {i_hbramClk90~CLKOUT~74~322}] -min 0.140 [get_ports {hbc_ck_p_LO hbc_ck_p_HI}]
set_output_delay -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~84~322}] -max 0.263 [get_ports {hbc_cs_n}]
set_output_delay -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~84~322}] -min 0.140 [get_ports {hbc_cs_n}]
set_output_delay -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~27~322}] -max 0.263 [get_ports {hbc_rst_n}]
set_output_delay -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~27~322}] -min 0.140 [get_ports {hbc_rst_n}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -max <MAX CALCULATION> [get_ports {o_led}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -min <MIN CALCULATION> [get_ports {o_led}]
set_output_delay -clock i_systemClk -reference_pin [get_ports {i_systemClk~CLKOUT~1~31}] -max 0.263 [get_ports {system_spi_0_io_sclk_write}]
set_output_delay -clock i_systemClk -reference_pin [get_ports {i_systemClk~CLKOUT~1~31}] -min 0.140 [get_ports {system_spi_0_io_sclk_write}]
set_output_delay -clock i_systemClk -reference_pin [get_ports {i_systemClk~CLKOUT~1~30}] -max 0.263 [get_ports {system_spi_0_io_ss}]
set_output_delay -clock i_systemClk -reference_pin [get_ports {i_systemClk~CLKOUT~1~30}] -min 0.140 [get_ports {system_spi_0_io_ss}]
set_input_delay -clock i_hbramClk_cal -reference_pin [get_ports {i_hbramClk_cal~CLKOUT~32~322}] -max 0.414 [get_ports {hbc_dq_IN_LO[0] hbc_dq_IN_HI[0]}]
set_input_delay -clock i_hbramClk_cal -reference_pin [get_ports {i_hbramClk_cal~CLKOUT~32~322}] -min 0.276 [get_ports {hbc_dq_IN_LO[0] hbc_dq_IN_HI[0]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~34~322}] -max 0.263 [get_ports {hbc_dq_OUT_LO[0] hbc_dq_OUT_HI[0]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~34~322}] -min 0.140 [get_ports {hbc_dq_OUT_LO[0] hbc_dq_OUT_HI[0]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~34~322}] -max 0.263 [get_ports {hbc_dq_OE[0]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~34~322}] -min 0.140 [get_ports {hbc_dq_OE[0]}]
set_input_delay -clock i_hbramClk_cal -reference_pin [get_ports {i_hbramClk_cal~CLKOUT~33~322}] -max 0.414 [get_ports {hbc_dq_IN_LO[1] hbc_dq_IN_HI[1]}]
set_input_delay -clock i_hbramClk_cal -reference_pin [get_ports {i_hbramClk_cal~CLKOUT~33~322}] -min 0.276 [get_ports {hbc_dq_IN_LO[1] hbc_dq_IN_HI[1]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~35~322}] -max 0.263 [get_ports {hbc_dq_OUT_LO[1] hbc_dq_OUT_HI[1]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~35~322}] -min 0.140 [get_ports {hbc_dq_OUT_LO[1] hbc_dq_OUT_HI[1]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~35~322}] -max 0.263 [get_ports {hbc_dq_OE[1]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~35~322}] -min 0.140 [get_ports {hbc_dq_OE[1]}]
set_input_delay -clock i_hbramClk_cal -reference_pin [get_ports {i_hbramClk_cal~CLKOUT~48~322}] -max 0.414 [get_ports {hbc_dq_IN_LO[2] hbc_dq_IN_HI[2]}]
set_input_delay -clock i_hbramClk_cal -reference_pin [get_ports {i_hbramClk_cal~CLKOUT~48~322}] -min 0.276 [get_ports {hbc_dq_IN_LO[2] hbc_dq_IN_HI[2]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~50~322}] -max 0.263 [get_ports {hbc_dq_OUT_LO[2] hbc_dq_OUT_HI[2]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~50~322}] -min 0.140 [get_ports {hbc_dq_OUT_LO[2] hbc_dq_OUT_HI[2]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~50~322}] -max 0.263 [get_ports {hbc_dq_OE[2]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~50~322}] -min 0.140 [get_ports {hbc_dq_OE[2]}]
set_input_delay -clock i_hbramClk_cal -reference_pin [get_ports {i_hbramClk_cal~CLKOUT~49~322}] -max 0.414 [get_ports {hbc_dq_IN_LO[3] hbc_dq_IN_HI[3]}]
set_input_delay -clock i_hbramClk_cal -reference_pin [get_ports {i_hbramClk_cal~CLKOUT~49~322}] -min 0.276 [get_ports {hbc_dq_IN_LO[3] hbc_dq_IN_HI[3]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~51~322}] -max 0.263 [get_ports {hbc_dq_OUT_LO[3] hbc_dq_OUT_HI[3]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~51~322}] -min 0.140 [get_ports {hbc_dq_OUT_LO[3] hbc_dq_OUT_HI[3]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~51~322}] -max 0.263 [get_ports {hbc_dq_OE[3]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~51~322}] -min 0.140 [get_ports {hbc_dq_OE[3]}]
set_input_delay -clock i_hbramClk_cal -reference_pin [get_ports {i_hbramClk_cal~CLKOUT~56~322}] -max 0.414 [get_ports {hbc_dq_IN_LO[4] hbc_dq_IN_HI[4]}]
set_input_delay -clock i_hbramClk_cal -reference_pin [get_ports {i_hbramClk_cal~CLKOUT~56~322}] -min 0.276 [get_ports {hbc_dq_IN_LO[4] hbc_dq_IN_HI[4]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~58~322}] -max 0.263 [get_ports {hbc_dq_OUT_LO[4] hbc_dq_OUT_HI[4]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~58~322}] -min 0.140 [get_ports {hbc_dq_OUT_LO[4] hbc_dq_OUT_HI[4]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~58~322}] -max 0.263 [get_ports {hbc_dq_OE[4]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~58~322}] -min 0.140 [get_ports {hbc_dq_OE[4]}]
set_input_delay -clock i_hbramClk_cal -reference_pin [get_ports {i_hbramClk_cal~CLKOUT~57~322}] -max 0.414 [get_ports {hbc_dq_IN_LO[5] hbc_dq_IN_HI[5]}]
set_input_delay -clock i_hbramClk_cal -reference_pin [get_ports {i_hbramClk_cal~CLKOUT~57~322}] -min 0.276 [get_ports {hbc_dq_IN_LO[5] hbc_dq_IN_HI[5]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~59~322}] -max 0.263 [get_ports {hbc_dq_OUT_LO[5] hbc_dq_OUT_HI[5]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~59~322}] -min 0.140 [get_ports {hbc_dq_OUT_LO[5] hbc_dq_OUT_HI[5]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~59~322}] -max 0.263 [get_ports {hbc_dq_OE[5]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~59~322}] -min 0.140 [get_ports {hbc_dq_OE[5]}]
set_input_delay -clock i_hbramClk_cal -reference_pin [get_ports {i_hbramClk_cal~CLKOUT~64~322}] -max 0.414 [get_ports {hbc_dq_IN_LO[6] hbc_dq_IN_HI[6]}]
set_input_delay -clock i_hbramClk_cal -reference_pin [get_ports {i_hbramClk_cal~CLKOUT~64~322}] -min 0.276 [get_ports {hbc_dq_IN_LO[6] hbc_dq_IN_HI[6]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~66~322}] -max 0.263 [get_ports {hbc_dq_OUT_LO[6] hbc_dq_OUT_HI[6]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~66~322}] -min 0.140 [get_ports {hbc_dq_OUT_LO[6] hbc_dq_OUT_HI[6]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~66~322}] -max 0.263 [get_ports {hbc_dq_OE[6]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~66~322}] -min 0.140 [get_ports {hbc_dq_OE[6]}]
set_input_delay -clock i_hbramClk_cal -reference_pin [get_ports {i_hbramClk_cal~CLKOUT~65~322}] -max 0.414 [get_ports {hbc_dq_IN_LO[7] hbc_dq_IN_HI[7]}]
set_input_delay -clock i_hbramClk_cal -reference_pin [get_ports {i_hbramClk_cal~CLKOUT~65~322}] -min 0.276 [get_ports {hbc_dq_IN_LO[7] hbc_dq_IN_HI[7]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~67~322}] -max 0.263 [get_ports {hbc_dq_OUT_LO[7] hbc_dq_OUT_HI[7]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~67~322}] -min 0.140 [get_ports {hbc_dq_OUT_LO[7] hbc_dq_OUT_HI[7]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~67~322}] -max 0.263 [get_ports {hbc_dq_OE[7]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~67~322}] -min 0.140 [get_ports {hbc_dq_OE[7]}]
set_input_delay -clock i_hbramClk_cal -reference_pin [get_ports {i_hbramClk_cal~CLKOUT~140~322}] -max 0.414 [get_ports {hbc_dq_IN_LO[8] hbc_dq_IN_HI[8]}]
set_input_delay -clock i_hbramClk_cal -reference_pin [get_ports {i_hbramClk_cal~CLKOUT~140~322}] -min 0.276 [get_ports {hbc_dq_IN_LO[8] hbc_dq_IN_HI[8]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~142~322}] -max 0.263 [get_ports {hbc_dq_OUT_LO[8] hbc_dq_OUT_HI[8]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~142~322}] -min 0.140 [get_ports {hbc_dq_OUT_LO[8] hbc_dq_OUT_HI[8]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~142~322}] -max 0.263 [get_ports {hbc_dq_OE[8]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~142~322}] -min 0.140 [get_ports {hbc_dq_OE[8]}]
set_input_delay -clock i_hbramClk_cal -reference_pin [get_ports {i_hbramClk_cal~CLKOUT~141~322}] -max 0.414 [get_ports {hbc_dq_IN_LO[9] hbc_dq_IN_HI[9]}]
set_input_delay -clock i_hbramClk_cal -reference_pin [get_ports {i_hbramClk_cal~CLKOUT~141~322}] -min 0.276 [get_ports {hbc_dq_IN_LO[9] hbc_dq_IN_HI[9]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~143~322}] -max 0.263 [get_ports {hbc_dq_OUT_LO[9] hbc_dq_OUT_HI[9]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~143~322}] -min 0.140 [get_ports {hbc_dq_OUT_LO[9] hbc_dq_OUT_HI[9]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~143~322}] -max 0.263 [get_ports {hbc_dq_OE[9]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~143~322}] -min 0.140 [get_ports {hbc_dq_OE[9]}]
set_input_delay -clock i_hbramClk_cal -reference_pin [get_ports {i_hbramClk_cal~CLKOUT~148~322}] -max 0.414 [get_ports {hbc_dq_IN_LO[10] hbc_dq_IN_HI[10]}]
set_input_delay -clock i_hbramClk_cal -reference_pin [get_ports {i_hbramClk_cal~CLKOUT~148~322}] -min 0.276 [get_ports {hbc_dq_IN_LO[10] hbc_dq_IN_HI[10]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~150~322}] -max 0.263 [get_ports {hbc_dq_OUT_LO[10] hbc_dq_OUT_HI[10]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~150~322}] -min 0.140 [get_ports {hbc_dq_OUT_LO[10] hbc_dq_OUT_HI[10]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~150~322}] -max 0.263 [get_ports {hbc_dq_OE[10]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~150~322}] -min 0.140 [get_ports {hbc_dq_OE[10]}]
set_input_delay -clock i_hbramClk_cal -reference_pin [get_ports {i_hbramClk_cal~CLKOUT~149~322}] -max 0.414 [get_ports {hbc_dq_IN_LO[11] hbc_dq_IN_HI[11]}]
set_input_delay -clock i_hbramClk_cal -reference_pin [get_ports {i_hbramClk_cal~CLKOUT~149~322}] -min 0.276 [get_ports {hbc_dq_IN_LO[11] hbc_dq_IN_HI[11]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~151~322}] -max 0.263 [get_ports {hbc_dq_OUT_LO[11] hbc_dq_OUT_HI[11]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~151~322}] -min 0.140 [get_ports {hbc_dq_OUT_LO[11] hbc_dq_OUT_HI[11]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~151~322}] -max 0.263 [get_ports {hbc_dq_OE[11]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~151~322}] -min 0.140 [get_ports {hbc_dq_OE[11]}]
set_input_delay -clock i_hbramClk_cal -reference_pin [get_ports {i_hbramClk_cal~CLKOUT~156~322}] -max 0.414 [get_ports {hbc_dq_IN_LO[12] hbc_dq_IN_HI[12]}]
set_input_delay -clock i_hbramClk_cal -reference_pin [get_ports {i_hbramClk_cal~CLKOUT~156~322}] -min 0.276 [get_ports {hbc_dq_IN_LO[12] hbc_dq_IN_HI[12]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~158~322}] -max 0.263 [get_ports {hbc_dq_OUT_LO[12] hbc_dq_OUT_HI[12]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~158~322}] -min 0.140 [get_ports {hbc_dq_OUT_LO[12] hbc_dq_OUT_HI[12]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~158~322}] -max 0.263 [get_ports {hbc_dq_OE[12]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~158~322}] -min 0.140 [get_ports {hbc_dq_OE[12]}]
set_input_delay -clock i_hbramClk_cal -reference_pin [get_ports {i_hbramClk_cal~CLKOUT~157~322}] -max 0.414 [get_ports {hbc_dq_IN_LO[13] hbc_dq_IN_HI[13]}]
set_input_delay -clock i_hbramClk_cal -reference_pin [get_ports {i_hbramClk_cal~CLKOUT~157~322}] -min 0.276 [get_ports {hbc_dq_IN_LO[13] hbc_dq_IN_HI[13]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~159~322}] -max 0.263 [get_ports {hbc_dq_OUT_LO[13] hbc_dq_OUT_HI[13]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~159~322}] -min 0.140 [get_ports {hbc_dq_OUT_LO[13] hbc_dq_OUT_HI[13]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~159~322}] -max 0.263 [get_ports {hbc_dq_OE[13]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~159~322}] -min 0.140 [get_ports {hbc_dq_OE[13]}]
set_input_delay -clock i_hbramClk_cal -reference_pin [get_ports {i_hbramClk_cal~CLKOUT~164~322}] -max 0.414 [get_ports {hbc_dq_IN_LO[14] hbc_dq_IN_HI[14]}]
set_input_delay -clock i_hbramClk_cal -reference_pin [get_ports {i_hbramClk_cal~CLKOUT~164~322}] -min 0.276 [get_ports {hbc_dq_IN_LO[14] hbc_dq_IN_HI[14]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~166~322}] -max 0.263 [get_ports {hbc_dq_OUT_LO[14] hbc_dq_OUT_HI[14]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~166~322}] -min 0.140 [get_ports {hbc_dq_OUT_LO[14] hbc_dq_OUT_HI[14]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~166~322}] -max 0.263 [get_ports {hbc_dq_OE[14]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~166~322}] -min 0.140 [get_ports {hbc_dq_OE[14]}]
set_input_delay -clock i_hbramClk_cal -reference_pin [get_ports {i_hbramClk_cal~CLKOUT~165~322}] -max 0.414 [get_ports {hbc_dq_IN_LO[15] hbc_dq_IN_HI[15]}]
set_input_delay -clock i_hbramClk_cal -reference_pin [get_ports {i_hbramClk_cal~CLKOUT~165~322}] -min 0.276 [get_ports {hbc_dq_IN_LO[15] hbc_dq_IN_HI[15]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~167~322}] -max 0.263 [get_ports {hbc_dq_OUT_LO[15] hbc_dq_OUT_HI[15]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~167~322}] -min 0.140 [get_ports {hbc_dq_OUT_LO[15] hbc_dq_OUT_HI[15]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~167~322}] -max 0.263 [get_ports {hbc_dq_OE[15]}]
set_output_delay -clock_fall -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~167~322}] -min 0.140 [get_ports {hbc_dq_OE[15]}]
set_input_delay -clock i_hbramClk_cal -reference_pin [get_ports {i_hbramClk_cal~CLKOUT~81~322}] -max 0.414 [get_ports {hbc_rwds_IN_LO[0] hbc_rwds_IN_HI[0]}]
set_input_delay -clock i_hbramClk_cal -reference_pin [get_ports {i_hbramClk_cal~CLKOUT~81~322}] -min 0.276 [get_ports {hbc_rwds_IN_LO[0] hbc_rwds_IN_HI[0]}]
set_output_delay -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~83~322}] -max 0.263 [get_ports {hbc_rwds_OUT_LO[0] hbc_rwds_OUT_HI[0]}]
set_output_delay -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~83~322}] -min 0.140 [get_ports {hbc_rwds_OUT_LO[0] hbc_rwds_OUT_HI[0]}]
set_output_delay -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~83~322}] -max 0.263 [get_ports {hbc_rwds_OE[0]}]
set_output_delay -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~83~322}] -min 0.140 [get_ports {hbc_rwds_OE[0]}]
set_input_delay -clock i_hbramClk_cal -reference_pin [get_ports {i_hbramClk_cal~CLKOUT~129~322}] -max 0.414 [get_ports {hbc_rwds_IN_LO[1] hbc_rwds_IN_HI[1]}]
set_input_delay -clock i_hbramClk_cal -reference_pin [get_ports {i_hbramClk_cal~CLKOUT~129~322}] -min 0.276 [get_ports {hbc_rwds_IN_LO[1] hbc_rwds_IN_HI[1]}]
set_output_delay -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~131~322}] -max 0.263 [get_ports {hbc_rwds_OUT_LO[1] hbc_rwds_OUT_HI[1]}]
set_output_delay -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~131~322}] -min 0.140 [get_ports {hbc_rwds_OUT_LO[1] hbc_rwds_OUT_HI[1]}]
set_output_delay -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~131~322}] -max 0.263 [get_ports {hbc_rwds_OE[1]}]
set_output_delay -clock i_hbramClk -reference_pin [get_ports {i_hbramClk~CLKOUT~131~322}] -min 0.140 [get_ports {hbc_rwds_OE[1]}]

set_input_delay -clock i_systemClk -reference_pin [get_ports {i_systemClk~CLKOUT~1~59}] -max 0.414 [get_ports {system_spi_0_io_data_0_read}]
set_input_delay -clock i_systemClk -reference_pin [get_ports {i_systemClk~CLKOUT~1~59}] -min 0.276 [get_ports {system_spi_0_io_data_0_read}]
set_output_delay -clock i_systemClk -reference_pin [get_ports {i_systemClk~CLKOUT~1~61}] -max 0.263 [get_ports {system_spi_0_io_data_0_write}]
set_output_delay -clock i_systemClk -reference_pin [get_ports {i_systemClk~CLKOUT~1~61}] -min 0.140 [get_ports {system_spi_0_io_data_0_write}]
set_output_delay -clock i_systemClk -reference_pin [get_ports {i_systemClk~CLKOUT~1~61}] -max 0.263 [get_ports {system_spi_0_io_data_0_writeEnable}]
set_output_delay -clock i_systemClk -reference_pin [get_ports {i_systemClk~CLKOUT~1~61}] -min 0.140 [get_ports {system_spi_0_io_data_0_writeEnable}]
set_input_delay -clock i_systemClk -reference_pin [get_ports {i_systemClk~CLKOUT~1~60}] -max 0.414 [get_ports {system_spi_0_io_data_1_read}]
set_input_delay -clock i_systemClk -reference_pin [get_ports {i_systemClk~CLKOUT~1~60}] -min 0.276 [get_ports {system_spi_0_io_data_1_read}]
set_output_delay -clock i_systemClk -reference_pin [get_ports {i_systemClk~CLKOUT~1~62}] -max 0.263 [get_ports {system_spi_0_io_data_1_write}]
set_output_delay -clock i_systemClk -reference_pin [get_ports {i_systemClk~CLKOUT~1~62}] -min 0.140 [get_ports {system_spi_0_io_data_1_write}]
set_output_delay -clock i_systemClk -reference_pin [get_ports {i_systemClk~CLKOUT~1~62}] -max 0.263 [get_ports {system_spi_0_io_data_1_writeEnable}]
set_output_delay -clock i_systemClk -reference_pin [get_ports {i_systemClk~CLKOUT~1~62}] -min 0.140 [get_ports {system_spi_0_io_data_1_writeEnable}]


# JTAG Constraints
####################
set_output_delay -clock jtag_inst1_TCK -max 0.117 [get_ports {jtag_inst1_TDO}]
set_output_delay -clock jtag_inst1_TCK -min 0.075 [get_ports {jtag_inst1_TDO}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -max 0.280 [get_ports {jtag_inst1_CAPTURE}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -min 0.187 [get_ports {jtag_inst1_CAPTURE}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -max 0.280 [get_ports {jtag_inst1_RESET}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -min 0.187 [get_ports {jtag_inst1_RESET}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -max 0.280 [get_ports {jtag_inst1_RUNTEST}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -min 0.187 [get_ports {jtag_inst1_RUNTEST}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -max 0.243 [get_ports {jtag_inst1_SEL}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -min 0.162 [get_ports {jtag_inst1_SEL}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -max 0.280 [get_ports {jtag_inst1_UPDATE}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -min 0.187 [get_ports {jtag_inst1_UPDATE}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -max 0.337 [get_ports {jtag_inst1_SHIFT}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -min 0.225 [get_ports {jtag_inst1_SHIFT}]

# False Path
#################
#set_false_path -setup -hold -from u_risc_v/io_systemReset* 
#set_false_path -setup -hold -from u_risc_v/io_memoryReset*
