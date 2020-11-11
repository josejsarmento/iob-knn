`timescale 1ns/1ps
`include "iob_lib.vh"

module knn_core
  #(
    parameter DATA_W = 32
    )
   (
    `INPUT(KNN_ENABLE, 1),
    `INPUT(KNN_SAMPLE, 1),
    `OUTPUT(KNN_VALUE, 2*`DATA_W),
    `INPUT(clk, 1),
    `INPUT(rst, 1)
    );

   `SIGNAL(time_counter, 2*DATA_W)
   `COUNTER_ARE(clk, rst, KNN_ENABLE, time_counter)

   //time counter register
   `SIGNAL(counter_reg, 2*DATA_W)
   
   `REG_E(clk, KNN_SAMPLE, counter_reg, time_counter)
   //always @(negedge clk) if(TIMER_SAMPLE)  counter_reg <= time_counter;

   `SIGNAL2OUT(KNN_VALUE, counter_reg)
      
endmodule

