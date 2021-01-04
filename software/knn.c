#include "system.h"
#include "periphs.h"
#include <iob-uart.h>
#include "iob_timer.h"
#include "iob_knn.h"
#include "random.h" //random generator for bare metal

//uncomment to use rand from C lib 
//#define cmwc_rand rand

#ifdef DEBUG //type make DEBUG=1 to print debug info
#define S 12  //random seed
#define N 10  //data set size
#define K 4   //number of neighbours (K)
#define C 4   //number data classes
#define M 4   //number samples to be classified
#else
#define S 12   
#define N 100000
#define K 10  
#define C 4  
#define M 100 
#endif

#define INFINITE ~0

//
//Data structures
//

//labeled dataset
struct datum {
  short x;
  short y;
  unsigned char label;
} data[N], x[M];

//neighbor info
struct neighbor {
  unsigned int idx; //index in dataset array
  unsigned int dist; //distance to test point
} neighbor[K];


///////////////////////////////////////////////////////////////////
int main() {

  unsigned long long elapsed;
  unsigned int elapsedu;

  int k, j, i, m;

  //init uart and timer
  uart_init(UART_BASE, FREQ/BAUD);
  uart_printf("\nInit timer\n");
  uart_txwait();

  timer_init(TIMER_BASE);
  //read current timer count, compute elapsed time
  //elapsed  = timer_get_count();
  //elapsedu = timer_time_us();

	knn_init(KNN_BASE);
  //int vote accumulator
  int votes_acc[C] = {0};

  //generate random seed 
  random_init(S);

  //init dataset
  for (i=0; i<N; i++) {

    //init coordinates
    data[i].x = (short) cmwc_rand();
    data[i].y = (short) cmwc_rand();

    //init label
    data[i].label = (unsigned char) (cmwc_rand()%C);
  }

#ifdef DEBUG
  uart_printf("\n\n\nDATASET\n");
  uart_printf("Idx \tX \tY \tLabel\n");
  for (i=0; i<N; i++)
    uart_printf("%d \t%d \t%d \t%d\n", i, data[i].x,  data[i].y, data[i].label);
#endif

  //init test points
  for (k=0; k<M; k++) {
    x[k].x  = (short) cmwc_rand();
    x[k].y  = (short) cmwc_rand();
    //x[k].label will be calculated by the algorithm
	knn_enable();
    knn_set_M_x_y(x[k].x, x[k].y, (short) k);
    knn_disable();
  }

#ifdef DEBUG
  uart_printf("\n\nTEST POINTS\n");
  uart_printf("Idx \tX \tY\n");
  for (k=0; k<M; k++)
    uart_printf("%d \t%d \t%d\n", k, x[k].x, x[k].y);
#endif
  
  //
  // PROCESS DATA
  //

  //start knn here
  
  for (i=0; i<N; i++) { //for all data set
  //compute distances to dataset points

#ifdef DEBUG
    uart_printf("\n\nProcessing data[%d]:\n", i);
#endif

      //compute distance to x[k]
      knn_calculate_N_distance(data[i].x, data[i].y, data[i].label);

    }
    
    //classify test point
  for (m=0; m<M; m++) { //for all data set
    //clear all votes
    int votes[C] = {0};
    int best_votation = 0;
    int best_voted = 0;

        #ifdef DEBUG
          uart_printf("M\t%d\n", m+1 );
        #endif
      //make neighbours vote
      for (k=0; k<K; k++) { //for all neighbors
		  
        #ifdef DEBUG
          uart_printf("K\t%d\n", k );
        #endif
        int vote = knn_get_class(k*M+m);
        #ifdef DEBUG
          uart_printf("vote\t%d\n", vote );
        #endif
        if ( (++votes[vote]) > best_votation ) {
          best_voted = vote;
          best_votation = votes[best_voted];
        }
      }

    x[m].label = best_voted;

    votes_acc[best_voted]++;
    
#ifdef DEBUG
    uart_printf("\n\nNEIGHBORS of x[%d]=(%d, %d):\n", m, x[m].x, x[m].y);
    uart_printf("K \tIdx \tX \tY \tDist \t\tLabel\n");
    for (int j=0; j<K; j++)
      uart_printf("%d \t%d \t%d \t%d \t%d \t%d\n", j+1, neighbor[j].idx, data[neighbor[j].idx].x,  data[neighbor[j].idx].y, neighbor[j].dist,  data[neighbor[j].idx].label);
    
    uart_printf("\n\nCLASSIFICATION of x[%d]:\n", m);
    uart_printf("X \tY \tLabel\n");
    uart_printf("%d \t%d \t%d\n\n\n", x[m].x, x[m].y, x[m].label);

#endif

  } //all test points classified

  //stop knn here
  //read current timer count, compute elapsed time
  elapsedu = timer_time_us(TIMER_BASE);
  uart_printf("\nExecution time: %dus @%dMHz\n\n", elapsedu, FREQ/1000000);

  
  //print classification distribution to check for statistical bias
  for (int l=0; l<C; l++)
    uart_printf("%d ", votes_acc[l]);
  uart_printf("\n");
  
}


