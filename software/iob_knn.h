#pragma once

//Functions
void knn_reset();
void knn_start();	
void knn_stop();
void knn_init( int base_address);
void knn_enable();
void knn_disable();

void knn_set_M_x_y(short x, short y, short k);
void knn_calculate_N_distance(short x, short y, unsigned char label);
unsigned char knn_get_label(int k);

