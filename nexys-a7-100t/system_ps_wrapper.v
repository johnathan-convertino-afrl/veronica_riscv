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
    input     [31:0]    gpio_io_i,
    output    [31:0]    gpio_io_o,
    output    [31:0]    gpio_io_t,
    output              s_axi_clk,
    input               spi_miso,
    output              spi_mosi,
    output    [31:0]    spi_csn,
    output              spi_clk,
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
  wire [ 2:0]    s_axi_perf_APROT;
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

  //axi4 w/ID memory bus DDR (ibus/dbus path)
  wire [31:0]    m_axi_ddr_ARADDR;
  wire [ 1:0]    m_axi_ddr_ARBURST;
  wire [ 3:0]    m_axi_ddr_ARCACHE;
  wire [ 3:0]    m_axi_ddr_ARID;
  wire [ 7:0]    m_axi_ddr_ARLEN;
  wire [ 2:0]    m_axi_ddr_ARPROT;
  wire           m_axi_ddr_ARREADY;
  wire [ 2:0]    m_axi_ddr_ARSIZE;
  wire           m_axi_ddr_ARVALID;
  wire [31:0]    m_axi_ddr_AWADDR;
  wire [ 1:0]    m_axi_ddr_AWBURST;
  wire [ 3:0]    m_axi_ddr_AWCACHE;
  wire [ 3:0]    m_axi_ddr_AWID;
  wire [ 7:0]    m_axi_ddr_AWLEN;
  wire [ 2:0]    m_axi_ddr_AWPROT;
  wire           m_axi_ddr_AWREADY;
  wire [ 2:0]    m_axi_ddr_AWSIZE;
  wire           m_axi_ddr_AWVALID;
  wire [ 3:0]    m_axi_ddr_BID;
  wire           m_axi_ddr_BREADY;
  wire           m_axi_ddr_BVALID;
  wire [31:0]    m_axi_ddr_RDATA;
  wire [ 3:0]    m_axi_ddr_RID;
  wire           m_axi_ddr_RLAST;
  wire           m_axi_ddr_RREADY;
  wire           m_axi_ddr_RVALID;
  wire [31:0]    m_axi_ddr_WDATA;
  wire           m_axi_ddr_WLAST;
  wire           m_axi_ddr_WREADY;
  wire [ 3:0]    m_axi_ddr_WSTRB;
  wire           m_axi_ddr_WVALID;
  wire [ 0:0]    m_axi_ddr_ARLOCK;
  wire [ 3:0]    m_axi_ddr_ARQOS;
  wire [ 0:0]    m_axi_ddr_AWLOCK;
  wire [ 3:0]    m_axi_ddr_AWQOS;
  wire [ 1:0]    m_axi_ddr_RRESP;
  wire [ 1:0]    m_axi_ddr_BRESP;

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

  //fill in vector
  wire [7*3-1:0]  m_axi_awprot_fill;
  wire [7*3-1:0]  m_axi_arprot_fill;
  wire            s_axi_dma_axixclk_aresetn;

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
    .s_axi_araddr(m_axi_ddr_ARADDR & 32'h0FFFFFFF),
    .s_axi_arburst(m_axi_ddr_ARBURST),
    .s_axi_arcache(m_axi_ddr_ARCACHE),
    .s_axi_arid(m_axi_ddr_ARID),
    .s_axi_arlen(m_axi_ddr_ARLEN),
    .s_axi_arlock(m_axi_ddr_ARLOCK),
    .s_axi_arprot(m_axi_ddr_ARPROT),
    .s_axi_arqos(m_axi_ddr_ARQOS),
    .s_axi_arready(m_axi_ddr_ARREADY),
    .s_axi_arsize(m_axi_ddr_ARSIZE),
    .s_axi_arvalid(m_axi_ddr_ARVALID),
    .s_axi_awaddr(m_axi_ddr_AWADDR & 32'h0FFFFFFF),
    .s_axi_awburst(m_axi_ddr_AWBURST),
    .s_axi_awcache(m_axi_ddr_AWCACHE),
    .s_axi_awid(m_axi_ddr_AWID),
    .s_axi_awlen(m_axi_ddr_AWLEN),
    .s_axi_awlock(m_axi_ddr_AWLOCK),
    .s_axi_awprot(m_axi_ddr_AWPROT),
    .s_axi_awqos(m_axi_ddr_AWQOS),
    .s_axi_awready(m_axi_ddr_AWREADY),
    .s_axi_awsize(m_axi_ddr_AWSIZE),
    .s_axi_awvalid(m_axi_ddr_AWVALID),
    .s_axi_bid(m_axi_ddr_BID),
    .s_axi_bready(m_axi_ddr_BREADY),
    .s_axi_bvalid(m_axi_ddr_BVALID),
    .s_axi_bresp(m_axi_ddr_BRESP),
    .s_axi_rdata(m_axi_ddr_RDATA),
    .s_axi_rid(m_axi_ddr_RID),
    .s_axi_rlast(m_axi_ddr_RLAST),
    .s_axi_rready(m_axi_ddr_RREADY),
    .s_axi_rvalid(m_axi_ddr_RVALID),
    .s_axi_rresp(m_axi_ddr_RRESP),
    .s_axi_wdata(m_axi_ddr_WDATA),
    .s_axi_wlast(m_axi_ddr_WLAST),
    .s_axi_wready(m_axi_ddr_WREADY),
    .s_axi_wstrb(m_axi_ddr_WSTRB),
    .s_axi_wvalid(m_axi_ddr_WVALID),
    .sys_clk_i(ddr_clk),
    .sys_rst(sys_rstn),
    .ui_clk(axi_ddr_ctrl_ui_clk),
    .ui_clk_sync_rst(axi_ddr_ctrl_ui_clk_sync_rst)
  );

  // Module: inst_axi_gpio32
  //
  // AXI GPIO
  axi_gpio32 inst_axi_gpio32
  (
    .gpio_io_i(gpio_io_i),
    .gpio_io_o(gpio_io_o),
    .gpio_io_t(gpio_io_t),
    .s_axi_aclk(axi_cpu_clk),
    .s_axi_araddr(m_axi_gpio_ARADDR[8:0]),
    .s_axi_aresetn(sys_rstgen_peripheral_aresetn),
    .s_axi_arready(m_axi_gpio_ARREADY),
    .s_axi_arvalid(m_axi_gpio_ARVALID),
    .s_axi_awaddr(m_axi_gpio_AWADDR[8:0]),
    .s_axi_awready(m_axi_gpio_AWREADY),
    .s_axi_awvalid(m_axi_gpio_AWVALID),
    .s_axi_bready(m_axi_gpio_BREADY),
    .s_axi_bresp(m_axi_gpio_BRESP),
    .s_axi_bvalid(m_axi_gpio_BVALID),
    .s_axi_rdata(m_axi_gpio_RDATA),
    .s_axi_rready(m_axi_gpio_RREADY),
    .s_axi_rresp(m_axi_gpio_RRESP),
    .s_axi_rvalid(m_axi_gpio_RVALID),
    .s_axi_wdata(m_axi_gpio_WDATA),
    .s_axi_wready(m_axi_gpio_WREADY),
    .s_axi_wstrb(m_axi_gpio_WSTRB),
    .s_axi_wvalid(m_axi_gpio_WVALID)
  );

  // Module: inst_axi_spix1
  //
  // AXI Standard SPI
  axi_spix1 inst_axi_spix1
  (
    .ext_spi_clk(axi_cpu_clk),
    .io0_i(spi_io0_i),
    .io0_o(spi_io0_o),
    .io0_t(spi_io0_t),
    .io1_i(spi_io1_i),
    .io1_o(spi_io1_o),
    .io1_t(spi_io1_t),
    .ip2intc_irpt(axi_spi_irq),
    .s_axi_aclk(axi_cpu_clk),
    .s_axi_araddr(m_axi_spi_ARADDR[6:0]),
    .s_axi_aresetn(sys_rstgen_peripheral_aresetn),
    .s_axi_arready(m_axi_spi_ARREADY),
    .s_axi_arvalid(m_axi_spi_ARVALID),
    .s_axi_awaddr(m_axi_spi_AWADDR[6:0]),
    .s_axi_awready(m_axi_spi_AWREADY),
    .s_axi_awvalid(m_axi_spi_AWVALID),
    .s_axi_bready(m_axi_spi_BREADY),
    .s_axi_bresp(m_axi_spi_BRESP),
    .s_axi_bvalid(m_axi_spi_BVALID),
    .s_axi_rdata(m_axi_spi_RDATA),
    .s_axi_rready(m_axi_spi_RREADY),
    .s_axi_rresp(m_axi_spi_RRESP),
    .s_axi_rvalid(m_axi_spi_RVALID),
    .s_axi_wdata(m_axi_spi_WDATA),
    .s_axi_wready(m_axi_spi_WREADY),
    .s_axi_wstrb(m_axi_spi_WSTRB),
    .s_axi_wvalid(m_axi_spi_WVALID),
    .sck_i(spi_sck_i),
    .sck_o(spi_sck_o),
    .sck_t(spi_sck_t),
    .ss_i(spi_ss_i),
    .ss_o(spi_ss_o),
    .ss_t(spi_ss_t)
  );

  // Module: inst_axi_uart
  //
  // AXI UART LITE
  axi_uart inst_axi_uart
  (
    .interrupt(axi_uartlite_irq),
    .rx(UART_rxd),
    .s_axi_aclk(axi_cpu_clk),
    .s_axi_araddr(m_axi_uart_ARADDR[3:0]),
    .s_axi_aresetn(sys_rstgen_peripheral_aresetn),
    .s_axi_arready(m_axi_uart_ARREADY),
    .s_axi_arvalid(m_axi_uart_ARVALID),
    .s_axi_awaddr(m_axi_uart_AWADDR[3:0]),
    .s_axi_awready(m_axi_uart_AWREADY),
    .s_axi_awvalid(m_axi_uart_AWVALID),
    .s_axi_bready(m_axi_uart_BREADY),
    .s_axi_bresp(m_axi_uart_BRESP),
    .s_axi_bvalid(m_axi_uart_BVALID),
    .s_axi_rdata(m_axi_uart_RDATA),
    .s_axi_rready(m_axi_uart_RREADY),
    .s_axi_rresp(m_axi_uart_RRESP),
    .s_axi_rvalid(m_axi_uart_RVALID),
    .s_axi_wdata(m_axi_uart_WDATA),
    .s_axi_wready(m_axi_uart_WREADY),
    .s_axi_wstrb(m_axi_uart_WSTRB),
    .s_axi_wvalid(m_axi_uart_WVALID),
    .tx(UART_txd)
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
    .ext_reset_in(sys_rstn & s_axi_dma_axixclk_aresetn),
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
    .S_AXI_WVALID   (s_axi_perf_AWVALID),
    .S_AXI_WREADY   (s_axi_perf_WREADY),
    .S_AXI_BRESP    (s_axi_perf_BRESP),
    .S_AXI_BVALID   (s_axi_perf_BVALID),
    .S_AXI_BREADY   (s_axi_perf_BREADY),
    .S_AXI_ARADDR   (s_axi_perf_ARADDR),
    .S_AXI_ARPROT   (s_axi_perf_APROT),
    .S_AXI_ARVALID  (s_axi_perf_ARVALID),
    .S_AXI_ARREADY  (s_axi_perf_ARREADY),
    .S_AXI_RDATA    (s_axi_perf_RDATA),
    .S_AXI_RRESP    (s_axi_perf_RRESP),
    .S_AXI_RVALID   (s_axi_perf_RVALID),
    .S_AXI_RREADY   (s_axi_perf_RREADY),
    .M_AXI_AWADDR  ({m_axi_spi_AWADDR,    m_axi_uart_AWADDR,     m_axi_gpio_AWADDR}),
    .M_AXI_AWPROT  (),
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
    .M_AXI_ARPROT  (),
    .M_AXI_ARVALID ({m_axi_spi_ARVALID,   m_axi_uart_ARVALID,    m_axi_gpio_ARVALID}),
    .M_AXI_ARREADY ({m_axi_spi_ARREADY,   m_axi_uart_ARREADY,    m_axi_gpio_ARREADY}),
    .M_AXI_RDATA   ({m_axi_spi_RDATA,     m_axi_uart_RDATA,      m_axi_gpio_RDATA}),
    .M_AXI_RRESP   ({m_axi_spi_RRESP,     m_axi_uart_RRESP,      m_axi_gpio_RRESP}),
    .M_AXI_RVALID  ({m_axi_spi_RVALID,    m_axi_uart_RVALID,     m_axi_gpio_RVALID}),
    .M_AXI_RREADY  ({m_axi_spi_RREADY,    m_axi_uart_RREADY,     m_axi_gpio_RREADY})
  );

  // Module: inst_axi_mem_xbar
  //
  // AXI Crossbar .. IBUS/DBUS @ 0x90000000 plus 2 dma cores. single Large RAM slave, 0xC0000000 is 1 GB mask (0x40000000 twos compliment).
  axixbar #(
    .C_AXI_DATA_WIDTH(32),
    .C_AXI_ADDR_WIDTH(32),
    .C_AXI_ID_WIDTH(4),
    .NM(1),
    .NS(1),
    .SLAVE_ADDR({{32'h90000000}}),
    .SLAVE_MASK({{32'hC0000000}})
  ) inst_axi_mem_xbar (
    .S_AXI_ACLK(axi_ddr_ctrl_ui_clk),
    .S_AXI_ARESETN(ddr_rstgen_peripheral_aresetn),
    .S_AXI_AWID    (s_axi_mbus_AWID),
    .S_AXI_AWADDR  (s_axi_mbus_AWADDR),
    .S_AXI_AWLEN   (s_axi_mbus_AWLEN),
    .S_AXI_AWSIZE  (s_axi_mbus_AWSIZE),
    .S_AXI_AWBURST (s_axi_mbus_AWBURST),
    .S_AXI_AWLOCK  (s_axi_mbus_AWLOCK),
    .S_AXI_AWCACHE (s_axi_mbus_AWCACHE),
    .S_AXI_AWPROT  (s_axi_mbus_AWPROT),
    .S_AXI_AWQOS   (s_axi_mbus_AWQOS),
    .S_AXI_AWVALID (s_axi_mbus_AWVALID),
    .S_AXI_AWREADY (s_axi_mbus_AWREADY),
    .S_AXI_WDATA   (s_axi_mbus_WDATA),
    .S_AXI_WSTRB   (s_axi_mbus_WSTRB),
    .S_AXI_WLAST   (s_axi_mbus_WLAST),
    .S_AXI_WVALID  (s_axi_mbus_WVALID),
    .S_AXI_WREADY  (s_axi_mbus_WREADY),
    .S_AXI_BID     (s_axi_mbus_BID),
    .S_AXI_BRESP   (s_axi_mbus_BRESP),
    .S_AXI_BVALID  (s_axi_mbus_BVALID),
    .S_AXI_BREADY  (s_axi_mbus_BREADY),
    .S_AXI_ARID    (s_axi_mbus_ARID),
    .S_AXI_ARADDR  (s_axi_mbus_ARADDR),
    .S_AXI_ARLEN   (s_axi_mbus_ARLEN),
    .S_AXI_ARSIZE  (s_axi_mbus_ARSIZE),
    .S_AXI_ARBURST (s_axi_mbus_ARBURST),
    .S_AXI_ARLOCK  (s_axi_mbus_ARLOCK),
    .S_AXI_ARCACHE (s_axi_mbus_ARCACHE),
    .S_AXI_ARPROT  (s_axi_mbus_ARPROT),
    .S_AXI_ARQOS   (s_axi_mbus_ARQOS),
    .S_AXI_ARVALID (s_axi_mbus_ARVALID),
    .S_AXI_ARREADY (s_axi_mbus_ARREADY),
    .S_AXI_RID     (s_axi_mbus_RID),
    .S_AXI_RDATA   (s_axi_mbus_RDATA),
    .S_AXI_RRESP   (s_axi_mbus_RRESP),
    .S_AXI_RLAST   (s_axi_mbus_RLAST),
    .S_AXI_RVALID  (s_axi_mbus_RVALID),
    .S_AXI_RREADY  (s_axi_mbus_RREADY),
    .M_AXI_AWID(m_axi_ddr_AWID),
    .M_AXI_AWADDR(m_axi_ddr_AWADDR),
    .M_AXI_AWLEN(m_axi_ddr_AWLEN),
    .M_AXI_AWSIZE(m_axi_ddr_AWSIZE),
    .M_AXI_AWBURST(m_axi_ddr_AWBURST),
    .M_AXI_AWLOCK(m_axi_ddr_AWLOCK),
    .M_AXI_AWCACHE(m_axi_ddr_AWCACHE),
    .M_AXI_AWPROT(m_axi_ddr_AWPROT),
    .M_AXI_AWQOS(m_axi_ddr_AWQOS),
    .M_AXI_AWVALID(m_axi_ddr_AWVALID),
    .M_AXI_AWREADY(m_axi_ddr_AWREADY),
    .M_AXI_WDATA(m_axi_ddr_WDATA),
    .M_AXI_WSTRB(m_axi_ddr_WSTRB),
    .M_AXI_WLAST(m_axi_ddr_WLAST),
    .M_AXI_WVALID(m_axi_ddr_WVALID),
    .M_AXI_WREADY(m_axi_ddr_WREADY),
    .M_AXI_BID(m_axi_ddr_BID),
    .M_AXI_BRESP(m_axi_ddr_BRESP),
    .M_AXI_BVALID(m_axi_ddr_BVALID),
    .M_AXI_BREADY(m_axi_ddr_BREADY),
    .M_AXI_ARID(m_axi_ddr_ARID),
    .M_AXI_ARADDR(m_axi_ddr_ARADDR),
    .M_AXI_ARLEN(m_axi_ddr_ARLEN),
    .M_AXI_ARSIZE(m_axi_ddr_ARSIZE),
    .M_AXI_ARBURST(m_axi_ddr_ARBURST),
    .M_AXI_ARLOCK(m_axi_ddr_ARLOCK),
    .M_AXI_ARCACHE(m_axi_ddr_ARCACHE),
    .M_AXI_ARPROT(m_axi_ddr_ARPROT),
    .M_AXI_ARQOS(m_axi_ddr_ARQOS),
    .M_AXI_ARVALID(m_axi_ddr_ARVALID),
    .M_AXI_ARREADY(m_axi_ddr_ARREADY),
    .M_AXI_RID(m_axi_ddr_RID),
    .M_AXI_RDATA(m_axi_ddr_RDATA),
    .M_AXI_RRESP(m_axi_ddr_RRESP),
    .M_AXI_RLAST(m_axi_ddr_RLAST),
    .M_AXI_RVALID(m_axi_ddr_RVALID),
    .M_AXI_RREADY(m_axi_ddr_RREADY)
  );

  // Module: inst_veronica
  //
  // Veronica AXI Vexriscv CPU
  Veronica inst_veronica
  (
    .io_aclk(axi_cpu_clk),
    .io_arst(sys_rstgen_peripheral_reset),
    .io_debug_rst(debug_rst),
    .io_ddr_clk(axi_ddr_ctrl_ui_clk),
    .io_ddr_rst(ddr_rstgen_peripheral_reset),
    .io_irq({{128-4{1'b0}}, axi_spi_irq, axi_uartlite_irq, IRQ, 1'b0}),
  `ifdef _JTAG_IO
    .io_jtag_tms(tms),
    .io_jtag_tdi(tdi),
    .io_jtag_tdo(tdo),
    .io_jtag_tck(tck),
  `endif
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
    .m_axi_perf_wvalid(s_axi_perf_WVALID),
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
    .m_axi_mbus_bresp(s_axi_mbus_BRESP)
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
