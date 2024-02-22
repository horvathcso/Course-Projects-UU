#include <stdio.h>
#include <stdlib.h>
#ifdef _OPENMP
    #include <omp.h>
#endif


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

#ifdef _OPENMP
    int n =(atoi(args[1]));
#else
    int n=1;
#endif

int M =(atoi(args[2]));
if(M==0 || M<0){printf("Error: n needs to be an integer bigger to or equal to 1\n");} 


int counter=1;
int res[n];

#ifdef _OPENMP
double start =omp_get_wtime();
#endif

#pragma omp parallel num_threads(n)
  {
    #ifdef _OPENMP
    int id = omp_get_thread_num();
    int N = omp_get_num_threads();
    #else
    int id=0; int N=1;
    #endif
    
    res[id] = thread_func(M,id,N);
  }

#ifdef _OPENMP
double end =omp_get_wtime();
#endif

for(int i=0; i<n;i++){counter+=res[i];}

printf("The number of primes from 1 to %d is %d\n" , M, counter);

#ifdef _OPENMP
printf("Run time: %lf\n",end-start);
#endif

return 0;
}