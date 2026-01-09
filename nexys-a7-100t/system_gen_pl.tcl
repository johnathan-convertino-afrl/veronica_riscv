set_msg_config -id "Common 17-55" -new_severity WARNING

#create tft vga display
ip_vlvn_version_check "xilinx.com:ip:axi_tft:2.0"

create_ip -vlnv xilinx.com:ip:axi_tft:2.0 -module_name axi_tft_vga
set_property CONFIG.C_EN_I2C_INTF {0} [get_ips axi_tft_vga]
set_property CONFIG.C_M_AXI_DATA_WIDTH {32} [get_ips axi_tft_vga]
set_property CONFIG.C_TFT_INTERFACE {0} [get_ips axi_tft_vga]
set_property CONFIG.C_DEFAULT_TFT_BASE_ADDR {0x0000000086000000} [get_ips axi_tft_vga]

set_property generate_synth_checkpoint false [get_files axi_tft_vga.xci]

#create ethernet controller
ip_vlvn_version_check "xilinx.com:ip:axi_ethernetlite:3.0"

create_ip -vlnv xilinx.com:ip:axi_ethernetlite:3.0 -module_name axi_ethernet
set_property CONFIG.AXI_ACLK_FREQ_MHZ {50} [get_ips axi_ethernet]
set_property CONFIG.C_INCLUDE_MDIO {1} [get_ips axi_ethernet]
set_property CONFIG.C_RX_PING_PONG {1} [get_ips axi_ethernet]
set_property CONFIG.C_TX_PING_PONG {1} [get_ips axi_ethernet]

set_property generate_synth_checkpoint false [get_files axi_ethernet.xci]

generate_target all [get_ips]
