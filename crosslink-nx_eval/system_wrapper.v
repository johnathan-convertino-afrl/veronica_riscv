//******************************************************************************
//  file:     system_wrapper.v
//
//  author:   JAY CONVERTINO
//
//  date:     2025/06/14
//
//  about:    Brief
//  System wrapper for ps (INCOMPLETE, CURRENTLY HAS NO EXTENDED RAM.. DO NOT USE FOR LINUX).
//
//  license: License MIT
//  Copyright 2025 Jay Convertino
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
 * System wrapper for (INCOMPLETE, CURRENTLY HAS NO EXTENDED RAM).
 *
 */
module system_wrapper
  (
    // clock and reset
    input  wire         clk,
    input  wire         resetn,
    // leds
    output wire [ 7:0]  leds,
    // slide switches
    input  wire [ 7:0]  slide_switches,
    // uart
    input  wire         ftdi_tx,
    output wire         ftdi_rx,
    // jtag
    input  wire         tck,
    input  wire         tms,
    input  wire         tdi,
    output wire         tdo,
    //spi
    output wire         spi_sclk,
    output wire         spi_mosi,
    input  wire         spi_miso,
    output wire         spi_csn
  );
  
  wire  [31:0] s_spi_csn;
  
  wire osc_clk;
  wire sys_clk;
  wire debug_rst;
  
  reg [ 7:0] r_rst_counter;
  reg r_peripheral_areset;
  reg r_peripheral_aresetn;
  reg r_ddr_peripheral_reset;
  
  assign spi_csn = s_spi_csn[0];
  
  //225.0 MHz
  clk_osc_1 inst_clk_osc_1 (
    .hf_out_en_i(1'b1),
    .hf_clk_out_o(osc_clk)
  );

  //50 MHz
  clk_wiz_1 inst_clk_wiz_1 (
    .clkop_o(sys_clk),
    .rstn_i(resetn),
    .clki_i(osc_clk)
  );
  
  // Module: inst_system_ps_wrapper
  //
  // Wraps all of the RISCV CPU core and its devices.
  system_ps_wrapper_jtag inst_system_ps_wrapper_jtag (
    .tck(tck),
    .tms(tms),
    .tdi(tdi),
    .tdo(tdo),
    .aclk(sys_clk),
    .arstn(r_peripheral_aresetn),
    .arst(r_peripheral_areset),
    .ddr_clk(sys_clk),
    .ddr_rst(r_ddr_peripheral_reset),
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
    .m_axi_acc_rvalid(1'b00),
    .m_axi_acc_wdata(),
    .m_axi_acc_wready(1'b1),
    .m_axi_acc_wstrb(),
    .m_axi_acc_wvalid(),
    .irq(3'b000),
    .uart_rxd(ftdi_tx),
    .uart_txd(ftdi_rx),
    .gpio_io_i(gpio_write),
    .gpio_io_o(gpio_read),
    .gpio_io_t(),
    .spi_miso(spi_miso),
    .spi_mosi(spi_mosi),
    .spi_csn(s_spi_csn),
    .spi_sclk(spi_sclk),
    .debug_rst(debug_rst)
  );
  
  //reset sync
  always @(posedge sys_clk or negedge resetn)
  begin
    if(resetn == 1'b0)
    begin
      r_rst_counter           <= 0;
      
      r_ddr_peripheral_reset  <= 1'b1;
      r_peripheral_areset     <= 1'b1;
      r_peripheral_aresetn    <= 1'b0;
    end else begin
      r_ddr_peripheral_reset  <= r_ddr_peripheral_reset;
      r_peripheral_areset     <= r_peripheral_areset;
      r_peripheral_aresetn    <= r_peripheral_aresetn;
      
      r_rst_counter <= r_rst_counter + 1;
      
      if(r_rst_counter == 8'hFF)
      begin
        r_rst_counter <= r_rst_counter;
        
        r_ddr_peripheral_reset <= 1'b0;
        r_peripheral_areset    <= 1'b0;
        r_peripheral_aresetn   <= 1'b1;
      end
      
      if(debug_rst == 1'b1)
      begin
        r_rst_counter <= 0;
        
        r_ddr_peripheral_reset <= 1'b1;
        r_peripheral_areset    <= 1'b1;
        r_peripheral_aresetn   <= 1'b0;
      end
    end
  end

endmodule
