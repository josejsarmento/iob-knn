`timescale 1ns/1ps
`include "iob_lib.vh"

 module FSM
   (
    `OUTPUT(dist_calculated, 1),
    `INPUT(valid, 1),
    `INPUT(clk, 1),
    `INPUT(knn_enable, 1),
    `INPUT(rst, 1),
    `INPUT(wstrb, 1)
    );

     `SIGNAL(pc, 2)
    `SIGNAL(next_pc, 2)
    `SIGNAL(dist_calcul, 1)

     `SIGNAL2OUT(dist_calculated, dist_calcul)

     `REG_ARE(clk, rst, 0, knn_enable, pc, next_pc)

     `COMB begin

     next_pc = pc;
    dist_calcul = 1'b0;

     case(pc)
      0: begin
        if(valid && wstrb) next_pc = pc + 1'b1;
      end

       1: begin
        if(valid && wstrb) next_pc = pc + 1'b1;
      end

       2: begin
        next_pc = 1'b0;
        dist_calcul = 1'b1;
      end

       default: begin
        next_pc = 1'b0;
        dist_calcul = 1'b0;
      end

     endcase

     end

endmodule // FSM

