//START_TABLE sw_reg
`SWREG_W(KNN_RESET,          1, 0) //Timer soft reset
`SWREG_W(KNN_ENABLE,         1, 0) //Timer enable
`SWREG_W(KNN_N_X,         DATA_W/2, 0) //Point N_X
`SWREG_W(KNN_N_Y,         DATA_W/2, 0) //Point N_Y
`SWREG_W(KNN_N_LABEL, 	  LABELS, 0)  //Point N_Class
`SWREG_BANKW(KNN_M_X,     DATA_W/2, 0, 4) // Point M_X
`SWREG_BANKW(KNN_M_Y,     DATA_W/2, 0, 4) // Point M_Y
`SWREG_BANKR(KNN_M_K, 	  LABELS, 0, 40) //Number of the neighbours per M

