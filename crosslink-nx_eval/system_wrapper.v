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
  
  reg [ 3:0] r_leds           = 0;
  reg [ 7:0] r_rst_counter    = 8'hFF;
  reg r_peripheral_areset     = 1'b1;
  reg r_peripheral_aresetn    = 1'b0;
  reg r_ddr_peripheral_areset = 1'b1;
  
  assign spi_csn = s_spi_csn[0];
  
  assign leds[0] = r_ddr_peripheral_areset;
  assign leds[1] = r_peripheral_areset;
  assign leds[2] = r_peripheral_aresetn;
  assign leds[6:3] = r_leds;
  assign leds[7] = resetn;
  
  //225.0 MHz
  clk_osc_1 inst_clk_osc_1 (
    .hf_out_en_i(1'b1),
    .hf_clk_out_o(osc_clk)
  );

  //50 MHz out from 225 in
  clk_wiz_1 inst_clk_wiz_1 (
    .clkop_o(sys_clk),
    .clki_i(osc_clk)
  );
  
  // Module: inst_system_ps_wrapper
  //
  // Wraps all of the RISCV CPU core and its devices.
  system_ps_wrapper_jtag #(
    .ACLK_FREQ_MHZ(50)
  ) inst_system_ps_wrapper_jtag (
    .tck(tck),
    .tms(tms),
    .tdi(tdi),
    .tdo(tdo),
    .cpu_clk(sys_clk),
    .cpu_rst(r_peripheral_areset),
    .aclk(sys_clk),
    .arstn(r_peripheral_aresetn),
    .arst(r_peripheral_areset),
    .usb_phy_clk(1'b0),
    .usb_phy_rst(sys_rstgen_peripheral_areset),
    .ddr_clk(sys_clk),
    .ddr_rst(r_ddr_peripheral_areset),
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
    .s_axi_dma0_awvalid(1'b0),
    .s_axi_dma0_awready(),
    .s_axi_dma0_awaddr(32'h00000000),
    .s_axi_dma0_awid(2'b00),
    .s_axi_dma0_awlen(8'h00),
    .s_axi_dma0_awsize(3'b000),
    .s_axi_dma0_awburst(2'b00),
    .s_axi_dma0_awlock(1'b0),
    .s_axi_dma0_awcache(4'b000),
    .s_axi_dma0_awqos(4'b0000),
    .s_axi_dma0_awprot(3'b00),
    .s_axi_dma0_wvalid(1'b0),
    .s_axi_dma0_wready(),
    .s_axi_dma0_wdata(32'h00000000),
    .s_axi_dma0_wstrb(4'b0000),
    .s_axi_dma0_wlast(1'b0),
    .s_axi_dma0_bvalid(),
    .s_axi_dma0_bready(1'b1),
    .s_axi_dma0_bid(),
    .s_axi_dma0_bresp(),
    .s_axi_dma0_arvalid(1'b0),
    .s_axi_dma0_arready(),
    .s_axi_dma0_araddr(32'h00000000),
    .s_axi_dma0_arid(2'b00),
    .s_axi_dma0_arlen(8'h00),
    .s_axi_dma0_arsize(3'b000),
    .s_axi_dma0_arburst(2'b00),
    .s_axi_dma0_arlock(1'b0),
    .s_axi_dma0_arcache(4'b000),
    .s_axi_dma0_arqos(4'b0000),
    .s_axi_dma0_arprot(3'b000),
    .s_axi_dma0_rvalid(),
    .s_axi_dma0_rready(1'b1),
    .s_axi_dma0_rdata(),
    .s_axi_dma0_rid(),
    .s_axi_dma0_rresp(),
    .s_axi_dma0_rlast(),
    .irq(3'b000),
    .uart_rxd(ftdi_tx),
    .uart_txd(ftdi_rx),
    .gpio_io_i(0),
    .gpio_io_o(),
    .gpio_io_t(),
    .spi_miso(spi_miso),
    .spi_mosi(spi_mosi),
    .spi_csn(s_spi_csn),
    .spi_sclk(spi_sclk),
    .usb_dp_read(1'b1),
    .usb_dp_write(),
    .usb_dp_writeEnable(),
    .usb_dm_read(1'b0),
    .usb_dm_write(),
    .usb_dm_writeEnable(),
    .debug_rst(debug_rst)
  );
  
  //reset sync
  always @(posedge sys_clk or negedge resetn or posedge debug_rst)
  begin
    if(resetn == 1'b0 || debug_rst == 1'b1)
    begin
      r_rst_counter           <= 8'hFF;
      
      r_leds                  <= 0;
      
      r_ddr_peripheral_areset  <= 1'b1;
      r_peripheral_areset      <= 1'b1;
      r_peripheral_aresetn     <= 1'b0;
    end else begin
      r_ddr_peripheral_areset  <= r_ddr_peripheral_areset;
      r_peripheral_areset      <= r_peripheral_areset;
      r_peripheral_aresetn     <= r_peripheral_aresetn;
      
      r_rst_counter <= r_rst_counter - 1;
      
      if(r_rst_counter == 0)
      begin
        r_leds <= 4'b1111;
      
        r_rst_counter <= r_rst_counter;
        
        r_ddr_peripheral_areset <= 1'b0;
        r_peripheral_areset     <= 1'b0;
        r_peripheral_aresetn    <= 1'b1;
      end
    end
  end

endmodule
