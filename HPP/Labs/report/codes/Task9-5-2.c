/**********************************************************************
 * This program calculates pi using C
 *
 **********************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#define NUM_THREADS	8

pthread_mutex_t lock;
double sum = 0.0;
const long int intervals = 5000000000;
double dx =1.0/intervals;

void * thread_funct(void* arg){
  double x; long int L,U;
  double tmp =0.0;
  long bnd=(long)arg;
  L=bnd*(intervals/NUM_THREADS);
  U=(bnd+1)*(intervals/NUM_THREADS);
  for (long i = L; i <= U; i++) { 
    x = dx*(i - 0.5);
    tmp += dx*4.0/(1.0 + x*x);
  }

  pthread_mutex_lock(&lock);
    sum+=tmp;
  pthread_mutex_unlock(&lock);
  return NULL;
} 

int main(int argc, char *argv[]) {

  pthread_t threads[NUM_THREADS];
  pthread_mutex_init(&lock, NULL);
  long i;
  double x;
 
  for(i=0; i<NUM_THREADS; i++)
    pthread_create(&threads[i], NULL, thread_funct, (void*)i);
  
  // Wait for threads to finish(intervals/NUM_THREADS)
  for(i=0; i<NUM_THREADS; i++)
    pthread_join(threads[i], NULL);

  pthread_mutex_lock(&lock);
  for (i = NUM_THREADS*(intervals/NUM_THREADS)+1; i <= intervals; i++) { 
    x = dx*(i - 0.5);
    sum += dx*4.0/(1.0 + x*x);
  }
  pthread_mutex_unlock(&lock);

  printf("PI is approx. %.16f\n",  sum);
  pthread_mutex_destroy(&lock);
  return 0;
}

