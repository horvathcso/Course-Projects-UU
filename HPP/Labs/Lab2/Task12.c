#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int is_prime(int n){
    if(n%2==0 && n!=2){
        return 0;
    }
    for (int i = 3; i < sqrt(n); i=i+2)
    {
        if (n%i==0)
        {
            return 0;
        }        
    }
    return 1;
}

void print_array(int *arr,int n){
    printf("[");
    for(int i=0; i<n-1; i++){
        printf("%d, ",arr[i]);
    }
    printf("%d]\n",arr[n-1]);

}

int main(){
    int n; int primes=0; int read;
    printf("Give value of n: ");
    scanf(" %d", &n);

    int *array=(int *) malloc(n*sizeof(int));

    for(int i; i<n-primes; i++){
        printf("Give the next integer: ");
        scanf(" %d", &read);
        if(is_prime(read)){
            i--;
            primes++;
            array = realloc(array, (n-primes+1)*sizeof(int));
        }
        else{
            array[i]=read;
        }
    }

    print_array(array, n-primes);
}