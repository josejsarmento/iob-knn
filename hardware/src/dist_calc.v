`timescale 1ns/1ps
`include "iob_lib.vh"

 module dist_calc
  #(
    parameter DATA_W = 32
    )
   (
    `INPUT(IN_1_X, `DATA_W/2),
    `INPUT(IN_1_Y, `DATA_W/2),
    `INPUT(IN_2_X, `DATA_W/2),
    `INPUT(IN_2_Y, `DATA_W/2),
    `OUTPUT(DIST_OUT, `DATA_W)
    );

     `SIGNAL_SIGNED(X_DIFF, `DATA_W/2)
    `SIGNAL_SIGNED(Y_DIFF, `DATA_W/2)
    `SIGNAL_SIGNED(X_PWR2, `DATA_W)
    `SIGNAL_SIGNED(Y_PWR2, `DATA_W)
    `SIGNAL_SIGNED(DIST_VALUE, `DATA_W)

     `SIGNAL2OUT(DIST_OUT, DIST_VALUE)

     `COMB begin

 	X_DIFF = IN_1_X - IN_2_X;
	X_PWR2 = X_DIFF * X_DIFF;
	Y_DIFF = IN_1_Y - IN_2_Y;
	Y_PWR2 = Y_DIFF * Y_DIFF;
	DIST_VALUE = X_PWR2 + Y_PWR2;

     end



 endmodule

