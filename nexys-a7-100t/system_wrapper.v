//******************************************************************************
//  file:     system_wrapper.v
//
//  author:   JAY CONVERTINO
//
//  date:     2024/11/25
//
//  about:    Brief
//  System wrapper for ps.
//
//  license: License MIT
//  Copyright 2024 Jay Convertino
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//******************************************************************************

`timescale 1ns/100ps

/*
 * Module: system_wrapper
 *
 * System wrapper for Vexriscv Veronica RISCV ps.
 *
 * Ports:
 *
 * tck                    - JTAG
 * tms                    - JTAG
 * tdi                    - JTAG
 * tdo                    - JTAG
 * clk                    - Master Input Clock
 * resetn                 - Master Reset Input
 * ddr2_addr              - DDR interface
 * ddr2_ba                - DDR interface
 * ddr2_cas_n             - DDR interface
 * ddr2_ck_n              - DDR interface
 * ddr2_ck_p              - DDR interface
 * ddr2_cke               - DDR interface
 * ddr2_cs_n              - DDR interface
 * ddr2_dm                - DDR interface
 * ddr2_dq                - DDR interface
 * ddr2_dqs_n             - DDR interface
 * ddr2_dqs_p             - DDR interface
 * ddr2_odt               - DDR interface
 * ddr2_ras_n             - DDR interface
 * ddr2_reset_n           - DDR interface
 * ddr2_we_n              - DDR interface
 * leds                   - board leds
 * slide_switches         - board slide switches
 * ftdi_tx                - FTDI UART TX
 * ftdi_rx                - FTDI UART RX
 * ftdi_rts               - FTDI UART RTS
 * ftdi_cts               - FTDI UART CTS
 * sd_spi_miso            - SD CARD Master In Master Out SPI
 * sd_spi_mosi            - SD CARD Master Out Master In SPI
 * sd_spi_csn             - SD CARD Chip Select SPI
 * sd_spi_sclk            - SD CARD clock SPI
 */
module system_wrapper #(
    parameter ACLK_FREQ_MHZ = 50
  )
  (
`ifdef _JTAG_IO
    input           tck,
    input           tms,
    input           tdi,
    output          tdo,
`endif
    input             clk,
    input             resetn,
    inout   [12:0]    ddr2_addr,
    inout   [ 2:0]    ddr2_ba,
    inout             ddr2_cas_n,
    inout             ddr2_ck_n,
    inout             ddr2_ck_p,
    inout             ddr2_cke,
    inout             ddr2_cs_n,
    inout   [ 1:0]    ddr2_dm,
    inout   [15:0]    ddr2_dq,
    inout   [ 1:0]    ddr2_dqs_n,
    inout   [ 1:0]    ddr2_dqs_p,
    inout             ddr2_odt,
    inout             ddr2_ras_n,
    inout             ddr2_reset_n,
    inout             ddr2_we_n,
    output  [15:0]    leds,
    input   [15:0]    slide_switches,
    input             ftdi_tx,
    output            ftdi_rx,
    input             ftdi_rts,
    output            ftdi_cts,
    input             sd_spi_miso,
    output            sd_spi_mosi,
    output            sd_spi_csn,
    output            sd_spi_sclk,
    output            sd_reset
  );
  
  assign ftdi_cts = ftdi_rts;

  // Memory bus wires
  wire            m_axi_mbus_awvalid;
  wire            m_axi_mbus_awready;
  wire  [31:0]    m_axi_mbus_awaddr;
  wire  [ 3:0]    m_axi_mbus_awid;
  wire  [ 7:0]    m_axi_mbus_awlen;
  wire  [ 2:0]    m_axi_mbus_awsize;
  wire  [ 1:0]    m_axi_mbus_awburst;
  wire  [ 0:0]    m_axi_mbus_awlock;
  wire  [ 3:0]    m_axi_mbus_awcache;
  wire  [ 3:0]    m_axi_mbus_awqos;
  wire  [ 2:0]    m_axi_mbus_awprot;
  wire            m_axi_mbus_wvalid;
  wire            m_axi_mbus_wready;
  wire  [31:0]    m_axi_mbus_wdata;
  wire  [ 3:0]    m_axi_mbus_wstrb;
  wire            m_axi_mbus_wlast;
  wire            m_axi_mbus_bvalid;
  wire            m_axi_mbus_bready;
  wire  [ 3:0]    m_axi_mbus_bid;
  wire  [ 1:0]    m_axi_mbus_bresp;
  wire            m_axi_mbus_arvalid;
  wire            m_axi_mbus_arready;
  wire  [31:0]    m_axi_mbus_araddr;
  wire  [ 3:0]    m_axi_mbus_arid;
  wire  [ 7:0]    m_axi_mbus_arlen;
  wire  [ 2:0]    m_axi_mbus_arsize;
  wire  [ 1:0]    m_axi_mbus_arburst;
  wire  [ 0:0]    m_axi_mbus_arlock;
  wire  [ 3:0]    m_axi_mbus_arcache;
  wire  [ 3:0]    m_axi_mbus_arqos;
  wire  [ 2:0]    m_axi_mbus_arprot;
  wire            m_axi_mbus_rvalid;
  wire            m_axi_mbus_rready;
  wire  [31:0]    m_axi_mbus_rdata;
  wire  [ 3:0]    m_axi_mbus_rid;
  wire  [ 1:0]    m_axi_mbus_rresp;
  wire            m_axi_mbus_rlast;
  
  //clocks
  wire           axi_clk;
  wire           ddr_clk;
  wire           cpu_clk;
  wire           clk_ibufg;
  wire           clk_bufg;

  //resets
  wire [ 0:0]    ddr_rstgen_peripheral_aresetn;
  wire [ 0:0]    ddr_rstgen_peripheral_areset;
  wire [ 0:0]    sys_rstgen_peripheral_aresetn;
  wire [ 0:0]    sys_rstgen_peripheral_areset;
  wire [ 0:0]    cpu_rstgen_peripheral_areset;
  wire           debug_rst;

  //ddr signals and clocks
  wire           axi_ddr_ctrl_mmcm_locked;
  wire           axi_ddr_ctrl_ui_clk;
  wire           axi_ddr_ctrl_ui_clk_sync_rst;
  
  wire [31:0] s_spi_csn;
  
  assign sd_spi_csn = s_spi_csn[0];

  assign sd_reset = sys_rstgen_peripheral_areset;
  
  IBUFG i_ibufg (
    .I (clk),
    .O (clk_ibufg));

  BUFG i_bufg (
    .I (clk_ibufg),
    .O (clk_bufg));
  
  // Module: inst_clk_wiz_1
  //
  // Generate system clocks
  clk_wiz_1 inst_clk_wiz_1
  (
    .clk_in1(clk_bufg),
    .clk_out1(axi_clk),
    .clk_out2(ddr_clk),
    .clk_out3(cpu_clk)
  );
  
  // Module: inst_ddr_rstgen
  //
  // Generate DDR Reset
  ddr_rstgen inst_ddr_rstgen
  (
    .aux_reset_in(axi_ddr_ctrl_ui_clk_sync_rst),
    .dcm_locked(axi_ddr_ctrl_mmcm_locked),
    .ext_reset_in(resetn),
    .mb_debug_sys_rst(debug_rst),
    .peripheral_reset(ddr_rstgen_peripheral_areset),
    .peripheral_aresetn(ddr_rstgen_peripheral_aresetn),
    .slowest_sync_clk(axi_ddr_ctrl_ui_clk)
  );
  
  // Module: inst_sys_rstgen
  //
  // Generate general system resets
  sys_rstgen inst_sys_rstgen
  (
    .aux_reset_in(axi_ddr_ctrl_ui_clk_sync_rst),
    .dcm_locked(axi_ddr_ctrl_mmcm_locked),
    .ext_reset_in(resetn),
    .interconnect_aresetn(),
    .mb_debug_sys_rst(debug_rst),
    .peripheral_reset(sys_rstgen_peripheral_areset),
    .peripheral_aresetn(sys_rstgen_peripheral_aresetn),
    .slowest_sync_clk(axi_clk)
  );
  
  // Module: inst_cpu_rstgen
  //
  // Generate general system resets
  cpu_rstgen inst_cpu_rstgen
  (
    .aux_reset_in(axi_ddr_ctrl_ui_clk_sync_rst),
    .dcm_locked(axi_ddr_ctrl_mmcm_locked),
    .ext_reset_in(resetn),
    .interconnect_aresetn(),
    .mb_debug_sys_rst(debug_rst),
    .peripheral_reset(cpu_rstgen_peripheral_areset),
    .peripheral_aresetn(),
    .slowest_sync_clk(cpu_clk)
  );
  
  // Module: inst_axi_ddr_ctrl
  //
  // AXI DDR Controller, 200 MHz in for 50 Mhz out (200/4 = 50).
  axi_ddr_ctrl inst_axi_ddr_ctrl
  (
    .init_calib_complete(),
    .app_sr_req(),
    .app_ref_req(),
    .app_zq_req(),
    .app_sr_active(),
    .app_ref_ack(),
    .app_zq_ack(),
    .aresetn(ddr_rstgen_peripheral_aresetn),
    .ddr2_addr(ddr2_addr),
    .ddr2_ba(ddr2_ba),
    .ddr2_cas_n(ddr2_cas_n),
    .ddr2_ck_n(ddr2_ck_n),
    .ddr2_ck_p(ddr2_ck_p),
    .ddr2_cke(ddr2_cke),
    .ddr2_cs_n(ddr2_cs_n),
    .ddr2_dm(ddr2_dm),
    .ddr2_dq(ddr2_dq),
    .ddr2_dqs_n(ddr2_dqs_n),
    .ddr2_dqs_p(ddr2_dqs_p),
    .ddr2_odt(ddr2_odt),
    .ddr2_ras_n(ddr2_ras_n),
    .ddr2_we_n(ddr2_we_n),
    .mmcm_locked(axi_ddr_ctrl_mmcm_locked),
    .s_axi_araddr(m_axi_mbus_araddr & 32'h0FFFFFFF),
    .s_axi_arburst(m_axi_mbus_arburst),
    .s_axi_arcache(m_axi_mbus_arcache),
    .s_axi_arid(m_axi_mbus_arid),
    .s_axi_arlen(m_axi_mbus_arlen),
    .s_axi_arlock(m_axi_mbus_arlock),
    .s_axi_arprot(m_axi_mbus_arprot),
    .s_axi_arqos(m_axi_mbus_arqos),
    .s_axi_arready(m_axi_mbus_arready),
    .s_axi_arsize(m_axi_mbus_arsize),
    .s_axi_arvalid(m_axi_mbus_arvalid),
    .s_axi_awaddr(m_axi_mbus_awaddr & 32'h0FFFFFFF),
    .s_axi_awburst(m_axi_mbus_awburst),
    .s_axi_awcache(m_axi_mbus_awcache),
    .s_axi_awid(m_axi_mbus_awid),
    .s_axi_awlen(m_axi_mbus_awlen),
    .s_axi_awlock(m_axi_mbus_awlock),
    .s_axi_awprot(m_axi_mbus_awprot),
    .s_axi_awqos(m_axi_mbus_awqos),
    .s_axi_awready(m_axi_mbus_awready),
    .s_axi_awsize(m_axi_mbus_awsize),
    .s_axi_awvalid(m_axi_mbus_awvalid),
    .s_axi_bid(m_axi_mbus_bid),
    .s_axi_bready(m_axi_mbus_bready),
    .s_axi_bvalid(m_axi_mbus_bvalid),
    .s_axi_bresp(m_axi_mbus_bresp),
    .s_axi_rdata(m_axi_mbus_rdata),
    .s_axi_rid(m_axi_mbus_rid),
    .s_axi_rlast(m_axi_mbus_rlast),
    .s_axi_rready(m_axi_mbus_rready),
    .s_axi_rvalid(m_axi_mbus_rvalid),
    .s_axi_rresp(m_axi_mbus_rresp),
    .s_axi_wdata(m_axi_mbus_wdata),
    .s_axi_wlast(m_axi_mbus_wlast),
    .s_axi_wready(m_axi_mbus_wready),
    .s_axi_wstrb(m_axi_mbus_wstrb),
    .s_axi_wvalid(m_axi_mbus_wvalid),
    .sys_clk_i(clk_bufg),
    .sys_rst(resetn),
    .clk_ref_i(ddr_clk),
    .ui_clk(axi_ddr_ctrl_ui_clk),
    .ui_clk_sync_rst(axi_ddr_ctrl_ui_clk_sync_rst)
  );

  // Module: inst_system_ps_wrapper
  //
  // Wraps all of the RISCV CPU core and its devices.
`ifdef _JTAG_IO
  system_ps_wrapper_jtag #(
    .ACLK_FREQ_MHZ(ACLK_FREQ_MHZ)
  ) inst_system_ps_wrapper_jtag (
    .tck(tck),
    .tms(tms),
    .tdi(tdi),
    .tdo(tdo),
`else
  system_ps_wrapper #(
    .ACLK_FREQ_MHZ(ACLK_FREQ_MHZ)
  ) inst_system_ps_wrapper (
`endif
    .cpu_clk(cpu_clk),
    .cpu_rst(cpu_rstgen_peripheral_areset),
    .aclk(axi_clk),
    .arstn(sys_rstgen_peripheral_aresetn),
    .arst(sys_rstgen_peripheral_areset),
    .ddr_clk(axi_ddr_ctrl_ui_clk),
    .ddr_rst(ddr_rstgen_peripheral_areset),
    .m_axi_mbus_araddr(m_axi_mbus_araddr),
    .m_axi_mbus_arburst(m_axi_mbus_arburst),
    .m_axi_mbus_arcache(m_axi_mbus_arcache),
    .m_axi_mbus_arid(m_axi_mbus_arid),
    .m_axi_mbus_arlen(m_axi_mbus_arlen),
    .m_axi_mbus_arprot(m_axi_mbus_arprot),
    .m_axi_mbus_arready(m_axi_mbus_arready),
    .m_axi_mbus_arsize(m_axi_mbus_arsize),
    .m_axi_mbus_arvalid(m_axi_mbus_arvalid),
    .m_axi_mbus_awaddr(m_axi_mbus_awaddr),
    .m_axi_mbus_awburst(m_axi_mbus_awburst),
    .m_axi_mbus_awcache(m_axi_mbus_awcache),
    .m_axi_mbus_awid(m_axi_mbus_awid),
    .m_axi_mbus_awlen(m_axi_mbus_awlen),
    .m_axi_mbus_awprot(m_axi_mbus_awprot),
    .m_axi_mbus_awready(m_axi_mbus_awready),
    .m_axi_mbus_awsize(m_axi_mbus_awsize),
    .m_axi_mbus_awvalid(m_axi_mbus_awvalid),
    .m_axi_mbus_bid(m_axi_mbus_bid),
    .m_axi_mbus_bready(m_axi_mbus_bready),
    .m_axi_mbus_bvalid(m_axi_mbus_bvalid),
    .m_axi_mbus_rdata(m_axi_mbus_rdata),
    .m_axi_mbus_rid(m_axi_mbus_rid),
    .m_axi_mbus_rlast(m_axi_mbus_rlast),
    .m_axi_mbus_rready(m_axi_mbus_rready),
    .m_axi_mbus_rvalid(m_axi_mbus_rvalid),
    .m_axi_mbus_wdata(m_axi_mbus_wdata),
    .m_axi_mbus_wlast(m_axi_mbus_wlast),
    .m_axi_mbus_wready(m_axi_mbus_wready),
    .m_axi_mbus_wstrb(m_axi_mbus_wstrb),
    .m_axi_mbus_wvalid(m_axi_mbus_wvalid),
    .m_axi_mbus_arqos(m_axi_mbus_arqos),
    .m_axi_mbus_arlock(m_axi_mbus_arlock),
    .m_axi_mbus_awqos(m_axi_mbus_awqos),
    .m_axi_mbus_awlock(m_axi_mbus_awlock),
    .m_axi_mbus_rresp(m_axi_mbus_rresp),
    .m_axi_mbus_bresp(m_axi_mbus_bresp),
    .m_axi_acc_araddr(),
    .m_axi_acc_arprot(),
    .m_axi_acc_arready(1'b1),
    .m_axi_acc_arvalid(),
    .m_axi_acc_awaddr(),
    .m_axi_acc_awprot(),
    .m_axi_acc_awready(1'b1),
    .m_axi_acc_awvalid(),
    .m_axi_acc_bready(),
    .m_axi_acc_bresp(3'b000),
    .m_axi_acc_bvalid(2'b00),
    .m_axi_acc_rdata(32'h00000000),
    .m_axi_acc_rready(),
    .m_axi_acc_rresp(3'b000),
    .m_axi_acc_rvalid(1'b00),
    .m_axi_acc_wdata(),
    .m_axi_acc_wready(1'b1),
    .m_axi_acc_wstrb(),
    .m_axi_acc_wvalid(),
    .irq(3'b000),
    .uart_rxd(ftdi_tx),
    .uart_txd(ftdi_rx),
    .gpio_io_i(slide_switches),
    .gpio_io_o(leds),
    .gpio_io_t(),
    .spi_miso(sd_spi_miso),
    .spi_mosi(sd_spi_mosi),
    .spi_csn(s_spi_csn),
    .spi_sclk(sd_spi_sclk),
    .debug_rst(debug_rst)
  );

endmodule
