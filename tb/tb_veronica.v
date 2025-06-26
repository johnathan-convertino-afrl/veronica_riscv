//******************************************************************************
/// @file    tb_veronica.v
/// @author  JAY CONVERTINO
/// @date    2022.10.24
/// @brief   run veronica in typical HDL simulation.
///
/// @LICENSE MIT
///  Copyright 2022 Jay Convertino
///
///  Permission is hereby granted, free of charge, to any person obtaining a copy
///  of this software and associated documentation files (the "Software"), to 
///  deal in the Software without restriction, including without limitation the
///  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or 
///  sell copies of the Software, and to permit persons to whom the Software is 
///  furnished to do so, subject to the following conditions:
///
///  The above copyright notice and this permission notice shall be included in 
///  all copies or substantial portions of the Software.
///
///  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
///  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
///  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
///  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
///  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
///  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
///  IN THE SOFTWARE.
//******************************************************************************

`timescale 1 ns/10 ps

module tb_veronica ();
  
  wire  tb_dut_clk;
  wire  tb_dut_rstn;

  wire  tb_tms;
  wire  tb_tck;
  wire  tb_tdi;
  wire  tb_tdo;
  
  wire  rx;
  wire  tx;
  
  wire  [31:0] s_spi_csn;
  
  wire debug_rst;
  
  reg  [ 7:0] s_axis_tdata;
  wire [ 7:0] m_axis_tdata;
  
  reg  s_axis_tvalid;
  wire m_axis_tvalid;
  
  wire s_axis_tready;
  reg  m_axis_tready;
  
  reg [ 7:0] r_rst_counter;
  reg r_peripheral_areset;
  reg r_peripheral_aresetn;
  reg r_ddr_peripheral_reset;

  wire [31:0] gpio_o;

  reg [31:0] gpio_i;
  reg [31:0] prev_gpio_o;

  integer return_value0 = 0;
  
  integer return_value1 = 0;
  
  // fst dump command
  initial begin
    $dumpfile ("tb_veronica.fst");
    $dumpvars (0, tb_veronica);

    $setup_tcp_server("127.0.0.1", 4422);
    #1;
    $setup_tcp_server("127.0.0.1", 4411);
    #1;
  end
  
  clk_stimulus #(
    .CLOCKS(1), // # of clocks
    .CLOCK_BASE(100000000), // clock time base mhz
    .CLOCK_INC(10), // clock time diff mhz
    .RESETS(1), // # of resets
    .RESET_BASE(20), // time to stay in reset
    .RESET_INC(100) // time diff for other resets
  ) clk_stim (
    //clk out ... maybe a vector of clks with diff speeds.
    .clkv(tb_dut_clk),
    //rstn out ... maybe a vector of rsts with different off times
    .rstnv(tb_dut_rstn),
    .rstv()
  );

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
    .enable(tb_dut_rstn),
    .init_done(tb_dut_rstn)
  );
  
  /*
   * Module: inst_fast_axis_uart
   *
   * Device under test, fast_axis_uart
   */
  fast_axis_uart #(
    .CLOCK_SPEED(100000000),
    .BAUD_RATE(115200),
    .PARITY_TYPE(0),
    .STOP_BITS(1),
    .DATA_BITS(8),
    .RX_BAUD_DELAY(0),
    .TX_BAUD_DELAY(0)
  ) inst_fast_axis_uart (
    .aclk(tb_dut_clk),
    .arstn(r_peripheral_aresetn),
    .parity_err(),
    .frame_err(),
    .s_axis_tdata(s_axis_tdata),
    .s_axis_tvalid(s_axis_tvalid),
    .s_axis_tready(s_axis_tready),
    .m_axis_tdata(m_axis_tdata),
    .m_axis_tvalid(m_axis_tvalid),
    .m_axis_tready(m_axis_tready),
    .tx(tx),
    .rx(rx)
  );

  // Module: inst_system_ps_wrapper
  //
  // Wraps all of the RISCV CPU core and its devices.
  system_ps_wrapper_jtag inst_system_ps_wrapper_jtag (
    .tck(tb_tck),
    .tms(tb_tms),
    .tdi(tb_tdi),
    .tdo(tb_tdo),
    .aclk(tb_dut_clk),
    .arstn(r_peripheral_aresetn),
    .arst(r_peripheral_areset),
    .ddr_clk(tb_dut_clk),
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
    .m_axi_acc_rvalid(1'b0),
    .m_axi_acc_wdata(),
    .m_axi_acc_wready(1'b1),
    .m_axi_acc_wstrb(),
    .m_axi_acc_wvalid(),
    .irq(3'b000),
    .uart_rxd(tx),
    .uart_txd(rx),
    .gpio_io_i(gpio_i),
    .gpio_io_o(gpio_o),
    .gpio_io_t(),
    .spi_miso(1'b1),
    .spi_mosi(),
    .spi_csn(),
    .spi_sclk(),
    .debug_rst(debug_rst)
  );
  
  //reset sync
  always @(posedge tb_dut_clk or negedge tb_dut_rstn)
  begin
    if(tb_dut_rstn == 1'b0)
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

  always @(posedge tb_dut_clk)
  begin
    if(tb_dut_rstn == 1'b0)
    begin
      prev_gpio_o = 0;
      gpio_i = 0;
    end else begin
      if(gpio_o != prev_gpio_o)
      begin
        return_value0 = $send_tcp_server(4422, gpio_o);
      end

      return_value0 = $recv_tcp_server(4422, gpio_i);

      prev_gpio_o = gpio_o;
    end
  end
  
  always @(posedge tb_dut_clk)
  begin
    if(tb_dut_rstn == 1'b0)
    begin
      s_axis_tdata  = 0;
      s_axis_tvalid = 1'b0;
      
    end else begin
      m_axis_tready <= 1'b0;
      
      s_axis_tvalid <= 1'b0;
      
      if(m_axis_tvalid == 1'b1)
      begin
        return_value1 = $send_tcp_server(4411, m_axis_tdata);
        
        m_axis_tready <= 1'b1;
      end

      if(s_axis_tready == 1'b1)
      begin
        return_value1 = $recv_tcp_server(4411, s_axis_tdata);
        
        if(return_value1 != 0)
        begin
          s_axis_tvalid <= 1'b1;
        end
      end
    end
  end

endmodule

