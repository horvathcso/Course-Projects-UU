#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>

void* the_thread_fun(void* arg){
int * data= (int *)arg;
int L=*data;
data ++;
int U=*data;
int counter=0;
for(int i=L; i<U;i=i+2){
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
printf("Thread bounds and count: U=%d, L=%d, count=%d\n", U,L,counter);
*data = counter;
}


int main(int argc, char**args){

int M =(atoi(args[1]));
if(M==0 || M<0){printf("Error: M needs to be an integer bigger to or equal to 1\n");} 

int N =(atoi(args[2]));
if(N==0 || N<0){printf("Error: N needs to be an integer bigger to or equal to 1\n");} 

int counter=1;


int arg[N-1][2];
pthread_t thread[N-1];


for(int i=0; i<N-1; i++){
arg[i][0]=M-(i+1)*(M/N)+1;
arg[i][1]=M-i*(M/N);
pthread_create(&thread[i], NULL, the_thread_fun, &arg[i]);
}

//main
for(int i=3; i<M/N;i=i+2){
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
for (int i = 0; i < N-1; i++)
{
pthread_join(thread[i], NULL);
counter+=arg[i][1];
}


printf("The number of primes from 1 to %d is %d\n" , M, counter);
return 0;
}
