from uvm import *

from {:NAME:}_if import *
from {:NAME:}_driver import *
from {:NAME:}_sequencer import *
from {:NAME:}_monitor import *

class {:NAME:}_agent(UVMAgent):
    """
       Class: {:UPPERNAME:} Verification Agent

       Definition: Contains the instantiations and connections of this agents
                   components.
    """

    def __init__(self, name, parent=None):
        """
           Function: new

           Definition: Agent constructor.

           Args:
             name: This agents name.
             parent: NONE
        """
        super().__init__(name, parent)
        self.cfg = None  # config
        self.sqr = None  # sequencer
        self.drv = None  # driver
        self.mon = None  # monitor
        self.id  = None  # agent's id
        self.ap  = UVMAnalysisPort("ap", self) # analysis port for the monitor


    def build_phase(self, phase):
        super().build_phase(phase)
        """
           Function: build_phase

           Definition: Creates this agent's components.

           Args:
             phase: build_phase
        """

        self.mon = {:NAME:}_monitor.type_id.create("mon", self)

        if (self.cfg.is_active):
            self.drv = {:NAME:}_driver.type_id.create("drv", self)
            self.sqr = UVMSequencer.type_id.create("sqr", self)


    def connect_phase(self, phase):
        """
           Function: connect_phase

           Definition: Connects the analysis port and sequence item export.

           Args:
             phase: connect_phase
        """
        self.mon.vif   = self.cfg.vif
        # sself.mon.ap.connect(self.ap)

        if (self.cfg.is_active):
            self.drv.vif = self.cfg.vif
            self.drv.seq_item_port.connect(self.sqr.seq_item_export) # Driver Connection


uvm_component_utils({:NAME:}_agent)
