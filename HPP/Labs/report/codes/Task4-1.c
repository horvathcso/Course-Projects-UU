#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>

int main(int argc, char**args){

int M =(atoi(args[1]));
if(M==0 || M<0){printf("Error: n needs to be an integer bigger to or equal to 1\n");} 

int counter=1;
for(int i=3; i<M;i=i+2){
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
printf("The number of primes from 1 to %d is %d\n" , M, counter);
return 0;
}
