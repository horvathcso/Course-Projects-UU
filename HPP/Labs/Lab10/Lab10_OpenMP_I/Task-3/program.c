#include <stdio.h>
#include <omp.h>

void thread_func() {
  int nr=omp_get_thread_num();
  int num=omp_get_max_threads();
  printf("This is inside thread_func()! Thread number: %d\n",nr);
  printf("Num threads here: %d\n\n",num);
}

int main(int argc, char** argv) {

#pragma omp parallel num_threads(10)
  {
    thread_func();
  }

  return 0;
}
