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
module system_wrapper
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

  // wire          sys_clk;
  // wire          reset;

  wire [31:0] s_spi_csn;
  
  assign sd_spi_csn = s_spi_csn[0];

  assign sd_reset = 1'b1;
  
  assign ftdi_cts = ftdi_rts;

  // Module: inst_system_ps_wrapper
  //
  // Wraps all of the RISCV CPU core and its devices.
  system_ps_wrapper inst_system_ps_wrapper (
`ifdef _JTAG_IO
    .tck(tck),
    .tms(tms),
    .tdi(tdi),
    .tdo(tdo),
`endif
    .DDR_addr(ddr2_addr),
    .DDR_ba(ddr2_ba),
    .DDR_cas_n(ddr2_cas_n),
    .DDR_ck_n(ddr2_ck_n),
    .DDR_ck_p(ddr2_ck_p),
    .DDR_cke(ddr2_cke),
    .DDR_cs_n(ddr2_cs_n),
    .DDR_dm(ddr2_dm),
    .DDR_dq(ddr2_dq),
    .DDR_dqs_n(ddr2_dqs_n),
    .DDR_dqs_p(ddr2_dqs_p),
    .DDR_odt(ddr2_odt),
    .DDR_ras_n(ddr2_ras_n),
    .DDR_we_n(ddr2_we_n),
    .IRQ(3'b000),
    .M_AXI_araddr(),
    .M_AXI_arprot(),
    .M_AXI_arready(1'b1),
    .M_AXI_arvalid(),
    .M_AXI_awaddr(),
    .M_AXI_awprot(),
    .M_AXI_awready(1'b1),
    .M_AXI_awvalid(),
    .M_AXI_bready(),
    .M_AXI_bresp(3'b000),
    .M_AXI_bvalid(2'b00),
    .M_AXI_rdata(32'h00000000),
    .M_AXI_rready(),
    .M_AXI_rresp(3'b000),
    .M_AXI_rvalid(1'b00),
    .M_AXI_wdata(),
    .M_AXI_wready(1'b1),
    .M_AXI_wstrb(),
    .M_AXI_wvalid(),
    .UART_rxd(ftdi_tx),
    .UART_txd(ftdi_rx),
    .gpio_io_i(slide_switches),
    .gpio_io_o(leds),
    .gpio_io_t(),
    .s_axi_clk(),
    .spi_miso(sd_spi_miso),
    .spi_mosi(sd_spi_mosi),
    .spi_csn(s_spi_csn),
    .spi_sclk(sd_spi_sclk),
    .sys_clk(clk),
    .sys_rstn(resetn)
  );

endmodule
