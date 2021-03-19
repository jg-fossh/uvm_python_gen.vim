import cocotb
from cocotb.triggers import *
from uvm.base.sv import sv_if

class {:NAME:}_if(sv_if):
    """
       Class: {:UPPERNAME:} Interface

       Definition: Contains functions, tasks and methods of this agent's
                   virtual interface.
    """


    def __init__(self, dut, bus_map=None):
        """
           Function: new

           Definition: Read slave interface constructor.

           Args:
             dut: The dut it connects to. Passed in by cocotb top.
             bus_map: Naming of the bus signals.
        """
        if bus_map is None:
            #  If NONE then create this as default. (The user should define
            #  its own signal names for this bus at the top.)
            bus_map = {"i_{:LOWERNAME:}_clk": "i_{:LOWERNAME:}_clk",
                       "i_{:LOWERNAME:}_reset": "i_{:LOWERNAME:}_reset",
                       "i_{:LOWERNAME:}_input_signal": "i_{:LOWERNAME:}_input_signal",
                       "o_{:LOWERNAME:}_output_signal": "o_{:LOWERNAME:}_output_signal"}
        super().__init__(dut, "",bus_map)


    async def start(self):
        # await Timer(0, "NS")
