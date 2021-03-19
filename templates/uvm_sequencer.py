from uvm import *

class {:NAME:}_sequencer(UVMSequencer):
    """
       Class:{:UPPERNAME:} Sequencer

       Definition: Contains functions, tasks and methods of this agent's
                   sequencer.
    """

    def __init__(self, name, parent=None):
        super().__init__(name, parent)
        """         
           Function: new

           Definition: Sequencer constructor.

           Args:
             name: This agents name.
             parent: NONE
        """
        self.seq_item_export = UVMBlockingPeekPort("seq_item_export", self)


uvm_component_utils({:NAME:}_sequencer)
