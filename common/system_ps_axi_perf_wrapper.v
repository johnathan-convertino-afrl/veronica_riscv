//******************************************************************************
//  file:     system_ps_axi_perf_wrapper.v
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
module system_ps_axi_perf_wrapper #(
    parameter  CLK_FREQ_MHZ = 100
  )
  (
    input   wire            aclk,
    input   wire            arstn,
    input   wire            s_axi_perf_AWVALID,
    output  wire            s_axi_perf_AWREADY,
    input   wire  [31:0]    s_axi_perf_AWADDR,
    input   wire  [ 2:0]    s_axi_perf_AWPROT,
    input   wire            s_axi_perf_WVALID,
    output  wire            s_axi_perf_WREADY,
    input   wire  [31:0]    s_axi_perf_WDATA,
    input   wire  [ 3:0]    s_axi_perf_WSTRB,
    output  wire            s_axi_perf_BVALID,
    input   wire            s_axi_perf_BREADY,
    output  wire  [ 1:0]    s_axi_perf_BRESP,
    input   wire            s_axi_perf_ARVALID,
    output  wire            s_axi_perf_ARREADY,
    input   wire  [31:0]    s_axi_perf_ARADDR,
    input   wire  [ 2:0]    s_axi_perf_ARPROT,
    output  wire            s_axi_perf_RVALID,
    input   wire            s_axi_perf_RREADY,
    output  wire  [31:0]    s_axi_perf_RDATA,
    output  wire  [ 1:0]    s_axi_perf_RRESP,
    input   wire            uart_rxd,
    output  wire            uart_txd,
    input   wire  [31:0]    gpio_io_i,
    output  wire  [31:0]    gpio_io_o,
    output  wire  [31:0]    gpio_io_t,
    input   wire            spi_miso,
    output  wire            spi_mosi,
    output  wire  [31:0]    spi_csn,
    output  wire            spi_sclk,
    output  wire            uart_irq,
    output  wire            gpio_irq,
    output  wire            spi_irq
  );

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


  // Module: inst_axi_gpio32
  //
  // AXI GPIO
  axi_lite_gpio #(
    .ADDRESS_WIDTH(32),
    .BUS_WIDTH(4),
    .GPIO_WIDTH(32),
    .IRQ_ENABLE(0)
  ) inst_axi_gpio32 (
    .aclk(aclk),
    .arstn(arstn),
    .s_axi_awvalid(m_axi_gpio_AWVALID),
    .s_axi_awaddr(m_axi_gpio_AWADDR),
    .s_axi_awprot(m_axi_gpio_AWPROT),
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
    .s_axi_arprot(m_axi_gpio_ARPROT),
    .s_axi_arready(m_axi_gpio_ARREADY),
    .s_axi_rvalid(m_axi_gpio_RVALID),
    .s_axi_rdata(m_axi_gpio_RDATA),
    .s_axi_rresp(m_axi_gpio_RRESP),
    .s_axi_rready(m_axi_gpio_RREADY),
    .irq(gpio_irq),
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
    .CLOCK_SPEED(CLK_FREQ_MHZ*1000000),
    .SELECT_WIDTH(32),
    .DEFAULT_RATE_DIV(0),
    .DEFAULT_CPOL(0),
    .DEFAULT_CPHA(0)
  ) inst_axi_spi (
    .aclk(aclk),
    .arstn(arstn),
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
    .irq(spi_irq),
    .sclk(spi_sclk),
    .mosi(spi_mosi),
    .miso(spi_miso),
    .ss_n(spi_csn)
  );
  
  // Module: inst_axi_uart
  //
  // AXI uart LITE 
  axi_lite_uart_lite #(
    .ADDRESS_WIDTH(32),
    .BUS_WIDTH(4),
    .CLOCK_SPEED(CLK_FREQ_MHZ*1000000),
    .BAUD_RATE(115200),
    .PARITY_TYPE(0),
    .STOP_BITS(1),
    .DATA_BITS(8),
    .RX_BAUD_DELAY(0),
    .TX_BAUD_DELAY(0)
  ) inst_axi_uart_lite (
    .aclk(aclk),
    .arstn(arstn),
    .s_axi_awvalid(m_axi_uart_AWVALID),
    .s_axi_awaddr(m_axi_uart_AWADDR),
    .s_axi_awprot(m_axi_uart_AWPROT),
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
    .s_axi_arprot(m_axi_uart_ARPROT),
    .s_axi_arready(m_axi_uart_ARREADY),
    .s_axi_rvalid(m_axi_uart_RVALID),
    .s_axi_rdata(m_axi_uart_RDATA),
    .s_axi_rresp(m_axi_uart_RRESP),
    .s_axi_rready(m_axi_uart_RREADY),
    .irq(uart_irq),
    .tx(uart_txd),
    .rx(uart_rxd)
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
    .S_AXI_ACLK     (aclk),
    .S_AXI_ARESETN  (arstn),
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

endmodule
