set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]

## I/O delay constraints
create_clock -period 20.000 -name VIRTUAL_clk_out1_system_clk_wiz_1 -waveform {0.000 10.000}

set_input_delay  -clock VIRTUAL_clk_out1_system_clk_wiz_1 -max 50.000  [get_ports ftdi_tx]
set_input_delay  -clock VIRTUAL_clk_out1_system_clk_wiz_1 -min 20.000  [get_ports ftdi_tx]
set_output_delay -clock VIRTUAL_clk_out1_system_clk_wiz_1 -max 50.000  [get_ports ftdi_rx]
set_output_delay -clock VIRTUAL_clk_out1_system_clk_wiz_1 -min 20.000  [get_ports ftdi_rx]
set_input_delay  -clock VIRTUAL_clk_out1_system_clk_wiz_1 -max 100.000 [get_ports resetn]
set_input_delay  -clock VIRTUAL_clk_out1_system_clk_wiz_1 -min 50.000  [get_ports resetn]

## it doesn't actually matter
set_false_path -through [get_ports ftdi_tx]
set_false_path -through [get_ports ftdi_rx]
set_false_path -through [get_ports resetn]

# ##Pmod Headers
# ##Pmod Header pmod_jb jtag 4, 8, 9, 10
# if {[get_ports -quiet tck] ne "" } {
#   create_clock -period 10.000 -name jtag_tck -waveform {0.000 5.000} [get_ports tck]
# 
#   set_property PACKAGE_PIN H14 [get_ports tms]
#   set_property PULLUP true [get_ports tms]
#   set_property IOSTANDARD LVCMOS33 [get_ports tms]
# 
#   set_property PACKAGE_PIN F13 [get_ports tdo]
#   set_property PULLUP true [get_ports tdo]
#   set_property IOSTANDARD LVCMOS33 [get_ports tdo]
# 
#   set_property PACKAGE_PIN G13 [get_ports tdi]
#   set_property PULLUP true [get_ports tdi]
#   set_property IOSTANDARD LVCMOS33 [get_ports tdi]
# 
#   set_property PACKAGE_PIN H16 [get_ports tck]
#   set_property PULLDOWN true [get_ports tck]
#   set_property IOSTANDARD LVCMOS33 [get_ports tck]
# }
 
##Micro SD Connector
set_property -dict { PACKAGE_PIN AE24 IOSTANDARD LVCMOS33 }                                    [get_ports { sd_reset }]; #IO_L14P_T2_SRCC_35 Sch=sd_reset
set_property -dict { PACKAGE_PIN R28  IOSTANDARD LVCMOS33 DRIVE 8  PULLDOWN  true SLEW FAST }  [get_ports { sd_spi_sclk }]; #IO_L9P_T1_DQS_AD7P_35 Sch=sd_sck
set_property -dict { PACKAGE_PIN R29  IOSTANDARD LVCMOS33 DRIVE 8  PULLUP    true SLEW FAST }  [get_ports { sd_spi_mosi }]; #IO_L16N_T2_35 Sch=sd_cmd
set_property -dict { PACKAGE_PIN R26  IOSTANDARD LVCMOS33 PULLUP true }                        [get_ports { sd_spi_miso }]; #IO_L16P_T2_35 Sch=sd_dat[0]
set_property -dict { PACKAGE_PIN T30  IOSTANDARD LVCMOS33 DRIVE 16 PULLUP    true SLEW SLOW }  [get_ports { sd_spi_csn }]; #IO_L14N_T2_SRCC_35 Sch=sd_dat[3]

# set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]






