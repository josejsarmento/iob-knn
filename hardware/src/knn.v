`timescale 1ns/1ps
`include "iob_lib.vh"

module knn_core
  #(
    parameter DATA_W = 32,
    parameter LABELS = 8,
    parameter M_POINTS = 4,
    parameter K_NEIGHBOURS = 10
    )
   (
    `INPUT(knn_enable, 1),
    `INPUT(KNN_SAMPLE, 1),
    `OUTPUT(KNN_VALUE, 2*`DATA_W),
    `INPUT(clk, 1),
    `INPUT(rst, 1),
    `INPUT(Point_1_X, `DATA_W/2),
    `INPUT(Point_1_Y, `DATA_W/2),
    `INPUT(Point_2_X, `DATA_W/2),
    `INPUT(Point_2_Y, `DATA_W/2),
    `INPUT(write, 1),
    `INPUT(Point_1_Label, `LABELS),
    `INPUT(valid, 1),
    `OUTPUT(labels, `LABELS*`K_NEIGHBOURS)
    );

   `SIGNAL(time_counter, 2*DATA_W)
   `COUNTER_ARE(clk, rst, knn_enable, time_counter)

   //time counter register
   `SIGNAL(counter_reg, 2*DATA_W)
   
   `REG_E(clk, KNN_SAMPLE, counter_reg, time_counter)
   //always @(negedge clk) if(TIMER_SAMPLE)  counter_reg <= time_counter;

   `SIGNAL2OUT(KNN_VALUE, counter_reg)

   `SIGNAL(DIST_OUT, `DATA_W)


     `SIGNAL2OUT(labels, DIST_OUT)

     dist_calc dist0
      (
      .IN_1_X(Point_1_X),
      .IN_1_Y(Point_1_Y),
      .IN_2_X(Point_2_X),
      .IN_2_Y(Point_2_Y),
      .DIST_OUT(DIST_OUT)
      );

    `SIGNAL(write_previous, 1)
    `SIGNAL(write_val, K_NEIGHBOURS)
    `SIGNAL(neighbour_dist, DATA_W)
    `SIGNAL(KNEIGHBOURS_CLASS, LABELS*K_NEIGHBOURS)
    `SIGNAL(KNEIGHBOURS_DIST, DATA_W*K_NEIGHBOURS)

    `SIGNAL2OUT(labels, KNEIGHBOURS_CLASS)

     genvar i;


     neighbour0 neighbour_nr0
    (
     .dist_candidate(DIST_OUT),
     .class_candidate(Point_1_Label),
     .valid(valid),
     .rst(rst),
     .knn_enable(knn_enable),
     .clk(clk),
     .neighbour_dist(KNEIGHBOURS_DIST[DATA_W-1:0]),
     .neighbour_label(KNEIGHBOURS_CLASS[LABELS-1:0])
     );

     generate
      for(i = 1; i < K_NEIGHBOURS; i = i+1) begin
        neighbour neighbour_nr
        (
		 .dist_candidate(KNEIGHBOURS_DIST[i*DATA_W-1:(i-1)*DATA_W]),
		 .class_candidate(KNEIGHBOURS_CLASS[LABELS*i-1:LABELS*(i-1)]),
		 .valid(valid),
		 .rst(rst),
		 .knn_enable(knn_enable),
		 .clk(clk),
		 .neighbour_dist(KNEIGHBOURS_DIST[(i+1)*DATA_W-1:i*DATA_W]),
		 .neighbour_label(KNEIGHBOURS_CLASS[LABELS*(i+1)-1:LABELS*i])
         );
      end
    endgenerate
      
endmodule

