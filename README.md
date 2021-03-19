# uvm_python_gen.vim
VIM / NeoVim plugin to auto-generate the shell for uvm-python verifiaction IP.

## Usage and Capabilities.

To generate a verification component call function UVMPYGEN(arg0, arg1). Where arg0 is the component and arg1 is the name given to the component. Ex. `:UVMPYGEN agent spi` would generate the _agent_ top level component for a verification agent call _spi_.

