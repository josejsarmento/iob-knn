#include "interconnect.h"
#include "iob_knn.h"
#include "KNNsw_reg.h"

 //base address
static int base;

 void knn_reset(){
  IO_SET(base, KNN_RESET, 1);
  IO_SET(base, KNN_RESET, 0);
}

 void knn_init(int base_address){
  base = base_address;
  knn_reset();
}

 void knn_set_M_x_y(short x, short y, short k){
  IO_SET(base, KNN_M_X0 + k, x);
  IO_SET(base, KNN_M_Y0 + k, y);
}

 void knn_calculate_N_distance(short x, short y, unsigned char label){
  IO_SET(base, KNN_N_X, x);
  IO_SET(base, KNN_N_Y, y);
  IO_SET(base, KNN_N_LABEL, label);
}

 unsigned char knn_get_class(short k){
	return IO_GET(base, KNN_M_K0 + k);
}

