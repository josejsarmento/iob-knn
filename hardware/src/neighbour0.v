`timescale 1ns/1ps
`include "iob_lib.vh"

 module neighbour0
  #(
    parameter DATA_W = 32,
    parameter LABELS = 8
    )
   (
    `INPUT(dist_candidate, DATA_W),
    `INPUT(class_candidate, LABELS),
    `INPUT(valid, 1),
    `INPUT(rst, 1),
    `INPUT(knn_enable, 1),
    `INPUT(clk, 1),
    `OUTPUT(neighbour_dist, DATA_W),
    `OUTPUT(neighbour_label, LABELS)
    );

     `SIGNAL(update_val, 1)
    `SIGNAL(Reg_out_dist, DATA_W)
    `SIGNAL(Reg_out_class, LABELS)
    `SIGNAL(Reg_in_dist, DATA_W)
    `SIGNAL(Reg_in_class, LABELS)

     `COMB begin

     if(dist_candidate < Reg_out_dist)
		update_val = 1'b1;
    else
		update_val = 1'b0;

     Reg_in_dist = dist_candidate;
    Reg_in_class = class_candidate;

     end

     `REG_ARE(clk, rst, '1, valid & knn_enable & update_val, Reg_out_class, Reg_in_class)
    `REG_ARE(clk, rst, '1, valid & knn_enable & update_val, Reg_out_dist, Reg_in_dist)

     `SIGNAL2OUT(neighbour_dist, Reg_out_dist)
    `SIGNAL2OUT(neighbour_label, Reg_out_class)

endmodule // neighbour0

