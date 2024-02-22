#include <omp.h>
#include <stdio.h>

long int N = 5000000;

double f(int q) {
  long int i;
  double x = 1.0;
  for(i = 0; i < N; i++)
    x *= 1.000000001;
  return x * q;
}

int main(int argc, char *argv[]) {
  const int M = 200;
  double arr[M];

//#pragma omp parallel num_threads(3)
  {

    int i;
//#pragma omp for
#pragma omp parallel for num_threads(3)
      for(i = 0; i < M; i++)
	arr[i] = f(i);

  }

  /* Sum up results. */
  double sum = 0;
  int k;
  #pragma omp parallel num_threads(3)
  {
    #pragma omp for
    for(k = 0; k < M; k++)
      #pragma omp critical
      sum += arr[k];
  }

  printf("sum = %f\n", sum);

  return 0;
}
