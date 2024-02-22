#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

void do_some_work() {
  printf("Now I am going to do some work...\n");
  long int i;
  long int j = 0;
  for(i = 0; i < 3000000000; i++) {
    j += 3;
  }
  printf("Work done! My result j = %ld\n", j);
}

int main(int argc, char** argv) {
const int n=atoi(argv[1]);

printf("n: %d\n", n);

double start; 
double end; 
start = omp_get_wtime(); 

#pragma omp parallel num_threads(n)
  {
    do_some_work();
  }

end = omp_get_wtime(); 
printf("Work took %f seconds\n", end - start);

  return 0;
}
