# FPGA Modules

This is a collection of FPGA designs for video capture and processing. All modules have been tested on a ZCU102 Evaluation Board with two IMX274 (LI-IMX274MIPI-FMC) cameras. All tcl scripts contain block diagrams for Vivado 2017.4. To build the block diagrams, create a new project in Vivado (File->New Project...) then, after the project has been created, select Tools->Run Tcl Script and select the tcl script. For an example of a module integrating AXI-Stream, AXI, and AXI-Lite interfaces see l2dma.
