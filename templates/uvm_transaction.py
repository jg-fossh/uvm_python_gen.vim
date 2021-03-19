from uvm import *

class {:NAME:}_transaction(UVMSequenceItem):
    """
       Class: {:UPPERNAME:} Sequence Item

       Definition: Contains functions, tasks and methods of this
    """

    def __init__(self, name="{:NAME:}_transfer"):
        super().__init__(name)
        """
           Function: new

           Definition: Class Constructor.

           Args:
             name: This agents name.
             parent: NONE
        """
        self.transmit_data = 0x0
        self.receive_data  = 0x0
        self.addr          = 0x0
        self.delay         = 0

    def do_copy(self, rhs):
        self.transmit_data = rhs.transmit_data
        self.receive_data  = rhs.receive_data
        self.addr          = rhs.addr
        self.delay         = rhs.delay


    def do_clone(self):
        new_obj = {:NAME:}_transaction()
        new_obj.copy(self)
        return new_obj


    def convert2string(self):
        return sv.sformatf("\n =================================== \n  Xmt Data : 0x%0h \n  Rcv Data : 0x%0h \n  Address  : 0x%0h \n  Delay    : %d  (clocks) \n =================================== \n ",
                self.transmit_data, self.receive_data, self.addr, self.delay)


uvm_object_utils({:NAME:}_transaction)
