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
 * Module: system_ps_wrapper_jtag
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
 * m_axi_araddr   - External AXI Lite Master Interface
 * m_axi_arprot   - External AXI Lite Master Interface
 * m_axi_arready  - External AXI Lite Master Interface
 * m_axi_arvalid  - External AXI Lite Master Interface
 * m_axi_awaddr   - External AXI Lite Master Interface
 * m_axi_awprot   - External AXI Lite Master Interface
 * m_axi_awready  - External AXI Lite Master Interface
 * m_axi_awvalid  - External AXI Lite Master Interface
 * m_axi_bready   - External AXI Lite Master Interface
 * m_axi_bresp    - External AXI Lite Master Interface
 * m_axi_bvalid   - External AXI Lite Master Interface
 * m_axi_rdata    - External AXI Lite Master Interface
 * m_axi_rready   - External AXI Lite Master Interface
 * m_axi_rresp    - External AXI Lite Master Interface
 * m_axi_rvalid   - External AXI Lite Master Interface
 * m_axi_wdata    - External AXI Lite Master Interface
 * m_axi_wready   - External AXI Lite Master Interface
 * m_axi_wstrb    - External AXI Lite Master Interface
 * m_axi_wvalid   - External AXI Lite Master Interface
 * QSPI_0_io0_io  - Quad SPI
 * QSPI_0_io1_io  - Quad SPI
 * QSPI_0_io2_io  - Quad SPI
 * QSPI_0_io3_io  - Quad SPI
 * QSPI_0_ss_io   - Quad SPI
 * uart_rxd       - uart RX
 * uart_txd       - uart TX
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
module system_ps_wrapper_jtag #(
    parameter  CLK_FREQ_MHZ = 100
  )
  (
    input   wire            tck,
    input   wire            tms,
    input   wire            tdi,
    output  wire            tdo,
    input   wire            aclk,
    input   wire            arstn,
    input   wire            arst,
    input   wire            ddr_clk,
    input   wire            ddr_rst,
    output  wire            m_axi_mbus_awvalid,
    input   wire            m_axi_mbus_awready,
    output  wire  [31:0]    m_axi_mbus_awaddr,
    output  wire  [ 3:0]    m_axi_mbus_awid,
    output  wire  [ 7:0]    m_axi_mbus_awlen,
    output  wire  [ 2:0]    m_axi_mbus_awsize,
    output  wire  [ 1:0]    m_axi_mbus_awburst,
    output  wire  [ 0:0]    m_axi_mbus_awlock,
    output  wire  [ 3:0]    m_axi_mbus_awcache,
    output  wire  [ 3:0]    m_axi_mbus_awqos,
    output  wire  [ 2:0]    m_axi_mbus_awprot,
    output  wire            m_axi_mbus_wvalid,
    input   wire            m_axi_mbus_wready,
    output  wire  [31:0]    m_axi_mbus_wdata,
    output  wire  [ 3:0]    m_axi_mbus_wstrb,
    output  wire            m_axi_mbus_wlast,
    input   wire            m_axi_mbus_bvalid,
    output  wire            m_axi_mbus_bready,
    input   wire  [3:0]     m_axi_mbus_bid,
    input   wire  [1:0]     m_axi_mbus_bresp,
    output  wire            m_axi_mbus_arvalid,
    input   wire            m_axi_mbus_arready,
    output  wire  [31:0]    m_axi_mbus_araddr,
    output  wire  [ 3:0]    m_axi_mbus_arid,
    output  wire  [ 7:0]    m_axi_mbus_arlen,
    output  wire  [ 2:0]    m_axi_mbus_arsize,
    output  wire  [ 1:0]    m_axi_mbus_arburst,
    output  wire  [ 0:0]    m_axi_mbus_arlock,
    output  wire  [ 3:0]    m_axi_mbus_arcache,
    output  wire  [ 3:0]    m_axi_mbus_arqos,
    output  wire  [ 2:0]    m_axi_mbus_arprot,
    input   wire            m_axi_mbus_rvalid,
    output  wire            m_axi_mbus_rready,
    input   wire  [31:0]    m_axi_mbus_rdata,
    input   wire  [ 3:0]    m_axi_mbus_rid,
    input   wire  [ 1:0]    m_axi_mbus_rresp,
    input   wire            m_axi_mbus_rlast,
    output  wire            m_axi_acc_awvalid,
    input   wire            m_axi_acc_awready,
    output  wire  [31:0]    m_axi_acc_awaddr,
    output  wire  [ 2:0]    m_axi_acc_awprot,
    output  wire            m_axi_acc_wvalid,
    input   wire            m_axi_acc_wready,
    output  wire  [31:0]    m_axi_acc_wdata,
    output  wire  [ 3:0]    m_axi_acc_wstrb,
    input   wire            m_axi_acc_bvalid,
    output  wire            m_axi_acc_bready,
    input   wire  [ 1:0]    m_axi_acc_bresp,
    output  wire            m_axi_acc_arvalid,
    input   wire            m_axi_acc_arready,
    output  wire  [31:0]    m_axi_acc_araddr,
    output  wire  [ 2:0]    m_axi_acc_arprot,
    input   wire            m_axi_acc_rvalid,
    output  wire            m_axi_acc_rready,
    input   wire  [31:0]    m_axi_acc_rdata,
    input   wire  [ 1:0]    m_axi_acc_rresp,
    input   wire  [ 2:0]    irq,
    input   wire            uart_rxd,
    output  wire            uart_txd,
    input   wire  [31:0]    gpio_io_i,
    output  wire  [31:0]    gpio_io_o,
    output  wire  [31:0]    gpio_io_t,
    input   wire            spi_miso,
    output  wire            spi_mosi,
    output  wire  [31:0]    spi_csn,
    output  wire            spi_sclk,
    output  wire            debug_rst
  );

  //irq
  wire           uart_irq;
  wire           spi_irq;
  wire           gpio_irq;

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

  system_ps_axi_perf_wrapper  #(
    .CLK_FREQ_MHZ(CLK_FREQ_MHZ)
  ) inst_system_ps_axi_perf_wrapper (
    .aclk(aclk),
    .arstn(arstn),
    .s_axi_perf_AWVALID(s_axi_perf_AWVALID),
    .s_axi_perf_AWREADY(s_axi_perf_AWREADY),
    .s_axi_perf_AWADDR(s_axi_perf_AWADDR),
    .s_axi_perf_AWPROT(s_axi_perf_AWPROT),
    .s_axi_perf_WVALID(s_axi_perf_WVALID),
    .s_axi_perf_WREADY(s_axi_perf_WREADY),
    .s_axi_perf_WDATA(s_axi_perf_WDATA),
    .s_axi_perf_WSTRB(s_axi_perf_WSTRB),
    .s_axi_perf_BVALID(s_axi_perf_BVALID),
    .s_axi_perf_BREADY(s_axi_perf_BREADY),
    .s_axi_perf_BRESP(s_axi_perf_BRESP),
    .s_axi_perf_ARVALID(s_axi_perf_ARVALID),
    .s_axi_perf_ARREADY(s_axi_perf_ARREADY),
    .s_axi_perf_ARADDR(s_axi_perf_ARADDR),
    .s_axi_perf_ARPROT(s_axi_perf_ARPROT),
    .s_axi_perf_RVALID(s_axi_perf_RVALID),
    .s_axi_perf_RREADY(s_axi_perf_RREADY),
    .s_axi_perf_RDATA(s_axi_perf_RDATA),
    .s_axi_perf_RRESP(s_axi_perf_RRESP),
    .uart_rxd(uart_rxd),
    .uart_txd(uart_txd),
    .gpio_io_i(gpio_io_i),
    .gpio_io_o(gpio_io_o),
    .gpio_io_t(gpio_io_t),
    .spi_miso(spi_miso),
    .spi_mosi(spi_mosi),
    .spi_csn(spi_csn),
    .spi_sclk(spi_sclk),
    .uart_irq(uart_irq),
    .gpio_irq(gpio_irq),
    .spi_irq(spi_irq)
  );
  
  // Module: inst_veronica
  //
  // Veronica AXI Vexriscv CPU
  Veronica inst_veronica
  (
    .io_jtag_tms(tms),
    .io_jtag_tdi(tdi),
    .io_jtag_tdo(tdo),
    .io_jtag_tck(tck),
    .io_aclk(aclk),
    .io_arst(arst),
    .io_debug_rst(debug_rst),
    .io_ddr_clk(ddr_clk),
    .io_ddr_rst(ddr_rst),
    .io_irq({{128-7{1'b0}}, gpio_irq, spi_irq, uart_irq, irq, 1'b0}),
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
    .m_axi_acc_araddr(m_axi_acc_araddr),
    .m_axi_acc_arprot(m_axi_acc_arprot),
    .m_axi_acc_arready(m_axi_acc_arready),
    .m_axi_acc_arvalid(m_axi_acc_arvalid),
    .m_axi_acc_awaddr(m_axi_acc_awaddr),
    .m_axi_acc_awprot(m_axi_acc_awprot),
    .m_axi_acc_awready(m_axi_acc_awready),
    .m_axi_acc_awvalid(m_axi_acc_awvalid),
    .m_axi_acc_bready(m_axi_acc_bready),
    .m_axi_acc_bresp(m_axi_acc_bresp),
    .m_axi_acc_bvalid(m_axi_acc_bvalid),
    .m_axi_acc_rdata(m_axi_acc_rdata),
    .m_axi_acc_rready(m_axi_acc_rready),
    .m_axi_acc_rresp(m_axi_acc_rresp),
    .m_axi_acc_rvalid(m_axi_acc_rvalid),
    .m_axi_acc_wdata(m_axi_acc_wdata),
    .m_axi_acc_wready(m_axi_acc_wready),
    .m_axi_acc_wstrb(m_axi_acc_wstrb),
    .m_axi_acc_wvalid(m_axi_acc_wvalid),
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

endmodule
