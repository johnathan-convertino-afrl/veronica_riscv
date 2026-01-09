//******************************************************************************
//  file:     system_pl_axi_acc_wrapper.v
//
//  author:   JAY CONVERTINO
//
//  date:     2026/1/05
//
//  about:    Brief
//  System wrapper for pl.
//
//  license: License MIT
//  Copyright 2026 Jay Convertino
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
 */
module system_pl_axi_acc_wrapper
  (
    input   wire            aclk,
    input   wire            arstn,
    input   wire            s_axi_acc_AWVALID,
    output  wire            s_axi_acc_AWREADY,
    input   wire  [31:0]    s_axi_acc_AWADDR,
    input   wire  [ 2:0]    s_axi_acc_AWPROT,
    input   wire            s_axi_acc_WVALID,
    output  wire            s_axi_acc_WREADY,
    input   wire  [31:0]    s_axi_acc_WDATA,
    input   wire  [ 3:0]    s_axi_acc_WSTRB,
    output  wire            s_axi_acc_BVALID,
    input   wire            s_axi_acc_BREADY,
    output  wire  [ 1:0]    s_axi_acc_BRESP,
    input   wire            s_axi_acc_ARVALID,
    output  wire            s_axi_acc_ARREADY,
    input   wire  [31:0]    s_axi_acc_ARADDR,
    input   wire  [ 2:0]    s_axi_acc_ARPROT,
    output  wire            s_axi_acc_RVALID,
    input   wire            s_axi_acc_RREADY,
    output  wire  [31:0]    s_axi_acc_RDATA,
    output  wire  [ 1:0]    s_axi_acc_RRESP,
    output  wire            vga_hsync,
    output  wire            vga_vsync,
    output  wire  [ 3:0]    vga_r,
    output  wire  [ 3:0]    vga_g,
    output  wire  [ 3:0]    vga_b,
    input   wire            vga_clk,
    output  wire            axi_vga_irq,
    input   wire            ddr_aclk,
    input   wire            ddr_arstn,
    output  wire  [31:0]    s_axi_dma_vga_araddr,
    output  wire  [ 3:0]    s_axi_dma_vga_arcache,
    output  wire  [ 7:0]    s_axi_dma_vga_arlen,
    output  wire  [ 2:0]    s_axi_dma_vga_arprot,
    input   wire            s_axi_dma_vga_arready,
    output  wire  [ 2:0]    s_axi_dma_vga_arsize,
    output  wire            s_axi_dma_vga_arvalid,
    output  wire  [ 1:0]    s_axi_dma_vga_arburst,
    output  wire  [31:0]    s_axi_dma_vga_awaddr,
    output  wire  [ 3:0]    s_axi_dma_vga_awcache,
    output  wire  [ 7:0]    s_axi_dma_vga_awlen,
    output  wire  [ 2:0]    s_axi_dma_vga_awprot,
    input   wire            s_axi_dma_vga_awready,
    output  wire  [ 2:0]    s_axi_dma_vga_awsize,
    output  wire            s_axi_dma_vga_awvalid,
    output  wire  [ 1:0]    s_axi_dma_vga_awburst,
    output  wire            s_axi_dma_vga_bready,
    input   wire            s_axi_dma_vga_bvalid,
    input   wire  [ 1:0]    s_axi_dma_vga_bresp,
    input   wire  [31:0]    s_axi_dma_vga_rdata,
    input   wire            s_axi_dma_vga_rlast,
    output  wire            s_axi_dma_vga_rready,
    input   wire            s_axi_dma_vga_rvalid,
    input   wire  [ 1:0]    s_axi_dma_vga_rresp,
    output  wire  [31:0]    s_axi_dma_vga_wdata,
    output  wire            s_axi_dma_vga_wlast,
    input   wire            s_axi_dma_vga_wready,
    output  wire  [ 3:0]    s_axi_dma_vga_wstrb,
    output  wire            s_axi_dma_vga_wvalid,
    output  wire            eth_mdc,
    inout   wire            eth_mdio,
    input   wire            eth_rstn,
    input   wire            eth_crsdv,
    input   wire            eth_rxerr,
    input   wire  [1:0]     eth_rxd,
    output  wire            eth_txen,
    output  wire  [1:0]     eth_txd,
    input   wire            eth_50mclk,
    output  wire            axi_eth_irq
  );
  
  //axi lite tft vga controller
  wire [31:0]    m_axi_vga_ARADDR;
  wire           m_axi_vga_ARREADY;
  wire           m_axi_vga_ARVALID;
  wire [31:0]    m_axi_vga_AWADDR;
  wire           m_axi_vga_AWREADY;
  wire           m_axi_vga_AWVALID;
  wire           m_axi_vga_BREADY;
  wire [ 1:0]    m_axi_vga_BRESP;
  wire           m_axi_vga_BVALID;
  wire [31:0]    m_axi_vga_RDATA;
  wire           m_axi_vga_RREADY;
  wire [ 1:0]    m_axi_vga_RRESP;
  wire           m_axi_vga_RVALID;
  wire [31:0]    m_axi_vga_WDATA;
  wire           m_axi_vga_WREADY;
  wire [ 3:0]    m_axi_vga_WSTRB;
  wire           m_axi_vga_WVALID;
  
  //axi lite ethernet
  wire [31:0]    m_axi_eth_ARADDR;
  wire           m_axi_eth_ARREADY;
  wire           m_axi_eth_ARVALID;
  wire [31:0]    m_axi_eth_AWADDR;
  wire           m_axi_eth_AWREADY;
  wire           m_axi_eth_AWVALID;
  wire           m_axi_eth_BREADY;
  wire [ 1:0]    m_axi_eth_BRESP;
  wire           m_axi_eth_BVALID;
  wire [31:0]    m_axi_eth_RDATA;
  wire           m_axi_eth_RREADY;
  wire [ 1:0]    m_axi_eth_RRESP;
  wire           m_axi_eth_RVALID;
  wire [31:0]    m_axi_eth_WDATA;
  wire           m_axi_eth_WREADY;
  wire [ 3:0]    m_axi_eth_WSTRB;
  wire           m_axi_eth_WVALID;
  wire           mdio_i;
  wire           mdio_o;
  wire           mdio_t;
  
  /// MII to RMII connection wires
  wire           MII_col;
  wire           MII_crs;
  wire           MII_rst_n;
  wire           MII_rx_clk;
  wire           MII_rx_dv;
  wire           MII_rx_er;
  wire  [ 3:0]   MII_rxd;
  wire           MII_tx_clk;
  wire           MII_tx_en;
  wire  [ 3:0]   MII_txd;
  
  wire  [5:0]   s_vga_r;
  wire  [5:0]   s_vga_g;
  wire  [5:0]   s_vga_b;

  assign vga_r = s_vga_r[5:2];
  assign vga_g = s_vga_g[5:2];
  assign vga_b = s_vga_b[5:2];
  
  IOBUF mdio_iobuf
  (
    .I(mdio_o),
    .IO(eth_mdio),
    .O(mdio_i),
    .T(mdio_t)
  );
  
  util_mii_to_rmii #(
    .INTF_CFG(0),
    .RATE_10_100(0)
  ) inst_util_mii_to_rmii (
    // MAC to MII(PHY)
    .mac_tx_en(MII_tx_en),
    .mac_txd(MII_txd),
    .mac_tx_er(1'b0),
    //MII to MAC
    .mii_tx_clk(MII_tx_clk),
    .mii_rx_clk(MII_rx_clk),
    .mii_col(MII_col),
    .mii_crs(MII_crs),
    .mii_rx_dv(MII_rx_dv),
    .mii_rx_er(MII_rx_er),
    .mii_rxd(MII_rxd),
    // RMII to PHY
    .rmii_txd(eth_txd),
    .rmii_tx_en(eth_txen),
    // PHY to RMII
    .phy_rxd(eth_rxd),
    .phy_crs_dv(eth_crsdv),
    .phy_rx_er(eth_rxerr),
    // External
    .ref_clk(eth_50mclk),
    .reset_n(eth_rstn)
  );

  
  axi_tft_vga inst_axi_vga
  (
    .s_axi_aclk(aclk),
    .s_axi_aresetn(arstn),
    .m_axi_aclk(ddr_aclk),
    .m_axi_aresetn(ddr_arstn),
    .md_error(),
    .ip2intc_irpt(axi_vga_irq),
    .m_axi_arready(s_axi_dma_vga_arready),  // input wire m_axi_arready
    .m_axi_arvalid(s_axi_dma_vga_arvalid),  // output wire m_axi_arvalid
    .m_axi_araddr(s_axi_dma_vga_araddr),    // output wire [31 : 0] m_axi_araddr
    .m_axi_arlen(s_axi_dma_vga_arlen),      // output wire [7 : 0] m_axi_arlen
    .m_axi_arsize(s_axi_dma_vga_arsize),    // output wire [2 : 0] m_axi_arsize
    .m_axi_arburst(s_axi_dma_vga_arburst),  // output wire [1 : 0] m_axi_arburst
    .m_axi_arprot(s_axi_dma_vga_arprot),    // output wire [2 : 0] m_axi_arprot
    .m_axi_arcache(s_axi_dma_vga_arcache),  // output wire [3 : 0] m_axi_arcache
    .m_axi_rready(s_axi_dma_vga_rready),    // output wire m_axi_rready
    .m_axi_rvalid(s_axi_dma_vga_rvalid),    // input wire m_axi_rvalid
    .m_axi_rdata(s_axi_dma_vga_rdata),      // input wire [31 : 0] m_axi_rdata
    .m_axi_rresp(s_axi_dma_vga_rresp),      // input wire [1 : 0] m_axi_rresp
    .m_axi_rlast(s_axi_dma_vga_rlast),      // input wire m_axi_rlast
    .m_axi_awready(s_axi_dma_vga_awready),  // input wire m_axi_awready
    .m_axi_awvalid(s_axi_dma_vga_awvalid),  // output wire m_axi_awvalid
    .m_axi_awaddr(s_axi_dma_vga_awaddr),    // output wire [31 : 0] m_axi_awaddr
    .m_axi_awlen(s_axi_dma_vga_awlen),      // output wire [7 : 0] m_axi_awlen
    .m_axi_awsize(s_axi_dma_vga_awsize),    // output wire [2 : 0] m_axi_awsize
    .m_axi_awburst(s_axi_dma_vga_awburst),  // output wire [1 : 0] m_axi_awburst
    .m_axi_awprot(s_axi_dma_vga_awprot),    // output wire [2 : 0] m_axi_awprot
    .m_axi_awcache(s_axi_dma_vga_awcache),  // output wire [3 : 0] m_axi_awcache
    .m_axi_wready(s_axi_dma_vga_wready),    // input wire m_axi_wready
    .m_axi_wvalid(s_axi_dma_vga_wvalid),    // output wire m_axi_wvalid
    .m_axi_wdata(s_axi_dma_vga_wdata),      // output wire [31 : 0] m_axi_wdata
    .m_axi_wstrb(s_axi_dma_vga_wstrb),      // output wire [3 : 0] m_axi_wstrb
    .m_axi_wlast(s_axi_dma_vga_wlast),      // output wire m_axi_wlast
    .m_axi_bready(s_axi_dma_vga_bready),    // output wire m_axi_bready
    .m_axi_bvalid(s_axi_dma_vga_bvalid),    // input wire m_axi_bvalid
    .m_axi_bresp(s_axi_dma_vga_bresp),      // input wire [1 : 0] m_axi_bresp
    .s_axi_awaddr(m_axi_vga_AWADDR),
    .s_axi_awvalid(m_axi_vga_AWVALID),
    .s_axi_awready(m_axi_vga_AWREADY),
    .s_axi_wdata(m_axi_vga_WDATA),
    .s_axi_wstrb(m_axi_vga_WSTRB),
    .s_axi_wvalid(m_axi_vga_WVALID),
    .s_axi_wready(m_axi_vga_WREADY),
    .s_axi_bresp(m_axi_vga_BRESP),
    .s_axi_bvalid(m_axi_vga_BVALID),
    .s_axi_bready(m_axi_vga_BREADY),
    .s_axi_araddr(m_axi_vga_ARADDR),
    .s_axi_arvalid(m_axi_vga_ARVALID),
    .s_axi_arready(m_axi_vga_ARREADY),
    .s_axi_rdata(m_axi_vga_RDATA),
    .s_axi_rresp(m_axi_vga_RRESP),
    .s_axi_rvalid(m_axi_vga_RVALID),
    .s_axi_rready(m_axi_vga_RREADY),
    .sys_tft_clk(vga_clk),
    .tft_hsync(vga_hsync),
    .tft_vsync(vga_vsync),
    .tft_de(),
    .tft_dps(),
    .tft_vga_clk(),
    .tft_vga_r(vga_r),
    .tft_vga_g(vga_g),
    .tft_vga_b(vga_b)
  );
  
  axi_ethernet inst_axi_eth
  (
    .ip2intc_irpt(axi_eth_irq),
    .phy_col(MII_col),
    .phy_crs(MII_crs),
    .phy_dv(MII_rx_dv),
    .phy_mdc(eth_mdc),
    .phy_mdio_i(mdio_i),
    .phy_mdio_o(mdio_o),
    .phy_mdio_t(mdio_t),
    .phy_rst_n(MII_rst_n),
    .phy_rx_clk(MII_rx_clk),
    .phy_rx_data(MII_rxd),
    .phy_rx_er(MII_rx_er),
    .phy_tx_clk(MII_tx_clk),
    .phy_tx_data(MII_txd),
    .phy_tx_en(MII_tx_en),
    .s_axi_aclk(aclk),
    .s_axi_araddr(m_axi_eth_ARADDR[12:0]),
    .s_axi_aresetn(arstn),
    .s_axi_arready(m_axi_eth_ARREADY),
    .s_axi_arvalid(m_axi_eth_ARVALID),
    .s_axi_awaddr(m_axi_eth_AWADDR[12:0]),
    .s_axi_awready(m_axi_eth_AWREADY),
    .s_axi_awvalid(m_axi_eth_AWVALID),
    .s_axi_bready(m_axi_eth_BREADY),
    .s_axi_bresp(m_axi_eth_BRESP),
    .s_axi_bvalid(m_axi_eth_BVALID),
    .s_axi_rdata(m_axi_eth_RDATA),
    .s_axi_rready(m_axi_eth_RREADY),
    .s_axi_rresp(m_axi_eth_RRESP),
    .s_axi_rvalid(m_axi_eth_RVALID),
    .s_axi_wdata(m_axi_eth_WDATA),
    .s_axi_wready(m_axi_eth_WREADY),
    .s_axi_wstrb(m_axi_eth_WSTRB),
    .s_axi_wvalid(m_axi_eth_WVALID)
  );
  
  // Module: axi_lite_otm
  //
  // AXI Lite Crossbar for pl devices .. vga, eth
  axi_lite_otm #(
    .ADDRESS_WIDTH(32),
    .BUS_WIDTH(4),
    .TIMEOUT_BEATS(32),
    .SLAVES(2),
    .SLAVE_ADDRESS({{32'h74A10000},{32'h74A00000}}),
    .SLAVE_REGION({{32'h0000FFFF},{32'h0000FFFF}})
  ) inst_axi_lite_acc_otm (
    .aclk   (aclk),
    .arstn  (arstn),
    .s_axi_awaddr   (s_axi_acc_AWADDR),
    .s_axi_awprot   (s_axi_acc_AWPROT),
    .s_axi_awvalid  (s_axi_acc_AWVALID),
    .s_axi_awready  (s_axi_acc_AWREADY),
    .s_axi_wdata    (s_axi_acc_WDATA),
    .s_axi_wstrb    (s_axi_acc_WSTRB),
    .s_axi_wvalid   (s_axi_acc_WVALID),
    .s_axi_wready   (s_axi_acc_WREADY),
    .s_axi_bresp    (s_axi_acc_BRESP),
    .s_axi_bvalid   (s_axi_acc_BVALID),
    .s_axi_bready   (s_axi_acc_BREADY),
    .s_axi_araddr   (s_axi_acc_ARADDR),
    .s_axi_arprot   (s_axi_acc_ARPROT),
    .s_axi_arvalid  (s_axi_acc_ARVALID),
    .s_axi_arready  (s_axi_acc_ARREADY),
    .s_axi_rdata    (s_axi_acc_RDATA),
    .s_axi_rresp    (s_axi_acc_RRESP),
    .s_axi_rvalid   (s_axi_acc_RVALID),
    .s_axi_rready   (s_axi_acc_RREADY),
    .m_axi_awaddr   ({m_axi_vga_AWADDR,     m_axi_eth_AWADDR}),
    .m_axi_awprot   (),
    .m_axi_awvalid  ({m_axi_vga_AWVALID,    m_axi_eth_AWVALID}),
    .m_axi_awready  ({m_axi_vga_AWREADY,    m_axi_eth_AWREADY}),
    .m_axi_wdata    ({m_axi_vga_WDATA,      m_axi_eth_WDATA}),
    .m_axi_wstrb    ({m_axi_vga_WSTRB,      m_axi_eth_WSTRB}),
    .m_axi_wvalid   ({m_axi_vga_WVALID,     m_axi_eth_WVALID}),
    .m_axi_wready   ({m_axi_vga_WREADY,     m_axi_eth_WREADY}),
    .m_axi_bresp    ({m_axi_vga_BRESP,      m_axi_eth_BRESP}),
    .m_axi_bvalid   ({m_axi_vga_BVALID,     m_axi_eth_BVALID}),
    .m_axi_bready   ({m_axi_vga_BREADY,     m_axi_eth_BREADY}),
    .m_axi_araddr   ({m_axi_vga_ARADDR,     m_axi_eth_ARADDR}),
    .m_axi_arprot   (),
    .m_axi_arvalid  ({m_axi_vga_ARVALID,    m_axi_eth_ARVALID}),
    .m_axi_arready  ({m_axi_vga_ARREADY,    m_axi_eth_ARREADY}),
    .m_axi_rdata    ({m_axi_vga_RDATA,      m_axi_eth_RDATA}),
    .m_axi_rresp    ({m_axi_vga_RRESP,      m_axi_eth_RRESP}),
    .m_axi_rvalid   ({m_axi_vga_RVALID,     m_axi_eth_RVALID}),
    .m_axi_rready   ({m_axi_vga_RREADY,     m_axi_eth_RREADY})
  );

endmodule
