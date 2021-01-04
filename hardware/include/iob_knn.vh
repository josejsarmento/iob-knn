`define KNN_ADDR_W 8  //address width
`define KNN_WDATA_W 48 //write data width
`ifndef DATA_W
 `define DATA_W 32      //cpu data width
`endif
`ifndef LABELS
 `define LABELS 8
`endif
`ifndef K_NEIGHBOURS
 `define K_NEIGHBOURS 4
`endif
`ifndef M_POINTS
 `define M_POINTS 4
`endif
