import cocotb
from cocotb.triggers import *

from uvm.base.uvm_callback import *
from uvm.comps.uvm_monitor import UVMMonitor
from uvm.tlm1 import *
from uvm.macros import *

from {:NAME:}_transfer import *
from {:NAME:}_if import *

class {:NAME:}_monitor(UVMMonitor):
    """
       Class: {:UPPERNAME:} Monitor

       Definition: Contains functions, tasks and methods of this agent's monitor.
    """

    def __init__(self, name, parent=None):
        super().__init__(name, parent)
        """
           Function: new

           Definition: Class Constructor.

           Args:
             name: This agents name.
             parent: NONE
        """
        self.ap        = None
        self.vif       = {:NAME:}_if  # connected at the agent
        self.cfg       = None
        self.errors    = 0
        self.num_items = 0
        self.tag       = "{:NAME:}_monitor" + name


    def build_phase(self, phase):
        super().build_phase(phase)
        """
           Function: build_phase

           Definition:

           Args:
             phase: build_phase
        """
        self.ap = UVMAnalysisPort("ap", self)


    async def run_phase(self, phase):
        """
           Function: run_phase

           Definition: Task executed during run phase.

           Args:
             phase: run_phase
        """
        cocotb.fork(self.collect_transactions())


    async def collect_transactions(self):
        while True:
            # Example :
            tr = None  # Clean transaction for every loop.

            await FallingEdge(self.vif.i_{:LOWERNAME:}_reset)

            tr = {:NAME:}_transfer.type_id.create("tr", self)

            await RisingEdge(self.vif.i_{:LOWERNAME:}_clk)
            if (self.cfg == 1):
                tr.transmit_data[i] = self.vif.i_{:LOWERNAME:}_input_signal
            else:
                tr.receive_data[i] = self.vif.o_{:LOWERNAME:}_output_signal

            self.num_items += 1       # Increment transactions count
            self.ap.write(tr) # Send transaction through analysis port
            # uvm_info(self.tag, tr.convert2string(), UVM_HIGH)


uvm_component_utils({:NAME:}_monitor)
