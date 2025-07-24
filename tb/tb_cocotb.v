//******************************************************************************
// file:    tb_cocotb.v
//
// author:  JAY CONVERTINO
//
// date:    2025/07/06
//
// about:   Brief
// Test bench wrapper for cocotb
//
// license: License MIT
// Copyright 2025 Jay Convertino
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.
//
//******************************************************************************

`timescale 1 ns/1 ps

/*
 * Module: tb_cocotb
 *
 * Parameters:
 *
 *   CLOCK_SPEED    - This is the clk frequency in Hz
 *
 * Ports:
 *
 *   clk            - Clock CPU/AXIS
 *   resetn         - Negative reset
 *   reset          - Positive reset
 *   ddr_clk        - Clock DDR
 *   ddr_rst        - Reset DDR
 *   uart_rx        - UART Receive input
 *   uart_tx        - UART Transmit output
 *   debug_rst      - debug reset output, active high.
 *   gpio_i         - GPIO input data
 *   gpio_o         - GPIO output data
 */
module tb_cocotb #(
    parameter CLOCK_SPEED = 50000000
  ) (
    input   wire          clk,
    input   wire          resetn,
    input   wire          reset,
    input   wire          ddr_clk,
    input   wire          ddr_rst,
    input   wire          uart_rx,
    output  wire          uart_tx,
    output  wire          debug_rst,
    input   wire [ 7:0]   gpio_i,
    output  wire [ 7:0]   gpio_o
  );
  
  wire tb_tms;
  wire tb_tck;
  wire tb_tdi;
  wire tb_tdo;
  
  jtag_vpi #(
    .DEBUG_INFO(0),
    .TP(1),
    .TCK_HALF_PERIOD(50), // Clock half period (Clock period = 100 ns => 10 MHz)
    .CMD_DELAY(1000)
  ) inst_jtag_vpi (
    .tms(tb_tms),
    .tck(tb_tck),
    .tdi(tb_tdi),
    .tdo(tb_tdo),
    .enable(resetn),
    .init_done(resetn)
  );

  // Module: inst_system_ps_wrapper
  //
  // Wraps all of the RISCV CPU core and its devices.
  system_ps_wrapper_jtag inst_system_ps_wrapper_jtag (
    .tck(tb_tck),
    .tms(tb_tms),
    .tdi(tb_tdi),
    .tdo(tb_tdo),
    .aclk(clk),
    .arstn(resetn),
    .arst(reset),
    .ddr_clk(ddr_clk),
    .ddr_rst(ddr_reset),
    .m_axi_mbus_araddr(),
    .m_axi_mbus_arburst(),
    .m_axi_mbus_arcache(),
    .m_axi_mbus_arid(),
    .m_axi_mbus_arlen(),
    .m_axi_mbus_arprot(),
    .m_axi_mbus_arready(1'b1),
    .m_axi_mbus_arsize(),
    .m_axi_mbus_arvalid(),
    .m_axi_mbus_awaddr(),
    .m_axi_mbus_awburst(),
    .m_axi_mbus_awcache(),
    .m_axi_mbus_awid(),
    .m_axi_mbus_awlen(),
    .m_axi_mbus_awprot(),
    .m_axi_mbus_awready(1'b1),
    .m_axi_mbus_awsize(),
    .m_axi_mbus_awvalid(),
    .m_axi_mbus_bid(4'b0000),
    .m_axi_mbus_bready(),
    .m_axi_mbus_bvalid(1'b0),
    .m_axi_mbus_rdata(32'h00000000),
    .m_axi_mbus_rid(4'b0000),
    .m_axi_mbus_rlast(1'b0),
    .m_axi_mbus_rready(),
    .m_axi_mbus_rvalid(1'b0),
    .m_axi_mbus_wdata(),
    .m_axi_mbus_wlast(),
    .m_axi_mbus_wready(1'b1),
    .m_axi_mbus_wstrb(),
    .m_axi_mbus_wvalid(),
    .m_axi_mbus_arqos(),
    .m_axi_mbus_arlock(),
    .m_axi_mbus_awqos(),
    .m_axi_mbus_awlock(),
    .m_axi_mbus_rresp(2'b00),
    .m_axi_mbus_bresp(2'b00),
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
    .m_axi_acc_rvalid(1'b0),
    .m_axi_acc_wdata(),
    .m_axi_acc_wready(1'b1),
    .m_axi_acc_wstrb(),
    .m_axi_acc_wvalid(),
    .irq(3'b000),
    .uart_rxd(uart_rx),
    .uart_txd(uart_tx),
    .gpio_io_i(gpio_i),
    .gpio_io_o(gpio_o),
    .gpio_io_t(),
    .spi_miso(1'b1),
    .spi_mosi(),
    .spi_csn(),
    .spi_sclk(),
    .debug_rst(debug_rst)
  );

endmodule

