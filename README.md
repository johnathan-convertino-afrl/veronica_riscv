# Veronica RISCV FPGA Project
### Contains core files and scripts to generate a Vexriscv platform using fusesoc.
---

![image](docs/manual/img/AFRL.png)

---

   author: Jay Convertino

   date: 2024.11.25

   details: Generate Vexriscv (Veronica, RISCV) FPGA image for various targets. See fusesoc section for targets available.

   license: MIT

---

### Version
#### Current
  - none

#### Previous
  - none

### DOCUMENTATION
  For detailed usage information, please navigate to one of the following sources. They are the same, just in a different format.

  - [veronica_riscv.pdf](docs/manual/veronica_riscv.pdf)
  - [github page](https://johnathan-convertino-afrl.github.io/veronica_riscv/)

### DEPENDENCIES
#### Build
  - AFRL:utility:digilent_nexys-a7-100t_board_base_constr:1.0.0
  - AFRL:utility:digilent_nexys-a7-100t_board_base_ddr_cfg:1.0.0
  - AFRL:utility:vivado_board_support_packages
  - AD:ethernet:util_mii_to_rmii:1.0.0
  - AFRL:utility:helper:1.0.0
  - AFRL:utility:tcl_helper_check:1.0.0
  - spinalhdl:cpu:veronica_axi_jtag_io:1.0.0
  - spinalhdl:cpu:veronica_axi_secure_jtag_io:1.0.0
  - spinalhdl:cpu:veronica_axi_jtag_xilinx_bscane:1.0.0
  - spinalhdl:cpu:veronica_axi_secure_jtag_xilinx_bscane:1.0.0

#### Simulation
  - none, not implimented.

### FUSESOC

* fusesoc_info.core created.
* Simulation not available

#### Targets

* RUN WITH: (fusesoc run --target=zed_bootgen VENDER:CORE:NAME:VERSION)
* -- target can be one of the below.
  - nexys-a7-100t                           : Base for nexys-a7-100t digilent development board builds, do not use.
  - nexys-a7-100t_uc_secure_jtag_io         : Build for nexys-a7-100t digilent development board with PMP enabled Veronica RISCV and JTAG using IO pins.
  - nexys-a7-100t_uc_jtag_io                : Build for nexys-a7-100t digilent development board with standard Veronica RISCV and JTAG using IO pins.
  - nexys-a7-100t_uc_secure_jtag_bscane     : Build for nexys-a7-100t digilent development board with PMP enabled Veronica RISCV using Xilinx BSCANE JTAG.
  - nexys-a7-100t_uc_jtag_bscane            : Build for nexys-a7-100t digilent development board with standard Veronica RISCV using Xilinx BSCANE JTAG.
  - nexys-a7-100t_linux_jtag_bscane         : Linux(MMU) build for nexys-a7-100t digilent development board with standard Veronica RISCV using Xilinx BSCANE JTAG.
  - nexys-a7-100t_linux_jtag_bscane_bootgen : Linux(MMU) build for nexys-a7-100t digilent development board with standard Veronica RISCV using Xilinx BSCANE JTAG.
  
Programmer is broken in Linux, use openFPGAloader.

openFPGAloader -c ft2232 filename.bit

The bit file is located in the impl folder of the project.

openOCD can also be used if a svf file is generated from the programmer.

Also the lattice programmer can be user if the ftdi_sio usbserial modules are rmmod.
Plus the usual JTAG adapter udev permissions (plugdev)

### Programming
* VC707 target must use the mt28gu01gaax1e-bpi-x16 device with the generated MCS file in Vivado.
* KC705 target must use the *** device with the generated MCS file in Vivado.
