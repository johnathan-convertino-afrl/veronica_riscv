//******************************************************************************
//  file:     system_ps_wrapper.v
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
 * Module: system_ps_wrapper
 *
 * System wrapper for ps.
 *
 * Ports:
 *
 * tck            - JTAG
 * tms            - JTAG
 * tdi            - JTAG
 * tdo            - JTAG
 * DDR_addr       - DDR interface
 * DDR_ba         - DDR interface
 * DDR_cas_n      - DDR interface
 * DDR_ck_n       - DDR interface
 * DDR_ck_p       - DDR interface
 * DDR_cke        - DDR interface
 * DDR_cs_n       - DDR interface
 * DDR_dm         - DDR interface
 * DDR_dq         - DDR interface
 * DDR_dqs_n      - DDR interface
 * DDR_dqs_p      - DDR interface
 * DDR_odt        - DDR interface
 * DDR_ras_n      - DDR interface
 * DDR_we_n       - DDR interface
 * IRQ            - External Interrupts
 * MDIO_mdc       - Ethernet Interface MII
 * MDIO_mdio_io   - Ethernet Interface MII
 * MII_col        - Ethernet Interface MII
 * MII_crs        - Ethernet Interface MII
 * MII_rst_n      - Ethernet Interface MII
 * MII_rx_clk     - Ethernet Interface MII
 * MII_rx_dv      - Ethernet Interface MII
 * MII_rx_er      - Ethernet Interface MII
 * MII_rxd        - Ethernet Interface MII
 * MII_tx_clk     - Ethernet Interface MII
 * MII_tx_en      - Ethernet Interface MII
 * MII_txd        - Ethernet Interface MII
 * M_AXI_araddr   - External AXI Lite Master Interface
 * M_AXI_arprot   - External AXI Lite Master Interface
 * M_AXI_arready  - External AXI Lite Master Interface
 * M_AXI_arvalid  - External AXI Lite Master Interface
 * M_AXI_awaddr   - External AXI Lite Master Interface
 * M_AXI_awprot   - External AXI Lite Master Interface
 * M_AXI_awready  - External AXI Lite Master Interface
 * M_AXI_awvalid  - External AXI Lite Master Interface
 * M_AXI_bready   - External AXI Lite Master Interface
 * M_AXI_bresp    - External AXI Lite Master Interface
 * M_AXI_bvalid   - External AXI Lite Master Interface
 * M_AXI_rdata    - External AXI Lite Master Interface
 * M_AXI_rready   - External AXI Lite Master Interface
 * M_AXI_rresp    - External AXI Lite Master Interface
 * M_AXI_rvalid   - External AXI Lite Master Interface
 * M_AXI_wdata    - External AXI Lite Master Interface
 * M_AXI_wready   - External AXI Lite Master Interface
 * M_AXI_wstrb    - External AXI Lite Master Interface
 * M_AXI_wvalid   - External AXI Lite Master Interface
 * QSPI_0_io0_io  - Quad SPI
 * QSPI_0_io1_io  - Quad SPI
 * QSPI_0_io2_io  - Quad SPI
 * QSPI_0_io3_io  - Quad SPI
 * QSPI_0_ss_io   - Quad SPI
 * UART_rxd       - UART RX
 * UART_txd       - UART TX
 * gpio_io_i      - GPIO input
 * gpio_io_o      - GPIO output
 * gpio_io_t      - GPIO tristate select
 * s_axi_clk      - AXI Clock
 * spi_io0_i      - SPI IO
 * spi_io0_o      - SPI IO
 * spi_io0_t      - SPI IO
 * spi_io1_i      - SPI IO
 * spi_io1_o      - SPI IO
 * spi_io1_t      - SPI IO
 * spi_sck_i      - SPI IO
 * spi_sck_o      - SPI IO
 * spi_sck_t      - SPI IO
 * spi_ss_i       - SPI IO
 * spi_ss_o       - SPI IO
 * spi_ss_t       - SPI IO
 * sys_clk        - SYSTEM clock for pll
 * sys_rstn       - SYSTEM reset
 * vga_hsync      - VGA
 * vga_vsync      - VGA
 * vga_r          - VGA
 * vga_g          - VGA
 * vga_b          - VGA
 * sd_resetn      - sd card
 * sd_cd          - sd card
 * sd_sck         - sd card
 * sd_cmd         - sd card
 * sd_dat         - sd card
 */
module system_ps_wrapper
  (
`ifdef _JTAG_IO
    input           tck,
    input           tms,
    input           tdi,
    output          tdo,
`endif
    output    [12:0]    DDR_addr,
    output    [ 2:0]    DDR_ba,
    output              DDR_cas_n,
    output    [ 0:0]    DDR_ck_n,
    output    [ 0:0]    DDR_ck_p,
    output    [ 0:0]    DDR_cke,
    output    [ 0:0]    DDR_cs_n,
    output    [ 1:0]    DDR_dm,
    inout     [15:0]    DDR_dq,
    inout     [ 1:0]    DDR_dqs_n,
    inout     [ 1:0]    DDR_dqs_p,
    output    [ 0:0]    DDR_odt,
    output              DDR_ras_n,
    output              DDR_we_n,
    input     [ 2:0]    IRQ,
    output    [31:0]    M_AXI_araddr,
    output    [ 2:0]    M_AXI_arprot,
    input               M_AXI_arready,
    output              M_AXI_arvalid,
    output    [31:0]    M_AXI_awaddr,
    output    [ 2:0]    M_AXI_awprot,
    input               M_AXI_awready,
    output              M_AXI_awvalid,
    output              M_AXI_bready,
    input     [ 1:0]    M_AXI_bresp,
    input               M_AXI_bvalid,
    input     [31:0]    M_AXI_rdata,
    output              M_AXI_rready,
    input     [ 1:0]    M_AXI_rresp,
    input               M_AXI_rvalid,
    output    [31:0]    M_AXI_wdata,
    input               M_AXI_wready,
    output    [ 3:0]    M_AXI_wstrb,
    output              M_AXI_wvalid,
    input               UART_rxd,
    output              UART_txd,
    output              UART_rts,
    input               UART_cts,
    input     [31:0]    gpio_io_i,
    output    [31:0]    gpio_io_o,
    output    [31:0]    gpio_io_t,
    output              s_axi_clk,
    input               spi_miso,
    output              spi_mosi,
    output    [31:0]    spi_csn,
    output              spi_sclk,
    input               sys_clk,
    input               sys_rstn
  );

  //clocks
  wire           axi_cpu_clk;
  wire           ddr_clk;

  //resets
  wire [ 0:0]    ddr_rstgen_peripheral_aresetn;
  wire [ 0:0]    ddr_rstgen_peripheral_reset;
  wire [ 0:0]    sys_rstgen_interconnect_aresetn;
  wire [ 0:0]    sys_rstgen_peripheral_aresetn;
  wire [ 0:0]    sys_rstgen_peripheral_reset;
  wire           debug_rst;

  //ddr signals and clocks
  wire           axi_ddr_ctrl_mmcm_locked;
  wire           axi_ddr_ctrl_ui_clk;
  wire           axi_ddr_ctrl_ui_clk_sync_rst;

  //irq
  wire           axi_uartlite_irq;
  wire           axi_spi_irq;

  //axi lite gpio
  wire [31:0]    m_axi_gpio_ARADDR;
  wire           m_axi_gpio_ARREADY;
  wire           m_axi_gpio_ARVALID;
  wire [31:0]    m_axi_gpio_AWADDR;
  wire           m_axi_gpio_AWREADY;
  wire           m_axi_gpio_AWVALID;
  wire           m_axi_gpio_BREADY;
  wire [ 1:0]    m_axi_gpio_BRESP;
  wire           m_axi_gpio_BVALID;
  wire [31:0]    m_axi_gpio_RDATA;
  wire           m_axi_gpio_RREADY;
  wire [ 1:0]    m_axi_gpio_RRESP;
  wire           m_axi_gpio_RVALID;
  wire [31:0]    m_axi_gpio_WDATA;
  wire           m_axi_gpio_WREADY;
  wire [ 3:0]    m_axi_gpio_WSTRB;
  wire           m_axi_gpio_WVALID;
  wire [ 2:0]    m_axi_gpio_AWPROT;
  wire [ 2:0]    m_axi_gpio_ARPROT;

  //axi lite perf (dbus only)
  wire [31:0]    s_axi_perf_ARADDR;
  wire           s_axi_perf_ARREADY;
  wire           s_axi_perf_ARVALID;
  wire [31:0]    s_axi_perf_AWADDR;
  wire           s_axi_perf_AWREADY;
  wire           s_axi_perf_AWVALID;
  wire           s_axi_perf_BREADY;
  wire [ 1:0]    s_axi_perf_BRESP;
  wire           s_axi_perf_BVALID;
  wire [31:0]    s_axi_perf_RDATA;
  wire           s_axi_perf_RREADY;
  wire [ 1:0]    s_axi_perf_RRESP;
  wire           s_axi_perf_RVALID;
  wire [31:0]    s_axi_perf_WDATA;
  wire           s_axi_perf_WREADY;
  wire [ 3:0]    s_axi_perf_WSTRB;
  wire           s_axi_perf_WVALID;
  wire [ 2:0]    s_axi_perf_ARPROT;
  wire [ 2:0]    s_axi_perf_AWPROT;

  //axi4 w/ID memory bus (ibus/dbus path)
  wire [31:0]    s_axi_mbus_ARADDR;
  wire [ 1:0]    s_axi_mbus_ARBURST;
  wire [ 3:0]    s_axi_mbus_ARCACHE;
  wire [ 3:0]    s_axi_mbus_ARID;
  wire [ 7:0]    s_axi_mbus_ARLEN;
  wire [ 2:0]    s_axi_mbus_ARPROT;
  wire           s_axi_mbus_ARREADY;
  wire [ 2:0]    s_axi_mbus_ARSIZE;
  wire           s_axi_mbus_ARVALID;
  wire [31:0]    s_axi_mbus_AWADDR;
  wire [ 1:0]    s_axi_mbus_AWBURST;
  wire [ 3:0]    s_axi_mbus_AWCACHE;
  wire [ 3:0]    s_axi_mbus_AWID;
  wire [ 7:0]    s_axi_mbus_AWLEN;
  wire [ 2:0]    s_axi_mbus_AWPROT;
  wire           s_axi_mbus_AWREADY;
  wire [ 2:0]    s_axi_mbus_AWSIZE;
  wire           s_axi_mbus_AWVALID;
  wire [ 3:0]    s_axi_mbus_BID;
  wire           s_axi_mbus_BREADY;
  wire           s_axi_mbus_BVALID;
  wire [31:0]    s_axi_mbus_RDATA;
  wire [ 3:0]    s_axi_mbus_RID;
  wire           s_axi_mbus_RLAST;
  wire           s_axi_mbus_RREADY;
  wire           s_axi_mbus_RVALID;
  wire [31:0]    s_axi_mbus_WDATA;
  wire           s_axi_mbus_WLAST;
  wire           s_axi_mbus_WREADY;
  wire [ 3:0]    s_axi_mbus_WSTRB;
  wire           s_axi_mbus_WVALID;
  wire [ 0:0]    s_axi_mbus_ARLOCK;
  wire [ 3:0]    s_axi_mbus_ARQOS;
  wire [ 0:0]    s_axi_mbus_AWLOCK;
  wire [ 3:0]    s_axi_mbus_AWQOS;
  wire [ 1:0]    s_axi_mbus_RRESP;
  wire [ 1:0]    s_axi_mbus_BRESP;

  // //axi4 w/ID memory bus DDR (ibus/dbus path)
  // wire [31:0]    m_axi_ddr_ARADDR;
  // wire [ 1:0]    m_axi_ddr_ARBURST;
  // wire [ 3:0]    m_axi_ddr_ARCACHE;
  // wire [ 3:0]    m_axi_ddr_ARID;
  // wire [ 7:0]    m_axi_ddr_ARLEN;
  // wire [ 2:0]    m_axi_ddr_ARPROT;
  // wire           m_axi_ddr_ARREADY;
  // wire [ 2:0]    m_axi_ddr_ARSIZE;
  // wire           m_axi_ddr_ARVALID;
  // wire [31:0]    m_axi_ddr_AWADDR;
  // wire [ 1:0]    m_axi_ddr_AWBURST;
  // wire [ 3:0]    m_axi_ddr_AWCACHE;
  // wire [ 3:0]    m_axi_ddr_AWID;
  // wire [ 7:0]    m_axi_ddr_AWLEN;
  // wire [ 2:0]    m_axi_ddr_AWPROT;
  // wire           m_axi_ddr_AWREADY;
  // wire [ 2:0]    m_axi_ddr_AWSIZE;
  // wire           m_axi_ddr_AWVALID;
  // wire [ 3:0]    m_axi_ddr_BID;
  // wire           m_axi_ddr_BREADY;
  // wire           m_axi_ddr_BVALID;
  // wire [31:0]    m_axi_ddr_RDATA;
  // wire [ 3:0]    m_axi_ddr_RID;
  // wire           m_axi_ddr_RLAST;
  // wire           m_axi_ddr_RREADY;
  // wire           m_axi_ddr_RVALID;
  // wire [31:0]    m_axi_ddr_WDATA;
  // wire           m_axi_ddr_WLAST;
  // wire           m_axi_ddr_WREADY;
  // wire [ 3:0]    m_axi_ddr_WSTRB;
  // wire           m_axi_ddr_WVALID;
  // wire [ 0:0]    m_axi_ddr_ARLOCK;
  // wire [ 3:0]    m_axi_ddr_ARQOS;
  // wire [ 0:0]    m_axi_ddr_AWLOCK;
  // wire [ 3:0]    m_axi_ddr_AWQOS;
  // wire [ 1:0]    m_axi_ddr_RRESP;
  // wire [ 1:0]    m_axi_ddr_BRESP;

  //axi lite spi
  wire [31:0]    m_axi_spi_ARADDR;
  wire           m_axi_spi_ARREADY;
  wire           m_axi_spi_ARVALID;
  wire [31:0]    m_axi_spi_AWADDR;
  wire           m_axi_spi_AWREADY;
  wire           m_axi_spi_AWVALID;
  wire           m_axi_spi_BREADY;
  wire [ 1:0]    m_axi_spi_BRESP;
  wire           m_axi_spi_BVALID;
  wire [31:0]    m_axi_spi_RDATA;
  wire           m_axi_spi_RREADY;
  wire [ 1:0]    m_axi_spi_RRESP;
  wire           m_axi_spi_RVALID;
  wire [31:0]    m_axi_spi_WDATA;
  wire           m_axi_spi_WREADY;
  wire [ 3:0]    m_axi_spi_WSTRB;
  wire           m_axi_spi_WVALID;
  wire [ 2:0]    m_axi_spi_AWPROT;
  wire [ 2:0]    m_axi_spi_ARPROT;

  //axi lite uart
  wire [31:0]    m_axi_uart_ARADDR;
  wire           m_axi_uart_ARREADY;
  wire           m_axi_uart_ARVALID;
  wire [31:0]    m_axi_uart_AWADDR;
  wire           m_axi_uart_AWREADY;
  wire           m_axi_uart_AWVALID;
  wire           m_axi_uart_BREADY;
  wire [ 1:0]    m_axi_uart_BRESP;
  wire           m_axi_uart_BVALID;
  wire [31:0]    m_axi_uart_RDATA;
  wire           m_axi_uart_RREADY;
  wire [ 1:0]    m_axi_uart_RRESP;
  wire           m_axi_uart_RVALID;
  wire [31:0]    m_axi_uart_WDATA;
  wire           m_axi_uart_WREADY;
  wire [ 3:0]    m_axi_uart_WSTRB;
  wire           m_axi_uart_WVALID;
  wire [ 2:0]    m_axi_uart_AWPROT;
  wire [ 2:0]    m_axi_uart_ARPROT;


  //distribute clock for axi and assign to output for m_axi_acc
  assign s_axi_clk = axi_cpu_clk;

  // Group: Instantianted Modules

  // Module: inst_axi_ddr_ctrl
  //
  // AXI DDR Controller
  axi_ddr_ctrl inst_axi_ddr_ctrl
  (
    .aresetn(ddr_rstgen_peripheral_aresetn),
    .ddr2_addr(DDR_addr),
    .ddr2_ba(DDR_ba),
    .ddr2_cas_n(DDR_cas_n),
    .ddr2_ck_n(DDR_ck_n),
    .ddr2_ck_p(DDR_ck_p),
    .ddr2_cke(DDR_cke),
    .ddr2_cs_n(DDR_cs_n),
    .ddr2_dm(DDR_dm),
    .ddr2_dq(DDR_dq[15:0]),
    .ddr2_dqs_n(DDR_dqs_n[1:0]),
    .ddr2_dqs_p(DDR_dqs_p[1:0]),
    .ddr2_odt(DDR_odt),
    .ddr2_ras_n(DDR_ras_n),
    .ddr2_we_n(DDR_we_n),
    .mmcm_locked(axi_ddr_ctrl_mmcm_locked),
    .s_axi_araddr(s_axi_mbus_ARADDR & 32'h0FFFFFFF),
    .s_axi_arburst(s_axi_mbus_ARBURST),
    .s_axi_arcache(s_axi_mbus_ARCACHE),
    .s_axi_arid(s_axi_mbus_ARID),
    .s_axi_arlen(s_axi_mbus_ARLEN),
    .s_axi_arlock(s_axi_mbus_ARLOCK),
    .s_axi_arprot(s_axi_mbus_ARPROT),
    .s_axi_arqos(s_axi_mbus_ARQOS),
    .s_axi_arready(s_axi_mbus_ARREADY),
    .s_axi_arsize(s_axi_mbus_ARSIZE),
    .s_axi_arvalid(s_axi_mbus_ARVALID),
    .s_axi_awaddr(s_axi_mbus_AWADDR & 32'h0FFFFFFF),
    .s_axi_awburst(s_axi_mbus_AWBURST),
    .s_axi_awcache(s_axi_mbus_AWCACHE),
    .s_axi_awid(s_axi_mbus_AWID),
    .s_axi_awlen(s_axi_mbus_AWLEN),
    .s_axi_awlock(s_axi_mbus_AWLOCK),
    .s_axi_awprot(s_axi_mbus_AWPROT),
    .s_axi_awqos(s_axi_mbus_AWQOS),
    .s_axi_awready(s_axi_mbus_AWREADY),
    .s_axi_awsize(s_axi_mbus_AWSIZE),
    .s_axi_awvalid(s_axi_mbus_AWVALID),
    .s_axi_bid(s_axi_mbus_BID),
    .s_axi_bready(s_axi_mbus_BREADY),
    .s_axi_bvalid(s_axi_mbus_BVALID),
    .s_axi_bresp(s_axi_mbus_BRESP),
    .s_axi_rdata(s_axi_mbus_RDATA),
    .s_axi_rid(s_axi_mbus_RID),
    .s_axi_rlast(s_axi_mbus_RLAST),
    .s_axi_rready(s_axi_mbus_RREADY),
    .s_axi_rvalid(s_axi_mbus_RVALID),
    .s_axi_rresp(s_axi_mbus_RRESP),
    .s_axi_wdata(s_axi_mbus_WDATA),
    .s_axi_wlast(s_axi_mbus_WLAST),
    .s_axi_wready(s_axi_mbus_WREADY),
    .s_axi_wstrb(s_axi_mbus_WSTRB),
    .s_axi_wvalid(s_axi_mbus_WVALID),
    .sys_clk_i(ddr_clk),
    .sys_rst(sys_rstn),
    .ui_clk(axi_ddr_ctrl_ui_clk),
    .ui_clk_sync_rst(axi_ddr_ctrl_ui_clk_sync_rst)
  );

  // Module: inst_axi_gpio32
  //
  // AXI GPIO
  axi_lite_gpio #(
    .ADDRESS_WIDTH(32),
    .BUS_WIDTH(4),
    .GPIO_WIDTH(32),
    .IRQ_ENABLE(0)
  ) inst_axi_gpio32 (
    .aclk(axi_cpu_clk),
    .arstn(sys_rstgen_peripheral_aresetn),
    .s_axi_awvalid(m_axi_gpio_AWVALID),
    .s_axi_awaddr(m_axi_gpio_AWADDR),
    .s_axi_awprot(s_axi_gpio_AWPROT),
    .s_axi_awready(m_axi_gpio_AWREADY),
    .s_axi_wvalid(m_axi_gpio_WVALID),
    .s_axi_wdata(m_axi_gpio_WDATA),
    .s_axi_wstrb(m_axi_gpio_WSTRB),
    .s_axi_wready(m_axi_gpio_WREADY),
    .s_axi_bvalid(m_axi_gpio_BVALID),
    .s_axi_bresp(m_axi_gpio_BRESP),
    .s_axi_bready(m_axi_gpio_BREADY),
    .s_axi_arvalid(m_axi_gpio_ARVALID),
    .s_axi_araddr(m_axi_gpio_ARADDR),
    .s_axi_arprot(s_axi_gpio_ARPROT),
    .s_axi_arready(m_axi_gpio_ARREADY),
    .s_axi_rvalid(m_axi_gpio_RVALID),
    .s_axi_rdata(m_axi_gpio_RDATA),
    .s_axi_rresp(m_axi_gpio_RRESP),
    .s_axi_rready(m_axi_gpio_RREADY),
    .irq(),
    .gpio_io_i(gpio_io_i),
    .gpio_io_o(gpio_io_o),
    .gpio_io_t(gpio_io_t)
  );

  // Module: inst_axi_spi
  //
  // AXI Standard SPI
  axi_lite_spi_master #(
    .ADDRESS_WIDTH(32),
    .BUS_WIDTH(4),
    .WORD_WIDTH(1),
    .CLOCK_SPEED(50000000),
    .SELECT_WIDTH(32),
    .DEFAULT_RATE_DIV(0),
    .DEFAULT_CPOL(0),
    .DEFAULT_CPHA(0)
  ) inst_axi_spi (
    .aclk(axi_cpu_clk),
    .arstn(sys_rstgen_peripheral_aresetn),
    .s_axi_awvalid(m_axi_spi_AWVALID),
    .s_axi_awaddr(m_axi_spi_AWADDR),
    .s_axi_awprot(m_axi_spi_AWPROT),
    .s_axi_awready(m_axi_spi_AWREADY),
    .s_axi_wvalid(m_axi_spi_WVALID),
    .s_axi_wdata(m_axi_spi_WDATA),
    .s_axi_wstrb(m_axi_spi_WSTRB),
    .s_axi_wready(m_axi_spi_WREADY),
    .s_axi_bvalid(m_axi_spi_BVALID),
    .s_axi_bresp(m_axi_spi_BRESP),
    .s_axi_bready(m_axi_spi_BREADY),
    .s_axi_arvalid(m_axi_spi_ARVALID),
    .s_axi_araddr(m_axi_spi_ARADDR),
    .s_axi_arprot(m_axi_spi_ARPROT),
    .s_axi_arready(m_axi_spi_ARREADY),
    .s_axi_rvalid(m_axi_spi_RVALID),
    .s_axi_rdata(m_axi_spi_RDATA),
    .s_axi_rresp(m_axi_spi_RRESP),
    .s_axi_rready(m_axi_spi_RREADY),
    .irq(axi_spi_irq),
    .sclk(spi_sclk),
    .mosi(spi_mosi),
    .miso(spi_miso),
    .ss_n(spi_csn)
  );
  
  // Module: inst_axi_uart
  //
  // AXI UART LITE 
  axi_lite_uart #(
    .ADDRESS_WIDTH(32),
    .BUS_WIDTH(4),
    .CLOCK_SPEED(50000000),
    .BAUD_RATE(115200),
    .PARITY_ENA(0),
    .PARITY_TYPE(0),
    .STOP_BITS(1),
    .DATA_BITS(8),
    .RX_DELAY(0),
    .RX_BAUD_DELAY(0),
    .TX_DELAY(0),
    .TX_BAUD_DELAY(0)
  ) inst_axi_uart (
    .aclk(axi_cpu_clk),
    .arstn(sys_rstgen_peripheral_aresetn),
    .s_axi_awvalid(m_axi_uart_AWVALID),
    .s_axi_awaddr(m_axi_uart_AWADDR),
    .s_axi_awprot(s_axi_uart_AWPROT),
    .s_axi_awready(m_axi_uart_AWREADY),
    .s_axi_wvalid(m_axi_uart_WVALID),
    .s_axi_wdata(m_axi_uart_WDATA),
    .s_axi_wstrb(m_axi_uart_WSTRB),
    .s_axi_wready(m_axi_uart_WREADY),
    .s_axi_bvalid(m_axi_uart_BVALID),
    .s_axi_bresp(m_axi_uart_BRESP),
    .s_axi_bready(m_axi_uart_BREADY),
    .s_axi_arvalid(m_axi_uart_ARVALID),
    .s_axi_araddr(m_axi_uart_ARADDR),
    .s_axi_arprot(s_axi_uart_ARPROT),
    .s_axi_arready(m_axi_uart_ARREADY),
    .s_axi_rvalid(m_axi_uart_RVALID),
    .s_axi_rdata(m_axi_uart_RDATA),
    .s_axi_rresp(m_axi_uart_RRESP),
    .s_axi_rready(m_axi_uart_RREADY),
    .irq(axi_uartlite_irq),
    .tx(UART_txd),
    .rx(UART_rxd),
    .rts(UART_rts),
    .cts(UART_cts)
  );

  // Module: inst_clk_wiz_1
  //
  // Generate system clocks
  clk_wiz_1 inst_clk_wiz_1
  (
    .clk_in1(sys_clk),
    .clk_out1(axi_cpu_clk),
    .clk_out2(ddr_clk)
  );

  // Module: inst_ddr_rstgen
  //
  // Generate DDR Reset
  ddr_rstgen inst_ddr_rstgen
  (
    .aux_reset_in(axi_ddr_ctrl_ui_clk_sync_rst),
    .dcm_locked(axi_ddr_ctrl_mmcm_locked),
    .ext_reset_in(sys_rstn),
    .mb_debug_sys_rst(debug_rst),
    .peripheral_reset(ddr_rstgen_peripheral_reset),
    .peripheral_aresetn(ddr_rstgen_peripheral_aresetn),
    .slowest_sync_clk(axi_ddr_ctrl_ui_clk)
  );


  // Module: inst_axilite_perf_xbar
  //
  // AXI Lite Crossbar for slow speed devices .. sdio, tft vga, double timer, ethernet, spi, qspi, uart, gpio
  axilxbar #(
    .C_AXI_DATA_WIDTH(32),
    .C_AXI_ADDR_WIDTH(32),
    .NM(1),
    .NS(3),
    .SLAVE_ADDR({{32'h44A20000},{32'h44A10000},{32'h44A00000}}),
    .SLAVE_MASK({{32'hFFFF0000},{32'hFFFF0000},{32'hFFFF0000}})
  ) inst_axilite_perf_xbar (
    .S_AXI_ACLK     (axi_cpu_clk),
    .S_AXI_ARESETN  (sys_rstgen_peripheral_aresetn),
    .S_AXI_AWADDR   (s_axi_perf_AWADDR),
    .S_AXI_AWPROT   (s_axi_perf_AWPROT),
    .S_AXI_AWVALID  (s_axi_perf_AWVALID),
    .S_AXI_AWREADY  (s_axi_perf_AWREADY),
    .S_AXI_WDATA    (s_axi_perf_WDATA),
    .S_AXI_WSTRB    (s_axi_perf_WSTRB),
    .S_AXI_WVALID   (s_axi_perf_WVALID),
    .S_AXI_WREADY   (s_axi_perf_WREADY),
    .S_AXI_BRESP    (s_axi_perf_BRESP),
    .S_AXI_BVALID   (s_axi_perf_BVALID),
    .S_AXI_BREADY   (s_axi_perf_BREADY),
    .S_AXI_ARADDR   (s_axi_perf_ARADDR),
    .S_AXI_ARPROT   (s_axi_perf_ARPROT),
    .S_AXI_ARVALID  (s_axi_perf_ARVALID),
    .S_AXI_ARREADY  (s_axi_perf_ARREADY),
    .S_AXI_RDATA    (s_axi_perf_RDATA),
    .S_AXI_RRESP    (s_axi_perf_RRESP),
    .S_AXI_RVALID   (s_axi_perf_RVALID),
    .S_AXI_RREADY   (s_axi_perf_RREADY),
    .M_AXI_AWADDR  ({m_axi_spi_AWADDR,    m_axi_uart_AWADDR,     m_axi_gpio_AWADDR}),
    .M_AXI_AWPROT  ({m_axi_spi_AWPROT,    m_axi_uart_AWPROT,     m_axi_gpio_AWPROT}),
    .M_AXI_AWVALID ({m_axi_spi_AWVALID,   m_axi_uart_AWVALID,    m_axi_gpio_AWVALID}),
    .M_AXI_AWREADY ({m_axi_spi_AWREADY,   m_axi_uart_AWREADY,    m_axi_gpio_AWREADY}),
    .M_AXI_WDATA   ({m_axi_spi_WDATA,     m_axi_uart_WDATA,      m_axi_gpio_WDATA}),
    .M_AXI_WSTRB   ({m_axi_spi_WSTRB,     m_axi_uart_WSTRB,      m_axi_gpio_WSTRB}),
    .M_AXI_WVALID  ({m_axi_spi_WVALID,    m_axi_uart_WVALID,     m_axi_gpio_WVALID}),
    .M_AXI_WREADY  ({m_axi_spi_WREADY,    m_axi_uart_WREADY,     m_axi_gpio_WREADY}),
    .M_AXI_BRESP   ({m_axi_spi_BRESP,     m_axi_uart_BRESP,      m_axi_gpio_BRESP}),
    .M_AXI_BVALID  ({m_axi_spi_BVALID,    m_axi_uart_BVALID,     m_axi_gpio_BVALID}),
    .M_AXI_BREADY  ({m_axi_spi_BREADY,    m_axi_uart_BREADY,     m_axi_gpio_BREADY}),
    .M_AXI_ARADDR  ({m_axi_spi_ARADDR,    m_axi_uart_ARADDR,     m_axi_gpio_ARADDR}),
    .M_AXI_ARPROT  ({m_axi_spi_ARPROT,    m_axi_uart_ARPROT,     m_axi_gpio_ARPROT}),
    .M_AXI_ARVALID ({m_axi_spi_ARVALID,   m_axi_uart_ARVALID,    m_axi_gpio_ARVALID}),
    .M_AXI_ARREADY ({m_axi_spi_ARREADY,   m_axi_uart_ARREADY,    m_axi_gpio_ARREADY}),
    .M_AXI_RDATA   ({m_axi_spi_RDATA,     m_axi_uart_RDATA,      m_axi_gpio_RDATA}),
    .M_AXI_RRESP   ({m_axi_spi_RRESP,     m_axi_uart_RRESP,      m_axi_gpio_RRESP}),
    .M_AXI_RVALID  ({m_axi_spi_RVALID,    m_axi_uart_RVALID,     m_axi_gpio_RVALID}),
    .M_AXI_RREADY  ({m_axi_spi_RREADY,    m_axi_uart_RREADY,     m_axi_gpio_RREADY})
  );
  
  // Module: inst_veronica
  //
  // Veronica AXI Vexriscv CPU
  Veronica inst_veronica
  (
  `ifdef _JTAG_IO
    .io_jtag_tms(tms),
    .io_jtag_tdi(tdi),
    .io_jtag_tdo(tdo),
    .io_jtag_tck(tck),
  `endif
    .io_aclk(axi_cpu_clk),
    .io_arst(sys_rstgen_peripheral_reset),
    .io_debug_rst(debug_rst),
    .io_ddr_clk(axi_ddr_ctrl_ui_clk),
    .io_ddr_rst(ddr_rstgen_peripheral_reset),
    .io_irq({{128-6{1'b0}}, axi_spi_irq, axi_uartlite_irq, IRQ, 1'b0}),
    .m_axi_mbus_araddr(s_axi_mbus_ARADDR),
    .m_axi_mbus_arburst(s_axi_mbus_ARBURST),
    .m_axi_mbus_arcache(s_axi_mbus_ARCACHE),
    .m_axi_mbus_arid(s_axi_mbus_ARID),
    .m_axi_mbus_arlen(s_axi_mbus_ARLEN),
    .m_axi_mbus_arprot(s_axi_mbus_ARPROT),
    .m_axi_mbus_arready(s_axi_mbus_ARREADY),
    .m_axi_mbus_arsize(s_axi_mbus_ARSIZE),
    .m_axi_mbus_arvalid(s_axi_mbus_ARVALID),
    .m_axi_mbus_awaddr(s_axi_mbus_AWADDR),
    .m_axi_mbus_awburst(s_axi_mbus_AWBURST),
    .m_axi_mbus_awcache(s_axi_mbus_AWCACHE),
    .m_axi_mbus_awid(s_axi_mbus_AWID),
    .m_axi_mbus_awlen(s_axi_mbus_AWLEN),
    .m_axi_mbus_awprot(s_axi_mbus_AWPROT),
    .m_axi_mbus_awready(s_axi_mbus_AWREADY),
    .m_axi_mbus_awsize(s_axi_mbus_AWSIZE),
    .m_axi_mbus_awvalid(s_axi_mbus_AWVALID),
    .m_axi_mbus_bid(s_axi_mbus_BID),
    .m_axi_mbus_bready(s_axi_mbus_BREADY),
    .m_axi_mbus_bvalid(s_axi_mbus_BVALID),
    .m_axi_mbus_rdata(s_axi_mbus_RDATA),
    .m_axi_mbus_rid(s_axi_mbus_RID),
    .m_axi_mbus_rlast(s_axi_mbus_RLAST),
    .m_axi_mbus_rready(s_axi_mbus_RREADY),
    .m_axi_mbus_rvalid(s_axi_mbus_RVALID),
    .m_axi_mbus_wdata(s_axi_mbus_WDATA),
    .m_axi_mbus_wlast(s_axi_mbus_WLAST),
    .m_axi_mbus_wready(s_axi_mbus_WREADY),
    .m_axi_mbus_wstrb(s_axi_mbus_WSTRB),
    .m_axi_mbus_wvalid(s_axi_mbus_WVALID),
    .m_axi_mbus_arqos(s_axi_mbus_ARQOS),
    .m_axi_mbus_arlock(s_axi_mbus_ARLOCK),
    .m_axi_mbus_awqos(s_axi_mbus_AWQOS),
    .m_axi_mbus_awlock(s_axi_mbus_AWLOCK),
    .m_axi_mbus_rresp(s_axi_mbus_RRESP),
    .m_axi_mbus_bresp(s_axi_mbus_BRESP),
    .m_axi_acc_araddr(M_AXI_araddr),
    .m_axi_acc_arprot(M_AXI_arprot),
    .m_axi_acc_arready(M_AXI_arready),
    .m_axi_acc_arvalid(M_AXI_arvalid),
    .m_axi_acc_awaddr(M_AXI_awaddr),
    .m_axi_acc_awprot(M_AXI_awprot),
    .m_axi_acc_awready(M_AXI_awready),
    .m_axi_acc_awvalid(M_AXI_awvalid),
    .m_axi_acc_bready(M_AXI_bready),
    .m_axi_acc_bresp(M_AXI_bresp),
    .m_axi_acc_bvalid(M_AXI_bvalid),
    .m_axi_acc_rdata(M_AXI_rdata),
    .m_axi_acc_rready(M_AXI_rready),
    .m_axi_acc_rresp(M_AXI_rresp),
    .m_axi_acc_rvalid(M_AXI_rvalid),
    .m_axi_acc_wdata(M_AXI_wdata),
    .m_axi_acc_wready(M_AXI_wready),
    .m_axi_acc_wstrb(M_AXI_wstrb),
    .m_axi_acc_wvalid(M_AXI_wvalid),
    .m_axi_perf_araddr(s_axi_perf_ARADDR),
    .m_axi_perf_arready(s_axi_perf_ARREADY),
    .m_axi_perf_arvalid(s_axi_perf_ARVALID),
    .m_axi_perf_arprot(s_axi_perf_ARPROT),
    .m_axi_perf_awaddr(s_axi_perf_AWADDR),
    .m_axi_perf_awprot(s_axi_perf_AWPROT),
    .m_axi_perf_awready(s_axi_perf_AWREADY),
    .m_axi_perf_awvalid(s_axi_perf_AWVALID),
    .m_axi_perf_bready(s_axi_perf_BREADY),
    .m_axi_perf_bresp(s_axi_perf_BRESP),
    .m_axi_perf_bvalid(s_axi_perf_BVALID),
    .m_axi_perf_rdata(s_axi_perf_RDATA),
    .m_axi_perf_rready(s_axi_perf_RREADY),
    .m_axi_perf_rresp(s_axi_perf_RRESP),
    .m_axi_perf_rvalid(s_axi_perf_RVALID),
    .m_axi_perf_wdata(s_axi_perf_WDATA),
    .m_axi_perf_wready(s_axi_perf_WREADY),
    .m_axi_perf_wstrb(s_axi_perf_WSTRB),
    .m_axi_perf_wvalid(s_axi_perf_WVALID)
  );

  // Module: inst_sys_rstgen
  //
  // Generate general system resets
  sys_rstgen inst_sys_rstgen
  (
    .aux_reset_in(axi_ddr_ctrl_ui_clk_sync_rst),
    .dcm_locked(axi_ddr_ctrl_mmcm_locked),
    .ext_reset_in(sys_rstn),
    .interconnect_aresetn(sys_rstgen_interconnect_aresetn),
    .mb_debug_sys_rst(debug_rst),
    .peripheral_reset(sys_rstgen_peripheral_reset),
    .peripheral_aresetn(sys_rstgen_peripheral_aresetn),
    .slowest_sync_clk(axi_cpu_clk)
  );

endmodule
