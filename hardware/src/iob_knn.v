`timescale 1ns/1ps
`include "iob_lib.vh"
`include "interconnect.vh"
`include "iob_knn.vh"

module iob_knn 
  #(
    parameter ADDR_W = `KNN_ADDR_W, //NODOC Address width
    parameter DATA_W = `DATA_W, //NODOC Data word width
    parameter WDATA_W = `KNN_WDATA_W, //NODOC Data word width on writes
    parameter LABELS = `LABELS,
    parameter K_NEIGHBOURS = `K_NEIGHBOURS,
    parameter M_POINTS = `M_POINTS
    )
   (
`include "cpu_nat_s_if.v"
`include "gen_if.v"
    );

//BLOCK Register File & Configuration, control and status registers accessible by the sofware
`include "KNNsw_reg.v"
`include "KNNsw_reg_gen.v"

    //combined hard/soft reset 
   `SIGNAL(rst_int, 1)
   `COMB rst_int = rst | KNN_RESET;

   //write signal
   `SIGNAL(write, 1) 
   `COMB write = | wstrb;

   `SIGNAL(dist_calculated, 1)
   `SIGNAL(KNN_OUT, LABELS*K_NEIGHBOURS*M_POINTS)
   genvar i, j;

   generate
      for(i = 0; i < `M_POINTS; i = i + 1) begin
       for (j = 0; j < `K_NEIGHBOURS; j = j + 1) begin
        assign KNN_M_K[i*`K_NEIGHBOURS+j] = KNN_OUT[((i+1)*`LABELS*`K_NEIGHBOURS)-1:i*`LABELS*`K_NEIGHBOURS];
      end

 	   knn_core knn0
		 (
		  .clk(clk),
		  .rst(rst_int),
		  .write(write),
		  .Point_1_Label(KNN_N_LABEL),
		  .Point_1_X(KNN_N_X),
		  .Point_1_Y(KNN_N_Y),
		  .Point_2_X(KNN_M_X[i]),
		  .Point_2_Y(KNN_M_Y[i]),
		  .valid(dist_calculated),
		  .knn_enable(KNN_ENABLE),
		  .labels(KNN_OUT[((i+1)*`LABELS*`K_NEIGHBOURS)-1:i*`LABELS*`K_NEIGHBOURS])
		  );
	end
   endgenerate

 	FSM control_unit
       (
        .dist_calculated(dist_calculated),
        .valid(valid),
        .clk(clk),
        .knn_enable(KNN_ENABLE),
        .rst(rst),
        .wstrb(write)
       );


   //
   //BLOCK 64-bit time counter & Free-running 64-bit counter with enable and soft reset capabilities
   //
  // `SIGNAL_OUT(KNN_VALUE, 2*DATA_W)
   //knn_core knn0
   //  (
   //   .KNN_ENABLE(KNN_ENABLE),
   //   .KNN_SAMPLE(KNN_SAMPLE),
   //   .KNN_VALUE(KNN_VALUE),
   //   .clk(clk),
   //   .rst(rst_int)
   //   );
   
   
   //ready signal   
   `SIGNAL(ready_int, 1)
   `REG_AR(clk, rst, 0, ready_int, valid)

   `SIGNAL2OUT(ready, ready_int)

   //rdata signal
   //`COMB begin
   //end
      
endmodule

