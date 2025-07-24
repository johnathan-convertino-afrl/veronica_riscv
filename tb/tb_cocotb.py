#******************************************************************************
# file:    tb_cocotb.py
#
# author:  JAY CONVERTINO
#
# date:    2025/07/08
#
# about:   Brief
# Cocotb test bench
#
# license: License MIT
# Copyright 2025 Jay Convertino
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.
#
#******************************************************************************

import random
import itertools

import cocotb
from cocotb.clock import Clock
from cocotb.utils import get_sim_time
from cocotb.triggers import FallingEdge, RisingEdge, Timer, Event
from cocotb.binary import BinaryValue
from cocotbext.uart_term import UartTerm

# Function: start_clock
# Start the simulation clock generator.
#
# Parameters:
#   dut - Device under test passed from cocotb test function
def start_clock(dut):
  dut._log.info(f'CLOCK NS : {int(1000000000/dut.CLOCK_SPEED.value)}')
  cocotb.start_soon(Clock(dut.clk, int(1000000000/dut.CLOCK_SPEED.value), units="ns").start())

# Function: reset_dut
# Cocotb coroutine for resets, used with await to make sure system is reset.
async def reset_dut(dut):
  dut.resetn.value = 0
  dut.reset.value  = 1
  await Timer(2000, units="ns")
  dut.resetn.value = 1
  dut.reset.value  = 0

# Function: interactive_simulation
# Coroutine that is identified as a test routine. This routine runs the veronica core
# in a loop till killed. This is not a verification simulation.
#
# Parameters:
#   dut - Device under test passed from cocotb.
@cocotb.test()
async def interactive_simulation(dut):

    start_clock(dut)

    term = UartTerm(dut.uart_tx, dut.uart_rx)
    
    await reset_dut(dut)
    
    while True:
        await Timer(2000, units="ns")
