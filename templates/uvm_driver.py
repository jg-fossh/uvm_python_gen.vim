import cocotb
from cocotb.triggers import *
from cocotb.clock import Clock

from uvm import *
from uvm.base import *
from uvm.comps import UVMDriver
from uvm.macros import uvm_component_utils, uvm_info

from {:NAME:}_transfer import *
from {:NAME:}_if import *
from {:NAME:}_monitor import *

class {:NAME:}_driver(UVMDriver):
    """
       Class: SPI Driver

       Definition: Contains functions, tasks and methods to drive the read
                   interface signals in response to the DUT. This is the
                   stimulus generator.
    """

    def __init__(self, name, parent=None):
        super().__init__(name,parent)
        """
           Function: new

           Definition: Read slave agent constructor.

           Args:
             name: This agents name.
             parent: NONE
        """
        self.seq_item_port
        self.vif   = {:NAME:}_if
        self.trig  = Event("trans_exec")  # event
        self.tag   = "{:NAME:}_driver" + name
        self.data  = 0
        #self.clk_out = None


    def build_phase(self, phase):
        super().build_phase(phase)
        """
           Function: build_phase

           Definition: Gets this agent's interface.

           Args:
             phase: build_phase
        """


    def connect_phase(self, phase):
        """
           Function: connect_phase

           Definition: Connects the analysis port and sequence item export.

           Args:
             phase: connect_phase
        """

    async def run_phase(self, phase):
        """
           Function: run_phase

           Definition: Task executed during run phase. Drives the signals in
                       response to a UUT requests.

           Args:
             phase: run_phase
        """
        cocotb.fork(self.get_and_drive(phase))
        cocotb.fork(self.reset_signals())


    async def get_and_drive(self, phase):
        tr = []
        while True:
            # Ex. Drives signals with sequences
            if (self.vif.i_{:LOWERNAME:}_reset == 0):
                await self.seq_item_port.get_next_item(tr)
                phase.raise_objection(self, self.tag + "objection")
                tr = tr[0]
                await self.drive_transfer(tr)
                self.seq_item_port.item_done()
                phase.drop_objection(self, self.tag + "drop objection")
                self.trig.set()
                await FallingEdge(self.vif.o_clk_out)
                tr = []


    async def reset_signals(self):
        while True:
            await RisingEdge(self.vif.i_{:LOWERNAME:}_reset)

            # Hold signals low while reset
            self.vif.o_{:LOWERNAME:}_output_signal <= 0

            await FallingEdge(self.vif.i_{:LOWERNAME:}_reset)


    async def drive_transfer(self, tr):
        # Drive output
        #uvm_info("{:NAME:}_DRIVER", $sformatf("Transfer sent :\n%s", tr.sprint()), UVM_MEDIUM)

uvm_component_utils({:NAME:}_driver)
