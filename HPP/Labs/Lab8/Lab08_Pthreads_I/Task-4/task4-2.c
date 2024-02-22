#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>

void* the_thread_fun(void* arg){
int * data= (int *)arg;
int M=*data;
int counter=0;
for(int i=0.7*M+1; i<M;i=i+2){
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
*data = counter;
}


int main(int argc, char**args){

int M =(atoi(args[1]));
if(M==0 || M<0){printf("Error: n needs to be an integer bigger to or equal to 1\n");} 

int counter=1;


int arg =M;
pthread_t thread;
pthread_create(&thread, NULL, the_thread_fun, &arg);

//main
for(int i=3; i<0.7*M;i=i+2){
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
pthread_join(thread, NULL);

counter+=arg;
printf("The number of primes from 1 to %d is %d\n" , M, counter);
return 0;
}