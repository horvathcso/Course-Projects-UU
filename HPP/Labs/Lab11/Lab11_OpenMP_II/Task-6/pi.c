/**********************************************************************
 * This program calculates pi using C
 *
 **********************************************************************/
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {

  int i;
  const int intervals = 500000000;
  double sum, dx, x;
  int Nthreads = atoi(argv[1]);

  dx  = 1.0/intervals;
  sum = 0.0;

  #pragma omp parallel for num_threads(Nthreads) reduction(+ : sum) private(x)
  for (i = 1; i <= intervals; i++) { 
    x = dx*(i - 0.5);
    sum += dx*4.0/(1.0 + x*x);
  }

  printf("PI is approx. %.16f\n",  sum);

  return 0;
}
