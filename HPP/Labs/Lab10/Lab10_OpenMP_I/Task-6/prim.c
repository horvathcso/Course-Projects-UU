#include <stdio.h>
#include <omp.h>
#include <stdlib.h>


long int thread_func(int M, int n, int N) {
  int counter=0;
  for(int i=3+n*2; i<M;i=i+2*N){
    int prime=1;
    for (int j = 2; j < i; j++)
    {
        if(i%j==0){
            prime=0;
            break;
        }
    }
    if (prime)
        counter++;
}
  return counter;
}

int main(int argc, char**args){
int n =(atoi(args[1]));
int M =(atoi(args[2]));
if(M==0 || M<0){printf("Error: n needs to be an integer bigger to or equal to 1\n");} 

int counter=1;
int res[n];

double start =omp_get_wtime();
#pragma omp parallel num_threads(n)
  {
    int id = omp_get_thread_num();
    int N = omp_get_num_threads();
    res[id] = thread_func(M,id,N);
  }
double end =omp_get_wtime();

for(int i=0; i<n;i++){counter+=res[i];}

printf("The number of primes from 1 to %d is %d\n" , M, counter);
printf("Run time: %lf\n",end-start);
return 0;
}